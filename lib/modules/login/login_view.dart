library login_view;

import 'package:compound/config.dart';
import 'package:compound/core/services/authentication/authentication_service.dart';
import 'package:compound/core/services/navigation/navigator_service.dart';
import 'package:compound/locator.dart';
import 'package:compound/router.dart';
import 'package:compound/shared_components/cards/card_with_button.dart';
import 'package:compound/ui/shared/ui_helpers.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:compound/modules/login/login_view_model.dart';
import 'package:compound/shared_components/buttons/button_primary.dart';
import 'package:compound/theme/app_theme.dart';
import 'package:compound/utils/colors_util.dart';
import 'package:compound/utils/scale_helper.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:url_launcher/url_launcher.dart';

part 'login_view_mobile.dart';
part 'login_view_web.dart';


class LoginView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ScreenTypeLayout(
      mobile: _LoginViewMobile(),
      desktop: _LoginViewWeb(),
      tablet: _LoginViewMobile(),
    );
  }
}
