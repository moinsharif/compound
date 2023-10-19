library add_market_view;

import 'package:compound/core/services/dialog_service.dart';
import 'package:compound/locator.dart';
import 'package:compound/modules/add_market/add_market_view_model.dart';
import 'package:compound/modules/all_markets/all_markets_view_model.dart';
import 'package:compound/modules/all_timesheet/all_timesheet_view_model.dart';
import 'package:compound/modules/all_violations/all_violation_view_model.dart';
import 'package:compound/shared_components/background/background_pattern.dart';
import 'package:compound/shared_components/buttons/buttons_choise.dart';
import 'package:compound/shared_models/market_model.dart';
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

part 'add_market_mobile.dart';
part 'add_market_web.dart';

class AddMarketsView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ScreenTypeLayout(
      mobile: __AddMarketsMobileState(),
      desktop: __AddMarketsWebState(),
      tablet: __AddMarketsMobileState(),
    );
  }
}
