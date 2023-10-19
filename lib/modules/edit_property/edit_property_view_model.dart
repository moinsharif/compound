import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:compound/core/base/base_view_model.dart';
import 'package:compound/core/services/dialog_service.dart';
import 'package:compound/core/services/geolocator/geolocator.dart';
import 'package:compound/core/services/navigation/navigator_service.dart';
import 'package:compound/modules/properties/properties_view_model.dart';
import 'package:compound/router.dart';
import 'package:compound/shared_models/config_property.dart';
import 'package:compound/shared_models/days_selected.dart';
import 'package:compound/shared_models/employee_detail_model.dart';
import 'package:compound/shared_models/market_model.dart';
import 'package:compound/shared_models/porter_model.dart';
import 'package:compound/shared_models/property_model.dart';
import 'package:compound/shared_models/response_google_places.dart';
import 'package:compound/shared_services/employees_service.dart';
import 'package:compound/shared_services/market_service.dart';
import 'package:compound/shared_services/property_service.dart';
import 'package:compound/locator.dart';
import 'package:compound/utils/string_utils.dart';
import 'package:flutter/material.dart';

import 'dart:async';

import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:intl/intl.dart';
import 'package:time_range_picker/time_range_picker.dart';

class EditPropertyViewModel extends BaseViewModel {
  final PropertyService _propertyService = locator<PropertyService>();
  final MarketService _marketService = locator<MarketService>();
  final EmployeesService _employeeService = locator<EmployeesService>();
  final NavigatorService _navigatorService = locator<NavigatorService>();
  final GeolocatorService _geolocatorService = locator<GeolocatorService>();
  final PropertiesViewModel _propertiesViewModel =
      locator<PropertiesViewModel>();

  PropertyModel _loadedProperty;
  List<MarketModel> markets = [];
  List<MarketModel> marketStrings = [];
  List<Porter> removePorters = [];
  PropertyModel newProperty = new PropertyModel(emails: []);
  List<Results> searchAddress = [];
  List<EmployeeDetailModel> employees = [];
  MarketModel _selectedMarket;
  MarketModel marketSelected;
  String _selectedPropertyId;
  TimeRange selectedTime;
  Results addressSelected;
  int radioValue = 0;
  bool activePropertyValue = true;
  DateTime endDate;
  String showDate = '';
  final SuggestionsBoxController porterBoxController =
      SuggestionsBoxController();
  bool openBoxProperty = false;
  bool openBoxPorter = false;
  final SuggestionsBoxController propertyBoxController =
      SuggestionsBoxController();
  final TextEditingController searchMarketController = TextEditingController();
  final TextEditingController addressController = new TextEditingController();

  PropertyModel get loadedProperty => _loadedProperty;
  set loadedProperty(PropertyModel property) => this._loadedProperty = property;

  MarketModel get selectedMarket => _selectedMarket;
  set selectedMarket(MarketModel market) => this._selectedMarket = market;

  Future<void> load(Map<String, dynamic> arguments) async {
    setBusy(true);
    loadedProperty =
        await _propertyService.getProperty(arguments['propertyId']);
    employees = await _employeeService.getEmployeesAndAdmins();
    if (loadedProperty.configProperty != null) {
      radioValue = loadedProperty.configProperty.end ? 1 : 0;
      endDate = loadedProperty.configProperty.end
          ? loadedProperty.configProperty.endDate.toDate()
          : DateTime.now();
      selectedTime = TimeRange(
          startTime: TimeOfDay(
              hour: int.parse(
                  loadedProperty.configProperty.startTime.split(':')[0]),
              minute: int.parse(
                  loadedProperty.configProperty.startTime.split(':')[1])),
          endTime: TimeOfDay(
              hour: int.parse(
                  loadedProperty.configProperty.endTime.split(':')[0]),
              minute: int.parse(
                  loadedProperty.configProperty.endTime.split(':')[1])));
      if (loadedProperty.configProperty.end) {
        formatDateRange(loadedProperty.configProperty.endDate.toDate());
      } else {
        formatDateRange(DateTime.now());
      }
      loadedProperty.configProperty.daysSelected = await _addDefaultDays();
    } else {
      loadedProperty.configProperty = new ConfigProperty();
      radioValue = 0;
      endDate = DateTime.now();
      selectedTime = null;
      formatDateRange(DateTime.now());
      loadedProperty.configProperty.daysSelected = _getDefaultDays();
    }
    activePropertyValue = loadedProperty.active;
    _selectedPropertyId = arguments['propertyId'];
    markets = await _marketService.getAllMarkets();
    marketSelected = markets.firstWhere(
      (element) => element.id == loadedProperty.marketId,
      orElse: () => null,
    );
    searchMarketController.text = marketSelected != null
        ? '${marketSelected.name}, ${marketSelected.state}'
        : '';
    addressController.text = loadedProperty.address;
    markets.map((market) {
      if ('${market.name}, ${market.state}' == loadedProperty.marketName)
        selectedMarket = market;
      if ((marketStrings.singleWhere(
              (mkt) => mkt.showName == '${market.name}, ${market.state}',
              orElse: () => null)) !=
          null) {
        print('Already Exist');
      } else {
        market.showName = '${market.name}, ${market.state}';
        marketStrings.add(market);
      }
    }).toList();

    setBusy(false);
  }

  Future<List<EmployeeDetailModel>> getEmployees(String pattern) async {
    if (markets == null) {
      return List<EmployeeDetailModel>.empty();
    }

    return this
        .employees
        .where((EmployeeDetailModel element) =>
            element.lastName.toLowerCase().indexOf(pattern.toLowerCase()) >= 0)
        .take(5)
        .toList();
  }

  void formatDateRange(DateTime date) {
    final DateFormat formatter = DateFormat('MMM dd, yyyy');
    this.showDate = formatter.format(date);
    notifyListeners();
  }

  void refresh() {
    this.notifyListeners();
  }

  Future<List<MarketModel>> getMarkets(String pattern) async {
    if (markets == null) {
      return List<MarketModel>.empty();
    }

    return this
        .markets
        .where((MarketModel element) =>
            element.name.toLowerCase().indexOf(pattern.toLowerCase()) >= 0)
        .take(5)
        .toList();
  }

  Future<List<Results>> getLocationResults(String text) async {
    if (text.isEmpty) return [];
    return await _geolocatorService.getPlacesWithDirecction(text);
  }

  void removeEmployee(Porter porter) {
    loadedProperty.configProperty.porters
        .removeWhere((element) => element.id == porter.id);
    removePorters = [...removePorters, porter];
    notifyListeners();
  }

  void addEmployee(EmployeeDetailModel suggestion) {
    Porter _porter = new Porter(
        id: suggestion.id,
        active: true,
        firstName: suggestion.firstName,
        lastName: suggestion.lastName);
    loadedProperty.configProperty.porters = [
      ...loadedProperty.configProperty.porters,
      _porter
    ];
  }

  void changeArrowPositionPorter(bool value, {String opneBox}) {
    this.openBoxPorter = value;
    if (opneBox == 'open') {
      this.porterBoxController?.open();
    } else if (opneBox == 'close') {
      this.porterBoxController?.close();
    }
    notifyListeners();
  }

  void changeArrowPositionStreet(bool value, {String opneBox}) {
    this.openBoxProperty = value;
    if (opneBox == 'open') {
      this.propertyBoxController?.open();
    } else if (opneBox == 'close') {
      this.propertyBoxController?.close();
    }
    notifyListeners();
  }

  void handleRadioValueChange(int value) {
    radioValue = value;
    notifyListeners();
  }

  void handleRadioValueActiveChange(bool value) {
    this.activePropertyValue = value;
    notifyListeners();
  }

  void selectDay(DaysSelected e) {
    int index = this.loadedProperty.configProperty.daysSelected.indexOf(e);
    this.loadedProperty.configProperty.daysSelected[index].selected =
        !this.loadedProperty.configProperty.daysSelected[index].selected;
    notifyListeners();
  }

  Future<List<DaysSelected>> _addDefaultDays() async {
    int cont = 0;
    List<DaysSelected> defaultDays = [
      DaysSelected(id: 0, nameDay: 'Sunday', shortNameDay: 'S', rate: 15),
      DaysSelected(id: 1, nameDay: 'Monday', shortNameDay: 'M', rate: 15),
      DaysSelected(id: 2, nameDay: 'Tuesday', shortNameDay: 'T', rate: 15),
      DaysSelected(id: 3, nameDay: 'Wednesday', shortNameDay: 'W', rate: 15),
      DaysSelected(id: 4, nameDay: 'Thursday', shortNameDay: 'T', rate: 15),
      DaysSelected(id: 5, nameDay: 'Friday', shortNameDay: 'F', rate: 15),
      DaysSelected(id: 6, nameDay: 'Saturday', shortNameDay: 'S', rate: 15)
    ];
    List<DaysSelected> auxList = [...defaultDays];
    await Future.forEach(defaultDays, (DaysSelected e) {
      int index = loadedProperty.configProperty.daysSelected
          .indexWhere((element) => element.id == e.id);
      if (index != -1) {
        auxList[cont] = loadedProperty.configProperty.daysSelected[index]
            .copyWith(selected: true);
      }
      cont += 1;
    });
    return auxList;
  }

  void updateProperty(FormBuilderState form) async {
    if (!form.validate()) {
      ScaffoldMessenger.of(locator<DialogService>().scaffoldKey.currentContext)
          .showSnackBar(SnackBar(
        content: Text('Please complete all required fields.'),
      ));
      return;
    }
    if (loadedProperty.address == '' && addressSelected == null) {
      ScaffoldMessenger.of(locator<DialogService>().scaffoldKey.currentContext)
          .showSnackBar(SnackBar(
        content: Text('Please add a valid address.'),
      ));
      return;
    }
    if (loadedProperty.emails.length <= 0) {
      ScaffoldMessenger.of(locator<DialogService>().scaffoldKey.currentContext)
          .showSnackBar(SnackBar(
        content: Text('add at least one mail for the property.'),
      ));
      return;
    }
    if (marketSelected == null) {
      ScaffoldMessenger.of(locator<DialogService>().scaffoldKey.currentContext)
          .showSnackBar(SnackBar(
        content: Text('Select a market for the property.'),
      ));
      return;
    }
    if (loadedProperty.configProperty.daysSelected.firstWhere(
            (element) => element.selected == true,
            orElse: () => null) ==
        null) {
      ScaffoldMessenger.of(locator<DialogService>().scaffoldKey.currentContext)
          .showSnackBar(SnackBar(
        content: Text('Select at least one day for the service.'),
      ));
      return;
    }
    if (selectedTime == null) {
      ScaffoldMessenger.of(locator<DialogService>().scaffoldKey.currentContext)
          .showSnackBar(SnackBar(
        content: Text('Select a time interval for the service.'),
      ));
      return;
    }
    setBusy(true);
    final date = DateTime.now();
    newProperty = newProperty.copyWith(
        id: loadedProperty.id,
        active: this.activePropertyValue,
        propertyName: form.fields['propertyName'].value,
        address: addressSelected != null
            ? addressSelected.formattedAddress
            : loadedProperty.address,
        units: form.fields['units'].value,
        phone: form.fields['phone'].value,
        marketName: marketSelected.name,
        marketId: marketSelected.id,
        emails: loadedProperty.emails,
        specialInstructions: form.fields['specialInstructions'].value,
        flagged: loadedProperty.flagged,
        configProperty: loadedProperty.configProperty.copyWith(
            startTime: StringUtils.cleanTime(selectedTime.startTime),
            endTime: StringUtils.cleanTime(selectedTime.endTime),
            end: this.radioValue == 1 ? true : false,
            endDate:
                this.radioValue == 0 ? null : Timestamp.fromDate(this.endDate),
            daysSelected: loadedProperty.configProperty.daysSelected
                .where((element) => element.selected == true)
                .toList()),
        lat: addressSelected != null
            ? addressSelected.geometry.location.lat
            : loadedProperty.lat,
        lng: addressSelected != null
            ? addressSelected.geometry.location.lng
            : loadedProperty.lng,
        updatedAt: Timestamp.fromDate(date),
        totalViolations: loadedProperty.totalViolations);
    setBusy(false);
    String resp = await _propertyService.updateProperty(
        newProperty.id, newProperty.toJson());
    if (resp != null) {
      if (removePorters.length > 0)
        await addPropertyToEmployee(newProperty, newProperty.id, remove: true);
      if (newProperty.configProperty.porters.length > 0)
        await addPropertyToEmployee(newProperty, newProperty.id);
      _propertiesViewModel.dispose();
      _navigatorService.navigateToPageWithReplacement(PropertiesViewRoute);
    }
  }

  Future<void> addPropertyToEmployee(
      PropertyModel newProperty, String propertyId,
      {bool remove = false}) async {
    List<String> portersIds = [];
    if (remove) {
      await Future.forEach(removePorters, ((Porter element) {
        portersIds = [...portersIds, element.id];
      }));
      await _employeeService.removePropertyByPorters(portersIds, propertyId);
    } else {
      await Future.forEach(loadedProperty.configProperty.porters,
          ((Porter element) {
        portersIds = [...portersIds, element.id];
      }));
      await _employeeService.assignPropertyByPorters(
          portersIds, propertyId, newProperty.marketId);
    }
  }

  List<DaysSelected> _getDefaultDays() {
    return [
      DaysSelected(id: 0, nameDay: 'Sunday', shortNameDay: 'S', rate: 15),
      DaysSelected(id: 1, nameDay: 'Monday', shortNameDay: 'M', rate: 15),
      DaysSelected(id: 2, nameDay: 'Tuesday', shortNameDay: 'T', rate: 15),
      DaysSelected(id: 3, nameDay: 'Wednesday', shortNameDay: 'W', rate: 15),
      DaysSelected(id: 4, nameDay: 'Thursday', shortNameDay: 'T', rate: 15),
      DaysSelected(id: 5, nameDay: 'Friday', shortNameDay: 'F', rate: 15),
      DaysSelected(id: 6, nameDay: 'Saturday', shortNameDay: 'S', rate: 15)
    ];
  }

  void updateAddress(String value) {
    if (value == null || value == "" || loadedProperty.address != value) {
      addressSelected = null;
      loadedProperty.address = '';
    }
    this.notifyListeners();
  }
}
