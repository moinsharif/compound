library all_employees_view;

import 'package:compound/modules/messaging/viewmodels/messaging_person_picker_model.dart';
import 'package:compound/modules/messaging/views/messaging_person_picker_list_item_view.dart';
import 'package:compound/shared_components/background/background_pattern.dart';
import 'package:compound/shared_models/user_model.dart';
import 'package:compound/theme/app_theme.dart';
import 'package:compound/utils/colors_util.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
part 'messaging_person_picker_mobile_view.dart';

class MessagingPersonPickerView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ScreenTypeLayout(
      mobile: MessagingPersonPickerMobileView(),
      desktop: MessagingPersonPickerMobileView(),
      tablet: MessagingPersonPickerMobileView(),
    );
  }
}
