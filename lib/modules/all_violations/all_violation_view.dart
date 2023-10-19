library all_violation_view;

import 'package:cached_network_image/cached_network_image.dart';
import 'package:compound/config.dart';
import 'package:compound/locator.dart';
import 'package:compound/modules/all_violations/all_violation_view_model.dart';
import 'package:compound/shared_components/animated_toggle/animated_toggle.dart';
import 'package:compound/shared_components/background/background_pattern.dart';
import 'package:compound/shared_components/buttons/button_blue.dart';
import 'package:compound/shared_models/property_model.dart';
import 'package:compound/shared_models/violation_model.dart';
import 'package:compound/shared_services/reports_service.dart';
import 'package:compound/theme/app_theme.dart';
import 'package:compound/utils/colors_util.dart';
import 'package:compound/utils/scale_helper.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:progressive_image/progressive_image.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

part 'all_violation_mobile.dart';
part 'all_violation_web.dart';

class AllViolationView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ScreenTypeLayout(
      mobile: __AllViolationMobileState(),
      desktop: __AllViolationWebState(),
      tablet: __AllViolationMobileState(),
    );
  }
}
