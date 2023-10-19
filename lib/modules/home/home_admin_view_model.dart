import 'package:compound/constants.dart';
import 'package:compound/core/base/base_view_model.dart';
import 'package:compound/core/services/authentication/authentication_service.dart';
import 'package:compound/core/services/navigation/navigator_service.dart';
import 'package:compound/core/services/ui/ui_service.dart';
import 'package:compound/locator.dart';
import 'package:compound/router.dart';

class HomeAdminViewModel extends BaseViewModel {
  final AuthenticationService _authenticationService =
      locator<AuthenticationService>();
  final NavigatorService _navigatorService = locator<NavigatorService>();
  final UIService _uiService = locator<UIService>();
  String admin;
  Future<void> load() async {
    setBusy(true);
    _authenticationService.textAppBarStream.add(ConstantsRoutePage.ADMIN_HOME);
    setBusy(false);
  }

  String getUserName() {
    return '${_authenticationService.currentUser?.firstName} ${_authenticationService.currentUser?.lastName}' ??
        '';
  }

  Future<dynamic> goToAllActivities() async {
    _authenticationService.changeindexMenuButtonStream(-1);
    await _navigatorService.navigateToPageWithReplacement(
        AllActivitiesViewRoute,
        title: ConstantsRoutePage.ACTIVITY_LOG);
  }

  void goToCalendar() async {
    await _navigatorService.navigateToPageWithReplacement(
      CalendarViewRoute,
    );
  }
}
