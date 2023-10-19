import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesService {
  static final autoLogin = "autoLogin";
  static final currentCheckIn = "currentCheckIn";
  static final currentUser = "currentUser";
  static final currentPassword = "currentPassword";
  static final showAlertPermission = "showAlertPermission";
  static final currentRol = "";

  SharedPreferences _prefs;

  initialize() async {
    _prefs = await SharedPreferences.getInstance();
  }

  SharedPreferences get prefs => _prefs;

  bool getAutoLoginEnabled() {
    if (_prefs == null) return false;

    var value = _prefs.getString(autoLogin);
    return value == null ? false : value == "1";
  }

  String getCurrentCheckIn() {
    if (_prefs == null) return null;

    var value = _prefs.getString(currentCheckIn);
    return value == null ? null : value;
  }

  void setCurrentCheckIn(String value) {
    _prefs.setString(currentCheckIn, value);
  }

  String getCurrentRole() {
    if (_prefs == null) return null;

    var value = _prefs.getString(currentCheckIn);
    return value == null ? null : value;
  }

  void setCurrentRol(String value) {
    _prefs.setString(currentCheckIn, value);
  }

  void clearCurrentCheckIn() {
    _prefs.remove(currentCheckIn);
  }

  void setAutoLoginEnabled(bool autoLoginFlag) {
    _prefs.setString(autoLogin, autoLoginFlag ? "1" : "0");
  }

  void initializeAutoLogin() {
    if (_prefs == null) return;

    var value = _prefs.getString(autoLogin);
    if (value == null) {
      this.setAutoLoginEnabled(true);
    }
  }

  String getCurrentUser() {
    if (_prefs == null) return null;

    var value = _prefs.getString(currentUser);
    return value == null ? null : value;
  }

  void setCurrentUser(String value) {
    _prefs.setString(currentUser, value);
  }

  bool getShowAlertPermission() {
    if (_prefs == null) return null;

    bool value = _prefs.getBool(showAlertPermission);
    return value == null ? true : value;
  }

  Future<bool> setShowAlertPermission(bool value) async {
    return await _prefs.setBool(showAlertPermission, value);
  }

  String getPassword() {
    if (_prefs == null) return null;

    var value = _prefs.getString(currentPassword);
    return value == null ? null : value;
  }

  void setCurrentPassword(String value) {
    _prefs.setString(currentPassword, value);
  }
}
