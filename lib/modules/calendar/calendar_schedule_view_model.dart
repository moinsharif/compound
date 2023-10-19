import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:compound/core/base/base_view_model.dart';
import 'package:compound/core/services/checkIn_service/checkin_service.dart';
import 'package:compound/locator.dart';
import 'package:compound/shared_models/checkIn_model.dart';
import 'package:compound/shared_models/days_selected.dart';
import 'package:compound/shared_models/porter_model.dart';
import 'package:compound/shared_models/property_model.dart';
import 'package:compound/shared_services/property_service.dart';
import 'package:compound/theme/app_theme.dart';
import 'package:compound/utils/timestamp_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:intl/intl.dart';

class CalendarScheduleViewModel extends BaseViewModel {
  final PropertyService _propertyService = locator<PropertyService>();
  final CheckInService _checkInService = locator<CheckInService>();
  final SuggestionsBoxController propertyBoxController =
      SuggestionsBoxController();
  bool openBoxProperty = false;
  List<PropertyModel> properties = [];
  List<PropertyModel> propertiesFiltered = [];
  PropertyModel selectedPropertyModel;
  int currentDay = DateTime.now().weekday;
  List<DaysSelected> daysToService = [];
  List<DaysSelected> defaultDays = [];
  List<CheckInModel> checkinsToday = [];
  DateTime dateToCompare = new DateTime.now();
  int recurrenceDay = 0;

  @override
  dispose() {
    super.dispose();
  }

  Future<void> load() async {
    setBusy(true);
    defaultDays = _getDefaultDays();
    checkinsToday = await _checkInService.getCheckInsByDate(
        TimestampUtils.wdRangeNowFrom(), TimestampUtils.wdRangeNowTo());
    properties = await _propertyService.getPropertiesBySchedule();
    _addDays();
    _addDays();
    _addDays();
    _addDays();
    setBusy(false);
  }

  void chooseProperty(PropertyModel property) {
    propertiesFiltered = [];
    propertiesFiltered = [...propertiesFiltered, property];
    this.selectedPropertyModel = property;
    notifyListeners();
  }

  void _addDays() {
    recurrenceDay += 1;
    for (var i = 0; i <= 6; i++) {
      if (currentDay > 6) {
        currentDay = 0;
      }
      daysToService = [
        ...daysToService,
        DaysSelected(
            id: currentDay,
            date: Timestamp.fromDate(dateToCompare),
            nameDay: defaultDays
                        .firstWhere((element) => element.id == currentDay,
                            orElse: () => null)
                        .nameDay +
                    ' ' +
                    this.loadDates(dateToCompare) ??
                '')
      ];
      currentDay += 1;
      dateToCompare = dateToCompare.add(Duration(days: 1));
    }
  }

  String loadHours(DateTime date) {
    final DateFormat formatterHour = DateFormat('hh:mm a');
    return date != null ? formatterHour.format(date) : '--';
  }

  String loadDates(DateTime date) {
    final DateFormat formatterHour = DateFormat('dd/MMM');
    return date != null ? formatterHour.format(date) : '--';
  }

  void changeArrowPositionStreet(bool value, {String opneBox}) {
    this.openBoxProperty = value;
    if (opneBox == 'open') {
      this.propertyBoxController.open();
    } else if (opneBox == 'close') {
      this.propertyBoxController.close();
    }
    notifyListeners();
  }

  Future<List<PropertyModel>> getProperties(String pattern) async {
    if (properties == null) {
      return List<PropertyModel>.empty();
    }

    return this
        .properties
        .where((PropertyModel element) =>
            element.propertyName.toLowerCase().indexOf(pattern.toLowerCase()) >=
            0)
        .toList();
  }

  String getDifferenceHour(String starTime, String endTime) {
    var format = DateFormat("HH:mm");
    var start = format.parse(starTime);
    var end = format.parse(endTime);
    if (start.isAfter(end)) {
      return '${start.subtract(Duration(days: 1)).difference(end).inHours.abs()}h Assigned';
    } else if (start.isBefore(end)) {
      return '${end.difference(start).inHours.abs()}h Assigned';
    } else {
      return '${end.difference(start).inHours.abs()}h Assigned';
    }
  }

  String getHour(String starTime, String endTime) {
    var format = DateFormat("HH:mm");
    var start = format.parse(starTime);
    var end = format.parse(endTime);
    var start2 = DateFormat.jm().format(start);
    var end2 = DateFormat.jm().format(end);
    return '$start2 - $end2';
  }

  List<DaysSelected> _getDefaultDays() {
    return [
      DaysSelected(id: 0, nameDay: 'SUN', shortNameDay: 'S', rate: 15),
      DaysSelected(id: 1, nameDay: 'MON', shortNameDay: 'M', rate: 15),
      DaysSelected(id: 2, nameDay: 'TUE', shortNameDay: 'T', rate: 15),
      DaysSelected(id: 3, nameDay: 'WED', shortNameDay: 'W', rate: 15),
      DaysSelected(id: 4, nameDay: 'THU', shortNameDay: 'T', rate: 15),
      DaysSelected(id: 5, nameDay: 'FRI', shortNameDay: 'F', rate: 15),
      DaysSelected(id: 6, nameDay: 'SAT', shortNameDay: 'S', rate: 15)
    ];
  }

  Color getColor(PropertyModel property, DaysSelected evalD) {
    var now = TimestampUtils.dateNow();
    DateTime dateService;
    try {
      dateService = DateTime(
          now.local().year,
          now.local().month,
          now.local().day,
          int.parse(property.configProperty.startTime.substring(0, 2)),
          int.parse(property.configProperty.startTime.substring(3)));
    } catch (e) {
      print(e);
    }

    if (evalD == null) {
      return AppTheme.instance.colorGreyLight;
    }

    var localEvalDay = TimestampUtils.convertToLocalTime(
        property.lat, property.lng, evalD.date.toDate());

    //var localEvalDay = evalD.date.toDate();

    if (localEvalDay == null ||
        localEvalDay.month != dateService.month ||
        localEvalDay.day != dateService.day) {
      return AppTheme.instance.colorGreyLight;
    }

    Iterable<Porter> portersInService = property.configProperty.porters.where(
        (element) => (element.temporary == null ||
            element.temporary == false ||
            (element.temporary == true &&
                element.temporaryDate.local().year == now.local().year &&
                element.temporaryDate.local().month == now.local().month &&
                element.temporaryDate.local().day == now.local().day)));

    var checkInsTodayProperty = this.checkinsToday.where((element) =>
        element.propertyId == property.id &&
        element.dateCheckOut != null &&
        TimestampUtils.equalDay(
            element.dateCheckIn, WrappedDate.fromLocal(localEvalDay)));

    if (checkInsTodayProperty.length > 0) {
      if (portersInService.length == checkInsTodayProperty.length) {
        return Colors.green[100];
      } else {
        return Colors.amberAccent[100];
      }
    } else if (localEvalDay.isAfter(dateService)) {
      return Colors.red[300];
    } else {
      return AppTheme.instance.colorGreyLight;
    }
  }

  bool validateAddPorter(PropertyModel property, DaysSelected evalDay) {
    DateTime dateService = DateTime(
        DateTime.now().year,
        DateTime.now().month,
        DateTime.now().day,
        int.parse(property.configProperty.startTime.substring(0, 2)),
        int.parse(property.configProperty.startTime.substring(3)));
    Iterable<Porter> portersInService = property.configProperty.porters.where(
        (element) => (element.temporary == null ||
            element.temporary == false ||
            (element.temporary == true &&
                element.temporaryDate.local().year == DateTime.now().year &&
                element.temporaryDate.local().month == DateTime.now().month &&
                element.temporaryDate.local().day == DateTime.now().day)));
    if (evalDay.date != null &&
        evalDay.date.toDate().month == dateService.month &&
        evalDay.date.toDate().day == dateService.day) {
      if (dateService.isBefore(new DateTime.now()) &&
          this
                  .checkinsToday
                  .where((element) => element.propertyId == property.id)
                  .where((element) => element.dateCheckOut != null)
                  .length >=
              portersInService.length) {
        return false;
      } else {
        return true;
      }
    } else {
      return true;
    }
  }

  void updateProperites(String s) {
    if (properties.length <= 0) {
      return;
    }

    if (this.selectedPropertyModel != null &&
        this.selectedPropertyModel.propertyName == s) {
      return;
    } else if (this.selectedPropertyModel != null &&
        this.selectedPropertyModel.propertyName != s) {
      this.propertiesFiltered = [];
    }
    this.notifyListeners();
  }

  String getLocalTime(PropertyModel e) {
    return DateFormat('hh:mm a').format(
        TimestampUtils.convertToLocalTime(e.lat, e.lng, DateTime.now()));
  }
}
