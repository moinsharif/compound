library timesheet_view;

import 'package:compound/core/services/dialog_service.dart';
import 'package:compound/locator.dart';
import 'package:compound/modules/timesheet/timesheet_view_model.dart';
import 'package:compound/shared_components/background/background_pattern.dart';
import 'package:compound/theme/app_theme.dart';
import 'package:compound/utils/timestamp_util.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

part 'timesheet_mobile.dart';

class TimeSheetView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ScreenTypeLayout(
      mobile: TimesheetMobileState(),
      desktop: TimesheetMobileState(),
      tablet: TimesheetMobileState(),
    );
  }
}
