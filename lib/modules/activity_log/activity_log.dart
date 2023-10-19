library activity_log_view;

import 'package:compound/modules/activity_log/activity_log_view_model.dart';
import 'package:compound/modules/all_timesheet/all_timesheet_view_model.dart';
import 'package:compound/modules/all_violations/all_violation_view_model.dart';
import 'package:compound/modules/timesheet/timesheet_view_model.dart';
import 'package:compound/shared_components/background/background_pattern.dart';
import 'package:compound/shared_components/buttons/button_blue.dart';
import 'package:compound/shared_components/buttons/buttons_choise.dart';
import 'package:compound/shared_components/buttons/buttons_choise_web.dart';
import 'package:compound/shared_components/list_activity/list_activity.dart';
import 'package:compound/shared_models/employee_detail_model.dart';
import 'package:compound/shared_models/property_model.dart';
import 'package:compound/shared_models/timesheet_model.dart';
import 'package:compound/shared_models/violation_model.dart';
import 'package:compound/theme/app_theme.dart';
import 'package:compound/utils/colors_util.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

part 'activity_log_mobile.dart';
part 'activity_log_web.dart';

class ActivityLogView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ScreenTypeLayout(
      mobile: ActivityLogMobileState(),
      desktop: ActivityLogWebState(),
      tablet: ActivityLogMobileState(),
    );
  }
}
