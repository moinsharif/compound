import 'dart:core';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:compound/utils/datetime_extensions.dart';
import 'package:lat_lng_to_timezone/lat_lng_to_timezone.dart';
import 'package:timezone/timezone.dart' as tz;

class WrappedDate {
  DateTime _local;

  WrappedDate.fromServer(dynamic date) {
    try {
      DateTime dt;
      if (date is DateTime) {
        dt = date;
      } else if (date is Timestamp) {
        dt = date.toDate();
      } else {
        print(date.runtimeType);
      } /*else if (date is WrappedDate) {
        this._local = date.local();
        return;
      }*/
      this._local = dt.add(dt.timeZoneOffset * -1);
    } catch (e, st) {
      print("WrappedDate FromServer Error: ");
      print(st);
      print(e);
    }
  }

  WrappedDate.fromLocal(DateTime date) {
    this._local = date;
  }

  WrappedDate.now() {
    this._local = DateTime.now();
  }

  WrappedDate rangeFrom() {
    return WrappedDate.fromLocal(
        this._local.copyWith(hour: 0, minute: 0, second: 0, millisecond: 0));
  }

  WrappedDate rangeTo() {
    return WrappedDate.fromLocal(this
        ._local
        .copyWith(hour: 23, minute: 59, second: 59, millisecond: 999));
  }

  WrappedDate addDays(days) {
    return WrappedDate.fromLocal(this._local.add(Duration(days: days)));
  }

  DateTime local() {
    return this._local;
  }

  Timestamp utcTs() {
    return Timestamp.fromDate(this.utc());
  }

  DateTime utc() {
    return this._local.copy().add(this._local.timeZoneOffset);
  }
}

class TimestampUtils {
  
  static DateTime convertToLocalTime(num lat, num lng, DateTime date) {
    try {
      String tzLocale = latLngToTimezoneString(lat, lng);
      var nowLocale = tz.TZDateTime.from(date, tz.getLocation(tzLocale));

      return DateTime(nowLocale.year, nowLocale.month, nowLocale.day,
          nowLocale.hour, nowLocale.minute, nowLocale.second);
    } catch (e) {
      return date;
    }
  }

  static dynamic safeLocal(WrappedDate date) {
    return date == null ? null : date.local();
  }

  static bool equalDay(WrappedDate date1, WrappedDate date2) {
    return date1.local().day == date2.local().day &&
        date1.local().month == date2.local().month &&
        date1.local().year == date2.local().year;
  }

  static WrappedDate wdRangeFrom(DateTime localDate) {
    return WrappedDate.fromLocal(
        new DateTime(localDate.year, localDate.month, localDate.day, 0, 0, 0));
  }

  static WrappedDate wdRangeTo(DateTime localDate) {
    return WrappedDate.fromLocal(new DateTime(
        localDate.year, localDate.month, localDate.day, 23, 59, 59, 999));
  }

  static WrappedDate wdRangeNowFrom() {
    return wdRangeFrom(DateTime.now());
  }

  static WrappedDate wdRangeNowTo() {
    return wdRangeTo(DateTime.now());
  }

  static WrappedDate dateNow() {
    return WrappedDate.fromLocal(DateTime.now());
  }

  static int currentWeekDay() {
    var wkDay = DateTime.now().weekday;
    if (wkDay == 7) {
      return 0;
    }

    return wkDay;
  }

  static Map<String, dynamic> timezone() {
    DateTime dateTime = DateTime.now();
    return {
      "tz_name": dateTime.timeZoneName,
      "tz_offset": dateTime.timeZoneOffset.inMinutes
    };
  }
}
