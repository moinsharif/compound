library create_account_view;

import 'package:compound/core/services/dialog_service.dart';
import 'package:compound/locator.dart';
import 'package:compound/modules/edit_account/edit_account_view_model.dart';
import 'package:compound/shared_components/buttons/buttons_choise.dart';
import 'package:compound/shared_components/buttons/buttons_choise_web.dart';
import 'package:compound/shared_components/cards/card_with_button.dart';
import 'package:compound/shared_components/cards/card_with_button_web.dart';
import 'package:compound/shared_models/market_model.dart';
import 'package:compound/ui/shared/ui_helpers.dart';
import 'package:compound/utils/scale_helper.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:compound/theme/app_theme.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

part 'edit_account_mobile.dart';
part 'edit_account_web.dart';

class EditAccountView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ScreenTypeLayout(
      mobile: _EditAccountMobile(),
      desktop: _EditAccountWeb(),
      tablet: _EditAccountMobile(),
    );
  }
}
