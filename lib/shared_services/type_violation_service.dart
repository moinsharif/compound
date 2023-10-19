import 'package:compound/core/base/base_service.dart';
import 'package:compound/core/services/generic_firestore/generic_firestore.dart';
import 'package:compound/shared_models/type_violation_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class TypeViolationService extends BaseService {
  static const String DatabaseRef = "type_violations";

  Future<List<TypeViolationModel>> getAllTypeViolations() async {
    Query _collectionReference =
        GenericFirestoreService.db.collection(DatabaseRef);
    var snapshot = await _collectionReference.getDocuments();
    if (snapshot.documents.isNotEmpty) {
      var data = snapshot.documents.map((snapshot) {
        var data = snapshot.data;
        return TypeViolationModel.fromData(data, id: snapshot.documentID);
      }).toList();

      return data;
    } else {
      return [];
    }
  }
}
