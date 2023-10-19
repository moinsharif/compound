library bottom_navigation_view;

import 'package:compound/shared_components/bottom_navigator/bottom_navigation_admin_web.dart';
import 'package:compound/shared_components/bottom_navigator/bottom_navigation_porter_web.dart';
import 'package:compound/shared_components/upload_progress_bar/upload_progress_bar.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:compound/shared_components/bottom_navigator/bottom_navigation_admin.dart';
import 'package:compound/shared_components/bottom_navigator/bottom_navigation_porter.dart';
import 'package:compound/shared_components/bottom_navigator/bottom_navigator_view_model.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

import '../../constants.dart';
import '../../router.dart';

part 'bottom_navigator_custom.dart';
part 'bottom_navigator_custom_web.dart';

class BottomNavigationView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ScreenTypeLayout(
      mobile: BottomNavigatorCustom(),
      desktop: BottomNavigatorCustomWeb(),
      tablet: BottomNavigatorCustom(),
    );
  }
}
