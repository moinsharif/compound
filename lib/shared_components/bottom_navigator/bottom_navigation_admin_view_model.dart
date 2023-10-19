import 'dart:async';

import 'package:compound/core/base/base_view_model.dart';
import 'package:compound/core/services/authentication/authentication_service.dart';
import 'package:compound/locator.dart';

class BottomNavigatorAdminViewModel extends BaseViewModel {
  final AuthenticationService _authenticationService =
      locator<AuthenticationService>();
  StreamSubscription<int> selectedIndexStream;

  int selectedIndex = 0;

  Future<void> load() async {
    selectedIndexStream =
        _authenticationService.indexMenuButtonStream.listen((value) {
      this.selectedIndex = value;
      this.notifyListeners();
    });
  }

  @override
  dispose() {
    if (selectedIndexStream != null) selectedIndexStream.cancel();
    super.dispose();
  }

  void updatedSelectedIndex(int index, String pageName) {
    this.selectedIndex = index;
    this.notifyListeners();
  }
}
