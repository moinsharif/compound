import 'package:compound/core/base/base_service.dart';
import 'package:compound/core/services/generic_firestore/generic_firestore.dart';

class ProfileUpdateMedia {
  final String documentType;
  final String fileType;
  final String fieldName;
  final String path;
  ProfileUpdateMedia(
      this.documentType, this.fileType, this.fieldName, this.path);
}

class ProfilePictureService extends BaseService {
  static ProfileUpdateMedia recruiterUpdateMedia =
      ProfileUpdateMedia("users", "main_profile", "img", "profiles_resources");
  static ProfileUpdateMedia userUpdateMedia = ProfileUpdateMedia(
      "profiles", "main_profile", "img", "profiles_resources");
  static ProfileUpdateMedia highligh1UpdateMedia = ProfileUpdateMedia(
      "profiles", "highlight_1", "image1", "profiles_resources");
  static ProfileUpdateMedia highligh2UpdateMedia = ProfileUpdateMedia(
      "profiles", "highlight_2", "image2", "profiles_resources");

  Future<void> updateMedia(
      ProfileUpdateMedia media, String id, String url) async {
    var db = GenericFirestoreService.db;
    var updateData = Map<String, String>();
    updateData[media.fieldName] = url;
    await db.collection(media.documentType).document(id).updateData(updateData);
  }
}
