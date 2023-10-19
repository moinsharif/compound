library all_employees_view;

import 'package:compound/modules/all_employees/all_employees_list_item_view.dart';
import 'package:compound/modules/all_employees/all_employees_list_item_view_web.dart';
import 'package:compound/shared_components/background/background_pattern.dart';
import 'package:compound/shared_components/big_round_action_button/big_round_action_button.dart';
import 'package:compound/shared_components/big_round_action_button/big_round_action_button_web.dart';
import 'package:compound/shared_models/employee_detail_model.dart';
import 'package:compound/shared_models/user_model.dart';
import 'package:compound/utils/colors_util.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:compound/modules/all_employees/all_employees_view_model.dart';

import '../../theme/app_theme.dart';


part 'all_employees_mobile_view.dart';
part 'all_employees_web.dart';

class AllEmployeesView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ScreenTypeLayout(
      mobile: AllEmployeesMobileView(),
      desktop: AllEmployeesWebView(),
      tablet: AllEmployeesMobileView(),
    );
  }
}
