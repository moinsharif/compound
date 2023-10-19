import 'dart:async';

import 'package:compound/core/base/base_view_model.dart';
import 'package:compound/core/services/navigation/navigator_service.dart';
import 'package:compound/locator.dart';
import 'package:compound/router.dart';
import 'package:compound/shared_models/property_model.dart';
import 'package:compound/shared_models/timesheet_model.dart';
import 'package:compound/shared_services/timesheet_service.dart';
import 'package:compound/utils/colors_util.dart';
import 'package:compound/utils/timestamp_util.dart';
import 'package:intl/intl.dart';
import 'package:sticky_and_expandable_list/sticky_and_expandable_list.dart';

class TimesheetModelWrapper implements ExpandableListSection<TimesheetModel> {
  String type;
  bool expanded = true;
  List<TimesheetModel> items;
  WrappedDate date;

  TimesheetModelWrapper(WrappedDate date, {type: "register"}) {
    this.date = date;
    this.type = type;
  }

  @override
  List<TimesheetModel> getItems() {
    return items;
  }

  @override
  bool isSectionExpanded() {
    return expanded;
  }

  @override
  void setSectionExpanded(bool expanded) {
    this.expanded = expanded;
  }
}

class AllTimesheetViewModel extends BaseViewModel {
  final TimesheetService _timesheetService = locator<TimesheetService>();
  final NavigatorService _navigatorService = locator<NavigatorService>();

  List<PropertyModel> properties = [];
  List<TimesheetModelWrapper> timeSheets = [];

  WrappedDate _lastDateLoaded;
  StreamSubscription<dynamic> _currentQuery$;

  @override
  void dispose() {
    if (_currentQuery$ != null) _currentQuery$.cancel();
    _timesheetService.dispose();

    super.dispose();
  }

  Future<void> load() async {
    try {
      setBusy(true);
      if (_currentQuery$ != null) _currentQuery$.cancel();

      _lastDateLoaded = TimestampUtils.dateNow();
      _currentQuery$ =
          _timesheetService.startStream(_lastDateLoaded).listen((newItems) {
        if (newItems != null) {
          var wrapper = TimesheetModelWrapper(_lastDateLoaded);
          wrapper.items = newItems;
          timeSheets.add(wrapper);
        }
        setBusy(false);
      });
    } catch (e, st) {
      handleException(e, "AllTimesheetViewModel -> load", st);
      setBusy(false);
    }
  }

  String loadHours(DateTime date) {
    final DateFormat formatterHour = DateFormat('hh:mm a');
    return date != null ? formatterHour.format(date) : '--';
  }

  String dateToService(DateTime date) {
    final DateFormat formatterHour = DateFormat('MMM dd, yyyy');
    return date != null ? formatterHour.format(date) : '--';
  }

  String dateToHeader(DateTime date) {
    final DateFormat formatterHour = DateFormat('EEEE, MMMM dd, yyyy');
    return date != null ? formatterHour.format(date) : '--';
  }

  Future<dynamic> goToDescriptionTimesheet(sectionIndex, itemIndex) async {
    var timesheet = timeSheets[sectionIndex].items[itemIndex];
    await _navigatorService
        .navigateTo(TimeSheetViewViewRoute, arguments: timesheet)
        .then((value) async {
      if (value != null && value['reload'] != null && value['reload'] == true) {
        setBusy(true);
        TimesheetModel sheet = value['value'];
        timeSheets[sectionIndex].items[itemIndex].id = sheet.id;
        timeSheets[sectionIndex].items[itemIndex].checkInId = sheet.checkInId;
        timeSheets[sectionIndex].items[itemIndex].dateCheckIn =
            sheet.dateCheckIn;
        timeSheets[sectionIndex].items[itemIndex].dateCheckOut =
            sheet.dateCheckOut;
        timeSheets[sectionIndex].items[itemIndex].dateCheckInByAdmin =
            sheet.dateCheckInByAdmin;
        timeSheets[sectionIndex].items[itemIndex].commentByAdmin =
            sheet.commentByAdmin;
        timeSheets[sectionIndex].items[itemIndex].checkInByAdmin =
            sheet.checkInByAdmin;
        timeSheets[sectionIndex].items[itemIndex].status = "Completed";
        timeSheets[sectionIndex].items[itemIndex].colorStatus =
            ColorsUtils.getMaterialColor(0xFF3a8d1d);
        setBusy(false);
      }
    });
  }

  Future handleItemCreated(sectionIndex, itemIndex) async {
    if (timeSheets[sectionIndex].items.length == itemIndex + 1) {
      _lastDateLoaded = _lastDateLoaded.addDays(-1);
      _timesheetService.loadTimesheetByDate(_lastDateLoaded);
    }
  }
}
