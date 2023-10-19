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

class AllEmployeesListItemViewWeb extends StatefulWidget {
  User data;
  AllEmployeesListItemViewWeb({Key key, this.data}) : super(key: key);

  @override
  _AllEmployeesListItemViewWebState createState() =>
      _AllEmployeesListItemViewWebState();
}

class _AllEmployeesListItemViewWebState
    extends State<AllEmployeesListItemViewWeb> {
  final NavigatorService _navigatorService = locator<NavigatorService>();

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Padding(
            padding: EdgeInsets.only(top: 5, bottom: 5, left: 0, right: 5),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                      padding: EdgeInsets.only(
                          top: 5, bottom: 15, left: 20, right: 15),
                      child: GestureDetector(
                          onTap: () async {
                            await _navigatorService
                                .navigateTo(
                              EditAccountViewRoute,
                              arguments: widget.data,
                              title: ConstantsRoutePage.EDITUSER,
                            )
                                .then((value) {
                              setState(() {
                                widget.data = value;
                              });
                            });
                          },
                          child: Text(
                            _name(),
                            style: AppTheme.instance.textStyleRegular(
                                color: Colors.black45,
                                fontWeight: FontWeight.w500),
                          ))),
                  _divider()
                ])));
  }

  Widget _divider() {
    return Divider(
      thickness: 0.8,
      height: 0.8,
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
