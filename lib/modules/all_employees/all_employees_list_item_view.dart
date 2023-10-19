import 'package:compound/constants.dart';
import 'package:compound/core/services/navigation/navigator_service.dart';
import 'package:compound/locator.dart';
import 'package:compound/router.dart';
import 'package:compound/shared_models/user_model.dart';
import 'package:compound/theme/app_theme.dart';
import 'package:compound/utils/colors_util.dart';
import 'package:compound/utils/string_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AllEmployeesListItemView extends StatefulWidget {
  User data;
  AllEmployeesListItemView({Key key, this.data}) : super(key: key);

  @override
  _AllEmployeesListItemViewState createState() =>
      _AllEmployeesListItemViewState();
}

class _AllEmployeesListItemViewState extends State<AllEmployeesListItemView> {
  final NavigatorService _navigatorService = locator<NavigatorService>();

  @override
  Widget build(BuildContext context) {
    return Container(
        width: double.infinity,
        color: Colors.transparent,
        child: Padding(
            padding:
                EdgeInsets.only(top: 5.w, bottom: 5.w, left: 0.w, right: 5.w),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                      padding: EdgeInsets.only(
                          top: 5.w, bottom: 15.w, left: 20.w, right: 15.w),
                      child: Text(_name(),
                          style: AppTheme.instance.textStyleSmall(
                              fontWeight: FontWeight.w500,
                              color: Colors.black))),
                  _divider()
                ])));
  }

  Widget _divider() {
    return Divider(
      thickness: 0.8.w,
      height: 0.8.w,
      color: ColorsUtils.getMaterialColor(0xFF979797),
    );
  }

  _name() {
    List<String> name = [];
    if (!StringUtils.isNullOrEmpty(widget.data?.lastName)) {
      name.add(widget.data?.lastName ?? '');
    }
    if (!StringUtils.isNullOrEmpty(widget.data?.firstName)) {
      name.add(widget.data?.firstName ?? '');
    }

    if (name.length < 1) {
      name.add(widget.data?.userName);
    }

    return name.join(", ");
  }
}
