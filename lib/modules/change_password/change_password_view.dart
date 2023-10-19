library change_password_view;

import 'package:compound/modules/change_password/change_password_view_model.dart';
import 'package:compound/shared_components/cards/card_with_button.dart';
import 'package:compound/ui/shared/ui_helpers.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:compound/modules/login/login_view_model.dart';
import 'package:compound/shared_components/buttons/button_primary.dart';
import 'package:compound/theme/app_theme.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
part 'change_password_mobile.dart';


class ChangePasswordView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ScreenTypeLayout(
          mobile: _ChangePasswordMobile(),
          desktop: _ChangePasswordMobile(),
          tablet: _ChangePasswordMobile(),  
        );
    }
}