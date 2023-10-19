import 'package:compound/core/base/base_view_model.dart';
import 'package:compound/core/services/authentication/authentication_service.dart';
import 'package:compound/core/services/navigation/navigator_service.dart';
import 'package:compound/locator.dart';
import 'package:compound/shared_models/employee_detail_model.dart';
import 'package:compound/shared_services/employees_service.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CalendarViewModel extends BaseViewModel {
  final AuthenticationService _authenticationService =
      locator<AuthenticationService>();
  final EmployeesService _employeeService = locator<EmployeesService>();
  final NavigatorService _navigatorService = locator<NavigatorService>();
  final PageController controller = new PageController(initialPage: 0);
  List<EmployeeDetailModel> employees = [];
  int index = 0;

  @override
  dispose() {
    super.dispose();
  }

  Future<void> load() async {
    setBusy(true);
    employees = await _employeeService.getEmployeesAll();
    setBusy(false);
  }

  String loadHours(DateTime date) {
    final DateFormat formatterHour = DateFormat('hh:mm a');
    return date != null ? formatterHour.format(date) : '--';
  }

  Future<dynamic> goToBack() async {
    await _navigatorService.navigateBack();
  }

  void changePage(int index) {
    this.controller.jumpToPage(index);
    this.index = index;
    notifyListeners();
  }
}
