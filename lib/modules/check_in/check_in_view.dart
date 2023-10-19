library check_in_view;

import 'package:compound/core/services/dialog_service.dart';
import 'package:compound/locator.dart';
import 'package:compound/modules/check_in/check_in_view_model.dart';
import 'package:compound/shared_components/background/background_pattern.dart';
import 'package:compound/shared_components/buttons/buttons_choise.dart';
import 'package:compound/shared_components/driving_direction/driving_direction.dart';
import 'package:compound/shared_components/image_source_picker/image_source_picker.dart';
import 'package:compound/shared_components/loading/loading.dart';
import 'package:compound/shared_components/maps/maps_custom.dart';
import 'package:compound/shared_models/property_model.dart';
import 'package:compound/utils/colors_util.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:compound/theme/app_theme.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

part 'check_in_mobile.dart';


class CheckInView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ScreenTypeLayout(
          mobile: CheckInMobile(),
          desktop: CheckInMobile(),
          tablet: CheckInMobile(),  
        );
    }
}