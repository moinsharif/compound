import 'package:compound/theme/app_theme.dart';
import 'package:flutter/material.dart';

class ButtonBlue extends StatelessWidget {
  final Function onpress;
  final String text;

  const ButtonBlue({Key key, @required this.onpress, this.text = 'View All'})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
            color: AppTheme.instance.primaryDarkColorBlue,
            borderRadius: BorderRadius.circular(10.0)),
        child: InkWell(
          onTap: onpress,
          child: Container(
              padding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
              child: Text(text,
                  style: AppTheme.instance.textStyleSmall(
                      color: Colors.white, fontWeight: FontWeight.w600))),
        ));
  }
}
