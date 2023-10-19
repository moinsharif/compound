library calendar_view;

import 'package:compound/modules/calendar/calendar_schedule.dart';
import 'package:compound/modules/calendar/calendar_unassigned.dart';
import 'package:compound/modules/calendar/calendar_view_model.dart';
import 'package:compound/theme/app_theme.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

part 'calendar_mobile.dart';

class CalendarView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ScreenTypeLayout(
      mobile: CalendarMobileState(),
      desktop: CalendarMobileState(),
      tablet: CalendarMobileState(),
    );
  }
}
