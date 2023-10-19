import 'package:compound/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart' show SizeExtension;

class WhiteInput extends StatelessWidget {
  final double width;
  final String placeholder;
  final FocusNode focusNode;
  final Function(String v) onChange;
  final TextEditingController controller;

  const WhiteInput({
    Key key,
    this.width,
    this.placeholder,
    this.focusNode,
    this.controller,
    this.onChange,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width ?? 100.w,
      child: TextFormField(
        onChanged: onChange,
        focusNode: focusNode,
        controller: controller,
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
          isDense: true,
          filled: true,
          hintText: placeholder,
          fillColor: Colors.white,
          contentPadding: EdgeInsets.all(10.w),
        ),
        style: AppTheme.instance
            .textStyleSmall(color: AppTheme.instance.primaryFontColor),
      ),
    );
  }
}
