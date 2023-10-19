library employees_payroll;

import 'package:compound/core/services/navigation/navigator_service.dart';
import 'package:compound/locator.dart';
import 'package:compound/modules/employees_payroll/employees_payroll_view_model.dart';
import 'package:compound/shared_components/buttons/button_blue.dart';
import 'package:compound/shared_components/buttons/button_icon.dart';
import 'package:compound/shared_components/checkboxes/custom_checkbox.dart';
import 'package:compound/shared_components/selector/custom_selector.dart';
import 'package:compound/shared_models/employee_detail_model.dart';
import 'package:compound/shared_models/property_model.dart';
import 'package:compound/shared_services/csv_service/csv_repository.dart';
import 'package:compound/theme/app_theme.dart';
import 'package:compound/modules/employees_payroll/edit_wage_dialog.dart';
import 'package:compound/utils/colors_util.dart';
import 'package:compound/utils/scale_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:stacked/stacked.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart' show SizeExtension;

part 'employees_payroll_view_mobile.dart';

part 'employees_payroll_view_web.dart';

class EmployeesPayrollView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ScreenTypeLayout(
      mobile: _EmployeesPayrollViewMobile(),
      desktop: _EmployeesPayrollViewWeb(),
      tablet: _EmployeesPayrollViewMobile(),
    );
  }
}
