import 'package:flutter/foundation.dart';
import 'cloud_storage_repository.dart';

class CloudStorageService {
  CloudStorageRepository _repository;

  CloudStorageService() {
    _repository = CloudStorageRepository();
  }

  /*Future<CloudStorageResult> uploadImageBytes({
    @required Uint8List imageToUpload,
    @required String title,
    String path,
    bool uniqueTime = true,
  }) async {
      return _repository.uploadImageBytes(imageToUpload: imageToUpload, title: title, uniqueTime: uniqueTime, path: path);
  }*/

  Future<CloudStorageResult> uploadImage(
      {@required dynamic imageToUpload,
      @required String title,
      String path,
      bool uniqueTime = true,
      String description = ""}) async {
    return _repository.uploadImage(
        imageToUpload: imageToUpload,
        title: title,
        uniqueTime: uniqueTime,
        path: path,
        description: description);
  }

  Future deleteImage(String imageFileName) async {
    return _repository.deleteImage(imageFileName);
  }
}

class CloudStorageResult {
  final String imageUrl;
  final String imageFileName;

  CloudStorageResult({this.imageUrl, this.imageFileName});
}
