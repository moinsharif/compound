library all_timesheet_view;

import 'package:compound/modules/all_timesheet/all_timesheet_view_model.dart';
import 'package:compound/shared_components/background/background_pattern.dart';
import 'package:compound/shared_models/timesheet_model.dart';
import 'package:compound/theme/app_theme.dart';
import 'package:compound/ui/widgets/creation_aware_list_item.dart';
import 'package:compound/utils/timestamp_util.dart';
import 'package:flutter/scheduler.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:sticky_and_expandable_list/sticky_and_expandable_list.dart';

part 'all_timesheet_mobile.dart';

class AllTimeSheetView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ScreenTypeLayout(
      mobile: __AllTimesheetMobileState(),
      desktop: __AllTimesheetMobileState(),
      tablet: __AllTimesheetMobileState(),
    );
  }
}
