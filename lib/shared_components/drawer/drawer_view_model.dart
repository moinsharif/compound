import 'dart:async';

import 'package:compound/core/base/base_view_model.dart';
import 'package:compound/core/services/authentication/authentication_service.dart';
import 'package:compound/locator.dart';
import 'package:flutter/foundation.dart';

class DrawerCustomViewModel extends BaseViewModel {
  final AuthenticationService _authenticationService =
      locator<AuthenticationService>();
  bool hidden = true;
  bool isAdmin = false;

  Future<void> load() async {
    if (await _authenticationService.isUserLoggedIn() &&
        _authenticationService.isUserChangePassword()) {
      this.hidden = false;
      this.isAdmin = _authenticationService.currentRole.key ==
                  describeEnum(TYPEROLE.admin) ||
              _authenticationService.currentRole.key ==
                  describeEnum(TYPEROLE.super_admin)
          ? true
          : false;
      this.notifyListeners();
    }
  }

  String getCurrentRole() {
    return _authenticationService.currentRole?.key == 'admin'
        ? 'Admin'
        : _authenticationService.currentRole?.key == 'super_admin'
            ? 'Super Admin'
            : 'Employee' ?? '';
  }
}
