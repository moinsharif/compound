import 'dart:async';

import 'package:compound/core/base/base_view_model.dart';
import 'package:compound/core/services/authentication/authentication_service.dart';
import 'package:compound/core/services/checkIn_service/checkin_service.dart';
import 'package:compound/core/services/dialog_service.dart';
import 'package:compound/locator.dart';

class BottomsPageViewModel extends BaseViewModel {
  final CheckInService _checkInService = locator<CheckInService>();
  final AuthenticationService _authenticationService =
      locator<AuthenticationService>();
  final DialogService _dialogService = locator<DialogService>();
  bool activeCheckIn = false;

  Future<void> load() async {
    activeCheckIn =
        await _checkInService.loadCurrentCheckIn() != null ? true : false;
  }

  Future<bool> isCurrentCheckIn() async {
    return await _checkInService.loadCurrentCheckIn() != null ? true : false;
  }

  void updatedSelectedIndex(int index, String pageName) {
    _authenticationService.changeindexMenuButtonStream(index);
    this.notifyListeners();
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
