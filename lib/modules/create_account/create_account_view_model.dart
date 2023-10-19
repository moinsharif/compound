import 'dart:convert';

import 'package:compound/core/base/base_view_model.dart';
import 'package:compound/core/exceptions/app_exception.dart';
import 'package:compound/shared_models/role_model.dart';
import 'package:compound/shared_models/user_model.dart';
import 'package:compound/core/services/authentication/authentication_service.dart';
import 'package:compound/core/services/navigation/navigator_service.dart';
import 'package:compound/locator.dart';
import 'package:compound/router.dart';
import 'package:compound/utils/encrypt_utils.dart';
import 'package:compound/utils/string_utils.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

class CreateAccountViewModel extends BaseViewModel {
  final NavigatorService _navigationService = locator<NavigatorService>();
  final AuthenticationService _authenticationService =
      locator<AuthenticationService>();

  void navigateToChangePassword() {
    _navigationService.navigateToPageWithReplacement(ChangePasswordViewRoute);
  }

  void setAuthStatePage(AuthStatePage statePage) {
    _authenticationService.authStatusPage(statePage);
  }

  Future<String> createAccount(FormBuilderState form) async {
    try {
      if (!form.validate()) {
        return "Please complete all required fields.";
      }

      setBusy(true);
      var role =
          Role(RoleType.user, Role.defaultRole, true, typeLevel: [], level: 1);
      var user = User(
          userName: form.fields["name"].value,
          firstName: form.fields["firstname"].value,
          lastName: form.fields["lastname"].value,
          email: form.fields["email"].value,
          phoneNumber: form.fields["phoneNumber"].value);
      String pass = StringUtils.getRandString();
      var userResult =
          await _authenticationService.signUpWithEmail(pass, user, role);
      setBusy(false);
      return userResult != null
          ? "success"
          : "There was a problem creating the account, please try again later";
    } on PlatformException catch (e) {
      setBusy(false);
      return e.message;
    } on AppException catch (e) {
      setBusy(false);
      return e.getMessage();
    } catch (e) {
      print(e);
      setBusy(false);
      return "Connection error, check your internet connection and try again";
    }
  }
}
