import 'package:compound/modules/activity_log/activity_log.dart';
import 'package:compound/modules/home/home_admin_view_model.dart';
import 'package:compound/shared_components/buttons/button_blue.dart';
import 'package:compound/shared_components/list_activity/list_activity.dart';
import 'package:compound/shared_components/payroll_admin/payroll_admin.dart';
import 'package:compound/shared_components/violation_summary/violation_summary.dart';
import 'package:compound/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HomeAdmin extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<HomeAdminViewModel>.reactive(
        viewModelBuilder: () => HomeAdminViewModel(),
        onModelReady: (model) {
          model.safeActionRefreshable(() => model.load());
        },
        builder: (context, model, child) => Column(
              children: [
                Container(
                  height: 90.0.h,
                  padding: EdgeInsets.symmetric(horizontal: 20.0.w),
                  decoration: BoxDecoration(
                      color: AppTheme.instance.primaryDarkColorBlue),
                  alignment: Alignment.bottomLeft,
                  child: Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Image.asset(
                          'assets/images/logo_doorstep.png',
                          color: Colors.white,
                          scale: 2.0,
                        ),
                        SizedBox(
                          width: 20.0,
                        ),
                        Expanded(
                          child: Text(
                            'Welcome Back, ${model.getUserName()}',
                            textAlign: TextAlign.start,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: AppTheme.instance.textStyleRegular(
                                color: Colors.white,
                                fontWeight: FontWeight.w600),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                ViolationSummary(),
                PayrollAdmin(),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 20.0.w),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        child: Text(
                          'Activity Log',
                          style: AppTheme.instance.textStyleSmall(
                              color: AppTheme.instance.primaryDarkColorBlue,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      ButtonBlue(
                        onpress: () async {
                          await model.goToAllActivities();
                        },
                      )
                    ],
                  ),
                ),
                Container(
                  height: 300.0.h,
                  child: ListActivity(),
                )
              ],
            ));
  }
}
