
import 'dart:html';
import 'dart:typed_data';
import 'package:compound/core/services/storage/cloud_storage_service.dart';
import 'package:firebase/firebase.dart' as fb;
import 'package:flutter/foundation.dart';

class CloudStorageRepository {


  /*Future<CloudStorageResult> uploadImageBytes({
    @required Uint8List imageToUpload,
    @required String title,
    bool uniqueTime = true,
  }) async {
    var imageFileName = title + "_" + (uniqueTime? DateTime.now().millisecondsSinceEpoch.toString() : "");

    final fb.StorageReference storageRef  = fb.storage().ref(imageFileName); //'images/$imageName'
    fb.UploadTaskSnapshot uploadTaskSnapshot = await storageRef.put(imageToUpload).future;

    if (uploadTaskSnapshot.state == fb.TaskState.SUCCESS) {
      Uri imageUri = await uploadTaskSnapshot.ref.getDownloadURL();
      return CloudStorageResult(
        imageUrl: imageUri.toString(),
        imageFileName: imageFileName,
      );
    }

    return null;
  }*/

  Future<CloudStorageResult> uploadImage({
    @required File imageToUpload,
    @required String title,
    String path,
    bool uniqueTime = true,
  }) async {
    var imageFileName =
            title + (uniqueTime? DateTime.now().millisecondsSinceEpoch.toString() : "");

        var fullPath = (path == null? "" : path + "/") + imageFileName;

    final fb.StorageReference storageRef  = fb.storage().ref(fullPath); //'images/$imageName'
    fb.UploadTaskSnapshot uploadTaskSnapshot = await storageRef.put(imageToUpload).future;

    if (uploadTaskSnapshot.state == fb.TaskState.SUCCESS) {
      Uri imageUri = await uploadTaskSnapshot.ref.getDownloadURL();
      return CloudStorageResult(
        imageUrl: imageUri.toString(),
        imageFileName: imageFileName,
      );
    }

    return null;
  }

  Future deleteImage(String imageFileName) async {
    try {
      final fb.StorageReference firebaseStorageRef = fb.storage().ref(imageFileName);
      await firebaseStorageRef.delete();
      return true;
    } catch (e) {
      return e.toString();
    }
  }
}

