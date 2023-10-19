import 'package:compound/constants.dart';
import 'package:compound/core/base/base_view_model.dart';
import 'package:compound/core/services/authentication/authentication_service.dart';
import 'package:compound/core/services/navigation/navigator_service.dart';
import 'package:compound/locator.dart';
import 'package:compound/router.dart';
import 'package:compound/shared_services/push_notifications_service.dart';
import 'package:flutter/foundation.dart';
import 'package:compound/core/services/shared_preferences/shared_preferences_service.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

class LoginViewModel extends BaseViewModel {
  final AuthenticationService _authenticationService =
      locator<AuthenticationService>();
  final NavigatorService _navigationService = locator<NavigatorService>();
  // final ProfileService _profileService = locator<ProfileService>();
  final SharedPreferencesService _sharedPreferencesService =
      locator<SharedPreferencesService>();
  // final PushNotificationService _fcmService =
  //     locator<PushNotificationService>();
  bool showPassword = true;
  bool showErroUsername = false;

  void setAuthStatePage(AuthStatePage statePage) {
    _authenticationService.authStatusPage(statePage);
  }

  void showPass() {
    this.showPassword = !this.showPassword;
    this.notifyListeners();
  }

  void showErrorUsername({bool show}) {
    this.showErroUsername = show;
    this.notifyListeners();
  }

  String getTitle() {
    return "Login";
  }

  Future<void> load() async {}

  Future<void> navigateToHome() async {
    if (_sharedPreferencesService.getShowAlertPermission()) {
      await _navigationService
          .navigateToPageWithReplacement(PermissionsViewRoute);
    } else {
      await _navigationService.navigateToPageWithReplacement(HomeViewRoute,
          title: ConstantsRoutePage.PROFILE);
    }
  }

  Future<String> login(FormBuilderState form, List<TYPEROLE> role) async {
    if (!form.validate()) {
      return "Please complete all required fields.";
    }
    if (showErroUsername)
      return 'Invalid username. Please use only letters (a-z) and numbers';
    setBusy(true);
    String username = '${form.fields["email"].value}@hd.com';
    var result = await _authenticationService.loginWithEmail(
        email: username, password: form.fields["password"].value, role: role);
    if (result == "1") {
      _sharedPreferencesService.initializeAutoLogin();
      if (!kIsWeb) locator<PushNotificationService>().initialize();
      //await _profileService.loadProfile(initializeSearch: true);
      // _authenticationService.currentUser
      _sharedPreferencesService.setCurrentUser(form.fields["email"].value);
      _sharedPreferencesService
          .setCurrentPassword(form.fields["password"].value);
      setBusy(false);
      return "success";
    } else if (result == "0") {
      setBusy(false);
      return "Connection error, check your internet connection and try again";
    } else {
      setBusy(false);
      return result;
    }
  }

  Future<String> resetPasswordAction({@required String email}) async {
    setBusy(true);
    var result =
        await _authenticationService.sendPasswordResetEmail(email: email);
    setBusy(false);

    return result;
  }

  String getUser() {
    return _sharedPreferencesService.getCurrentUser();
  }

  String getPassword() {
    return _sharedPreferencesService.getPassword();
  }

  void navigateToReset() {
    _navigationService.navigateTo(ResetPasswordViewRoute);
  }

  void navigateToSignUp() {
    _navigationService.navigateTo(CreateAccountViewRoute);
  }

  void navigateToLogIn({result}) {
    _navigationService.navigateBack(arguments: result);
  }

  Future<String> navigateToResetPassword() async {
    var result = await _navigationService.navigateTo(ResetPasswordViewRoute);
    return result;
  }
}
