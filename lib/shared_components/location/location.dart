import 'package:compound/shared_components/location/location_view_model.dart';
import 'package:compound/theme/app_theme.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

class Location extends StatelessWidget implements PreferredSizeWidget {
  Location({Key key}) : super(key: key);

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<LocationViewModel>.reactive(
        viewModelBuilder: () => LocationViewModel(),
        onModelReady: (model) {
          model.load();
        },
        builder: (context, model, child) => !model.busy
            ? Container(
                child: Text(
                  model.data,
                  overflow: TextOverflow.ellipsis,
                  style: AppTheme.instance.textStyleSmall(
                      color: Colors.black, fontWeight: FontWeight.w400),
                ),
              )
            : Row(
                children: [
                  Container(
                      child: SizedBox(
                    width: 10.sp,
                    height: 10.sp,
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.black),
                      strokeWidth: 1.0,
                    ),
                  )),
                ],
              ));
  }
}
