import 'dart:math';

import 'package:compound/constants.dart';
import 'package:compound/core/base/base_view_model.dart';
import 'package:compound/core/services/authentication/authentication_service.dart';
import 'package:compound/core/services/checkIn_service/checkin_service.dart';
import 'package:compound/core/services/navigation/navigator_service.dart';
import 'package:compound/locator.dart';
import 'package:compound/router.dart';
import 'package:compound/shared_models/activityLog_model.dart';
import 'package:compound/shared_services/activity_service.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ListActivityViewModel extends BaseViewModel {
  final AuthenticationService _authenticationService =
      locator<AuthenticationService>();
  final NavigatorService _navigatorService = locator<NavigatorService>();
  final ActivityLogService _activityLogService = locator<ActivityLogService>();
  final ScrollController scroll = new ScrollController();
  bool showArrow = true;

  List<ActivityLogModel> activities = [];
  Random random = new Random();

  Future<void> load() async {
    setBusy(true);
    setBusy(false);
    this.loadActivity();
    this.notifyListeners();
  }

  void loadActivity(
      {DateTime start,
      DateTime end,
      String porterId,
      String propertyId}) async {
    activities = await _activityLogService.getAllActivityLog(
        start: start, end: end, porterId: porterId, propertyId: propertyId);
    this.notifyListeners();
  }

  String formatDate(DateTime date) {
    final DateFormat formatter = DateFormat('MMMM dd, yyyy');
    return formatter.format(date);
  }

  String formatTime(DateTime date) {
    final DateFormat formatterHour = DateFormat('hh:mm a');
    return formatterHour.format(date);
  }

  void scrollPosition() {
    if ((scroll.position.maxScrollExtent - scroll.position.pixels) <= 60) {
      this.showArrow = false;
      notifyListeners();
    } else {
      this.showArrow = true;
      notifyListeners();
    }
  }
}
