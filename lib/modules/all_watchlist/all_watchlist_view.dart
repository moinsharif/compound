library all_violation_view;

import 'package:compound/config.dart';
import 'package:compound/locator.dart';
import 'package:compound/modules/all_violations/all_violation_view_model.dart';
import 'package:compound/modules/all_watchlist/all_watchlist_view_model.dart';
import 'package:compound/shared_components/background/background_pattern.dart';
import 'package:compound/shared_components/buttons/button_blue.dart';
import 'package:compound/shared_models/property_model.dart';
import 'package:compound/shared_models/violation_model.dart';
import 'package:compound/shared_models/watchlist_model.dart';
import 'package:compound/shared_services/reports_service.dart';
import 'package:compound/theme/app_theme.dart';
import 'package:compound/utils/colors_util.dart';
import 'package:compound/utils/scale_helper.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

part 'all_watchlist_mobile.dart';
part 'all_watchlist_web.dart';

class AllWatchlistView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ScreenTypeLayout(
      mobile: __AllWatchlistMobileState(),
      desktop: __AllWatchlistWebState(),
      tablet: __AllWatchlistMobileState(),
    );
  }
}
