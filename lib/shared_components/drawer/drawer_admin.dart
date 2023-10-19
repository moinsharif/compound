import 'package:compound/config.dart';
import 'package:compound/constants.dart';
import 'package:compound/core/services/navigation/navigator_service.dart';
import 'package:compound/locator.dart';
import 'package:compound/router.dart';
import 'package:compound/shared_components/drawer/drawer_admin_view_model.dart';

import 'package:compound/theme/app_theme.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:url_launcher/url_launcher.dart';

class DrawerAdmin extends StatelessWidget implements PreferredSizeWidget {
  DrawerAdmin({Key key}) : super(key: key);

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);

  void _onItemTappedAdmin(int index, {DrawerAdminViewModel modelDrawer}) {
    var routeName = "";
    String textAppBar = "";
    switch (index) {
      case 0:
        routeName = HomeViewRoute;
        textAppBar = ConstantsRoutePage.ADMIN_HOME;
        break;
      case 1:
        routeName = MessagingViewRoute;
        textAppBar = ConstantsRoutePage.MESSAGES;
        break;
      case 2:
        routeName = EmployeesViewRoute;
        textAppBar = ConstantsRoutePage.ALLEMPLOYEES;
        break;
      case 3:
        routeName = AllMarketsViewRoute;
        textAppBar = ConstantsRoutePage.MARKETS;
        break;
      case 4:
        routeName = PropertiesViewRoute;
        textAppBar = ConstantsRoutePage.PROPERTIES;
        break;
      case 6:
        routeName = AllTimeSheetViewRoute;
        textAppBar = ConstantsRoutePage.TIMESHEET;
        break;
      case 7:
        routeName = AllViolationViewRoute;
        textAppBar = Config.violations;
        break;
      case 9:
        routeName = IssuesViewRoute;
        textAppBar = ConstantsRoutePage.ISSUES;
        break;
      case 10:
        routeName = CalendarViewRoute;
        textAppBar = ConstantsRoutePage.SCHEDULING;
        break;
    }

    locator<NavigatorService>()
        .navigateToPageWithReplacement(routeName, title: textAppBar);
  }

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<DrawerAdminViewModel>.reactive(
        viewModelBuilder: () => DrawerAdminViewModel(),
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
                                0, ConstantsRoutePage.ADMIN_HOME);
                            _onItemTappedAdmin(0, modelDrawer: model);
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
                          title: Text('Timesheet',
                              textAlign: TextAlign.start,
                              style: AppTheme.instance.textStyleRegular(
                                  fontWeight: FontWeight.w500,
                                  color: Color(0xffC6C6C6))),
                          onTap: () {
                            model.updatedSelectedIndex(
                                1, ConstantsRoutePage.TIMESHEET);
                            _onItemTappedAdmin(6, modelDrawer: model);
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
                          title: Text('Scheduling',
                              textAlign: TextAlign.start,
                              style: AppTheme.instance.textStyleRegular(
                                  fontWeight: FontWeight.w500,
                                  color: Color(0xffC6C6C6))),
                          onTap: () {
                            model.updatedSelectedIndex(
                                0, ConstantsRoutePage.ADMIN_HOME);
                            _onItemTappedAdmin(10, modelDrawer: model);
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
                          title: Text('Messages',
                              textAlign: TextAlign.start,
                              style: AppTheme.instance.textStyleRegular(
                                  fontWeight: FontWeight.w500,
                                  color: Color(0xffC6C6C6))),
                          onTap: () {
                            model.updatedSelectedIndex(
                                2, ConstantsRoutePage.MESSAGES);
                            _onItemTappedAdmin(1, modelDrawer: model);
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
                          title: Text('Team',
                              textAlign: TextAlign.start,
                              style: AppTheme.instance.textStyleRegular(
                                  fontWeight: FontWeight.w500,
                                  color: Color(0xffC6C6C6))),
                          onTap: () {
                            _onItemTappedAdmin(2, modelDrawer: model);
                            model.updatedSelectedIndex(
                                -1, ConstantsRoutePage.ALLEMPLOYEES);
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
                          title: Text('Markets',
                              textAlign: TextAlign.start,
                              style: AppTheme.instance.textStyleRegular(
                                  fontWeight: FontWeight.w500,
                                  color: Color(0xffC6C6C6))),
                          onTap: () {
                            model.updatedSelectedIndex(
                                -1, ConstantsRoutePage.MARKETS);
                            _onItemTappedAdmin(3, modelDrawer: model);
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
                          title: Text('Properties',
                              textAlign: TextAlign.start,
                              style: AppTheme.instance.textStyleRegular(
                                  fontWeight: FontWeight.w500,
                                  color: Color(0xffC6C6C6))),
                          onTap: () {
                            model.updatedSelectedIndex(
                                3, ConstantsRoutePage.PROPERTIES);
                            _onItemTappedAdmin(4, modelDrawer: model);
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
                          title: Text(Config.violations,
                              textAlign: TextAlign.start,
                              style: AppTheme.instance.textStyleRegular(
                                  fontWeight: FontWeight.w500,
                                  color: Color(0xffC6C6C6))),
                          onTap: () {
                            model.updatedSelectedIndex(4, Config.violations);
                            _onItemTappedAdmin(7, modelDrawer: model);
                            Navigator.pop(context);
                          },
                          tileColor: Colors.black,
                        ),
                      ),
                    ),
                    // Flexible(
                    //   child: Container(
                    //     margin: EdgeInsets.only(left: 15.w, right: 50.0.w),
                    //     decoration: BoxDecoration(
                    //       color: Colors.black,
                    //       border: Border(
                    //         bottom: BorderSide(
                    //             color: Color(0XFF3C3D3C).withOpacity(1),
                    //             width: 1), // red as border color
                    //       ),
                    //     ),
                    //     child: ListTile(
                    //       contentPadding: EdgeInsets.zero,
                    //       title: Text('Watch List',
                    //           textAlign: TextAlign.start,
                    //           style: AppTheme.instance.textStyleRegular(
                    //               fontWeight: FontWeight.w500,
                    //               color: Color(0xffC6C6C6))),
                    //       onTap: () {
                    //         _onItemTappedAdmin(8, modelDrawer: model);
                    //         Navigator.pop(context);
                    //       },
                    //       tileColor: Colors.black,
                    //     ),
                    //   ),
                    // ),
                    // Flexible(
                    //   child: Container(
                    //     margin: EdgeInsets.only(left: 15.w, right: 50.0.w),
                    //     decoration: BoxDecoration(
                    //       color: Colors.black,
                    //       border: Border(
                    //         bottom: BorderSide(
                    //             color: Color(0XFF3C3D3C).withOpacity(1),
                    //             width: 1), // red as border color
                    //       ),
                    //     ),
                    //     child: ListTile(
                    //       contentPadding: EdgeInsets.zero,
                    //       title: Text('Issues',
                    //           textAlign: TextAlign.start,
                    //           style: AppTheme.instance.textStyleRegular(
                    //               fontWeight: FontWeight.w500,
                    //               color: Color(0xffC6C6C6))),
                    //       onTap: () {
                    //         model.updatedSelectedIndex(
                    //             -1, ConstantsRoutePage.ISSUES);
                    //         _onItemTappedAdmin(9, modelDrawer: model);
                    //         Navigator.pop(context);
                    //       },
                    //       tileColor: Colors.black,
                    //     ),
                    //   ),
                    // ),
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
                    )
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
