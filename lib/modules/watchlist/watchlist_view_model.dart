import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:compound/constants.dart';
import 'package:compound/core/base/base_view_model.dart';
import 'package:compound/core/services/authentication/authentication_service.dart';
import 'package:compound/core/services/checkIn_service/checkin_service.dart';
import 'package:compound/core/services/dialog_service.dart';
import 'package:compound/core/services/generic_firestore/generic_firestore.dart';
import 'package:compound/core/services/geolocator/geolocator.dart';
import 'package:compound/core/services/images/images.dart';
import 'package:compound/core/services/navigation/navigator_service.dart';
import 'package:compound/core/services/storage/cloud_storage_service.dart';
import 'package:compound/locator.dart';
import 'package:compound/router.dart';
import 'package:compound/shared_models/activityLog_model.dart';
import 'package:compound/shared_models/checkIn_model.dart';
import 'package:compound/shared_models/employee_model.dart';
import 'package:compound/shared_models/location_model.dart';
import 'package:compound/shared_models/payrrol_model.dart';
import 'package:compound/shared_models/property_model.dart';
import 'package:compound/shared_models/violation_model.dart';
import 'package:compound/shared_models/watchlist_model.dart';
import 'package:compound/shared_services/activity_service.dart';
import 'package:compound/shared_services/employees_service.dart';
import 'package:compound/shared_services/payrrol_service.dart';
import 'package:compound/shared_services/property_service.dart';
import 'package:compound/shared_services/timesheet_service.dart';
import 'package:compound/shared_services/violation_service.dart';
import 'package:compound/shared_services/watchlist_service.dart';
import 'package:compound/utils/timestamp_util.dart';
import 'package:compound/utils/upload_util.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';

class WatchlistViewModel extends BaseViewModel {
  final TimesheetService _timesheetService = locator<TimesheetService>();
  final NavigatorService _navigatorService = locator<NavigatorService>();
  final PropertyService _propertyService = locator<PropertyService>();
  final PayrollService _payrollService = locator<PayrollService>();
  final ActivityLogService _activityLogService = locator<ActivityLogService>();
  final EmployeesService _employeeService = locator<EmployeesService>();
  final CheckInService _checkInService = locator<CheckInService>();
  final WatchlistService _watchlistService = locator<WatchlistService>();
  final GeolocatorService _geolocatorService = locator<GeolocatorService>();
  final ViolationService _violationService = locator<ViolationService>();
  final AuthenticationService _authenticationService =
      locator<AuthenticationService>();

  Position geoPositionEmployee;
  List<PropertyModel> properties = [];
  List<WatchlistModel> watchlist = [];
  CheckInModel checkInModel;
  bool endWatchlist = false;
  bool performingTask = false;
  bool documentIncidents = false;
  bool existViolations = false;
  PropertyModel currentProperty;

  @override
  dispose() {
    super.dispose();
  }

  Future<void> load() async {
    setBusy(true);
    _authenticationService.textAppBarStream.add(ConstantsRoutePage.WATCHLIST);
    checkInModel = await _checkInService.loadCurrentCheckIn();
    currentProperty =
        await _propertyService.getProperty(checkInModel.propertyId);
    watchlist = await _watchlistService.getWatchlist(
        start: checkInModel.dateCheckIn.rangeFrom(),
        end: checkInModel.dateCheckIn.rangeTo(),
        propertyId: checkInModel.propertyId);
    documentIncidents = checkInModel.documentIncidents ?? false;
    endWatchlist = watchlist.firstWhere(
            (element) => element.status == 'schedule',
            orElse: () => null) ==
        null;
    setBusy(false);
  }

  Future selectImage(ImageData imageData, WatchlistModel model) async {
    if (imageData == null || imageData.file == null) return;

    this.setLocalBusy(true);
    var url = await UploadUtils.upload(imageData.file, 'checkIn_resources',
        'checkIn', ' Uploading watchlist image ');

    WatchlistModel dat =
        watchlist.firstWhere((element) => element.id == model.id);

    dat.image = url;
    dat.status = 'completed';
    dat.imageFile = imageData.file;
    dat.porterId = _authenticationService.currentUser.id;
    dat.porterName = _authenticationService.currentUser.userName;
    dat.completionDate = TimestampUtils.dateNow();
    dat.checkInId = this.checkInModel.id;
    await _watchlistService.updateWatchlist(dat);
    watchlist[watchlist.indexWhere((e) => e.id == dat.id)] = dat;
    endWatchlist = watchlist.firstWhere(
            (element) => element.status == 'schedule',
            orElse: () => null) ==
        null;

    this.setLocalBusy(false);
  }

  void removeImage(WatchlistModel model) async {
    this.setLocalBusy(true);
    WatchlistModel dat =
        watchlist.firstWhere((element) => element.id == model.id);
    WatchlistModel cleanWatchlist = new WatchlistModel(
      id: dat.id,
      date: dat.date,
      name: dat.name,
      status: 'schedule',
      propertyId: dat.propertyId,
      propertyName: dat.propertyName,
    );
    await _watchlistService.updateWatchlist(cleanWatchlist);
    watchlist[watchlist.indexWhere((e) => e.id == dat.id)] = cleanWatchlist;
    endWatchlist = watchlist.firstWhere(
            (element) => element.status == 'schedule',
            orElse: () => null) ==
        null;

    this.setLocalBusy(false);
  }

  String loadHours(DateTime date) {
    final DateFormat formatterHour = DateFormat('hh:mm a');
    return date != null ? formatterHour.format(date) : '--';
  }

  String dateToService(DateTime date) {
    final DateFormat formatterHour = DateFormat('dd');
    return date != null ? formatterHour.format(date) : '--';
  }

  String dayToService(DateTime date) {
    final DateFormat formatterHour = DateFormat('EEE');
    return date != null ? formatterHour.format(date) : '--';
  }

  Future<void> goToManage() async {
    await _navigatorService.navigateToPageWithReplacement(ManageViewRoute);
  }

  void endCheckOutandGoToHome() {
    _checkInService.clearCurrentCheckIn();
    this.navigateToHome();
  }

  Future<void> changeDocumentIncidents() async {
    if (!documentIncidents) {
      this.setLocalBusy(true);
      documentIncidents = true;
      checkInModel.documentIncidents = true;
      await _checkInService.updateCheckIn(checkInModel);
      _checkInService.updateLocalCheckIn(checkInModel);
      this.notifyListeners();
      this.setLocalBusy(false);
    }
  }

  Future<String> checkOut() async {
    try {
      if (!endWatchlist) {
        return 'Please complete watch list to check out';
      } else if (!documentIncidents) {
        return 'Please confirm all incidents have been documented during service';
      } else if (checkInModel.imageCheckOut == null) {
        return 'Please take the check out picture';
      }

      this.setLocalBusy(true);
      geoPositionEmployee = await _geolocatorService.determinePosition();
      existViolations =
          await _violationService.checkViolationsByCheckInId(checkInModel.id);

      var now = TimestampUtils.dateNow();
      checkInModel.dateCheckOut = now;
      checkInModel.dateCheckOutTz = TimestampUtils.timezone();
      checkInModel.locationCheckOut = new LocationModel(
          lat: geoPositionEmployee.latitude,
          lng: geoPositionEmployee.longitude);

      var batch = GenericFirestoreService.db.batch();
      this._savePayroll(batch, now);

      this._releaseTemporaryPorter(batch, now.local());
      if (!existViolations) {
        await this._saveViolationDefault(batch, now);
      }

      _checkInService.updateCheckInTransact(checkInModel, batch);
      _timesheetService.updateTimeSheetTransact(checkInModel.id, batch);
      this._saveActivity(batch, now);

      await batch.commit();
      this.setLocalBusy(false);
      return 'success';
    } on SocketException catch (e1, st) {
      handleException(e1, "checkOut", st);
      this.setLocalBusy(false);
      return 'Connection problem, please verify your internet connection';
    } catch (e2, st) {
      handleException(e2, "checkOut", st);
      this.setLocalBusy(false);
      return 'Someting went wrong, please try again or contact your admin';
    }
  }

  void _releaseTemporaryPorter(WriteBatch batch, DateTime today) async {
    int initialPortes = currentProperty.configProperty.porters.length;
    currentProperty.configProperty.porters.removeWhere((element) =>
        (element.temporary != null &&
            element.temporary == true &&
            element.temporaryDate.local().year == today.year &&
            element.temporaryDate.local().month == today.month &&
            element.temporaryDate.local().day == today.day));

    if (currentProperty.configProperty.porters.length != initialPortes) {
      if (currentProperty.configProperty.porters
              .where((element) =>
                  element.id == _authenticationService.currentEmploye.id)
              .length ==
          0) {
        EmployeeModel currentEmployee = _authenticationService.currentEmploye;
        currentEmployee.temporalProperties
            .removeWhere((element) => element == currentProperty.id);
        _employeeService.updateEmployeeTransact(currentEmployee, batch);
      }
      _propertyService.updatePropertyTransact(currentProperty, batch);
    }
  }

  Future<void> _savePayroll(WriteBatch batch, WrappedDate now) async {
    PayrollModel newPayroll = new PayrollModel(
        createdAt: now,
        employeeId: checkInModel.employeedId,
        employeeName: checkInModel.employeedName,
        propertyId: checkInModel.propertyId,
        propertyName: checkInModel.propertyName,
        propertyAddress: checkInModel.property.address,
        wage: checkInModel.wage,
        checkInId: checkInModel.id);

    _payrollService.setPayrollTransact(newPayroll, batch);
  }

  Future<void> _saveViolationDefault(WriteBatch batch, WrappedDate now) async {
    var violation = new ViolationModel(now,
        id: now.utc().millisecondsSinceEpoch.toString(),
        checkInId: this.checkInModel.id,
        propertyId: this.checkInModel.propertyId,
        description: null,
        employeeName: this.checkInModel.employeedName,
        employeeId: this.checkInModel.employeedId,
        unit: null,
        violationType: ['All units compliant with Service Guidelines']);
    violation.location = new LocationModel(
        lat: geoPositionEmployee.latitude, lng: geoPositionEmployee.longitude);
    violation.images = [this.checkInModel.imageCheckIn];
    _violationService.setViolationTransact(violation, batch);
  }

  void _saveActivity(WriteBatch batch, WrappedDate now) {
    var activity = new ActivityLogModel(
        description: 'Added New CheckOut',
        editedBy: checkInModel.employeedName,
        propertyId: checkInModel.propertyId,
        porterId: checkInModel.employeedId,
        location: new LocationModel(
            lat: geoPositionEmployee.latitude,
            lng: geoPositionEmployee.longitude),
        createdAt: now,
        entityId: this.checkInModel.id);
    _activityLogService.saveActivityLogTransact(activity, batch);
  }

  void setLocalBusy(bool value) {
    this.performingTask = value;
    notifyListeners();
  }

  void navigateToHome() {
    _authenticationService.changeindexMenuButtonStream(0);
    _navigatorService.navigateToAndRemoveUntil(
        HomeViewRoute, (Route<dynamic> route) => false);
  }
}
