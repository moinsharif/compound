import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:compound/core/base/base_view_model.dart';
import 'package:compound/core/services/authentication/authentication_service.dart';
import 'package:compound/core/services/images/images.dart';
import 'package:compound/core/services/storage/cloud_storage_service.dart';
import 'package:compound/locator.dart';
import 'package:compound/shared_components/image_source_picker/image_source_picker.dart';
import 'package:compound/shared_components/profile_picture/services/profile_picture_service.dart';
import 'package:flutter/material.dart';

class ProfilePictureViewModel extends BaseViewModel {

    final ProfileUpdateMedia profileUpdateMedia;
    final CloudStorageService _cloudStorageService = locator<CloudStorageService>();
    final AuthenticationService _authenticationService = locator<AuthenticationService>();
    final ProfilePictureService _profileService = locator<ProfilePictureService>();
    final ImageSelectedCallback onImageSelected;
    
    ProfilePictureViewModel(this.profileUpdateMedia, this.onImageSelected);

    File _selectedImageFile;

    ImageProvider _provider;
    ImageProvider get provider => _provider;

    Future load(String url) async {
        if(url == null){
          return;
        }

        _provider = CachedNetworkImageProvider(url);
        notifyListeners();
    }

    Future selectImage(ImageData imageData) async {

      if (imageData == null || imageData.file == null) 
           return;

      var fileNamePrefix = "";
      if(_authenticationService.currentUser != null){
          fileNamePrefix = _authenticationService.currentUser.id;
      } 

      var fileName = fileNamePrefix + "_" + profileUpdateMedia.fileType; //+ imageData.fileName.split(".").last;
      _selectedImageFile = imageData.file;
      _provider = FileImage(imageData.file);
      notifyListeners();

      if(this.onImageSelected != null){
        this.onImageSelected({"imageData": imageData, 
                              "mediaData" : profileUpdateMedia});
        return;
      }

      CloudStorageResult storageResult;
      storageResult = await _cloudStorageService.uploadImage(
        imageToUpload: _selectedImageFile,
        title: fileName,
        path: profileUpdateMedia.path,
        uniqueTime: false
      );

      _profileService.updateMedia(this.profileUpdateMedia, 
                                  _authenticationService.currentUser.id,
                                  storageResult.imageUrl);
    }

}
