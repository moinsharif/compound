import 'package:compound/constants.dart';
import 'package:compound/core/base/base_view_model.dart';
import 'package:compound/core/services/authentication/authentication_service.dart';
import 'package:compound/core/services/checkIn_service/checkin_service.dart';
import 'package:compound/core/services/navigation/navigator_service.dart';
import 'package:compound/locator.dart';
import 'package:compound/router.dart';
import 'package:compound/shared_models/checkIn_model.dart';
import 'package:intl/intl.dart';

class LastCheckInViewModel extends BaseViewModel {
  final CheckInService _checkInService = locator<CheckInService>();
  final AuthenticationService _authenticationService =
      locator<AuthenticationService>();
  final NavigatorService _navigatorService = locator<NavigatorService>();
  CheckInModel lastcheckIn;
  String lastLocation = '';
  String hour = '';
  bool activeCheckIn = false;
  Future<void> load() async {
    setBusy(true);
    activeCheckIn =
        await _checkInService.loadCurrentCheckIn() != null ? true : false;
    if (this.activeCheckIn) {
      this.hour = 'Right now';
    } else {
      this.lastcheckIn = await _checkInService.getLastCheckIn();
      if (this.lastcheckIn != null) {
        this.loadlastTime(this.lastcheckIn.dateCheckIn.local());
      }
      this.loadlastLocation();
    }
    setBusy(false);
    notifyListeners();
  }

  void loadlastTime(DateTime date) {
    final DateFormat formatterHour = DateFormat('MMM dd, yyyy hh:mm a');
    this.hour = formatterHour.format(date);
  }

  void loadlastLocation() {
    if (lastcheckIn != null) {
      this.lastLocation =
          '${this.lastcheckIn.propertyName}, ${this.lastcheckIn.marketName}';
    } else {
      this.lastLocation = 'You do not have check ins yet';
    }
  }

  void goToCheckIn() {
    _authenticationService.changeindexMenuButtonStream(1);
    _navigatorService.navigateToPageWithReplacement(ManageViewRoute,
        title: ConstantsRoutePage.MANAGE);
  }
}
