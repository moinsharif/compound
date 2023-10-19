import 'package:compound/utils/scale_helper.dart';
import 'package:flutter/material.dart';

class ButtonGradient extends StatefulWidget {
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
  final Color borderColor;
  final Color fillColor;
  final double bordeRadius;

  const ButtonGradient(
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
      this.subTitle,
      this.textStyleSub});

  @override
  _ButtonGradientState createState() => _ButtonGradientState();
}

class _ButtonGradientState extends State<ButtonGradient> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10.0),
      child: ButtonTheme(
          height: this.widget.height,
          child: InkWell(
            onTap: widget.busy ? () {} : this.widget.onPressed,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 20.0),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xff0093D0), Color(0xff56EDFF)],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
              ),
              child:
                  Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                Container(
                    margin: EdgeInsets.all(10.0),
                    child: widget.busy
                        ? CircularProgressIndicator()
                        : Text(widget.title, style: this.widget.textStyle)),
                if (widget.subTitle != null)
                  Text(widget.title, style: this.widget.textStyleSub),
              ]),
            ),
          )),
    );
  }
}
