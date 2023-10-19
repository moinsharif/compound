library properties_view;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:compound/modules/properties/properties_view_model.dart';
import 'package:compound/shared_components/big_round_action_button/big_round_action_button.dart';
import 'package:compound/shared_components/flag_property/flagModal.dart';
import 'package:compound/shared_models/property_model.dart';
import 'package:compound/utils/colors_util.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:compound/theme/app_theme.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:stacked/stacked.dart';
import 'package:compound/shared_components/background/background_pattern.dart';

part 'properties_mobile.dart';
part 'properties_web.dart';

class PropertiesView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ScreenTypeLayout(
      mobile: _PropertiesMobile(),
      desktop: _PropertiesWeb(),
      tablet: _PropertiesMobile(),
    );
  }
}
