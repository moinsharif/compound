library violation_by_property_view;

import 'package:compound/config.dart';
import 'package:compound/locator.dart';
import 'package:compound/modules/violations_by_property/violation_by_property_view_model.dart';
import 'package:compound/shared_components/animated_toggle/animated_toggle.dart';
import 'package:compound/shared_components/background/background_pattern.dart';
import 'package:compound/shared_components/buttons/buttons_choise.dart';
import 'package:compound/shared_models/violation_model.dart';
import 'package:compound/shared_services/reports_service.dart';
import 'package:compound/theme/app_theme.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

part 'violation_by_property_mobile.dart';
part 'violation_by_property_web.dart';

class ViolationByPropertyView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ScreenTypeLayout(
      mobile: _ViolationByPropertyMobileState(),
      desktop: _ViolationByPropertyWebState(),
      tablet: _ViolationByPropertyMobileState(),
    );
  }
}
