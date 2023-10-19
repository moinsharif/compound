import 'dart:io';

import 'package:compound/config.dart';
import 'package:compound/core/services/authentication/authentication_service.dart';
import 'package:compound/core/services/storage/cloud_storage_service.dart';
import 'package:compound/locator.dart';

class UploadUtils {
  static Future<String> upload(
      File dataImage, String path, String fileName, String description) async {
    Stopwatch stopwatch;
    if (Config.debugMode) {
      print("IMAGE UPLOADING..." );
      stopwatch = new Stopwatch()..start();
    }

    var storageService = locator<CloudStorageService>();
    var authService = locator<AuthenticationService>();
    var image = await storageService.uploadImage(
        imageToUpload: dataImage,
        title: authService.currentUser.id +
            "_" +
            fileName + "_" +
            DateTime.now().millisecondsSinceEpoch.toString(),
        path: path,
        uniqueTime: false,
        description: description);

    if (Config.debugMode) {
      print("IMAGE UPLOADED: (" + path + fileName + ") SIZE:" + (dataImage.lengthSync() / (1024 * 1024)).toString() +  " TIME: " + stopwatch.elapsed.inSeconds.toString() + "s");
    }
    return image.imageUrl;
  }
}
