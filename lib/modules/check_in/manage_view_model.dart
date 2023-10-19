import 'dart:async';

import 'package:compound/config.dart';
import 'package:compound/constants.dart';
import 'package:compound/core/base/base_view_model.dart';
import 'package:compound/core/services/authentication/authentication_service.dart';
import 'package:compound/core/services/checkIn_service/checkin_service.dart';
import 'package:compound/core/services/navigation/navigator_service.dart';
import 'package:compound/core/services/shared_preferences/shared_preferences_service.dart';
import 'package:compound/locator.dart';
import 'package:compound/modules/violations_by_property/violation_by_property_view_model.dart';
import 'package:compound/router.dart';
import 'package:compound/shared_models/checkIn_model.dart';
import 'package:compound/shared_services/timesheet_service.dart';
import 'package:compound/shared_services/violation_service.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';

class ManageViewModel extends BaseViewModel {
  final NavigatorService _navigationService = locator<NavigatorService>();
  final AuthenticationService _authenticationService =
      locator<AuthenticationService>();
  final ViolationService _violationService = locator<ViolationService>();
  final CheckInService _checkInService = locator<CheckInService>();
  

  StreamSubscription<String> errorSubs;
  StreamSubscription<List<Placemark>> locationSubs;

  String location = '...';
  String hour = '';
  String showDate = '';
  Position position;
  

  CheckInModel checkInModel;
  bool existViolations = false;
  

  @override
  dispose() {
    if (errorSubs != null) errorSubs.cancel();
    if (locationSubs != null) locationSubs.cancel();
    super.dispose();
  }

  Future<void> load() async {
    setBusy(true);
    this.loadDates();
    _authenticationService.textAppBarStream.add(ConstantsRoutePage.MANAGE);
    checkInModel = await _checkInService.loadCurrentCheckIn();
    if (checkInModel != null) {
      position = await checkInModel.getPosition();
      existViolations = await checkViolations();
    }
    setBusy(false);
    this.notifyListeners();
  }

  

  void loadDates() {
    final DateFormat formatterHour = DateFormat('hh:mm a');
    this.hour = formatterHour.format(DateTime.now());
  }

  String loadDate(DateTime date) {
    final DateFormat formatterHour = DateFormat('MMM dd, yyyy');
    return formatterHour.format(date);
  }

  void navigateToViolation() {
    _authenticationService.changeindexMenuButtonStream(3);
    _navigationService
        .navigateTo(ViolationViewRoute,
            arguments: {'isViolation': true}, title: Config.oneViolation)
        .then((value) async {
      if (!existViolations) {
        existViolations = await checkViolations();
        notifyListeners();
      }
    });
  }

  Future<void> navigateToWatchlist() async{
    await _navigationService.navigateTo(WatchlistViewRoute);
  }

  Future<dynamic> goToViolationsProperty() async {
    await _navigationService.navigateTo(ViolationByPropertyViewRoute,
        arguments: AuxCheckInModel(checkInId: checkInModel.id),
        title: checkInModel.propertyName);
  }

  Future<bool> checkViolations() async {
    return await _violationService.checkViolationsByCheckInId(checkInModel.id);
  }

  void navigateToHome() {
    _authenticationService.changeindexMenuButtonStream(0);
    _navigationService.navigateToAndRemoveUntil(
        HomeViewRoute, (Route<dynamic> route) => false);
  }
}
