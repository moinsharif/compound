library add_property_view;

import 'package:compound/modules/asign_property/asign_property_view_model.dart';
import 'package:compound/shared_components/background/background_pattern.dart';
import 'package:compound/shared_components/big_round_action_button/big_round_action_button.dart';
import 'package:compound/shared_models/property_model.dart';
import 'package:compound/theme/app_theme.dart';
import 'package:compound/utils/colors_util.dart';
import 'package:flutter/material.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:stacked/stacked.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

part 'asign_property_mobile.dart';

class AsignPropertyAsignView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ScreenTypeLayout(
      mobile: _AsignPropertyMobile(),
      desktop: _AsignPropertyMobile(),
      tablet: _AsignPropertyMobile(),
    );
  }
}
