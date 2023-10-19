import 'package:compound/core/base/base_service.dart';
import 'package:compound/core/services/generic_firestore/generic_firestore.dart';

class EvidenceUpdateMedia {
  final String documentType;
  final String fileType;
  final String fieldName;
  final String path;
  final String description;
  EvidenceUpdateMedia(
      this.documentType, this.fileType, this.fieldName, this.path, this.description);
}

class EvidencePictureService extends BaseService {
  Future<void> updateMedia(
      EvidenceUpdateMedia media, String id, String url) async {
    var db = GenericFirestoreService.db;
    var updateData = Map<String, String>();
    updateData[media.fieldName] = url;
    await db.collection(media.documentType).document(id).updateData(updateData);
  }
}
