import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:compound/core/base/base_view_model.dart';
import 'package:compound/core/services/authentication/authentication_service.dart';
import 'package:compound/core/services/checkIn_service/checkin_service.dart';
import 'package:compound/core/services/images/images.dart';
import 'package:compound/locator.dart';
import 'package:compound/shared_components/evidence_picture/services/evidence_picture_service.dart';
import 'package:compound/shared_components/image_source_picker/image_source_picker.dart';
import 'package:compound/shared_services/property_service.dart';
import 'package:flutter/material.dart';
import 'package:compound/core/services/storage/cloud_storage_service.dart';

class EvidencePictureViewModel extends BaseViewModel {
  final EvidenceUpdateMedia evidenceUpdateMedia;
  final AuthenticationService _authenticationService =
      locator<AuthenticationService>();
  final EvidencePictureService _evidencePictureService =
      locator<EvidencePictureService>();
  final ImageSelectedCallback onImageSelected;
  final PropertyService _propertyService = locator<PropertyService>();
  final CheckInService _checkInService = locator<CheckInService>();
  final CloudStorageService _cloudStorageService =
      locator<CloudStorageService>();
  EvidencePictureViewModel(this.evidenceUpdateMedia, this.onImageSelected);

  File _selectedImageFile;

  ImageProvider _provider;
  ImageProvider get provider => _provider;

  Future load(String url) async {
    if (url == null) {
      return;
    }

    _provider = CachedNetworkImageProvider(url);
    notifyListeners();
  }

  void removeImage({String url}) async {
    await _cloudStorageService
        .deleteImage(url ?? _checkInService.currentCheckIn.imageCheckOut);
    _evidencePictureService.updateMedia(this.evidenceUpdateMedia,
        url ?? _checkInService.currentCheckIn.id, null);
    _provider = null;
    _checkInService.currentCheckIn.imageCheckOut = null;
    notifyListeners();
  }

  Future selectImage(ImageData imageData) async {
    if (imageData == null || imageData.file == null) return;

    var fileNamePrefix = "";
    if (_authenticationService.currentUser != null) {
      fileNamePrefix = _authenticationService.currentUser.id;
    }

    var fileName = fileNamePrefix +
        "_" +
        evidenceUpdateMedia.fileType +
        "_" +
        DateTime.now().millisecondsSinceEpoch.toString();
    _selectedImageFile = imageData.file;
    _provider = FileImage(imageData.file);
    notifyListeners();

    if (this.onImageSelected != null) {
      this.onImageSelected(
          {"imageData": imageData, "mediaData": evidenceUpdateMedia});
      return;
    }

    CloudStorageResult storageResult;
    storageResult = await _cloudStorageService.uploadImage(
        imageToUpload: _selectedImageFile,
        title: fileName,
        path: evidenceUpdateMedia.path,
        uniqueTime: false,
        description: evidenceUpdateMedia.description);

    await _evidencePictureService.updateMedia(this.evidenceUpdateMedia,
        _checkInService.currentCheckIn.id, storageResult.imageUrl);
    _checkInService.currentCheckIn.imageCheckOut = storageResult.imageUrl;
  }
}
