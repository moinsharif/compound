import 'package:compound/constants.dart';
import 'package:compound/locator.dart';
import 'package:compound/router.dart';
import 'package:compound/shared_components/bottom_navigator/bottom_navigation_porter_view_model.dart';
import 'package:compound/shared_components/general_message/general_message.dart';
import 'package:compound/shared_components/icon_navigator/icon_navigator.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:compound/core/services/navigation/navigator_service.dart';

class BottomNavigatorPorterWeb extends StatelessWidget {
  BottomNavigatorPorterWeb({Key key}) : super(key: key);

  void _onItemTappedPorter(int index, {bool checkInActive = false}) {
    var routeName = "";
    String textAppBar = "";
    switch (index) {
      case 0:
        routeName = HomeViewRoute;
        textAppBar = ConstantsRoutePage.PROFILE;
        break;
      case 1:
        if (checkInActive) {
          routeName = ManageViewRoute;
          textAppBar = ConstantsRoutePage.MANAGE;
        } else {
          routeName = CheckInViewRoute;
          textAppBar = ConstantsRoutePage.PROPERTY_CHECK_IN;
        }
        break;
      case 2:
        // routeName = ProfileViewRoute;
        break;
      case 3:
        routeName = ViolationViewRoute;
        textAppBar = ConstantsRoutePage.VIOLATION;
        break;
    }

    locator<NavigatorService>()
        .navigateToPageWithReplacement(routeName, title: textAppBar);
  }

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<BottomNavigatorPorterViewModel>.reactive(
        viewModelBuilder: () => BottomNavigatorPorterViewModel(),
        onModelReady: (model) {
          model.load();
        },
        builder: (context, model, child) => Container(
              width: double.infinity,
              height: 50.h,
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
                          if (model.selectedIndex != 0) {
                            model.updatedSelectedIndex(
                                0, ConstantsRoutePage.PROFILE);
                            _onItemTappedPorter(0);
                          }
                        },
                        index: 0,
                        currentIndex: model.selectedIndex,
                      ),
                      IconNavigator(
                        routeImage: 'assets/icons/check_menu.png',
                        onPress: () async {
                          if (model.selectedIndex != 1) {
                            if (await model.loadCheckIn()) {
                              model.updatedSelectedIndex(
                                  1, ConstantsRoutePage.MANAGE);
                              _onItemTappedPorter(1, checkInActive: true);
                            } else {
                              model.updatedSelectedIndex(
                                  1, ConstantsRoutePage.PROPERTY_CHECK_IN);
                              _onItemTappedPorter(1, checkInActive: false);
                            }
                          }
                        },
                        index: 1,
                        currentIndex: model.selectedIndex,
                      ),
                      IconNavigator(
                        routeImage: 'assets/icons/message_menu.png',
                        onPress: () {
                          // model.updatedSelectedIndex(2);
                          _onItemTappedPorter(2);
                        },
                        index: 2,
                        currentIndex: model.selectedIndex,
                      ),
                      IconNavigator(
                        routeImage: 'assets/icons/plus_menu.png',
                        onPress: () async {
                          if (model.selectedIndex != 3) {
                            if (await model.checkInActive()) {
                              model.updatedSelectedIndex(
                                  3, ConstantsRoutePage.VIOLATION);
                              _onItemTappedPorter(3);
                            }
                          }
                        },
                        index: 3,
                        currentIndex: model.selectedIndex,
                      ),
                      IconNavigator(
                        routeImage: 'assets/icons/info_menu.png',
                        onPress: () {
                          Navigator.of(context).push(PageRouteBuilder(
                              opaque: false,
                              pageBuilder: (BuildContext context, _, __) {
                                return GeneralMessage(
                                  isWeb: true,
                                );
                              }));
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
