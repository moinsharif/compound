import 'package:compound/core/base/base_view_model.dart';
import 'package:compound/core/services/authentication/authentication_service.dart';
import 'package:compound/core/services/navigation/navigator_service.dart';
import 'package:compound/locator.dart';
import 'package:compound/router.dart';
import 'package:flutter/foundation.dart';
import 'package:compound/core/services/shared_preferences/shared_preferences_service.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

class ForgotPasswordViewModel extends BaseViewModel {
  final AuthenticationService _authenticationService =
      locator<AuthenticationService>();
  final NavigatorService _navigationService = locator<NavigatorService>();
  // final ProfileService _profileService = locator<ProfileService>();
  final SharedPreferencesService _sharedPreferencesService =
      locator<SharedPreferencesService>();

  bool showPassword = true;

  void setAuthStatePage(AuthStatePage statePage) {
    _authenticationService.authStatusPage(statePage);
    this.notifyListeners();
  }

  Future<String> resetPasswordAction(FormBuilderState form) async {
    if (!form.validate()) {
      return "Please complete all required fields.";
    }

    setBusy(true);
    var result =
        await _authenticationService.sendPasswordResetEmail(email: form.fields["email"].value);
    setBusy(false);

    return result;
  }
}
