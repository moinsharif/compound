import 'package:compound/core/base/base_view_model.dart';
import 'package:compound/core/services/authentication/authentication_service.dart';
import 'package:compound/core/services/navigation/navigator_service.dart';
import 'package:compound/locator.dart';
import 'package:compound/shared_models/employee_detail_model.dart';
import 'package:compound/shared_models/property_model.dart';
import 'package:compound/shared_services/employees_service.dart';
import 'package:compound/shared_services/property_service.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CalendarUnassignedViewModel extends BaseViewModel {
  final AuthenticationService _authenticationService =
      locator<AuthenticationService>();
  final NavigatorService _navigatorService = locator<NavigatorService>();
  final PropertyService _propertyService = locator<PropertyService>();
  List<PropertyModel> properties;

  @override
  dispose() {
    super.dispose();
  }

  Future<void> load() async {
    setBusy(true);
    properties = await _propertyService.getPropertiesByUnassigned();
    setBusy(false);
  }

  String loadHours(DateTime date) {
    final DateFormat formatterHour = DateFormat('hh:mm a');
    return date != null ? formatterHour.format(date) : '--';
  }

  Future<dynamic> goToBack() async {
    await _navigatorService.navigateBack();
  }
}
