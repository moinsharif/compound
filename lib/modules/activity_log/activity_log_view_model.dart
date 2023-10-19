import 'dart:math';

import 'package:compound/constants.dart';
import 'package:compound/core/base/base_view_model.dart';
import 'package:compound/core/services/authentication/authentication_service.dart';
import 'package:compound/core/services/navigation/navigator_service.dart';
import 'package:compound/locator.dart';
import 'package:compound/router.dart';
import 'package:compound/shared_models/activityLog_model.dart';
import 'package:compound/shared_models/employee_detail_model.dart';
import 'package:compound/shared_models/property_model.dart';
import 'package:compound/shared_models/timesheet_model.dart';
import 'package:compound/shared_models/violation_model.dart';
import 'package:compound/shared_services/activity_service.dart';
import 'package:compound/shared_services/employees_service.dart';
import 'package:compound/shared_services/property_service.dart';
import 'package:compound/shared_services/timesheet_service.dart';
import 'package:compound/shared_services/violation_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:intl/intl.dart';

class ActivityLogViewModel extends BaseViewModel {
  final ActivityLogService _activityLogService = locator<ActivityLogService>();
  final ScrollController scroll = new ScrollController();
  final NavigatorService _navigatorService = locator<NavigatorService>();
  final EmployeesService _employeesService = locator<EmployeesService>();
  final PropertyService _propertyService = locator<PropertyService>();

  List<ActivityLogModel> activities = [];
  List<EmployeeDetailModel> porters = [];
  List<PropertyModel> properties = [];
  PropertyModel propertySelected;
  EmployeeDetailModel porterSelected;
  Random random = new Random();
  bool showArrow = true;
  bool showFilters = false;
  bool results = false;
  DateTimeRange selectedDateRange;

  bool openBoxPorter = false;
  final SuggestionsBoxController porterBoxController =
      SuggestionsBoxController();

  bool openBoxProperty = false;
  final SuggestionsBoxController propertyBoxController =
      SuggestionsBoxController();

  @override
  dispose() {
    super.dispose();
  }

  Future<void> load() async {
    setBusy(true);
    porters = await _employeesService.getEmployeesAll(isEmployee: false);
    properties = await _propertyService.getPropertiesAll(true);
    await this.loadActivity();
    setBusy(false);
    this.notifyListeners();
  }

  Future<void> loadActivity() async {
    activities = await _activityLogService.getAllActivityLog(
        start: selectedDateRange?.start ?? null,
        end: selectedDateRange?.end ?? null,
        porterId: porterSelected?.id ?? null,
        propertyId: propertySelected?.id ?? null);
    this.notifyListeners();
  }

  Future<void> clearFilters() async {
    selectedDateRange = null;
    propertySelected = null;
    porterSelected = null;
    await this.loadActivity();
    notifyListeners();
  }

  String formatDate(DateTime date) {
    final DateFormat formatter = DateFormat('MMMM dd, yyyy');
    return formatter.format(date);
  }

  String formatDateRange(DateTime date) {
    final DateFormat formatter = DateFormat('MMM dd, yyyy');
    return formatter.format(date);
  }

  String formatTime(DateTime date) {
    final DateFormat formatterHour = DateFormat('hh:mm a');
    return formatterHour.format(date);
  }

  void scrollPosition() {
    if ((scroll.position.maxScrollExtent - scroll.position.pixels) <= 5) {
      this.showArrow = false;
      notifyListeners();
    } else {
      this.showArrow = true;
      notifyListeners();
    }
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

  void changeArrowPositionProperty(bool value, {String opneBox}) {
    this.openBoxProperty = value;
    if (opneBox == 'open') {
      this.propertyBoxController.open();
    } else if (opneBox == 'close') {
      this.propertyBoxController.close();
    }
    notifyListeners();
  }

  Future<List<EmployeeDetailModel>> getPorters(String pattern) async {
    if (porters == null) {
      return List<EmployeeDetailModel>.empty();
    }
    return this
        .porters
        .where((EmployeeDetailModel element) => (element.lastName
                .toLowerCase()
                .startsWith(pattern.toLowerCase()) ||
            element.firstName.toLowerCase().startsWith(pattern.toLowerCase())))
        .toList();
  }

  void refresh() {
    this.notifyListeners();
  }

  Future<List<PropertyModel>> getProperties(String pattern) async {
    if (properties == null) {
      return List<PropertyModel>.empty();
    }

    return this
        .properties
        .where((PropertyModel element) =>
            element.propertyName.toLowerCase().indexOf(pattern.toLowerCase()) >=
            0)
        .toList();
  }

  void showFiltersContainer() {
    this.showFilters = !this.showFilters;
    notifyListeners();
  }
}
