library add_property_view;

import 'package:compound/config.dart';
import 'package:compound/modules/add_property/add_property_view_model.dart';
import 'package:compound/shared_components/background/background_pattern.dart';
import 'package:compound/shared_components/big_round_action_button/big_round_action_button.dart';
import 'package:compound/shared_components/big_round_action_button/big_round_action_button_web.dart';
import 'package:compound/shared_components/set_rate_property/set_rate_property.dart';
import 'package:compound/shared_models/employee_detail_model.dart';
import 'package:compound/shared_models/market_model.dart';
import 'package:compound/shared_models/porter_model.dart';
import 'package:compound/shared_models/response_google_places.dart';
import 'package:compound/shared_models/user_model.dart';
import 'package:compound/theme/app_theme.dart';
import 'package:compound/utils/colors_util.dart';
import 'package:compound/utils/scale_helper.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:google_places_flutter/google_places_flutter.dart';
import 'package:google_places_flutter/model/prediction.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:stacked/stacked.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:textfield_tags/textfield_tags.dart';
import 'package:time_range_picker/time_range_picker.dart';

part 'add_property_mobile.dart';
part 'add_property_web.dart';

class AddPropertyView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ScreenTypeLayout(
      mobile: _AddPropertyMobile(),
      desktop: _AddPropertyWeb(),
      tablet: _AddPropertyMobile(),
    );
  }
}
