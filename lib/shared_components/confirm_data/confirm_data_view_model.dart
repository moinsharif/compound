import 'dart:async';
import 'package:compound/constants.dart';
import 'package:compound/core/base/base_view_model.dart';
import 'package:compound/core/services/authentication/authentication_service.dart';
import 'package:compound/core/services/navigation/navigator_service.dart';
import 'package:compound/locator.dart';
import 'package:compound/router.dart';

class ConfirmDataViewModel extends BaseViewModel {
  final NavigatorService _navigationService = locator<NavigatorService>();
  final AuthenticationService _authenticationService =
      locator<AuthenticationService>();
  bool isViolation = false;

  Future<void> load(bool value) async {
    isViolation = value;
  }

  void navigateToBack(bool pop) {
    if (isViolation != null && isViolation) {
      _authenticationService.changeindexMenuButtonStream(1);
      if (pop) {
        _navigationService.navigateBack(title: ConstantsRoutePage.MANAGE);
      } else {
        _navigationService.navigateToPageWithReplacement(ManageViewRoute,
            title: ConstantsRoutePage.MANAGE);
      }
    }
  }
}
