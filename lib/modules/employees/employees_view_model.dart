import 'package:compound/constants.dart';
import 'package:compound/core/base/base_view_model.dart';
import 'package:compound/core/services/authentication/authentication_service.dart';
import 'package:compound/core/services/navigation/navigator_service.dart';
import 'package:compound/locator.dart';
import 'package:compound/router.dart';
import 'package:compound/shared_models/employee_detail_model.dart';
import 'package:compound/shared_models/market_model.dart';
import 'package:compound/shared_models/property_model.dart';
import 'package:compound/shared_models/timesheet_model.dart';
import 'package:compound/shared_services/employees_service.dart';
import 'package:compound/shared_services/market_service.dart';
import 'package:compound/shared_services/property_service.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:intl/intl.dart';

class EmployeesViewModel extends BaseViewModel {
  final AuthenticationService _authenticationService =
      locator<AuthenticationService>();
  final NavigatorService _navigatorService = locator<NavigatorService>();
  final EmployeesService _employeesService = locator<EmployeesService>();
  List<EmployeeDetailModel> employees;

  @override
  dispose() {
    super.dispose();
  }

  Future<void> load() async {
    setBusy(true);
    employees = await _employeesService.getEmployeesAll();
    setBusy(false);
  }

  String loadDate(DateTime date) {
    final DateFormat formatterHour = DateFormat('MMM dd, yyyy hh:mm a');
    return formatterHour.format(date);
  }
}
