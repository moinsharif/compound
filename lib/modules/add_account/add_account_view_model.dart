import 'package:compound/constants.dart';
import 'package:compound/core/base/base_view_model.dart';
import 'package:compound/core/exceptions/app_exception.dart';
import 'package:compound/shared_models/market_model.dart';
import 'package:compound/shared_models/user_model.dart';
import 'package:compound/core/services/authentication/authentication_service.dart';
import 'package:compound/core/services/navigation/navigator_service.dart';
import 'package:compound/locator.dart';
import 'package:compound/router.dart';
import 'package:compound/shared_services/market_service.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

class AddAccountViewModel extends BaseViewModel {
  final NavigatorService _navigationService = locator<NavigatorService>();
  final AuthenticationService _authenticationService =
      locator<AuthenticationService>();
  final MarketService _marketService = locator<MarketService>();

  final TextEditingController usernameController = TextEditingController();
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  List<MarketModel> markets = [];
  User data;
  bool isSuperAdmin = false;
  int radioValue = 0;
  Future<void> load() async {
    isSuperAdmin = _authenticationService.currentRole.key ==
            describeEnum(TYPEROLE.super_admin)
        ? true
        : false;
    markets = await _marketService.getAllMarkets();
    notifyListeners();
  }

  void handleRadioValueChange(int value) {
    radioValue = value;
    notifyListeners();
  }

  Future<dynamic> goToBack({bool create = false}) async {
    await _navigationService.navigateBack(
        title: ConstantsRoutePage.ALLEMPLOYEES, arguments: create);
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
      var data = {
        "userName": form.fields["name"].value,
        "firstName": form.fields["firstname"].value,
        "lastName": form.fields["lastname"].value,
        "phoneNumber": form.fields["phoneNumber"].value,
        "password": form.fields["password"].value,
        "role": _authenticationService.currentRole.key,
        "roleCreated": radioValue == 0 ? 'user_tier_1' : 'admin',
      };
      var userResult = await _authenticationService.createUser(newUser: data);
      if (userResult ==
          "The email address is already in use by another account.")
        userResult = 'The username is already in use by another account.';
      setBusy(false);
      return userResult == "success" ? "success" : userResult;
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
