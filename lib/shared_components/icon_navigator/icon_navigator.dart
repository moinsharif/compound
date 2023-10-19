import 'package:compound/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class IconNavigator extends StatelessWidget {
  final String routeImage;
  final Function onPress;
  final int index;
  final int currentIndex;
  const IconNavigator({
    Key key,
    @required this.routeImage,
    @required this.onPress,
    @required this.index,
    @required this.currentIndex,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Stack(
        alignment: Alignment.center,
        children: [
          if (index == currentIndex)
            Container(
              margin: EdgeInsets.only(bottom: 2.sp),
              width: 22.sp,
              decoration: BoxDecoration(
                  border: Border(
                      top: BorderSide(
                          color: AppTheme.instance.primaryColorBlue,
                          width: 4))),
            ),
          if (currentIndex == -1)
            Container(
              margin: EdgeInsets.only(bottom: 2.sp),
              width: 22.sp,
              decoration: BoxDecoration(
                  border: Border(
                      top: BorderSide(color: Colors.transparent, width: 4))),
            ),
          Container(
              margin: EdgeInsets.only(bottom: 2.sp),
              child: GestureDetector(
                onTap: onPress,
                child: Image.asset(
                  routeImage,
                  fit: BoxFit.contain,
                  width: 25.sp,
                ),
              ))
        ],
      ),
    );
  }
}
