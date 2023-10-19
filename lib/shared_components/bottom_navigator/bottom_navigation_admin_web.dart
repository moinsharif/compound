import 'package:compound/config.dart';
import 'package:compound/constants.dart';
import 'package:compound/locator.dart';
import 'package:compound/router.dart';
import 'package:compound/shared_components/bottom_navigator/bottom_navigation_admin_view_model.dart';
import 'package:compound/shared_components/icon_navigator/icon_navigator.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:compound/core/services/navigation/navigator_service.dart';

class BottomNavigatorAdminWeb extends StatelessWidget {
  BottomNavigatorAdminWeb({Key key}) : super(key: key);

  void _onItemTappedAdmin(int index) {
    var routeName = "";
    var title = "";
    switch (index) {
      case 0:
        routeName = HomeViewRoute;
        title = ConstantsRoutePage.ADMIN_HOME;
        break;
      case 1:
        routeName = EmployeesPayrollViewRoute;
        title = ConstantsRoutePage.PAYROLLEMPLOYEE;
        break;
      case 2:
        routeName = MessagingViewRoute;
        title = ConstantsRoutePage.MESSAGES;
        break;
      case 3:
        routeName = PropertiesViewRoute;
        title = ConstantsRoutePage.PROPERTIES;
        break;
      case 4:
        routeName = AllViolationViewRoute;
        title = Config.violations;
        break;
    }

    locator<NavigatorService>()
        .navigateToPageWithReplacement(routeName, title: title);
  }

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<BottomNavigatorAdminViewModel>.reactive(
        viewModelBuilder: () => BottomNavigatorAdminViewModel(),
        onModelReady: (model) {
          model.load();
        },
        builder: (context, model, child) => Container(
              width: double.infinity,
              height: 60.sp,
              child: Stack(
                children: [
                  Container(
                    margin: EdgeInsets.only(top: 2),
                    decoration: BoxDecoration(
                        border: Border(
                            top: BorderSide(
                                color: Color(0XFF4A4A4A).withOpacity(0.5),
                                width: 1))),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      IconNavigator(
                        routeImage: 'assets/icons/home_menu.png',
                        onPress: () {
                          model.updatedSelectedIndex(
                              0, ConstantsRoutePage.PROFILE);
                          _onItemTappedAdmin(0);
                        },
                        index: 0,
                        currentIndex: model.selectedIndex,
                      ),
                      IconNavigator(
                        routeImage: 'assets/icons/money_menu.png',
                        onPress: () {
                          model.updatedSelectedIndex(
                              1, ConstantsRoutePage.PROPERTY_CHECK_IN);
                          _onItemTappedAdmin(1);
                        },
                        index: 1,
                        currentIndex: model.selectedIndex,
                      ),
                      IconNavigator(
                        routeImage: 'assets/icons/message_menu.png',
                        onPress: () {
                          model.updatedSelectedIndex(
                              2, ConstantsRoutePage.MESSAGES);
                          _onItemTappedAdmin(2);
                        },
                        index: 2,
                        currentIndex: model.selectedIndex,
                      ),
                      IconNavigator(
                        routeImage: 'assets/icons/property_menu.png',
                        onPress: () {
                          model.updatedSelectedIndex(
                              3, ConstantsRoutePage.PROPERTIES);
                          _onItemTappedAdmin(3);
                        },
                        index: 3,
                        currentIndex: model.selectedIndex,
                      ),
                      IconNavigator(
                        routeImage: 'assets/icons/plus_menu.png',
                        onPress: () {
                          model.updatedSelectedIndex(4, Config.violations);
                          _onItemTappedAdmin(4);
                        },
                        index: 4,
                        currentIndex: model.selectedIndex,
                      ),
                    ],
                  ),
                ],
              ),
            ));
  }
}
