import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:compound/core/base/base_view_model.dart';
import 'package:compound/core/services/navigation/navigator_service.dart';
import 'package:compound/locator.dart';
import 'package:compound/shared_models/days_selected.dart';
import 'package:compound/shared_models/employee_detail_model.dart';
import 'package:compound/shared_models/porter_model.dart';
import 'package:compound/shared_models/property_model.dart';
import 'package:compound/shared_models/watchlist_model.dart';
import 'package:compound/shared_services/employees_service.dart';
import 'package:compound/shared_services/property_service.dart';
import 'package:compound/shared_services/watchlist_service.dart';
import 'package:compound/utils/timestamp_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:intl/intl.dart';

class AddPorterScheduleViewModel extends BaseViewModel {
  final PropertyService _propertyService = locator<PropertyService>();
  final WatchlistService _watchlistService = locator<WatchlistService>();
  final NavigatorService _navigatorService = locator<NavigatorService>();
  final SuggestionsBoxController porterBoxController =
      SuggestionsBoxController();
  final EmployeesService _employeeService = locator<EmployeesService>();
  List<EmployeeDetailModel> employees = [];
  List<WatchlistModel> watchlist = [];
  List<WatchlistModel> removeWatchs = [];
  List<WatchlistModel> addedWatchs = [];
  List<Porter> portersAvailables = [];
  final FocusNode focusInstructions = FocusNode();
  final TextEditingController controller = new TextEditingController();
  WrappedDate dateSelected;
  bool openBoxPorter = false;
  Porter porter;

  Future<void> load(DateTime date, PropertyModel property) async {
    employees = await _employeeService.getEmployeesAndAdmins();
    watchlist = await _watchlistService.getWatchlist(
        start: TimestampUtils.wdRangeFrom(date),
        end: TimestampUtils.wdRangeTo(date),
        propertyId: property.id);
    this.dateSelected = WrappedDate.fromLocal(date);
    notifyListeners();
  }

  Future<List<EmployeeDetailModel>> getEmployees(String pattern) async {
    if (employees == null) {
      return List<EmployeeDetailModel>.empty();
    }

    return this
        .employees
        .where((EmployeeDetailModel element) =>
            (element.lastName.toLowerCase().startsWith(pattern.toLowerCase()) ||
                element.firstName
                    .toLowerCase()
                    .startsWith(pattern.toLowerCase())) &&
            portersAvailables
                    .indexWhere((current) => current.id == element.id) ==
                -1)
        .toList();
  }

  String getDifferenceHour(String starTime, String endTime) {
    var format = DateFormat("HH:mm");
    var start = format.parse(starTime);
    var end = format.parse(endTime);
    if (start.isAfter(end)) {
      return '${start.subtract(Duration(days: 1)).difference(end).inHours.abs()}h Assigned';
    } else if (start.isBefore(end)) {
      return '${end.difference(start).inHours.abs()}h Assigned';
    } else {
      return '${end.difference(start).inHours.abs()}h Assigned';
    }
  }

  String getHour(String starTime, String endTime) {
    return '${DateFormat.jm().format(DateFormat("hh:mm:ss").parse('$starTime:00'))} - ${DateFormat.jm().format(DateFormat("hh:mm:ss").parse('$endTime:00'))}';
  }

  void changeArrowPositionPorter(bool value, {String opneBox}) {
    this.openBoxPorter = value;
    if (opneBox == 'open') {
      this.porterBoxController.open();
    } else if (opneBox == 'close') {
      this.porterBoxController.close();
    }
    notifyListeners();
  }

  void addEmployee(
      EmployeeDetailModel suggestion, PropertyModel property, DateTime date) {
    porter = new Porter(
        id: suggestion.id,
        active: true,
        firstName: suggestion.firstName,
        lastName: suggestion.lastName,
        temporary: true,
        temporaryDate: this.dateSelected.rangeTo());
    property.configProperty.porters = [
      ...property.configProperty.porters,
      porter
    ];
  }

  void addTemporalPorter(String value, PropertyModel property) {
    if (porter == null) return;
    if (porter != null && '${porter.lastName} ${porter.firstName}' == value) {
      return;
    }
    property.configProperty.porters
        .removeWhere((element) => element.id == porter.id);
    this.porter = null;
    this.notifyListeners();
    return;
  }

  Future<void> addPropertyToEmployee(
      PropertyModel property, String propertyId) async {
    List<String> portersIds = [];
    await Future.forEach(property.configProperty.porters, ((Porter element) {
      if (element.temporary != null && element.temporary == true)
        portersIds = [...portersIds, element.id];
    }));
    if (portersIds.length > 0)
      await _employeeService.assignTemporalPropertyByPorters(
          portersIds, propertyId, property.marketId);
  }

  Future<void> updateProperty(PropertyModel property) async {
    String resp =
        await _propertyService.updateProperty(property.id, property.toJson());
    if (resp != null) {
      await addPropertyToEmployee(property, property.id);
      await _watchlistService.removeWatchlist(removeWatchs);
      await _watchlistService.addWatchlist(addedWatchs);
      _navigatorService.pop();
    }
  }

  void removeWatchlist(WatchlistModel removeWatchlist) {
    watchlist.removeWhere((element) => element.id == removeWatchlist.id);
    addedWatchs.remove(removeWatchlist);
    removeWatchs = [...removeWatchs, removeWatchlist];
    this.notifyListeners();
  }

  void addWatchlist(DateTime date, PropertyModel property) {
    addedWatchs = [
      ...addedWatchs,
      new WatchlistModel(
          name: controller.text,
          status: 'schedule',
          propertyId: property.id,
          propertyName: property.propertyName,
          date: this.dateSelected.rangeTo())
    ];
    controller.text = '';
    notifyListeners();
  }
}
