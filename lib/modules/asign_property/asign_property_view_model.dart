import 'package:compound/core/base/base_view_model.dart';
import 'package:compound/core/services/navigation/navigator_service.dart';
import 'package:compound/locator.dart';
import 'package:compound/router.dart';
import 'package:compound/shared_models/employee_detail_model.dart';
import 'package:compound/shared_models/property_model.dart';
import 'package:compound/shared_services/employees_service.dart';
import 'package:compound/shared_services/property_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'dart:async';

import 'package:flutter_typeahead/flutter_typeahead.dart';

class AsignPropertyViewModel extends BaseViewModel {
  final EmployeesService _employeeService = locator<EmployeesService>();
  final PropertyService _propertyService = locator<PropertyService>();
  final NavigatorService _navigatorService = locator<NavigatorService>();

  List<EmployeeDetailModel> employees = [];
  List<PropertyModel> properties;
  PropertyModel selectedPropertyModel;
  String selectedProperty;
  String selectedMarket;
  String selectedUnit;

  String selectedEmployee;

  final SuggestionsBoxController propertyBoxController =
      SuggestionsBoxController();
  bool openBoxProperty = false;

  TextEditingController unitsController;
  TextEditingController marketController;

  Future<void> load(TextEditingController unitsController,
      TextEditingController marketController) async {
    setBusy(true);
    this.unitsController = unitsController;
    this.marketController = marketController;
    employees = await _employeeService.getEmployeesAll();
    properties = await _propertyService.getPropertiesAll(true);
    setBusy(false);
  }

  navigateBack() {
    _navigatorService.navigateToPageWithReplacement(HomeViewRoute);
  }

  updateEmployee(String value) {
    if (this.selectedEmployee == value) {
      return;
    }

    if (value == null || value == "") {
      this.selectedEmployee = null;
      this.notifyListeners();
      return;
    }

    this.selectedEmployee = value;
  }

  void updateProperites(String value) {
    if (this.selectedProperty == value) {
      return;
    }

    if (value == null || value == "") {
      this.selectedProperty = null;
      this.selectedPropertyModel = null;
      this.unitsController.text = null;
      this.marketController.text = null;
      this.notifyListeners();
      return;
    }

    this.selectedProperty = value;
    this.selectedPropertyModel = this.properties.firstWhere(
        (element) => element.address == value,
        orElse: () => null); //TODO retrieve data from database on demand

    if (this.selectedPropertyModel != null) {
      this.selectedMarket = this.selectedPropertyModel.marketName;
      this.selectedUnit = this.selectedPropertyModel.units;
      this.unitsController.text = this.selectedUnit;
      this.marketController.text = this.selectedMarket;
    }

    this.notifyListeners();
  }

  Future<List<PropertyModel>> getProperties(String pattern) async {
    if (properties == null) {
      return List<PropertyModel>.empty();
    }

    //TODO retrieve data from database on demand
    return this
        .properties
        .where((PropertyModel element) =>
            element.address.toLowerCase().indexOf(pattern.toLowerCase()) >= 0)
        .toList();
  }

  Future<String> asignProperty(FormBuilderState state) async {
    if (this.selectedEmployee == null) {
      return "Porter cannot be empty";
    }

    if (this.selectedPropertyModel == null) {
      return "Property cannot be empty";
    }

    //TODO check if property is already assigned
    this.setBusy(true);
    var result = await _employeeService.assignProperty(this.selectedEmployee,
        this.selectedPropertyModel.id, this.selectedPropertyModel.marketId);

    this.setBusy(false);
    return result;
  }
}
