import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:compound/config.dart';
import 'package:compound/core/base/base_view_model.dart';
import 'package:compound/core/services/authentication/authentication_service.dart';
import 'package:compound/core/services/checkIn_service/checkin_service.dart';
import 'package:compound/core/services/generic_firestore/generic_firestore.dart';
import 'package:compound/core/services/geolocator/geolocator.dart';
import 'package:compound/core/services/images/images.dart';
import 'package:compound/core/services/navigation/navigator_service.dart';
import 'package:compound/core/services/shared_preferences/shared_preferences_service.dart';
import 'package:compound/core/services/storage/cloud_storage_service.dart';
import 'package:compound/locator.dart';
import 'package:compound/router.dart';
import 'package:compound/shared_models/activityLog_model.dart';
import 'package:compound/shared_models/checkIn_model.dart';
import 'package:compound/shared_models/location_model.dart';
import 'package:compound/shared_models/property_model.dart';
import 'package:compound/shared_models/timesheet_model.dart';
import 'package:compound/shared_services/activity_service.dart';
import 'package:compound/shared_services/property_service.dart';
import 'package:compound/shared_services/timesheet_service.dart';
import 'package:compound/utils/timestamp_util.dart';
import 'package:compound/utils/upload_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';

class CheckInViewModel extends BaseViewModel {
  final PropertyService _propertyService = locator<PropertyService>();
  final CheckInService _checkInService = locator<CheckInService>();
  final NavigatorService _navigationService = locator<NavigatorService>();
  final AuthenticationService _authenticationService =
      locator<AuthenticationService>();
  final GeolocatorService _geolocatorService = locator<GeolocatorService>();
  final TimesheetService _timesheetService = locator<TimesheetService>();
  final ActivityLogService _activityLogService = locator<ActivityLogService>();
  final SharedPreferencesService _preferencesService =
      locator<SharedPreferencesService>();
  final CloudStorageService _cloudStorageService =
      locator<CloudStorageService>();

  StreamSubscription<String> errorSubs;
  StreamSubscription<List<Placemark>> locationSubs;

  Position position;
  List<CheckInModel> checkinsToday = [];
  List<Placemark> placemarks;
  List<PropertyModel> properties;
  PropertyModel selectedPropertyModel;
  String selectedProperty;
  bool loadCheckIn = false;
  CheckInModel checkInModel = new CheckInModel();
  File _selectedImageFile;
  File get selectedImages => _selectedImageFile;

  final SuggestionsBoxController propertyBoxController =
      SuggestionsBoxController();
  bool openBoxProperty = false;

  @override
  dispose() {
    if (errorSubs != null) errorSubs.cancel();
    if (locationSubs != null) locationSubs.cancel();
    super.dispose();
  }

  Future selectImage(ImageData imageData) async {
    if (imageData == null || imageData.file == null) return;
    _selectedImageFile = imageData.file;
    notifyListeners();
  }

  void removeImage(File selectedImag) {
    _selectedImageFile = null;
    notifyListeners();
  }

  Future<void> load(TextEditingController condoController,
      TextEditingController unitController) async {
    setBusy(true);
    if (_authenticationService.currentEmploye.properties.length > 0 ||
        _authenticationService.currentEmploye.temporalProperties.length > 0) {
      checkinsToday = await _checkInService.getCheckInsByDate(
          TimestampUtils.wdRangeNowFrom(), TimestampUtils.wdRangeNowTo());
      properties = await getPropertiesAvailablesToCheckIn();
    }
    position = await _geolocatorService.determinePosition();
    placemarks = await _geolocatorService.getLocation(
        position.latitude, position.longitude);
    setBusy(false);
  }

  Future<List<PropertyModel>> getPropertiesAvailablesToCheckIn() async {
    List<PropertyModel> data = await _propertyService
        .getProperties(_authenticationService.currentEmploye.properties);
    data = [
      ...data,
      ...await _propertyService.getTemporalProperties(
          _authenticationService.currentEmploye.temporalProperties)
    ];
    Future.wait(checkinsToday.map((e) async {
      int index = data.indexWhere((element) => (element.id == e.propertyId));
      if (index != -1 &&
          e.employeedId == _authenticationService.currentEmploye.id) {
        data.removeAt(index);
      }
    }));
    data.sort((a, b) => a.propertyName.compareTo(b.propertyName));
    return data;
  }

  void navigateToChekIn() {
    _navigationService.navigateBack();
  }

  void navigateToManage() {
    _navigationService.navigateTo(ManageViewRoute);
  }

  void changeArrowPositionStreet(bool value, {String opneBox}) {
    this.openBoxProperty = value;
    if (opneBox == 'open') {
      this.propertyBoxController.open();
    } else if (opneBox == 'close') {
      this.propertyBoxController.close();
    }
    notifyListeners();
  }

  Future<List<PropertyModel>> getProperties(String pattern) async {
    if (properties == null) {
      return List<PropertyModel>.empty();
    }

    //TODO retrieve data from database on demand
    return this
        .properties
        .where((PropertyModel element) =>
            element.propertyName.toLowerCase().indexOf(pattern.toLowerCase()) >=
            0)
        .toList();
  }

  void updateProperites(String value) {
    if (_authenticationService.currentEmploye.properties.length <= 0 &&
        _authenticationService.currentEmploye.temporalProperties.length <= 0) {
      return;
    }

    if (this.selectedProperty == value) {
      return;
    }

    if (value == null || value == "") {
      this.selectedProperty = null;
      this.selectedPropertyModel = null;
      this.notifyListeners();
      // tryUpdatePosition();
      return;
    }

    this.selectedProperty = value;
    this.selectedPropertyModel = this.properties.firstWhere(
        (element) => element.propertyName == value,
        orElse: () => null); //TODO retrieve data from database on demand

    // tryUpdatePosition();
    this.notifyListeners();
  }

  // void tryUpdatePosition() {
  //   if (this.selectedPropertyModel == null) {
  //     position = null;
  //     return;
  //   }

  //   position = Position(
  //       latitude: this.selectedPropertyModel.lat,
  //       longitude: this.selectedPropertyModel.lng);
  // }

  String getHour(String time) {
    return '${DateFormat.jm().format(DateFormat("hh:mm:ss").parse('$time:00'))}';
  }

  void lockScreen() {
    this.loadCheckIn = true;
    notifyListeners();
  }

  void unlockScreen() {
    this.loadCheckIn = false;
    notifyListeners();
  }

  Future<String> saveNewCheckIn() async {
    try {
      var now = TimestampUtils.dateNow();
      checkInModel = this._checkInService.newCheckInModel(
          now,
          this.selectedPropertyModel,
          _authenticationService.currentUser.id,
          _authenticationService.currentUser.userName);
      checkInModel.locationCheckIn = new LocationModel();
      checkInModel.locationCheckIn.lat = position.latitude;
      checkInModel.locationCheckIn.lng = position.longitude;

      checkInModel.imageCheckIn = await UploadUtils.upload(selectedImages,
          'checkIn_resources', 'checkIn', ' Uploading checkin image ');

      var batch = GenericFirestoreService.db.batch();
      _checkInService.saveCheckInTransact(checkInModel, batch);
      this._saveTimesheet(batch);
      this._saveActivity(batch, now);
      await batch.commit();
      return 'success';
    } on PlatformException catch (e1, st) {
      handleException(e1, "checkIn", st);
      if (e1.message != null && e1.message.indexOf("permissions") >= 0) {
        return 'Update required, please update app version to ' +
            Config.versionApp;
      }

      return 'Something went wrong';
    } catch (e, st) {
      handleException(e, "checkIn", st);
      return 'Something went wrong';
    }
  }

  void _saveTimesheet(WriteBatch batch) {
    var ts = new TimesheetModel(
        checkInId: checkInModel.id,
        id: checkInModel.id,
        propertyId: checkInModel.propertyId,
        propertyName: checkInModel.propertyName,
        dateCheckIn: checkInModel.dateCheckIn,
        employeId: checkInModel.employeedId,
        employeeName: checkInModel.employeedName,
        isTemporaryPorter: checkInModel.isTemporaryPorter,
        status: 'In Progress');

    _timesheetService.saveTimesheetTransact(ts, batch);
  }

  void _saveActivity(WriteBatch batch, WrappedDate now) {
    var activity = new ActivityLogModel(
        description: 'Added New Check In',
        editedBy: checkInModel.employeedName,
        propertyId: checkInModel.propertyId,
        porterId: checkInModel.employeedId,
        location:
            new LocationModel(lat: position.latitude, lng: position.longitude),
        createdAt: now,
        entityId: this.checkInModel.id);
    _activityLogService.saveActivityLogTransact(activity, batch);
  }

  void setCheckInPreference() {
    _preferencesService.setCurrentCheckIn(checkInModel.id);
  }

  void navigateToManageAfterCheckIn() {
    this.setCheckInPreference();
    _navigationService.navigateToAndRemoveUntil(
        WatchlistViewRoute, (Route<dynamic> route) => false);
  }

  Future<bool> validateDistance() async {
    position = await _geolocatorService.determinePosition();
    double distance = Geolocator.distanceBetween(
        position.latitude,
        position.longitude,
        this.selectedPropertyModel.lat,
        this.selectedPropertyModel.lng);
    if (Config.debugMode || distance <= 1600) {
      return true;
    }
    return false;
  }
}
