import 'package:cloud_firestore/cloud_firestore.dart';

class GenericFirestoreRepository {

  final Firestore _db = Firestore.instance;
  final String path;
  CollectionReference ref;

  GenericFirestoreRepository(this.path) {
    ref = _db.collection(path);
  }

  Future<List<Map<String, dynamic>>> list<T>({limit : int}) async { //TODO MAVHA error handling
      QuerySnapshot snapshot = limit == null? await ref.getDocuments() : ref.limit(limit).getDocuments();
      if (snapshot.documents.isNotEmpty) {
           return snapshot.documents.map((document) {
              document.data["documentID"] = document.documentID;
              return document.data;
           });
      }
      return null;
  }
 
  Future<List<Map<String, dynamic>>> getAll<T>() async {
    //TODO MAVHA error handling
    QuerySnapshot snapshot = await ref.getDocuments();
    if (snapshot.documents.isNotEmpty) {
      return snapshot.documents.map((snapshot) => snapshot.data).toList();
    }
    return null;
  }

  Stream<List<Map<String, dynamic>>> stream() {  //TODO MAVHA error handling
      return ref.snapshots().map((query){ 
          if (query.documents.isNotEmpty) {
              return query.documents.map((document) {
                document.data["documentID"] = document.documentID;
                return document.data;
              });
          } else {
              return null;
          }
      });
  }
 
  Future<Map<String, dynamic>> getById(String id) async{ //TODO MAVHA error handling
      DocumentSnapshot document = await ref.document(id).get();
      if (document.exists) {
        document.data["documentID"] = document.documentID;
        return document.data;
      }
      return null;
  }

    Future<Map<String, dynamic>> getByInnerId(String id) async{ //TODO MAVHA error handling
      var document = (await ref.where('id', isEqualTo: id).getDocuments()).documents.first;
      if (document.exists) {
        document.data["documentID"] = document.documentID;
        return document.data;
      }
      return null;
  }

  Future<String> add(data) async{  //TODO MAVHA error handling
     var docRef = await ref.add(data.toJson());
     return docRef.documentID;
  }
  
  Future setData(data, String id, {bool merge = false}) async{ 
     ref.document(id).setData(data.toJson(), merge: merge);
  }

  Future update(data, String id) async { //TODO MAVHA error handling
     ref.document(id).updateData(data.toJson()) ;
  } 

  Future delete(String id) async{ //TODO MAVHA error handling
     ref.document(id).delete();
  }
}