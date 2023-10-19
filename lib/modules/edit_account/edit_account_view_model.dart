import 'package:compound/constants.dart';
import 'package:compound/core/base/base_view_model.dart';
import 'package:compound/core/exceptions/app_exception.dart';
import 'package:compound/shared_models/user_model.dart';
import 'package:compound/core/services/authentication/authentication_service.dart';
import 'package:compound/core/services/navigation/navigator_service.dart';
import 'package:compound/locator.dart';
import 'package:compound/router.dart';
import 'package:compound/shared_services/role_service.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

class EditAccountViewModel extends BaseViewModel {
  final NavigatorService _navigationService = locator<NavigatorService>();
  final RoleService _roleService = locator<RoleService>();
  final AuthenticationService _authenticationService =
      locator<AuthenticationService>();
  
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

      bool activeUser = true;
  bool isSuperAdmin = false;
  int radioValue = 0;
  User data;
  Future<void> load(Object arguments) async {
    data = arguments;
    activeUser = data.active;
    isSuperAdmin = _authenticationService.currentRole.key ==
            describeEnum(TYPEROLE.super_admin)
        ? true
        : false;
    radioValue = data.isEmployee ? 0 : 1;
    firstNameController.text = data.firstName;
    lastNameController.text = data.lastName;
    phoneController.text = data.phoneNumber;
    notifyListeners();
  }

  Future<dynamic> goToBack({bool backWithoutSave = false}) async {
    await _navigationService.navigateBack(
        arguments: data, title: ConstantsRoutePage.ALLEMPLOYEES);
  }

  void handleRadioValueActiveChange(bool value) {
    this.activeUser = value;
    notifyListeners();
  }

  void navigateToChangePassword() {
    _navigationService.navigateToPageWithReplacement(ChangePasswordViewRoute);
  }

  void setAuthStatePage(AuthStatePage statePage) {
    _authenticationService.authStatusPage(statePage);
  }

  void handleRadioValueChange(int value) {
    radioValue = value;
    notifyListeners();
  }

  Future<String> createAccount(FormBuilderState form) async {
    try {
      if (!form.validate()) {
        return "Please complete all required fields.";
      }
      setBusy(true);
      if (form.fields["password"].value != null &&
          form.fields["password"].value.length > 0) {
        String result = await _authenticationService.changePasswordCloudF(
            form.fields["password"].value,
            data.id,
            _authenticationService.currentRole);
        if (result != 'success') {
          setBusy(false);
          return result;
        }
      }
      data = data.copyWith(
          userName: form.fields["name"].value,
          firstName: form.fields["firstname"].value,
          lastName: form.fields["lastname"].value,
          isEmployee: radioValue == 0 ? true : false,
          active: activeUser,
          phoneNumber: form.fields["phoneNumber"].value);
      var userResult =
          await _authenticationService.updateCurrentUser(newUser: data);
      var roleResult = await _roleService.updateRoles(
          data.id, radioValue == 0 ? TYPEROLE.user_tier_1 : TYPEROLE.admin);
      setBusy(false);
      return userResult == "1" && roleResult == "1"
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
