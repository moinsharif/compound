import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:compound/config.dart';
import 'package:compound/constants.dart';
import 'package:compound/core/base/base_view_model.dart';
import 'package:compound/core/services/authentication/authentication_service.dart';
import 'package:compound/core/services/checkIn_service/checkin_service.dart';
import 'package:compound/core/services/generic_firestore/generic_firestore.dart';
import 'package:compound/core/services/geolocator/geolocator.dart';
import 'package:compound/core/services/images/images.dart';
import 'package:compound/core/services/navigation/navigator_service.dart';
import 'package:compound/core/services/storage/cloud_storage_service.dart';
import 'package:compound/core/services/ui/ui_service.dart';
import 'package:compound/locator.dart';
import 'package:compound/router.dart';
import 'package:compound/shared_models/activityLog_model.dart';
import 'package:compound/shared_models/checkIn_model.dart';
import 'package:compound/shared_models/location_model.dart';
import 'package:compound/shared_models/property_model.dart';
import 'package:compound/shared_models/type_violation_model.dart';
import 'package:compound/shared_models/violation_model.dart';
import 'package:compound/shared_services/activity_service.dart';
import 'package:compound/shared_services/type_violation_service.dart';
import 'package:compound/shared_services/violation_service.dart';
import 'package:compound/utils/timestamp_util.dart';
import 'package:compound/utils/upload_util.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:geolocator/geolocator.dart';

class ViolationViewModel extends BaseViewModel {
  final NavigatorService _navigationService = locator<NavigatorService>();
  final AuthenticationService _authenticationService =
      locator<AuthenticationService>();
  final CloudStorageService _cloudStorageService =
      locator<CloudStorageService>();
  final TypeViolationService _typeViolationService =
      locator<TypeViolationService>();
  final CheckInService _checkInService = locator<CheckInService>();
  final ActivityLogService _activityLogService = locator<ActivityLogService>();
  final ViolationService _violationService = locator<ViolationService>();
  final GeolocatorService _geolocatorService = locator<GeolocatorService>();
  CheckInModel _checkInModel;
  List<TypeViolationModel> typeViolations;
  Position position;

  PropertyModel selectedProperty;
  String showUnit = '';
  String showMarket = '';
  String showProperty = '';
  List<String> selectedViolation = [];
  List<File> _selectedImageFile = [];
  List<File> get selectedImages => _selectedImageFile;

  final SuggestionsBoxController violationBoxController =
      SuggestionsBoxController();
  bool openBoxViolation = false;

  @override
  dispose() {
    super.dispose();
  }

  Future<void> load() async {
    _authenticationService.textAppBarStream.add(Config.oneViolation);
    this.typeViolations = await _typeViolationService.getAllTypeViolations();
    _checkInModel = await _checkInService.getLastCheckIn();
    this.getViolationInformation();
    notifyListeners();
  }

  Future<List<TypeViolationModel>> getTypeViolations(String pattern) async {
    if (typeViolations == null) {
      return List<TypeViolationModel>.empty();
    }
    return this
        .typeViolations
        .where((element) =>
            element.name.toLowerCase().indexOf(pattern.toLowerCase()) >= 0)
        .toList();
  }

  void changeArrowPositionViolation(bool value, {String opneBox}) {
    this.openBoxViolation = value;
    if (opneBox == 'open') {
      this.violationBoxController.open();
    } else if (opneBox == 'close') {
      this.violationBoxController.close();
    }
    notifyListeners();
  }

  void updateViolation(String value) {
    this.selectedViolation.add(value);
    this.notifyListeners();
  }

  void navigateToChekIn() {
    _navigationService.navigateBack();
  }

  void getViolationInformation() {
    this.showProperty = _checkInModel.propertyName;
    this.showMarket = _checkInModel.marketName;
    this.showUnit = _checkInModel.units;
  }

  void navigateToManage({bool back = true}) {
    if (back) {
      _navigationService.navigateBack(title: ConstantsRoutePage.MANAGE);
    } else {
      _navigationService.navigateTo(ManageViewRoute,
          title: ConstantsRoutePage.MANAGE);
    }
  }

  Future selectImage(ImageData imageData) async {
    if (imageData == null || imageData.file == null) return;
    _selectedImageFile = [..._selectedImageFile, imageData.file];
    notifyListeners();
  }

  void removeImage(File selectedImag) {
    _selectedImageFile.removeWhere((element) => selectedImag == element);
    notifyListeners();
  }

  void removeEmployee(String typeOfViolation) {
    selectedViolation.remove(typeOfViolation);
    notifyListeners();
  }

  Future<String> createViolation(FormBuilderState form) async {
    if (!form.validate()) {
      return "Please complete all required fields.";
    }

    if (this.selectedViolation.isEmpty) {
      return "Please select at least one type of observation.";
    }

    if (this.selectedImages.length <= 0) {
      return "Please take at least one picture";
    }

    if (_checkInModel != null) {
      setBusy(true);
      List<String> images = [];
      position = await _geolocatorService.determinePosition();
      var batch = GenericFirestoreService.db.batch();
      var now = TimestampUtils.dateNow();
      ViolationModel _violation = new ViolationModel(now,
          id: now.utc().millisecondsSinceEpoch.toString(),
          checkInId: this._checkInModel.id,
          propertyId: this._checkInModel.propertyId,
          description: form.fields["description"].value,
          employeeName: this._checkInModel.employeedName,
          employeeId: this._checkInModel.employeedId,
          unit: form.fields["unit"].value,
          violationType: selectedViolation);

      _violation.location =
          new LocationModel(lat: position.latitude, lng: position.longitude);
      await Future.forEach(this._selectedImageFile, (e) async {
        images = [
          ...images,
          await UploadUtils.upload(e, 'violations_resources', 'violation',
              " Uploading observations images ")
        ];
      });
      _violation.images = images;
      _violationService.setViolationTransact(_violation, batch);
      this._saveActivity(batch, now);
      await batch.commit();

      setBusy(false);
      return 'success';
    }
    return 'Error load data';
  }

  void _saveActivity(WriteBatch batch, WrappedDate now) {
    var activity = new ActivityLogModel(
        description: 'Added New Observation',
        editedBy: _checkInModel.employeedName,
        propertyId: _checkInModel.propertyId,
        porterId: _checkInModel.employeedId,
        createdAt: now,
        entityId: _checkInModel.id);
    _activityLogService.saveActivityLogTransact(activity, batch);
  }

  void navigatoToSuccessData() {
    _navigationService.navigateToPageWithReplacement(ConfirmationViewRoute,
        arguments: true, title: '${Config.oneViolation} Added');
  }
}
