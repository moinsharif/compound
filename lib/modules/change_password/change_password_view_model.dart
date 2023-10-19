import 'package:compound/constants.dart';
import 'package:compound/core/base/base_view_model.dart';
import 'package:compound/shared_models/user_model.dart';
import 'package:compound/core/services/authentication/authentication_service.dart';
import 'package:compound/core/services/navigation/navigator_service.dart';
import 'package:compound/locator.dart';
import 'package:compound/router.dart';
import 'package:compound/utils/encrypt_utils.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

class ChangePasswordViewModel extends BaseViewModel {
  final AuthenticationService _authenticationService =
      locator<AuthenticationService>();
  final NavigatorService _navigationService = locator<NavigatorService>();

  bool showTemporaryPassword = true;
  bool showNewPassword = true;
  bool showConfirmPassword = true;

  void hideTemporaryPassword() {
    this.showTemporaryPassword = !this.showTemporaryPassword;
    this.notifyListeners();
  }

  void hideNewPassword() {
    this.showNewPassword = !this.showNewPassword;
    this.notifyListeners();
  }

  void hideConfirmPassword() {
    this.showConfirmPassword = !this.showConfirmPassword;
    this.notifyListeners();
  }

  void setAuthStatePage(AuthStatePage statePage) {
    _authenticationService.authStatusPage(statePage);
  }

  Future<void> navigateToHome() async {
    await _navigationService.navigateToPageWithReplacement(HomeViewRoute);
  }

  Future<void> logOut() async {
    await _authenticationService.logout();
    this.setAuthStatePage(AuthStatePage.LOGIN);
  }

  String getUserName() {
    return _authenticationService.currentUser?.userName ?? '';
  }

  Future<void> updateUser() async {
    User newUser =
        _authenticationService.currentUser.copyWith(changePassword: true);
    _authenticationService.updateCurrentUser(newUser: newUser);
  }

  Future<String> changePassword(FormBuilderState form) async {
    if (!form.validate()) {
      return "Please complete all required fields.";
    }

    if (form.fields["temporaryPassword"].value !=
            _authenticationService.currentUser.temporalPassword
        /*EncryptUtils.decryptData(
            _authenticationService.currentUser.temporalPassword)*/
        ) {
      return 'Temporary password is wrong';
    }

    if (form.fields["confirmPassword"].value !=
        form.fields["newPassword"].value) {
      return 'Passwords do not match.';
    }

    setBusy(true);
    var result = await _authenticationService.changePassword(
        newPassword: form.fields["confirmPassword"].value);

    if (result == "1") {
      setBusy(false);
      return "success";
    } else {
      setBusy(false);
      return result;
    }
  }
}
