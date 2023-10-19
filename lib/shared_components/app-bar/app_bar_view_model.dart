import 'dart:async';

import 'package:compound/core/base/base_view_model.dart';
import 'package:compound/core/services/authentication/authentication_service.dart';
import 'package:compound/core/services/navigation/navigator_service.dart';
import 'package:compound/core/services/ui/ui_service.dart';
import 'package:compound/locator.dart';
import 'package:compound/router.dart';

class AppBarViewModel extends BaseViewModel {
  bool hidden = true;
  bool showMail = false;
  bool showFilterViolations = false;
  bool showMessages = true;
  String titleAppBar = '';
  final AuthenticationService _authenticationService =
      locator<AuthenticationService>();
  final NavigatorService _navigatorService = locator<NavigatorService>();
  final UIService _uiService = locator<UIService>();

  StreamSubscription<bool> subs;
  StreamSubscription<String> titleAppBarStream;
  StreamSubscription<IconAppBarModel> showEmailHeader;
  StreamSubscription<IconAppBarModel> showFilterViolationsHeader;

  Function functionEmail;
  Function functionFilterViolations;

  @override
  dispose() {
    if (subs != null) subs.cancel();
    if (showEmailHeader != null) showEmailHeader.cancel();
    if (titleAppBarStream != null) titleAppBarStream.cancel();
    if (showFilterViolationsHeader != null) showFilterViolationsHeader.cancel();
    super.dispose();
  }

  Future<void> load() async {
    if (await _authenticationService.isUserLoggedIn() &&
        _authenticationService.isUserChangePassword()) {
      hidden = false;
      this.notifyListeners();
    }

    if (subs != null) {
      subs.cancel();
    }

    if (titleAppBarStream != null) {
      titleAppBarStream.cancel();
    }

    if (showFilterViolationsHeader != null) {
      showFilterViolationsHeader.cancel();
    }

    subs = _authenticationService.loginStatusChangeStream.listen((value) {
      this.hidden = !value;
      this.notifyListeners();
    });

    showEmailHeader = _uiService.emailHeaderStream.listen((value) {
      this.showMail = value.showIcon;
      this.functionEmail = value.function;
      this.notifyListeners();
    });

    showFilterViolationsHeader =
        _uiService.filterViolationsHeaderStream.listen((value) {
      this.showFilterViolations = value.showIcon;
      this.functionFilterViolations = value.function;
      this.notifyListeners();
    });

    _navigatorService.onChangePage.listen((event) {
      try {
        if (event['title'] != null) {
          this.titleAppBar = event['title'];
          this.notifyListeners();
        }
      } catch (e) {}
    });

    _authenticationService.textAppBarStream.listen((value) {
      this.titleAppBar = value;
      this.notifyListeners();
    });
  }

  void updatedSelectedIndex(int index) {
    this.notifyListeners();
  }

  Future<void> logOut() async {
    await this._authenticationService.logout();
    _navigatorService.navigateToPageWithReplacement(AuthViewRoute);
  }
}
