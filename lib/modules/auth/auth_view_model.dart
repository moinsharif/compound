import 'dart:async';

import 'package:compound/constants.dart';
import 'package:compound/core/base/base_view_model.dart';
import 'package:compound/core/services/authentication/authentication_service.dart';
import 'package:compound/core/services/navigation/navigator_service.dart';
import 'package:compound/core/services/shared_preferences/shared_preferences_service.dart';
import 'package:compound/locator.dart';
import 'package:compound/router.dart';
import 'package:compound/shared_services/push_notifications_service.dart';
import 'package:flutter/foundation.dart';

class AuthViewModel extends BaseViewModel {
  final NavigatorService _navigationService = locator<NavigatorService>();
  final AuthenticationService _authenticationService =
      locator<AuthenticationService>();
  final SharedPreferencesService _sharedPreferencesService =
      locator<SharedPreferencesService>();
  AuthStatePage statusPage;
  StreamSubscription<AuthStatePage> subs;
  // final PushNotificationService _fcmService =
  //     locator<PushNotificationService>();

  @override
  dispose() {
    if (subs != null) subs.cancel();
    super.dispose();
  }

  Future<void> load() async {
    setBusy(true);
    if (await _authenticationService.isUserLoggedIn() &&
        !_authenticationService.isUserChangePassword()) {
      this.statusPage = AuthStatePage.SIGNUPCONFIRMATION;
      this.notifyListeners();
    } else if (await _authenticationService.isUserLoggedIn() &&
        _authenticationService.isUserChangePassword()) {
      if (_sharedPreferencesService.getShowAlertPermission()) {
        await _navigationService.navigateToPageWithReplacement(
            PermissionsViewRoute,
            title: ConstantsRoutePage.CheckPermissions);
      } else {
        this.navigateToHome();
      }
    } else {
      this.statusPage = AuthStatePage.LOGIN;
      this.notifyListeners();
    }

    if (subs != null) {
      subs.cancel();
    }

    subs = _authenticationService.pageStateStream.listen((value) {
      this.statusPage = value;
      this.notifyListeners();
    });
    setBusy(false);
  }

  void navigateToChangePassword() {
    _navigationService.navigateToPageWithReplacement(ChangePasswordViewRoute);
  }

  void navigateToHome() {
    if (!kIsWeb) locator<PushNotificationService>().initialize();
    _authenticationService.listenEmployeeChanges();
    _navigationService.navigateToPageWithReplacement(HomeViewRoute);
  }
}
