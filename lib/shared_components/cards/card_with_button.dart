import 'package:compound/theme/app_theme.dart';
import 'package:compound/utils/scale_helper.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CardWithButton extends StatefulWidget {
  final bool busy;
  final String title;
  final String subTitle;
  final Function onPressed;
  final bool enabled;
  final double width;
  final double height;
  final TextStyle textStyle;
  final TextStyle textStyleSub;
  final IconData icon;
  final Widget childIcon;
  final Widget childCard;
  final Color borderColor;
  final Color fillColor;
  final double bordeRadius;
  final bool isWeb;

  const CardWithButton(
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
      this.bordeRadius = 15.0,
      @required this.childCard,
      this.subTitle,
      this.textStyleSub,
      this.isWeb = false});

  @override
  _CardWithButtonState createState() => _CardWithButtonState();
}

class _CardWithButtonState extends State<CardWithButton> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: this.widget.isWeb
          ? EdgeInsets.symmetric(vertical: 20.h, horizontal: 100.w)
          : EdgeInsets.all(30.w),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            child: Card(
              margin: EdgeInsets.only(bottom: 30.0),
              shadowColor: Colors.black,
              elevation: 5,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0)),
              child: Padding(
                padding: const EdgeInsets.only(bottom: 65.0),
                child: this.widget.childCard,
              ),
            ),
          ),
          Positioned(
            bottom: 0.0,
            child: ButtonTheme(
                height: this.widget.height,
                child: Container(
                    height: this.widget.height,
                    width: this.widget.width == 0
                        ? ScaleHelper.rsDoubleW(context, 65)
                        : this.widget.width,
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          textStyle: TextStyle(
                            color: Colors.white,
                          ),
                          padding: this.widget.isWeb
                              ? EdgeInsets.symmetric(horizontal: 80.w)
                              : EdgeInsets.zero,
                          primary:
                              this.widget.isWeb ? Colors.white : Colors.red,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                  this.widget.bordeRadius),
                              side: BorderSide(
                                  color: this.widget.borderColor == null
                                      ? Colors.transparent
                                      : this.widget.borderColor)),
                        ),
                        onPressed: widget.onPressed,
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
                                    ? Ink(
                                        decoration: BoxDecoration(
                                          gradient: LinearGradient(
                                            colors: [
                                              AppTheme
                                                  .instance.colorGradientFrom,
                                              AppTheme.instance.colorGradientTo,
                                            ],
                                            begin: Alignment.centerLeft,
                                            end: Alignment.centerRight,
                                          ),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(80.0)),
                                        ),
                                        child: Container(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 20.0),
                                          child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Container(
                                                  width: 20.0,
                                                ),
                                                Text(widget.title,
                                                    style:
                                                        this.widget.textStyle),
                                                if (widget.subTitle != null)
                                                  Text(widget.title,
                                                      style: this
                                                          .widget
                                                          .textStyleSub),
                                                Icon(
                                                  this.widget.icon,
                                                  color: this
                                                      .widget
                                                      .textStyle
                                                      .color,
                                                  size: 25.0,
                                                )
                                              ]),
                                        ),
                                      )
                                    : Text(widget.title,
                                        style: this.widget.textStyle)
                            : Ink(
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      AppTheme.instance.colorGradientFrom,
                                      AppTheme.instance.colorGradientTo,
                                    ],
                                    begin: Alignment.centerLeft,
                                    end: Alignment.centerRight,
                                  ),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(80.0)),
                                ),
                                child: Center(
                                  child: CircularProgressIndicator(),
                                ),
                              )))),
          ),
        ],
      ),
    );
  }
}
