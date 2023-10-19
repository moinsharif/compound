import 'package:compound/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class BigRoundActionButtonView extends StatelessWidget {
  final Function onTap;
  final String title;
  final String icon;
  final bool busy;
  final bool isWeb;

  const BigRoundActionButtonView(this.onTap, this.title, this.icon,
      {Key key, this.busy = false, this.isWeb = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return _button();
  }

  Widget _button() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 5.w),
      child: InkWell(
        onTap: () => onTap(),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            busy
                ? Container(
                    width: isWeb ? 15.w : 45.w,
                    height: isWeb ? 15.w : 45.w,
                    decoration: BoxDecoration(
                      color: AppTheme.instance.primaryColorBlue,
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  )
                : Container(
                    width: isWeb ? 15.w : 45.w,
                    height: isWeb ? 15.w : 45.w,
                    decoration: BoxDecoration(
                      color: AppTheme.instance.primaryColorBlue,
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Image.asset(
                        this.icon,
                        height: isWeb ? 10.w : 30.w,
                      ),
                    ),
                  ),
            Text(
              title,
              style: TextStyle(
                  decoration: TextDecoration.none,
                  fontSize: isWeb ? 5.w : 15.w,
                  color: AppTheme.instance.primaryColorBlue),
            ),
          ],
        ),
      ),
    );
  }
}
