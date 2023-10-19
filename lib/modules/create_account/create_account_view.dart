library create_account_view;

import 'package:compound/core/services/authentication/authentication_service.dart';
import 'package:compound/modules/create_account/create_account_view_model.dart';
import 'package:compound/shared_components/cards/card_with_button.dart';
import 'package:compound/ui/shared/ui_helpers.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:compound/theme/app_theme.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

part 'create_account_mobile.dart';
part 'create_account_web.dart';

class CreateAccountView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ScreenTypeLayout(
      mobile: _CreateAccountMobile(),
      desktop: _CreateAccountWeb(),
      tablet: _CreateAccountMobile(),
    );
  }
}
