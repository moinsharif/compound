library home_view;

import 'package:compound/core/services/authentication/authentication_service.dart';
import 'package:compound/modules/home/home_admin.dart';
import 'package:compound/modules/home/home_admin_web.dart';
import 'package:compound/modules/home/home_porter.dart';
import 'package:compound/modules/home/home_porter_web.dart';
import 'package:compound/modules/home/home_view_model.dart';
import 'package:compound/shared_components/background/background_pattern.dart';
import 'package:compound/theme/app_theme.dart';
import 'package:flutter/foundation.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

part 'home_view_mobile.dart';
part 'home_view_web.dart';

class HomeView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ScreenTypeLayout(
      mobile: _HomeViewMobile(),
      desktop: _HomeViewWeb(),
      tablet: _HomeViewMobile(),
    );
  }
}
