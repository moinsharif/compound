import 'package:compound/theme/app_theme.dart';
import 'package:flutter/material.dart';

class BigRoundActionButtonViewWeb extends StatelessWidget {
  final Function onTap;
  final String title;
  final String icon;
  final bool busy;
  final bool isWeb;

  const BigRoundActionButtonViewWeb(this.onTap, this.title, this.icon,
      {Key key, this.busy = false, this.isWeb = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return _button();
  }

  Widget _button() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 5),
      child: InkWell(
        onTap: () => onTap(),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            busy
                ? Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      color: AppTheme.instance.primaryColorBlue,
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  )
                : Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      color: AppTheme.instance.primaryColorBlue,
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Image.asset(
                        this.icon,
                        height: 30,
                      ),
                    ),
                  ),
            Text(
              title,
              style: TextStyle(
                  decoration: TextDecoration.none,
                  fontSize: 15,
                  color: AppTheme.instance.primaryColorBlue),
            ),
          ],
        ),
      ),
    );
  }
}
