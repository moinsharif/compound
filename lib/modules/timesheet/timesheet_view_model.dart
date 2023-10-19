import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:compound/core/base/base_view_model.dart';
import 'package:compound/core/services/authentication/authentication_service.dart';
import 'package:compound/core/services/checkIn_service/checkin_service.dart';
import 'package:compound/core/services/dialog_service.dart';
import 'package:compound/core/services/generic_firestore/generic_firestore.dart';
import 'package:compound/core/services/navigation/navigator_service.dart';
import 'package:compound/locator.dart';
import 'package:compound/shared_models/activityLog_model.dart';
import 'package:compound/shared_models/checkIn_model.dart';
import 'package:compound/shared_models/days_selected.dart';
import 'package:compound/shared_models/payrrol_model.dart';
import 'package:compound/shared_models/property_model.dart';
import 'package:compound/shared_models/timesheet_model.dart';
import 'package:compound/shared_services/activity_service.dart';
import 'package:compound/shared_services/payrrol_service.dart';
import 'package:compound/shared_services/property_service.dart';
import 'package:compound/shared_services/timesheet_service.dart';
import 'package:compound/utils/timestamp_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:intl/intl.dart';

class TimesheetViewModel extends BaseViewModel {
  final AuthenticationService _authenticationService =
      locator<AuthenticationService>();
  final CheckInService _checkInService = locator<CheckInService>();
  final ActivityLogService _activityLogService = locator<ActivityLogService>();
  final PayrollService _payrollService = locator<PayrollService>();
  final TimesheetService _timesheetService = locator<TimesheetService>();
  final PropertyService _propertyService = locator<PropertyService>();
  final NavigatorService _navigatorService = locator<NavigatorService>();
  final FocusNode focusInstructions = FocusNode();
  final TextEditingController controller = new TextEditingController();

  CheckInModel checkInModel;
  TimesheetModel timeSheets;
  bool loadCheckOut = false;

  @override
  dispose() {
    super.dispose();
  }

  Future<void> load(TimesheetModel ts) async {
    setBusy(true);
    if (ts.checkInId != null) {
      var data = await _timesheetService.getTimeSheet(ts.id);
      timeSheets = data['timesheet'];
      checkInModel = data['checkin'];
      if (timeSheets.checkInByAdmin) {
        controller.text = timeSheets?.commentByAdmin ?? '';
      }
    } else {
      timeSheets = ts;
      var now = TimestampUtils.dateNow();
      PropertyModel prop = await _propertyService.getProperty(ts.propertyId);
      checkInModel = new CheckInModel(
        id: now.utc().millisecondsSinceEpoch.toString(),
        marketName: prop.marketName,
        marketId: prop.marketId,
        checkInByAdmin: true,
        dateCheckInByAdmin: now,
        dateCheckInByAdminTz: TimestampUtils.timezone(),
        dateCheckIn: ts.dateCheckIn,
        employeedId: ts.employeId,
        employeedName: ts.employeeName,
        property: prop,
        propertyId: prop.id,
        propertyName: prop.propertyName,
        units: prop.units,
        wage: prop.configProperty.daysSelected
            .firstWhere(
              (element) => element.id == TimestampUtils.currentWeekDay(),
              orElse: () => new DaysSelected(rate: 15),
            )
            .rate,
      );
    }
    setBusy(false);
  }

  String loadHours(DateTime date) {
    final DateFormat formatterHour = DateFormat('hh:mm a');
    return date != null ? formatterHour.format(date) : '--';
  }

  Future<dynamic> goToBack({bool reload = false}) async {
    await _navigatorService
        .navigateBack(arguments: {"reload": reload, "value": this.timeSheets});
  }

  Future<bool> setCheckIn(FormBuilderState form) async {
    try {
      if (!form.validate()) {
        ScaffoldMessenger.of(
                locator<DialogService>().scaffoldKey.currentContext)
            .showSnackBar(SnackBar(
          content: Text('Please complete all required fields.'),
        ));
        return false;
      }
      this.loadCheckIn();

      var batch = GenericFirestoreService.db.batch();

      var now = TimestampUtils.dateNow();
      if (checkInModel.dateCheckIn == null) {
        checkInModel.dateCheckIn = now;
        checkInModel.dateCheckInTz = TimestampUtils.timezone();
      }
      checkInModel.dateCheckOut = now;
      checkInModel.dateCheckOutTz = TimestampUtils.timezone();
      try {
        _checkInService.saveCheckInTransact(checkInModel, batch);
        _saveTimeSheet(batch, now);
        _saveActivity(
            'Added New Admin Check In', batch, now, checkInModel.id);
        _saveActivity(
            'Added New Admin Check Out', batch, now, checkInModel.id);
        _savePayroll(batch, now);
        batch.commit();

        this.loadCheckIn();
      } catch (e) {
        ScaffoldMessenger.of(
                locator<DialogService>().scaffoldKey.currentContext)
            .showSnackBar(SnackBar(
          content: Text('Something went wrong'),
        ));
        this.loadCheckIn();
        return false;
      }
      return true;
    } catch (e) {
      ScaffoldMessenger.of(locator<DialogService>().scaffoldKey.currentContext)
          .showSnackBar(SnackBar(
        content: Text('Something went wrong'),
      ));
      this.loadCheckIn();
      return false;
    }
  }

  void loadCheckIn() {
    this.loadCheckOut = !this.loadCheckOut;
    notifyListeners();
  }

  void _savePayroll(WriteBatch batch, WrappedDate now) {
    var pm = new PayrollModel(
      createdAt: now,
      employeeId: checkInModel.employeedId,
      employeeName: checkInModel.employeedName,
      propertyId: checkInModel.propertyId,
      propertyName: checkInModel.propertyName,
      propertyAddress: checkInModel.property.address,
      wage: checkInModel.wage,
    );
    this._payrollService.setPayrollTransact(pm, batch);
  }

  void _saveTimeSheet(WriteBatch batch, WrappedDate now) {
    this.timeSheets.checkInId = checkInModel.id;
    this.timeSheets.id = checkInModel.id;
    this.timeSheets.dateCheckIn = checkInModel.dateCheckIn;
    this.timeSheets.dateCheckOut = checkInModel.dateCheckOut;
    this.timeSheets.employeId = checkInModel.employeedId;
    this.timeSheets.employeeName = checkInModel.employeedName;
    this.timeSheets.status = 'Completed';
    this.timeSheets.checkInByAdmin = true;
    this.timeSheets.commentByAdmin = controller.text;
    this.timeSheets.dateCheckInByAdmin = checkInModel.dateCheckIn ?? now;
    this.timeSheets.propertyId = timeSheets.propertyId;
    this.timeSheets.propertyName = timeSheets.propertyName;
    _timesheetService.saveTimesheetTransact(timeSheets, batch);
  }

  void _saveActivity(
      String description, WriteBatch batch, WrappedDate now, String entityId) {
    var activity = new ActivityLogModel(
        description: description,
        adminId: _authenticationService.currentUser.id,
        editedBy: _authenticationService.currentUser?.userName ?? '',
        propertyId: checkInModel.propertyId,
        porterId: checkInModel.employeedId,
        createdAt: now,
        entityId: entityId);
    _activityLogService.saveActivityLogTransact(activity, batch);
  }
}
