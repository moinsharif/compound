library violation_view;

import 'package:compound/config.dart';
import 'package:compound/core/services/dialog_service.dart';
import 'package:compound/locator.dart';
import 'package:compound/modules/violation/violation_view_model.dart';
import 'package:compound/shared_components/buttons/buttons_choise.dart';
import 'package:compound/shared_components/image_source_picker/image_source_picker.dart';
import 'package:compound/shared_models/type_violation_model.dart';
import 'package:compound/utils/colors_util.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:compound/theme/app_theme.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

part 'violation_mobile.dart';

class ViolationView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ScreenTypeLayout(
      mobile: _ViolationMobile(),
      desktop: _ViolationMobile(),
      tablet: _ViolationMobile(),
    );
  }
}
