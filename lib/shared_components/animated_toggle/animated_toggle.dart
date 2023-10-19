



import 'package:compound/theme/app_theme.dart';
import 'package:flutter/material.dart';

class AnimatedToggle extends StatefulWidget {

  final double width;
  final Function onTapLeft;
  final Function onTapRight;

  AnimatedToggle({Key key, this.width = 300.0, this.onTapLeft, this.onTapRight}) : super(key: key);

  @override
  _AnimatedToggleState createState() => _AnimatedToggleState();
}

const double height = 25.0;
const double loginAlign = -1;
const double signInAlign = 1;

class _AnimatedToggleState extends State<AnimatedToggle> {

  double xAlign;
  Color leftColor;
  Color rightColor;

  final normalColor = AppTheme.instance.primaryLighter;
  final selectedColor  = Colors.white;

  @override
  void initState() {
    super.initState();
    xAlign = loginAlign;
    leftColor = Colors.white;
    rightColor = AppTheme.instance.primaryLighter;
  }

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Container(
          width: this.widget.width,
          height: height,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(
              Radius.circular(50.0),
            ),
          ),
          child: Stack(
            children: [
              AnimatedAlign(
                alignment: Alignment(xAlign, 0),
                duration: Duration(milliseconds: 150),
                child: Container(
                  width: this.widget.width * 0.5,
                  height: height,
                  decoration: BoxDecoration(
                    color: AppTheme.instance.primaryDarker,
                    borderRadius: BorderRadius.all(
                      Radius.circular(50.0),
                    ),
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  setState(() {
                    xAlign = loginAlign;
                    leftColor = selectedColor;
                    rightColor = normalColor;
                  });
                  this.widget.onTapLeft();
                },
                child: Align(
                  alignment: Alignment(-1, 0),
                  child: Container(
                    width: this.widget.width * 0.5,
                    padding: EdgeInsets.only(top:3),
                    color: Colors.transparent,
                    alignment: Alignment.center,
                    child: Text(
                      'Resort',
                      style: AppTheme.instance.textStyleSmall(color: leftColor),
                    ),
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  setState(() {
                    xAlign = signInAlign;
                    rightColor = selectedColor;
                    leftColor = normalColor;
                  });
                  this.widget.onTapRight();
                },
                child: Align(
                  alignment: Alignment(1, 0),
                  child: Container(
                    padding: EdgeInsets.only(top:3),
                    width: this.widget.width * 0.5,
                    color: Colors.transparent,
                    alignment: Alignment.center,
                    child: Text(
                      'Local',
                      style: AppTheme.instance.textStyleSmall(color: rightColor),
                    ),
                  ),
                ),
              ),
            ],
          ))
      );
  }
}