import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart' show SizeExtension;

import 'package:compound/theme/app_theme.dart';

class ButtonIcon extends StatelessWidget {
  final Color color;
  final String text;
  final IconData icon;
  final Function onPress;

  const ButtonIcon(
      {Key key, @required this.onPress, this.icon, this.color, this.text})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPress,
      child: Container(
        padding: text != null && text.isNotEmpty
            ? EdgeInsets.symmetric(vertical: 4.w)
            : EdgeInsets.all(1.w),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(kIsWeb ? 5 : 5.w),
          border: Border.all(
            color: color ?? AppTheme.instance.primaryFontColor.withOpacity(0.5),
          ),
        ),
        child: text != null && text.isNotEmpty
            ? Text(
                text,
                style: AppTheme.instance.textStyleVerySmall(
                  color: AppTheme.instance.primaryFontColor,
                  fontWeight: FontWeight.w400,
                ),
              )
            : Icon(
                icon ?? Icons.close,
                size: kIsWeb ? 18 : 18.w,
                color: color ??
                    AppTheme.instance.primaryFontColor.withOpacity(0.5),
              ),
      ),
    );
  }
}
