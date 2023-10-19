import 'dart:async';

import 'package:compound/constants.dart';
import 'package:compound/core/base/base_view_model.dart';
import 'package:compound/core/services/authentication/authentication_service.dart';
import 'package:compound/locator.dart';
import 'package:flutter/foundation.dart';

class BottomNavigatorViewModel extends BaseViewModel {
  bool hidden = true;
  bool isAdmin = false;
  final AuthenticationService _authenticationService =
      locator<AuthenticationService>();
  StreamSubscription<bool> subs;

  @override
  dispose() {
    if (subs != null) subs.cancel();
    super.dispose();
  }

  Future<void> load() async {
    if (await _authenticationService.isUserLoggedIn() &&
        _authenticationService.isUserChangePassword()) {
      this.isAdmin = _authenticationService.currentRole.key ==
                  describeEnum(TYPEROLE.admin) ||
              _authenticationService.currentRole.key ==
                  describeEnum(TYPEROLE.super_admin)
          ? true
          : false;
      _authenticationService.onLogin();
      this.notifyListeners();
    }

    if (subs != null) {
      subs.cancel();
    }

    subs = _authenticationService.loginStatusChangeStream.listen((value) {
      this.hidden = !value;
      this.notifyListeners();
    });
  }
}
