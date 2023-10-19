import 'package:compound/config.dart';
import 'package:compound/constants.dart';
import 'package:compound/locator.dart';
import 'package:compound/router.dart';
import 'package:compound/shared_components/bottom_navigator/bottom_navigator_view_model.dart';
import 'package:compound/core/services/navigation/navigator_service.dart';
import 'package:compound/shared_components/bottoms_pages/bottoms_page_view_model.dart';
import 'package:compound/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:stacked/stacked.dart';

class BottomPage extends StatelessWidget {
  BottomPage({Key key}) : super(key: key);

  void _onItemTapped(int index, {BottomsPageViewModel model}) {
    var routeName = "";
    String textAppBar = "";
    switch (index) {
      case 1:
        if (model.activeCheckIn) {
          routeName = WatchlistViewRoute;
          textAppBar = ConstantsRoutePage.WATCHLIST;
        } else {
          routeName = CheckInViewRoute;
          textAppBar = ConstantsRoutePage.PROPERTY_CHECK_IN;
        }
        break;
      case 2:
        routeName = MessagingViewRoute;
        textAppBar = ConstantsRoutePage.MESSAGES;
        break;
      case 3:
        routeName = ViolationViewRoute;
        textAppBar = Config.violations;
        break;
    }

    locator<NavigatorService>()
        .navigateToPageWithReplacement(routeName, title: textAppBar);
  }

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<BottomsPageViewModel>.reactive(
        viewModelBuilder: () => BottomsPageViewModel(),
        onModelReady: (model) {
          model.load();
        },
        builder: (context, model, child) => Container(
              width: double.infinity,
              height: 85.h,
              child: Column(
                children: [
                  Container(
                    height: 15.0,
                  ),
                  Container(
                    decoration: BoxDecoration(color: Colors.white, boxShadow: [
                      BoxShadow(color: Colors.white, offset: Offset(0, -3))
                    ]),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        InkWell(
                          child: Column(
                            children: [
                              Image.asset(
                                'assets/icons/check_menu.png',
                                width: ScreenUtil().setWidth(20),
                                color: Color(0XFF606060),
                              ),
                              Text('Check In',
                                  style: AppTheme.instance.textStyleSmall(
                                      fontWeight: FontWeight.bold,
                                      color: Color(0XFF606060).withOpacity(1)))
                            ],
                          ),
                          onTap: () {
                            if (model.activeCheckIn) {
                              model.updatedSelectedIndex(
                                  1, ConstantsRoutePage.MANAGE);
                            } else {
                              model.updatedSelectedIndex(
                                  1, ConstantsRoutePage.PROPERTY_CHECK_IN);
                            }
                            _onItemTapped(1, model: model);
                          },
                        ),
                        Container(
                          color: Color(0XFFDEDEDE),
                          height: 70.h,
                          width: 1,
                        ),
                        InkWell(
                          child: Column(
                            children: [
                              Image.asset('assets/icons/plus_menu.png',
                                  width: ScreenUtil().setWidth(20),
                                  color: Color(0XFF606060)),
                              Text('Add ${Config.oneViolation}',
                                  style: AppTheme.instance.textStyleSmall(
                                      fontWeight: FontWeight.bold,
                                      color: Color(0XFF606060).withOpacity(1)))
                            ],
                          ),
                          onTap: () async {
                            if (await model.checkInActive()) {
                              model.updatedSelectedIndex(
                                  3, ConstantsRoutePage.VIOLATION);
                              _onItemTapped(3);
                            }
                          },
                        ),
                        Container(
                          color: Color(0XFFDEDEDE),
                          height: 70.h,
                          width: 1,
                        ),
                        InkWell(
                          child: Column(
                            children: [
                              Image.asset('assets/icons/message_menu.png',
                                  width: ScreenUtil().setWidth(20),
                                  color: Color(0XFF606060)),
                              Text('Messages',
                                  style: AppTheme.instance.textStyleSmall(
                                      fontWeight: FontWeight.bold,
                                      color: Color(0XFF606060).withOpacity(1)))
                            ],
                          ),
                          onTap: () {
                            model.updatedSelectedIndex(
                                2, ConstantsRoutePage.MESSAGES);
                            _onItemTapped(2);
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ));
  }
}
