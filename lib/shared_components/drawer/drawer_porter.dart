import 'package:compound/config.dart';
import 'package:compound/constants.dart';
import 'package:compound/core/services/navigation/navigator_service.dart';
import 'package:compound/locator.dart';
import 'package:compound/router.dart';
import 'package:compound/shared_components/drawer/drawer_porter_view_model.dart';

import 'package:compound/theme/app_theme.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:url_launcher/url_launcher.dart';

class DrawerPorter extends StatelessWidget implements PreferredSizeWidget {
  DrawerPorter({Key key}) : super(key: key);

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);

  void _onItemTappedPorter(int index, {DrawerPorterViewModel modelDrawer}) {
    var routeName = "";
    String textAppBar = "";
    switch (index) {
      case 0:
        routeName = HomeViewRoute;
        textAppBar = ConstantsRoutePage.PROFILE;
        break;
      case 1:
        if (modelDrawer.activeCheckIn) {
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
        textAppBar = ConstantsRoutePage.VIOLATION;
        break;
    }

    locator<NavigatorService>()
        .navigateToPageWithReplacement(routeName, title: textAppBar);
  }

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<DrawerPorterViewModel>.reactive(
        viewModelBuilder: () => DrawerPorterViewModel(),
        onModelReady: (model) {
          model.load();
        },
        builder: (context, model, child) => Drawer(
              child: Container(
                color: Colors.black,
                child: Column(
                  children: <Widget>[
                    DrawerHeader(
                      child: Image.asset(
                        AppTheme.instance.brandIcon,
                        width: 120.0.sp,
                      ),
                      margin: EdgeInsets.zero,
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 15.0.w),
                      color: Colors.black,
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Text('User: ${model.getUserName()}',
                                  style: AppTheme.instance.textStyleSmall(
                                      fontWeight: FontWeight.w500,
                                      color: Color(0xffC6C6C6))),
                              Spacer(),
                              Text('Date: ${model.getCurrentDate()}',
                                  style: AppTheme.instance.textStyleSmall(
                                      fontWeight: FontWeight.w500,
                                      color: Color(0xffC6C6C6))),
                            ],
                          ),
                          SizedBox(
                            height: 5.0,
                          ),
                          Row(
                            children: [
                              Text('Role: ${model.getCurrentRole()}',
                                  style: AppTheme.instance.textStyleSmall(
                                      fontWeight: FontWeight.w500,
                                      color: Color(0xffC6C6C6))),
                            ],
                          )
                        ],
                      ),
                    ),
                    Flexible(
                      child: Container(
                        margin: EdgeInsets.only(left: 15.w, right: 50.0.w),
                        decoration: BoxDecoration(
                          color: Colors.black,
                          border: Border(
                            bottom: BorderSide(
                                color: Color(0XFF3C3D3C).withOpacity(1),
                                width: 1), // red as border color
                          ),
                        ),
                        child: ListTile(
                          contentPadding: EdgeInsets.zero,
                          title: Text('Dashboard',
                              textAlign: TextAlign.start,
                              style: AppTheme.instance.textStyleRegular(
                                  fontWeight: FontWeight.w500,
                                  color: Color(0xffC6C6C6))),
                          onTap: () {
                            model.updatedSelectedIndex(
                                0, ConstantsRoutePage.PROFILE);
                            _onItemTappedPorter(0, modelDrawer: model);
                            Navigator.pop(context);
                          },
                          tileColor: Colors.black,
                        ),
                      ),
                    ),
                    Flexible(
                      child: Container(
                        margin: EdgeInsets.only(left: 15.w, right: 50.0.w),
                        decoration: BoxDecoration(
                          color: Colors.black,
                          border: Border(
                            bottom: BorderSide(
                                color: Color(0XFF3C3D3C).withOpacity(1),
                                width: 1), // red as border color
                          ),
                        ),
                        child: ListTile(
                          contentPadding: EdgeInsets.zero,
                          title: Text('Property Check in',
                              textAlign: TextAlign.start,
                              style: AppTheme.instance.textStyleRegular(
                                  fontWeight: FontWeight.w500,
                                  color: Color(0xffC6C6C6))),
                          onTap: () {
                            if (model.activeCheckIn) {
                              model.updatedSelectedIndex(
                                  1, ConstantsRoutePage.WATCHLIST);
                            } else {
                              model.updatedSelectedIndex(
                                  1, ConstantsRoutePage.PROPERTY_CHECK_IN);
                            }
                            _onItemTappedPorter(1, modelDrawer: model);
                            Navigator.pop(context);
                          },
                          tileColor: Colors.black,
                        ),
                      ),
                    ),
                    Flexible(
                      child: Container(
                        margin: EdgeInsets.only(left: 15.w, right: 50.0.w),
                        decoration: BoxDecoration(
                          color: Colors.black,
                          border: Border(
                            bottom: BorderSide(
                                color: Color(0XFF3C3D3C).withOpacity(1),
                                width: 1), // red as border color
                          ),
                        ),
                        child: ListTile(
                          contentPadding: EdgeInsets.zero,
                          title: Text('Add ${Config.oneViolation}',
                              textAlign: TextAlign.start,
                              style: AppTheme.instance.textStyleRegular(
                                  fontWeight: FontWeight.w500,
                                  color: Color(0xffC6C6C6))),
                          onTap: () async {
                            if (await model.checkInActive()) {
                              model.updatedSelectedIndex(
                                  3, ConstantsRoutePage.VIOLATION);
                              _onItemTappedPorter(3);
                              Navigator.pop(context);
                            }
                          },
                          tileColor: Colors.black,
                        ),
                      ),
                    ),
                    Flexible(
                      child: Container(
                        margin: EdgeInsets.only(left: 15.w, right: 50.0.w),
                        decoration: BoxDecoration(
                          color: Colors.black,
                          border: Border(
                            bottom: BorderSide(
                                color: Color(0XFF3C3D3C).withOpacity(1),
                                width: 1), // red as border color
                          ),
                        ),
                        child: ListTile(
                          contentPadding: EdgeInsets.zero,
                          title: Text('Messages',
                              textAlign: TextAlign.start,
                              style: AppTheme.instance.textStyleRegular(
                                  fontWeight: FontWeight.w500,
                                  color: Color(0xffC6C6C6))),
                          onTap: () {
                            model.updatedSelectedIndex(
                                2, ConstantsRoutePage.MESSAGES);
                            _onItemTappedPorter(2);
                            Navigator.pop(context);
                          },
                          tileColor: Colors.black,
                        ),
                      ),
                    ),
                    Flexible(
                      child: Container(
                        margin: EdgeInsets.only(left: 15.w, right: 50.0.w),
                        child: ListTile(
                          contentPadding: EdgeInsets.zero,
                          title: Text('Log Out',
                              textAlign: TextAlign.start,
                              style: AppTheme.instance.textStyleRegular(
                                  fontWeight: FontWeight.w500,
                                  color: Color(0xffC6C6C6))),
                          onTap: () {
                            model.logOut();
                          },
                          tileColor: Colors.black,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 60.0.h,
                    ),
                    Flexible(
                      child: Container(
                        margin: EdgeInsets.only(left: 15.w, right: 50.0.w),
                        child: TextButton(
                            onPressed: () {
                              _launchUrl();
                            },
                            child: Text(Config.terms,
                                textAlign: TextAlign.start,
                                style: AppTheme.instance.textStyleRegular(
                                    fontWeight: FontWeight.w500,
                                    underlined: true,
                                    color: Color(0xffC6C6C6)))),
                      ),
                    ),
                    Flexible(
                      child: Container(
                        margin: EdgeInsets.only(left: 15.w, right: 50.0.w),
                        child: Text(
                            Config.versionApp +
                                (model.currentBackend == "QA" ? "(QA)" : ""),
                            textAlign: TextAlign.start,
                            style: AppTheme.instance.textStyleRegular(
                                fontWeight: FontWeight.w500,
                                color: Color(0xffC6C6C6))),
                      ),
                    ),
                  ],
                ),
              ),
            ));
  }

  void _launchUrl() async {
    if (!await launch(Config.urlTerms))
      throw 'Could not launch ${Config.urlTerms}';
  }
}
