import 'dart:async';

import 'package:compound/core/services/authentication/authentication_service.dart';
import 'package:compound/core/services/checkIn_service/checkin_service.dart';
import 'package:compound/core/services/dialog_service.dart';
import 'package:compound/core/services/navigation/navigator_service.dart';
import 'package:compound/locator.dart';
import 'package:compound/router.dart';
import 'package:compound/shared_components/general_message/general_message.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

class BottomNavigatorPorterViewModel extends BaseViewModel {
  final AuthenticationService _authenticationService =
      locator<AuthenticationService>();
  final CheckInService _checkInService = locator<CheckInService>();
  final DialogService _dialogService = locator<DialogService>();
  final NavigatorService _navigationService = locator<NavigatorService>();
  StreamSubscription<int> selectedIndexStream;

  int selectedIndex = 0;

  Future<void> load() async {
    selectedIndexStream =
        _authenticationService.indexMenuButtonStream.listen((value) {
      this.selectedIndex = value;
      this.notifyListeners();
    });
  }

  @override
  dispose() {
    if (selectedIndexStream != null) selectedIndexStream.cancel();
    super.dispose();
  }

  void updatedSelectedIndex(int index, String pageName) {
    this.selectedIndex = index;
    _authenticationService.changeindexMenuButtonStream(index);
    this.notifyListeners();
  }

  Future<bool> loadCheckIn() async {
    return await _checkInService.loadCurrentCheckIn() != null ? true : false;
  }

  Future<bool> checkInActive() async {
    if (await _checkInService.loadCurrentCheckIn() == null) {
      _dialogService.showDialog(
          title: 'Attention!!',
          description: 'You don\'t have an active check-in');
      return false;
    }
    return true;
  }
}
