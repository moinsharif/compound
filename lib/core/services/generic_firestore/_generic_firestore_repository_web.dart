import 'package:firebase/firebase.dart' as fb;
import 'package:firebase/firestore.dart' as fs;
import 'package:firebase/firestore.dart';

class GenericFirestoreRepository {

  fs.Firestore _db = fb.firestore();
  final String path;
  fs.CollectionReference ref;

  GenericFirestoreRepository(this.path) {
    ref = _db.collection(path);
  }

 Future<List<Map<String, dynamic>>> list<T>({limit : int}) async { //TODO MAVHA error handling
      fs.QuerySnapshot snapshot = limit == null? await ref.get() : ref.limit(limit).get();
      if (snapshot.docs.isNotEmpty) {
           return snapshot.docs.map((document) {
              var data = document.data();
              data["documentID"] = document.id;
              return data;
           });
      }
      return null;
  }
  
  Future<List<Map<String, dynamic>>> getAll<T>() async {
    //TODO MAVHA error handling
    QuerySnapshot snapshot = await ref.get();
    if (snapshot.docs.isNotEmpty) {
      return snapshot.docs.map((document) => document.data()).toList();
    }
    return null;
  }
 
  Stream<List<Map<String, dynamic>>> stream() {  //TODO MAVHA error handling
      return ref.onSnapshot.map((query){ 
          if (query.docs.isNotEmpty) {
              return query.docs.map((document) {
                    var data = document.data();
                    data["documentID"] = document.id;
                    return data;
              });
          } else {
              return null;
          }
      });
  }
 
  Future<Map<String, dynamic>> getById(String id) async{ //TODO MAVHA error handling
      fs.DocumentSnapshot document = await ref.doc().get();
      if (document.exists) {
        var data = document.data();
        data["documentID"] = document.id;
        return data;
      }
      return null;
  }

  Future<String> add(data) async{  //TODO MAVHA error handling
     var docRef = await ref.add(data.toJson());
     return docRef.id;
  }
    
  Future setData(data, String id, {bool merge = false}) async{ 
    await ref.doc(id).set(data.toJson(), SetOptions(merge: merge)) ;
  }

  Future update(data, String id) async { //TODO MAVHA error handling
    await ref.doc(id).update(data: data.toJson()) ;
  }

  Future delete(String id) async{ //TODO MAVHA error handling
      await ref.doc(id).delete();
  }
}