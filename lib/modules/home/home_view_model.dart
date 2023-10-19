
import 'package:compound/core/base/base_view_model.dart';
import 'package:compound/core/services/authentication/authentication_service.dart';
import 'package:compound/locator.dart';

class HomeViewModel extends BaseViewModel {
  final AuthenticationService _authenticationService =
      locator<AuthenticationService>();
  String admin;
  Future<void> load() async {
    setBusy(true);
    admin = _authenticationService.currentRole.key;
    setBusy(false);
  }

  String getUserName() {
    return _authenticationService.currentUser?.userName ?? '';
  }
}
