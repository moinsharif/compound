import 'package:compound/theme/app_theme.dart';
import 'package:flutter/material.dart';

class CustomCheckbox extends StatelessWidget {
  final bool selected;
  final Function(bool v) onChange;

  const CustomCheckbox(
      {Key key, @required this.onChange, this.selected = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData(
        unselectedWidgetColor: AppTheme.instance.primaryFontColor
      ),
      child: Checkbox(
        activeColor: Colors.white,
        checkColor: AppTheme.instance.primaryColorBlue,
        value: selected,
        onChanged: onChange,
      ),
    );
  }
}
