import 'package:flutter/material.dart';
import 'package:compound/theme/app_theme.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart' show SizeExtension;

class CustomSelector extends StatelessWidget {
  final String value;
  final String placeholder;
  final List<String> values;
  final Function(String v) onChange;

  const CustomSelector(
      {Key key,
      @required this.onChange,
      this.placeholder,
      this.value,
      this.values = const []})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100.w,
      padding: EdgeInsets.only(left: 5.w),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5.w),
        border: Border.all(
            color: AppTheme.instance.primaryFontColor.withOpacity(0.4)),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          isDense: true,
          value: value,
          hint: Text(
            placeholder ?? '',
            style: AppTheme.instance.textStyleVerySmall(
              color: AppTheme.instance.primaryFontColor,
              fontWeight: FontWeight.w400,
            ),
          ),
          icon: Icon(Icons.arrow_drop_down_outlined,
              color: AppTheme.instance.primaryFontColor),
          iconSize: 18,
          elevation: 10,
          onChanged: onChange,
          dropdownColor: Colors.white,
          style: TextStyle(color: Colors.red),
          items: values.map<DropdownMenuItem<String>>((String v) {
            return DropdownMenuItem<String>(
              value: v,
              child: Text(
                v,
                style: AppTheme.instance.textStyleVerySmall(
                  color: AppTheme.instance.primaryFontColor,
                  fontWeight: FontWeight.w400,
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
