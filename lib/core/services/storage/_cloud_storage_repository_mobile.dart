import 'dart:io';
import 'dart:typed_data';

import 'package:compound/core/services/storage/cloud_storage_service.dart';
import 'package:compound/core/services/ui/ui_service.dart';
import 'package:compound/locator.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';

class CloudStorageRepository {
  final UIService _uiService = locator<UIService>();

  Future<CloudStorageResult> uploadImageBytes({
    @required Uint8List imageToUpload,
    @required String title,
    bool uniqueTime = true,
  }) async {
    var imageFileName = title +
        (uniqueTime ? DateTime.now().millisecondsSinceEpoch.toString() : "");

    final StorageReference firebaseStorageRef =
        FirebaseStorage.instance.ref().child(imageFileName);
    StorageUploadTask uploadTask = firebaseStorageRef.putData(imageToUpload);
    StorageTaskSnapshot storageSnapshot = await uploadTask.onComplete;

    var downloadUrl = await storageSnapshot.ref.getDownloadURL();

    if (uploadTask.isComplete) {
      var url = downloadUrl.toString();
      return CloudStorageResult(
        imageUrl: url,
        imageFileName: imageFileName,
      );
    }

    return null;
  }

  Future<CloudStorageResult> uploadImage(
      {@required File imageToUpload,
      @required String title,
      String path,
      bool uniqueTime = true,
      String description}) async {
    var imageFileName = title +
        (uniqueTime ? DateTime.now().millisecondsSinceEpoch.toString() : "");

    var fullPath = (path == null ? "" : path + "/") + imageFileName;

    _uiService
        .emitUploadFileEvent({"type": "begin", "description": description});
    final StorageReference firebaseStorageRef =
        FirebaseStorage.instance.ref().child(fullPath);
    StorageUploadTask uploadTask = firebaseStorageRef.putFile(imageToUpload);
    uploadTask.events.listen((event) {
      print(event.snapshot.bytesTransferred.toString() +
          "/" +
          event.snapshot.totalByteCount.toString());
      var progress = event.snapshot.bytesTransferred.toDouble() /
          event.snapshot.totalByteCount.toDouble();
      _uiService.emitUploadFileEvent(
          {"type": "progress", "value": progress, "description": description});
    }).onError((error) {
      _uiService.emitUploadFileEvent(
          {"type": "error", "error": error, "description": description});
    });

    StorageTaskSnapshot storageSnapshot = await uploadTask.onComplete;
    var downloadUrl = await storageSnapshot.ref.getDownloadURL();

    if (uploadTask.isComplete) {
      _uiService
          .emitUploadFileEvent({"type": "success", "description": description});
      var url = downloadUrl.toString();
      return CloudStorageResult(
        imageUrl: url,
        imageFileName: imageFileName,
      );
    } else {
      _uiService.emitUploadFileEvent({
        "type": "error",
        "error": "Unknown error",
        "description": description
      });
      return null;
    }
  }

  Future deleteImage(String path) async {
    final StorageReference firebaseStorageRef =
        FirebaseStorage.instance.ref().child(path);

    try {
      await firebaseStorageRef.delete();
      return true;
    } catch (e) {
      return e.toString();
    }
  }
}
