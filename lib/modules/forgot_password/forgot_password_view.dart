library forgot_password_view;

import 'package:compound/core/services/authentication/authentication_service.dart';
import 'package:compound/core/services/navigation/navigator_service.dart';
import 'package:compound/locator.dart';
import 'package:compound/modules/forgot_password/forgot_password_view_model.dart';
import 'package:compound/router.dart';
import 'package:compound/shared_components/cards/card_with_button.dart';
import 'package:compound/ui/shared/ui_helpers.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:compound/theme/app_theme.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

part 'forgot_password_mobile.dart';
part 'forgot_password_web.dart';

class ForgotPasswordView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ScreenTypeLayout(
      mobile: _ForgotPasswordViewMobile(),
      desktop: _ForgotPasswordViewWeb(),
      tablet: _ForgotPasswordViewMobile(),
    );
  }
}
