import 'package:compound/core/base/base_service.dart';
import 'package:compound/shared_models/watchlist_model.dart';
import 'package:compound/core/services/generic_firestore/generic_firestore.dart';
import 'package:compound/utils/timestamp_util.dart';

class WatchlistService extends BaseService {
  static const String DatabaseRef = "watchlist";

  Future<List<WatchlistModel>> getWatchlist(
      {WrappedDate start,
      WrappedDate end,
      String porterId,
      String propertyId}) async {
    var query = GenericFirestoreService.db
        .collection(DatabaseRef)
        .orderBy('date', descending: true);
    if (start != null) {
      query = query.where('date', isGreaterThanOrEqualTo: start.utc());
    }
    if (end != null) {
      query = query.where('date', isLessThanOrEqualTo: end.utc());
    }
    if (porterId != null) {
      query = query.where('porterId', isEqualTo: porterId);
    }
    if (propertyId != null) {
      query = query.where('propertyId', isEqualTo: propertyId);
    }
    var snapshot = await query.getDocuments();
    if (snapshot.documents.isNotEmpty) {
      var data = snapshot.documents.map((snapshot) {
        var data = snapshot.data;
        return WatchlistModel.fromJson(data);
      }).toList();
      return data;
    } else {
      return [];
    }
  }

  Future<List<WatchlistModel>> getWatchlistCompleted(
      {WrappedDate start,
      WrappedDate end,
      String porterId,
      String propertyId}) async {
    var query = GenericFirestoreService.db
        .collection(DatabaseRef)
        .orderBy('date', descending: true);
    if (start != null) {
      query = query.where('date', isGreaterThanOrEqualTo: start.utc());
    }
    if (end != null) {
      query = query.where('date', isLessThanOrEqualTo: end.utc());
    }
    if (porterId != null) {
      query = query.where('porterId', isEqualTo: porterId);
    }
    if (propertyId != null) {
      query = query.where('propertyId', isEqualTo: propertyId);
    }
    query = query.where('status', isEqualTo: 'completed');
    var snapshot = await query.getDocuments();
    if (snapshot.documents.isNotEmpty) {
      var data = snapshot.documents.map((snapshot) {
        var data = snapshot.data;
        return WatchlistModel.fromJson(data);
      }).toList();
      return data;
    } else {
      return [];
    }
  }

  Future<bool> removeWatchlist(List<WatchlistModel> watchlist) async {
    try {
      var batch = GenericFirestoreService.db.batch();
      await Future.forEach(watchlist, (WatchlistModel doc) async {
        var docRef = GenericFirestoreService.db
            .collection(DatabaseRef)
            .document(doc.id.toString());
        batch.delete(docRef);
      });
      batch.commit();
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> addWatchlist(List<WatchlistModel> watchlist) async {
    try {
      var batch = GenericFirestoreService.db.batch();
      await Future.forEach(watchlist, (WatchlistModel doc) async {
        var document =
            GenericFirestoreService.db.collection(DatabaseRef).document();
        doc.id = document.documentID;
        var docRef = GenericFirestoreService.db
            .collection(DatabaseRef)
            .document(document.documentID);
        batch.setData(docRef, doc.toJson());
      });
      batch.commit();
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<String> updateWatchlist(WatchlistModel watchlist) async {
    try {
      await GenericFirestoreService.db
          .collection(DatabaseRef)
          .document(watchlist.id)
          .updateData(watchlist.toJson());
      return 'success';
    } catch (e) {
      return null;
    }
  }
}
