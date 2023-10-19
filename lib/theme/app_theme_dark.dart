import 'dart:ui';

import 'package:compound/config.dart';
import 'package:compound/theme/app_theme.dart';
import 'package:compound/utils/colors_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppThemeBrand {
  final double designWidth = 360;
  final double designHeight = 672;

  final MaterialColor primaryDarker = ColorsUtils.getMaterialColor(0xFFF1F1F1);
  final MaterialColor primaryLighter = ColorsUtils.getMaterialColor(0xFFDFE0E1);
  final MaterialColor colorGreyLight = ColorsUtils.getMaterialColor(0xFFE1E1E1);
  final MaterialColor primaryLightest = ColorsUtils.getMaterialColor(0xFFFFFFF);
  final MaterialColor icons = ColorsUtils.getMaterialColor(0xFF2C3445);
  final MaterialColor primaryDarkColorBlue =
      ColorsUtils.getMaterialColor(0xFF55B540);
  final MaterialColor iconsBackground =
      ColorsUtils.getMaterialColor(0xFF6A6A6A);
  final MaterialColor buttonPrimary = ColorsUtils.getMaterialColor(0xFF2C3445);
  final MaterialColor bottombarIconsActive =
      ColorsUtils.getMaterialColor(0xFFF4A940);
  final MaterialColor inputs = ColorsUtils.getMaterialColor(0xFF8C8E91);

  final String brandIcon = 'assets/icons/brand_' + Config.brand + '.png';
  final String brandLogo = 'assets/images/logo_' + Config.brand + '.png';

  final String primaryFont = "Open Sans";
  final String secondaryFont = "Myriad Pro";

  final Color primaryFontColor2 = Color(0XFF3a8d1d);
  final Color primaryFontColor = Color(0xFF555555);
  final Color tableBackground = Color(0xff3c3c3c);

  final Color primaryColorBlue = Color(0XFF3a8d1d);
  final Color colorGradientFrom = Color(0XFF55B235);
  final Color colorGradientTo = Color(0XFF52D425);
  final Color colorGradientLightFrom = Color(0XFF55B235);
  final Color colorGradientLightTo = Color(0xff55CE7C);
  void initialize() {}

  TextStyle textStyleBigTitle(
          {String fontFamily = "Open Sans",
          FontWeight fontWeight = FontWeight.normal,
          bool underlined = false,
          Color color}) =>
      _textStyle(25.0.sp,
          fontWeight: fontWeight, underlined: underlined, color: color);

  TextStyle textStyleTitles(
          {String fontFamily = "Open Sans",
          FontWeight fontWeight = FontWeight.normal,
          bool underlined = false,
          Color color}) =>
      _textStyle(20.0.sp,
          fontWeight: fontWeight, underlined: underlined, color: color);

  TextStyle textStyleRegularPlus(
          {String fontFamily = "Open Sans",
          FontWeight fontWeight = FontWeight.normal,
          bool underlined = false,
          Color color}) =>
      _textStyle(18.0.sp,
          fontWeight: fontWeight, underlined: underlined, color: color);

  TextStyle textStyleRegular(
          {String fontFamily = "Open Sans",
          FontWeight fontWeight = FontWeight.normal,
          bool underlined = false,
          Color color}) =>
      _textStyle(16.0.sp,
          fontWeight: fontWeight, underlined: underlined, color: color);

  TextStyle textStyleSmall(
          {String fontFamily = "Open Sans",
          FontWeight fontWeight = FontWeight.normal,
          bool underlined = false,
          bool crossed = false,
          Color color}) =>
      _textStyle(13.0.sp,
          fontWeight: fontWeight,
          underlined: underlined,
          crossed: crossed,
          color: color);

  TextStyle textStyleVerySmall(
          {String fontFamily = "Open Sans",
          double size = 10.0,
          FontWeight fontWeight = FontWeight.normal,
          bool underlined = false,
          bool italic = false,
          Color color}) =>
      _textStyle(size,
          fontWeight: fontWeight,
          underlined: underlined,
          color: color,
          italic: italic);

  TextStyle _textStyle(double fontSize,
          {FontWeight fontWeight = FontWeight.normal,
          bool underlined = false,
          bool crossed = false,
          bool italic = false,
          String fontFamily = "Open Sans",
          Color color}) =>
      TextStyle(
          fontWeight: fontWeight,
          fontFamily: fontFamily,
          fontStyle: italic ? FontStyle.italic : FontStyle.normal,
          color:
              color == null ? ColorsUtils.getMaterialColor(0xFF2C3445) : color,
          decoration: underlined
              ? TextDecoration.underline
              : crossed
                  ? TextDecoration.lineThrough
                  : TextDecoration.none,
          fontSize: fontSize);

  TextStyle imagePickerFont;
  InputDecorationTheme getInputDecorationTheme() {
    var color = ColorsUtils.getMaterialColor(0xFF8C8E91);
    return InputDecorationTheme(
        isDense: false,
        errorMaxLines: 5,
        labelStyle: TextStyle(
            height: 1.w,
            color: color,
            fontFamily: primaryFont,
            fontSize: 15.sp),
        hintStyle: TextStyle(color: inputs),
        fillColor: Colors.white,
        contentPadding: EdgeInsets.zero,
        filled: false,
        border: UnderlineInputBorder(
            borderSide: BorderSide(color: Color(0XFFE2E2E2))));
  }

  Widget formFieldFormat({child: Widget}) {
    var padded = Center(
        child: Padding(
            padding: EdgeInsets.only(
                top: 15.0.w, bottom: 0.w, left: 25.w, right: 25.w),
            child: child));
    return Config.isAdminSite ? Container(width: 500.w, child: padded) : padded;
  }

  Widget formProfileFieldFormat({child: Widget}) => Center(
      child: Padding(
          padding:
              EdgeInsets.only(top: 5.w, bottom: 5.w, left: 8.w, right: 8.w),
          child: child));

  TextStyle hintStyle() {
    return TextStyle(color: Color(0XFFE2E2E2));
  }

  Widget datePickerStyle(
      BuildContext context, FormBuilderDateTimePicker picker) {
    return Theme(
        data: Theme.of(context).copyWith(
          textTheme: Theme.of(context).textTheme.apply(
                fontFamily: AppTheme.instance.primaryFont,
                bodyColor: AppTheme.instance.primaryFontColor,
                displayColor: AppTheme.instance.primaryFontColor,
              ),
          colorScheme:
              ColorScheme.dark(primary: AppTheme.instance.primaryLighter),
        ),
        child: picker);
  }

  Widget errorSnackbar =
      Text("Connection error, check your internet connection and try again");
}
