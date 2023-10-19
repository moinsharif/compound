library auth_view;

import 'package:compound/core/initializer/image_initializer.dart';
import 'package:compound/core/services/authentication/authentication_service.dart';
import 'package:compound/core/views/conditional_builder/conditional_builder.dart';
import 'package:compound/locator.dart';
import 'package:compound/modules/auth/auth_view_model.dart';
import 'package:compound/modules/change_password/change_password_view.dart';
import 'package:compound/modules/create_account/create_account_view.dart';
import 'package:compound/modules/forgot_password/forgot_password_view.dart';
import 'package:compound/modules/login/login_view.dart';
import 'package:compound/shared_components/background/background_pattern.dart';
import 'package:compound/shared_components/image/image.dart';
import 'package:compound/ui/shared/ui_helpers.dart';
import 'package:compound/utils/view_utils.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:compound/theme/app_theme.dart';
import 'package:provider/provider.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

part 'auth_mobile.dart';
part 'auth_web.dart';

class AuthView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ScreenTypeLayout(
      mobile: _AuthMobile(),
      desktop: _AuthWeb(),
      tablet: _AuthMobile(),
    );
  }
}
