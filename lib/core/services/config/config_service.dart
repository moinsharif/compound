import 'package:compound/core/services/generic_firestore/generic_firestore.dart';

class ConfigService {
  Map<String, dynamic> config;

  Future<String> getCurrentBackend() async {
    try {
      if (config != null) return config['description'];

      var db = GenericFirestoreService.db;
      var docRef = await db.collection("config").document("backend").get();
      config = docRef.data;
      return docRef.data['description'];
    } catch (e) {
      return "";
    }
  }
}
