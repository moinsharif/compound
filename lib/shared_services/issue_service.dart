import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:compound/core/base/base_service.dart';
import 'package:compound/core/services/generic_firestore/generic_firestore.dart';
import 'package:compound/shared_models/issue_model.dart';

class IssueService extends BaseService {
  static const String DatabaseRef = 'issues';
  DocumentSnapshot nextDocumentSnapshot;
  DocumentSnapshot prevDocumentSnapshot;
  List<DocumentSnapshot> prevDocumentSnapshotList = [];

  addIssue(Map<String, dynamic> data) async {
    try {
      var doc =
          await GenericFirestoreService.db.collection(DatabaseRef).add(data);
      return doc.documentID;
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future<List<IssueModel>> getPaginatedIssues(
      {int itemsPerPage = 6, bool next = true}) async {
    try {
      List<IssueModel> _issuesAux = [];
      // NEXT PAGE
      if (next && nextDocumentSnapshot != null) {
        Query _collectionReference = GenericFirestoreService.db
            .collection(DatabaseRef)
            .orderBy('createdAt', descending: true)
            .startAfterDocument(nextDocumentSnapshot)
            .limit(itemsPerPage);
        var snapshot = await _collectionReference.getDocuments();
        prevDocumentSnapshotList.add(prevDocumentSnapshot);
        nextDocumentSnapshot =
            snapshot.documents[snapshot.documents.length - 1];
        prevDocumentSnapshot = snapshot.documents[0];
        snapshot.documents.map((snapshot) {
          _issuesAux.add(IssueModel.fromData(snapshot.data)
              .copyWith(id: snapshot.documentID));
        }).toList();
        // PREV PAGE
      } else if (!next && prevDocumentSnapshot != null) {
        DocumentSnapshot _prev = prevDocumentSnapshotList.removeLast();
        Query _q = GenericFirestoreService.db
            .collection(DatabaseRef)
            .orderBy('createdAt', descending: true)
            .startAtDocument(_prev)
            .limit(itemsPerPage);
        QuerySnapshot _querySnapshot = await _q.getDocuments();
        nextDocumentSnapshot =
            _querySnapshot.documents[_querySnapshot.documents.length - 1];
        prevDocumentSnapshot = _querySnapshot.documents[0];
        _querySnapshot.documents.map((snapshot) {
          _issuesAux.add(IssueModel.fromData(snapshot.data)
              .copyWith(id: snapshot.documentID));
        }).toList();
        // FIRST LOAD
      } else {
        Query _collectionReference = GenericFirestoreService.db
            .collection(DatabaseRef)
            .orderBy('createdAt', descending: true)
            .limit(itemsPerPage);
        var snapshot = await _collectionReference.getDocuments();
        nextDocumentSnapshot =
            snapshot.documents[snapshot.documents.length - 1];
        prevDocumentSnapshot = snapshot.documents[0];
        if (snapshot.documents.isNotEmpty) {
          snapshot.documents.map((snapshot) {
            _issuesAux.add(IssueModel.fromData(snapshot.data)
                .copyWith(id: snapshot.documentID));
          }).toList();
        }
      }
      return _issuesAux;
    } catch (e) {
      print(e);
      return [];
    }
  }
}
