import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:compound/core/base/base_view_model.dart';
import 'package:compound/core/services/dialog_service.dart';
import 'package:compound/core/services/geolocator/geolocator.dart';
import 'package:compound/core/services/navigation/navigator_service.dart';
import 'package:compound/locator.dart';
import 'package:compound/modules/properties/properties_view_model.dart';
import 'package:compound/router.dart';
import 'package:compound/shared_models/config_property.dart';
import 'package:compound/shared_models/days_selected.dart';
import 'package:compound/shared_models/employee_detail_model.dart';
import 'package:compound/shared_models/market_model.dart';
import 'package:compound/shared_models/porter_model.dart';
import 'package:compound/shared_models/property_model.dart';
import 'package:compound/shared_models/response_google_places.dart';
import 'package:compound/shared_models/user_model.dart';
import 'package:compound/shared_services/employees_service.dart';
import 'package:compound/shared_services/market_service.dart';
import 'package:compound/shared_services/property_service.dart';
import 'package:compound/utils/string_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'dart:async';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:time_range_picker/time_range_picker.dart';

class AddPropertyViewModel extends BaseViewModel {
  final PropertyService _propertyService = locator<PropertyService>();
  final NavigatorService _navigatorService = locator<NavigatorService>();
  final EmployeesService _employeeService = locator<EmployeesService>();
  final PropertiesViewModel _propertiesViewModel =
      locator<PropertiesViewModel>();
  final MarketService _marketService = locator<MarketService>();
  final GeolocatorService _geolocatorService = locator<GeolocatorService>();
  Position position;
  List<MarketModel> markets = [];
  List<Results> searchAddress = [];
  List<EmployeeDetailModel> employees = [];
  MarketModel marketSelected;
  Results addressSelected;
  PropertyModel newProperty = new PropertyModel(emails: []);
  final SuggestionsBoxController propertyBoxController =
      SuggestionsBoxController();
  final SuggestionsBoxController porterBoxController =
      SuggestionsBoxController();
  bool openBoxProperty = false;
  bool openBoxPorter = false;
  int radioValue = 0;
  DateTime endDate;
  String showDate = '';
  TimeRange selectedTime;

  Future<void> load() async {
    setBusy(true);
    newProperty.configProperty = new ConfigProperty();
    employees = await _employeeService.getEmployeesAndAdmins();
    newProperty.configProperty.daysSelected = _getDefaultDays();
    this.formatDateRange(DateTime.now());
    markets = await _marketService.getAllMarkets();
    setBusy(false);
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

  void refresh() {
    this.notifyListeners();
  }

  Future<List<EmployeeDetailModel>> getEmployees(String pattern) async {
    if (employees == null) {
      return List<EmployeeDetailModel>.empty();
    }

    return this
        .employees
        .where((EmployeeDetailModel element) => (element.lastName
                .toLowerCase()
                .startsWith(pattern.toLowerCase()) ||
            element.firstName.toLowerCase().startsWith(pattern.toLowerCase())))
        .take(5)
        .toList();
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

  void changeArrowPositionPorter(bool value, {String opneBox}) {
    this.openBoxPorter = value;
    if (opneBox == 'open') {
      this.porterBoxController?.open();
    } else if (opneBox == 'close') {
      this.porterBoxController?.close();
    }
    notifyListeners();
  }

  Future<List<Results>> getLocationResults(String text) async {
    if (text.isEmpty) return [];
    return await _geolocatorService.getPlacesWithDirecction(text);
  }

  void addProperty(FormBuilderState form) async {
    if (!form.validate()) {
      ScaffoldMessenger.of(locator<DialogService>().scaffoldKey.currentContext)
          .showSnackBar(SnackBar(
        content: Text('Please complete all required fields.'),
      ));
      return;
    }
    if (addressSelected == null) {
      ScaffoldMessenger.of(locator<DialogService>().scaffoldKey.currentContext)
          .showSnackBar(SnackBar(
        content: Text('Please add a valid address.'),
      ));
      return;
    }
    if (newProperty.emails.length <= 0) {
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
    if (newProperty.configProperty.daysSelected.firstWhere(
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
        propertyName: form.fields['propertyName'].value,
        active: true,
        address: addressSelected.formattedAddress,
        units: form.fields['units'].value,
        phone: form.fields['phone'].value,
        marketName: marketSelected.name,
        marketId: marketSelected.id,
        specialInstructions: form.fields['specialInstructions'].value,
        flagged: false,
        configProperty: newProperty.configProperty.copyWith(
            createdAt: Timestamp.fromDate(date),
            startTime: StringUtils.cleanTime(selectedTime.startTime),
            endTime: StringUtils.cleanTime(selectedTime.endTime),
            end: this.radioValue == 1 ? true : false,
            endDate:
                this.radioValue == 0 ? null : Timestamp.fromDate(this.endDate),
            daysSelected: newProperty.configProperty.daysSelected
                .where((element) => element.selected == true)
                .toList()),
        lat: addressSelected.geometry.location.lat,
        lng: addressSelected.geometry.location.lng,
        updatedAt: Timestamp.fromDate(date),
        createdAt: Timestamp.fromDate(date),
        totalViolations: 0);
    setBusy(false);
    String resp = await _propertyService.addProperty(newProperty);
    if (resp != null) {
      if (newProperty.configProperty.porters.length > 0)
        addPropertyToEmployee(newProperty, resp);
      _propertiesViewModel.dispose();
      _navigatorService.navigateToPageWithReplacement(PropertiesViewRoute);
    }
  }

  Future<void> addPropertyToEmployee(
      PropertyModel newProperty, String propertyId) async {
    List<String> portersIds = [];
    await Future.forEach(newProperty.configProperty.porters, ((Porter element) {
      portersIds = [...portersIds, element.id];
    }));

    await _employeeService.assignPropertyByPorters(
        portersIds, propertyId, newProperty.marketId);
  }

  void selectDay(DaysSelected e) {
    int index = this.newProperty.configProperty.daysSelected.indexOf(e);
    this.newProperty.configProperty.daysSelected[index].selected =
        !this.newProperty.configProperty.daysSelected[index].selected;
    notifyListeners();
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

  void handleRadioValueChange(int value) {
    radioValue = value;
    notifyListeners();
  }

  void formatDateRange(DateTime date) {
    final DateFormat formatter = DateFormat('MMM dd, yyyy');
    this.showDate = formatter.format(date);
    notifyListeners();
  }

  void removeEmployee(Porter porter) {
    newProperty.configProperty.porters
        .removeWhere((element) => element.id == porter.id);
    notifyListeners();
  }

  void addEmployee(EmployeeDetailModel suggestion) {
    Porter _porter = new Porter(
        id: suggestion.id,
        active: true,
        firstName: suggestion.firstName,
        lastName: suggestion.lastName,
        temporary: false);
    newProperty.configProperty.porters = [
      ...newProperty.configProperty.porters,
      _porter
    ];
  }
}
