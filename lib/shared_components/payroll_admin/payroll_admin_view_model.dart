import 'package:compound/constants.dart';
import 'package:compound/core/base/base_view_model.dart';
import 'package:compound/core/services/authentication/authentication_service.dart';
import 'package:compound/core/services/checkIn_service/checkin_service.dart';
import 'package:compound/core/services/navigation/navigator_service.dart';
import 'package:compound/locator.dart';
import 'package:compound/router.dart';
import 'package:compound/utils/timestamp_util.dart';
import 'package:intl/intl.dart';

import '../../shared_models/checkIn_model.dart';

class PayrollAdminViewModel extends BaseViewModel {
  final AuthenticationService _authenticationService =
      locator<AuthenticationService>();
  final NavigatorService _navigatorService = locator<NavigatorService>();
  final CheckInService _checkInService = locator<CheckInService>();
  DateTime initDate;
  DateTime endDate;
  String showDate = '';
  String hour = '';
  bool canUp = false;
  bool canDown = false;
  String dayChackIn = '00';
  String lastWeekCheckIn = '00';

  Future<void> load() async {
    setBusy(true);
    CheckInModel initCheckIn = await _checkInService.getfirstCheckIn();
    this.initDate = initCheckIn?.dateCheckIn?.local() ?? DateTime.now();
    this.endDate = DateTime.now();
    loadCheckInDay();
    loadCheckInLastWeek();
    loadDates();
    canUp = up();
    canDown = down();
    setBusy(false);
    this.notifyListeners();
  }

  void loadCheckInDay() async {
    List<CheckInModel> checksIn = await _checkInService.getCheckInsByDate(
        TimestampUtils.wdRangeNowFrom(), TimestampUtils.wdRangeNowTo());
    this.dayChackIn = checksIn.length > 0 ? checksIn.length.toString() : '00';
    notifyListeners();
  }

  void loadCheckInLastWeek() async {
    List<CheckInModel> checksIn = await _checkInService.getCheckInsByDate(
        WrappedDate.fromLocal(new DateTime(
            this.endDate.year,
            this.endDate.month,
            DateTime.now().day - this.endDate.weekday,
            0,
            0,
            0)),
        WrappedDate.fromLocal(new DateTime(
            this.endDate.year,
            this.endDate.month,
            DateTime.now().day + (DateTime.daysPerWeek - this.endDate.weekday),
            23,
            59,
            59)));
    this.lastWeekCheckIn =
        checksIn.length > 0 ? checksIn.length.toString() : '00';
    notifyListeners();
  }

  Future<bool> isCurrentCheckIn() async {
    var res = await _checkInService.loadCurrentCheckIn();
    return res != null ? true : false;
  }

  void getDate(String direcction) {
    if (direcction == 'up' && up()) {
      setDate(this.endDate.subtract(Duration(days: 1)));
      loadCheckInDay();
    } else if (direcction == 'down' && down()) {
      setDate(this.endDate.add(Duration(days: 1)));
      loadCheckInDay();
    }
  }

  void setDate(DateTime newDate) {
    this.endDate = newDate;
    this.showDate = formatDate(this.endDate);
    this.notifyListeners();
  }

  String formatDate(DateTime date) {
    final DateFormat formatter = DateFormat('MMMM dd, yyyy');
    return formatter.format(date);
  }

  void loadDates() {
    final DateFormat formatter = DateFormat('MMMM dd, yyyy');
    final DateFormat formatterHour = DateFormat('hh:mm a');
    this.showDate = formatter.format(endDate);
    this.hour = formatterHour.format(endDate);
  }

  bool up() {
    return this.initDate.isBefore(this.endDate) &&
        this.initDate.difference(this.endDate).inDays != 0;
  }

  bool down() {
    return this.endDate.add(Duration(days: 1)).isBefore(DateTime.now());
  }

  Future<dynamic> goToTimeSheets() async {
    _authenticationService.changeindexMenuButtonStream(-1);
    await _navigatorService.navigateToPageWithReplacement(AllTimeSheetViewRoute,
        title: ConstantsRoutePage.TIMESHEET);
    this.notifyListeners();
  }
}
