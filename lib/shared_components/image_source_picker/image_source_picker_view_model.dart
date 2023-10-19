import 'dart:io';

import 'package:compound/core/base/base_view_model.dart';
import 'package:compound/core/services/images/images.dart';
import 'package:compound/core/services/navigation/navigator_service.dart';
import 'package:compound/locator.dart';
import 'package:compound/router.dart';
import 'package:compound/shared_components/image_source_picker/image_source_picker.dart';
import 'package:compound/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';

class ImageSourcePickerViewModel extends BaseViewModel {
  final NavigatorService _navigatorService = locator<NavigatorService>();
  final ImagesService _imagesService = locator<ImagesService>();
  final ImageSelectedCallback onImageSelected;
  final bool croppedImage;
  final int croppedSize;

  ImageSourcePickerViewModel(
      {this.onImageSelected, this.croppedImage, this.croppedSize});

  Future<File> _cropImage(String path) async {
    File croppedFile = await ImageCropper().cropImage(
        sourcePath: path,
        androidUiSettings: AndroidUiSettings(
            toolbarTitle: 'Cropper',
            toolbarColor: AppTheme.instance.primaryDarker,
            toolbarWidgetColor: Colors.black,
            hideBottomControls: true,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: false),
        iosUiSettings: IOSUiSettings(
            title: 'Cropper',
            rotateButtonsHidden: true,
            aspectRatioLockDimensionSwapEnabled: true));

    return croppedFile;
  }

  Future selectImageGallery() async {
    var imageData = await _imagesService.getImageGallery();
    if (imageData != null && imageData.file != null) {
      if (this.croppedImage) {
        imageData.file = await _cropImage(imageData.file.path);
      }

      this.onImageSelected(imageData);
    }
  }

  Future selectImageCamera() async {
    var imageData = ImageData();
    var imagePimagePath = await _navigatorService.navigateTo(CameraViewRoute);
    if (imagePimagePath == null) return;

    if (this.croppedImage) {
      imageData.file = await _cropImage(imagePimagePath);
    } else {
      //TODO MAVHA set imageData.file when not cropped
    }

    this.onImageSelected(imageData);
  }
}
