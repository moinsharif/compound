import 'package:compound/core/base/base_view_model.dart';
import 'package:compound/core/services/navigation/navigator_service.dart';
import 'package:compound/core/services/shared_preferences/shared_preferences_service.dart';
import 'package:compound/locator.dart';
import 'package:compound/router.dart';

class PermissionsViewModel extends BaseViewModel {
  final NavigatorService _navigatorService = locator<NavigatorService>();
  final SharedPreferencesService _sharedPreferencesService =
      locator<SharedPreferencesService>();
  bool activeCheckIn = false;
  Future<void> load() async {
    setBusy(true);
    setBusy(false);
    notifyListeners();
  }

  @override
  dispose() {
    super.dispose();
    confirmPermissions();
  }

  Future<void> confirmPermissions() async {
    await _sharedPreferencesService.setShowAlertPermission(false);
    await _navigatorService.navigateToPageWithReplacement(HomeViewRoute);
  }
}
