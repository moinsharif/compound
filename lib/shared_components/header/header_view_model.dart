import 'dart:async';

import 'package:compound/core/base/base_view_model.dart';
import 'package:compound/core/services/authentication/authentication_service.dart';
import 'package:compound/locator.dart';

class HeaderViewModel extends BaseViewModel {
  final AuthenticationService _authenticationService =
      locator<AuthenticationService>();

  String getULegend() {
    return _authenticationService.currentEmploye?.legend ?? '';
  }

  String getUserName() {
    return '${_authenticationService.currentUser?.firstName} ${_authenticationService.currentUser?.lastName}' ??
        '';
  }

  String getPhone() {
    return _authenticationService.currentUser?.phoneNumber ?? '';
  }

  String getUsername() {
    return _authenticationService.currentUser?.userName ?? '';
  }

  String getEmail() {
    return _authenticationService.currentUser?.email ?? '';
  }

  String getPhoto() {
    return _authenticationService.currentUser?.img ?? null;
  }

  String getMemberYear() {
    return _authenticationService.currentUser?.createdAt?.year.toString() ??
        null;
  }
}
