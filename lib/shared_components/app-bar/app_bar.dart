import 'package:compound/modules/messaging/messaging_button/messaging_button.dart';
import 'package:compound/shared_components/app-bar/app_bar_view_model.dart';
import 'package:compound/theme/app_theme.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

class AppBarCustom extends StatelessWidget implements PreferredSizeWidget {
  AppBarCustom({Key key}) : super(key: key);

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<AppBarViewModel>.reactive(
        viewModelBuilder: () => AppBarViewModel(),
        onModelReady: (model) {
          model.load();
        },
        builder: (context, model, child) => model.hidden
            ? Container()
            : SafeArea(
                child: AppBar(
                  title: Text(
                    model.titleAppBar,
                    style: AppTheme.instance.textStyleTitles(
                        color: Colors.white, fontWeight: FontWeight.w300),
                  ),
                  backgroundColor: Colors.black,
                  centerTitle: true,
                  actions: [
                    if (model.showFilterViolations)
                      IconButton(
                          padding: EdgeInsets.symmetric(horizontal: 0.0),
                          constraints: BoxConstraints(maxWidth: 18.0.sp),
                          icon: Image.asset(
                            'assets/icons/filter.png',
                            color: Colors.white,
                            width: 20.sp,
                          ),
                          onPressed: model.functionFilterViolations),
                    if (model.showMessages) MessagingButton(),
                    IconButton(
                        icon: Icon(
                          Icons.power_settings_new_outlined,
                          color: Colors.white.withOpacity(1),
                          size: 20.sp,
                        ),
                        onPressed: () {
                          model.logOut();
                        })
                  ],
                ),
              ));
  }
}
