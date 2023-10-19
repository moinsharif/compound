import 'package:compound/theme/app_theme.dart';
import 'package:compound/utils/scale_helper.dart';
import 'package:flutter/material.dart';

class ButtonPrimary extends StatefulWidget {
  final bool busy;
  final String title;
  final Function onPressed;
  final bool enabled;
  final double width;
  final double height;
  final TextStyle textStyle;
  final IconData icon;
  final Widget childIcon;
  final Color borderColor;
  final Color fillColor;
  final double bordeRadius;

  const ButtonPrimary(
      {@required this.title,
      this.busy = false,
      @required this.onPressed,
      this.enabled = true,
      this.width = 0,
      this.height = 60,
      this.textStyle = const TextStyle(fontSize: 18),
      this.icon,
      this.childIcon,
      this.borderColor,
      this.fillColor,
      this.bordeRadius = 15.0});

  @override
  _ButtonPrimaryState createState() => _ButtonPrimaryState();
}

class _ButtonPrimaryState extends State<ButtonPrimary> {
  @override
  Widget build(BuildContext context) {
    return ButtonTheme(
        height: this.widget.height,
        child: Container(
            height: this.widget.height,
            width: this.widget.width == 0
                ? ScaleHelper.rsDoubleW(context, 65)
                : this.widget.width,
            child: RaisedButton(
                shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(this.widget.bordeRadius),
                    side: BorderSide(
                        color: this.widget.borderColor == null
                            ? AppTheme.instance.primaryDarkColorBlue
                            : this.widget.borderColor)),
                onPressed: widget.onPressed,
                textColor: Colors.white,
                color: this.widget.fillColor == null
                    ? AppTheme.instance.primaryDarkColorBlue
                    : this.widget.fillColor,
                child: !widget.busy
                    ? this.widget.childIcon != null
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                                this.widget.childIcon,
                                Padding(
                                  padding: EdgeInsets.only(left: 6),
                                  child: Text(widget.title,
                                      style: this.widget.textStyle),
                                )
                              ])
                        : this.widget.icon != null
                            ? Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                    Padding(
                                        padding: EdgeInsets.only(right: 6),
                                        child: Icon(
                                          this.widget.icon,
                                          color: this.widget.textStyle.color,
                                          size: 40.0,
                                        )),
                                    Padding(
                                      padding: EdgeInsets.only(left: 6),
                                      child: Text(widget.title,
                                          style: this.widget.textStyle),
                                    )
                                  ])
                            : Text(widget.title, style: this.widget.textStyle)
                    : CircularProgressIndicator())));
  }
}
