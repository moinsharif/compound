library drawer_view;

import 'package:compound/shared_components/drawer/drawer_adminWeb.dart';
import 'package:flutter/cupertino.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:compound/constants.dart';
import 'package:compound/core/services/navigation/navigator_service.dart';
import 'package:compound/locator.dart';
import 'package:compound/router.dart';
import 'package:compound/shared_components/drawer/drawer_admin.dart';
import 'package:compound/shared_components/drawer/drawer_porter.dart';
import 'package:compound/shared_components/drawer/drawer_view_model.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

part 'drawer.dart';
part 'drawer_custom_web.dart';

class DrawerView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ScreenTypeLayout(
      mobile: DrawerCustom(),
      desktop: DrawerCustomWeb(),
      tablet: DrawerCustom(),
    );
  }
}
