import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';

class StringUtils {
  static String capitalize(String str) {
    return "${str[0].toUpperCase()}${str.substring(1)}";
  }

  static DateTime timestampToDate(data, attr) {
    return data[attr] != null && data[attr] != ""
        ? DateTime.parse(data[attr].toDate().toString())
        : null;
  }

  static bool isNullOrEmpty(String value) {
    return value == null || value.trim() == "";
  }

  static String clamp(String value, int max, {String clampPrefix: "..."}) {
    if (value.length < max) {
      return value;
    }

    return value.substring(0, max - clampPrefix.length) + clampPrefix;
  }

  static String getRandString({int len = 6}) {
    var random = Random.secure();
    var values = List<int>.generate(len, (i) => random.nextInt(255));
    return base64UrlEncode(values);
  }

  static String cleanTime(TimeOfDay time) {
    String firstValue = time.toString().replaceAll('TimeOfDay(', '');
    return firstValue.replaceAll(')', '');
  }
}
