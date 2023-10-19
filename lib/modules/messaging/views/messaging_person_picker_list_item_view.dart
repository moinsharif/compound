import 'package:compound/shared_models/employee_detail_model.dart';
import 'package:compound/shared_models/user_model.dart';
import 'package:compound/theme/app_theme.dart';
import 'package:compound/utils/colors_util.dart';
import 'package:compound/utils/string_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MessagingPersonPickerListItemView extends StatelessWidget {
  final User data;
  const MessagingPersonPickerListItemView({Key key, this.data})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
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
    if (!StringUtils.isNullOrEmpty(data.lastName)) {
      name.add(data.lastName);
    }
    if (!StringUtils.isNullOrEmpty(data.firstName)) {
      name.add(data.firstName);
    }

    if (name.length < 1) {
      name.add(data.userName);
    }

    return name.join(", ");
  }
}
