library payroll_porter_view;

import 'package:compound/modules/payroll_porter/payroll_porter_view_model.dart';
import 'package:compound/modules/timesheet/timesheet_view_model.dart';
import 'package:compound/shared_components/background/background_pattern.dart';
import 'package:compound/shared_components/buttons/buttons_choise.dart';
import 'package:compound/theme/app_theme.dart';
import 'package:month_picker_dialog/month_picker_dialog.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

part 'payroll_porter_mobile.dart';

class PayrollPorterView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ScreenTypeLayout(
      mobile: PayrollProterMobileState(),
      desktop: PayrollProterMobileState(),
      tablet: PayrollProterMobileState(),
    );
  }
}
