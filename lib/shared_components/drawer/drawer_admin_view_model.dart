import 'dart:async';

import 'package:compound/core/base/base_view_model.dart';
import 'package:compound/core/services/authentication/authentication_service.dart';
import 'package:compound/core/services/checkIn_service/checkin_service.dart';
import 'package:compound/core/services/config/config_service.dart';
import 'package:compound/core/services/navigation/navigator_service.dart';
import 'package:compound/locator.dart';
import 'package:compound/router.dart';
import 'package:intl/intl.dart';

class DrawerAdminViewModel extends BaseViewModel {
  final AuthenticationService _authenticationService =
      locator<AuthenticationService>();
  final ConfigService _configService = locator<ConfigService>();
  final CheckInService _checkInService = locator<CheckInService>();
  final NavigatorService _navigatorService = locator<NavigatorService>();
  bool activeCheckIn = false;
  StreamSubscription<bool> subs;
  String currentBackend;

  @override
  dispose() {
    if (subs != null) subs.cancel();
    super.dispose();
  }

  Future<void> load() async {
    this.activeCheckIn =
        await _checkInService.loadCurrentCheckIn() != null ? true : false;

    this.currentBackend = await _configService.getCurrentBackend();
    this.notifyListeners();
  }

  String getCurrentRole() {
    return _authenticationService.currentRole?.key == 'admin'
        ? 'Admin'
        : _authenticationService.currentRole?.key == 'super_admin'
            ? 'Super Admin'
            : 'Employee' ?? '';
  }

  String getUserName() {
    return _authenticationService.currentUser?.userName ?? '';
  }

  String getCurrentDate() {
    final DateTime now = DateTime.now();
    final DateFormat formatter = DateFormat('MM/dd/yyyy');
    return formatter.format(now);
  }

  int getGlobalIndex() {
    return _authenticationService.indexPage;
  }

  void updatedSelectedIndex(int index, String pageName) {
    _authenticationService.changeindexMenuButtonStream(index);
    this.notifyListeners();
  }

  Future<void> logOut() async {
    await this._authenticationService.logout();
    _navigatorService.navigateToPageWithReplacement(AuthViewRoute);
  }
}
