import 'package:compound/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ButtonsChooseWebModel {
  Widget icon;
  Widget title;
  EdgeInsets margin;
  EdgeInsets marginText;
  Function function;
  Color borderColor;
  bool isWeb;
  ButtonsChooseWebModel({
    this.icon,
    this.title,
    this.function,
    this.borderColor = const Color(0XFF606060),
    this.margin = const EdgeInsets.all(0.0),
    this.marginText = const EdgeInsets.symmetric(vertical: 10.0),
    this.isWeb = false,
  });
}

class ButtonsChooseWeb extends StatelessWidget {
  final List<ButtonsChooseWebModel> buttons;
  ButtonsChooseWeb({Key key, @required this.buttons}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return _chooseButton(button: buttons, index: buttons.length);
  }

  Row _chooseButton({List<ButtonsChooseWebModel> button, int index}) {
    switch (index) {
      case 1:
        return Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
          Container(),
          Column(
            children: [
              InkWell(
                onTap: button[0].function,
                child: Container(
                  decoration: BoxDecoration(
                      color: AppTheme.instance.primaryColorBlue,
                      borderRadius: BorderRadius.circular(50.0)),
                  height: 50,
                  width: 50,
                  child: button[0].icon,
                ),
              ),
              button[0].title
            ],
          ),
          Container()
        ]);
        break;
      case 2:
        return Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Container(
                child: Column(
                  children: [
                    InkWell(
                      onTap: button[0].function,
                      child: Container(
                        decoration: BoxDecoration(
                            color: Colors.transparent,
                            border: Border.all(color: Colors.white, width: 1.5),
                            borderRadius: BorderRadius.circular(50.0)),
                        height: 15.w,
                        width: 15.w,
                        child: buttons[0].icon,
                      ),
                    ),
                    Container(
                      margin: button[0].marginText,
                      child: buttons[0].title,
                    )
                  ],
                ),
              ),
              InkWell(
                onTap: button[1].function,
                child: Column(
                  children: [
                    Container(
                      margin: EdgeInsets.only(left: 20.0.w),
                      decoration: BoxDecoration(
                          color: AppTheme.instance.primaryColorBlue,
                          borderRadius: BorderRadius.circular(50.0)),
                      height: 15.w,
                      width: 15.w,
                      child: buttons[1].icon,
                    ),
                    Container(
                      margin: button[1].marginText,
                      padding: EdgeInsets.only(left: 20.0.w),
                      child: buttons[1].title,
                    )
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 25.0.w),
              )
            ]);
        break;
      case 3:
        return Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Container(
                child: Column(
                  children: [
                    InkWell(
                      onTap: button[1].function,
                      child: Container(
                        decoration: BoxDecoration(
                            color: Colors.transparent,
                            border: Border.all(
                                color: button[1].borderColor, width: 1.5),
                            borderRadius: BorderRadius.circular(50.0)),
                        height: 30,
                        width: 30,
                        child: button[1].icon,
                      ),
                    ),
                    Container(
                      margin: button[1].marginText,
                      child: button[1].title,
                    )
                  ],
                ),
              ),
              Column(
                children: [
                  InkWell(
                    onTap: button[0].function,
                    child: Container(
                      margin: button[0].margin,
                      decoration: BoxDecoration(
                          color: AppTheme.instance.primaryColorBlue,
                          borderRadius: BorderRadius.circular(50.0)),
                      height: 50,
                      width: 50,
                      child: button[0].icon,
                    ),
                  ),
                  Container(
                    margin: button[0].marginText,
                    padding: button[0].margin,
                    child: button[0].title,
                  )
                ],
              ),
              Column(
                children: [
                  InkWell(
                    onTap: button[2].function,
                    child: Container(
                      decoration: BoxDecoration(
                          color: Colors.transparent,
                          border: Border.all(
                              color: button[2].borderColor, width: 1.5),
                          borderRadius: BorderRadius.circular(50.0)),
                      height: 30,
                      width: 30,
                      child: button[2].icon,
                    ),
                  ),
                  Container(
                    margin: button[2].marginText,
                    child: button[2].title,
                  )
                ],
              )
            ]);
        break;
      default:
        return Row();
        break;
    }
  }
}
