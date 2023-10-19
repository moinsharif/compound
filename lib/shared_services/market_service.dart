import 'package:compound/core/base/base_service.dart';
import 'package:compound/shared_models/market_model.dart';
import 'package:compound/core/services/generic_firestore/generic_firestore.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MarketService extends BaseService {
  static const String DatabaseRef = "markets";

  Future<List<MarketModel>> getMarkets(List<String> markets) async {
    Query _collectionReference = GenericFirestoreService.db
        .collection(DatabaseRef)
        .where('id', whereIn: markets);
    var snapshot = await _collectionReference.getDocuments();
    if (snapshot.documents.isNotEmpty) {
      var data = snapshot.documents.map((snapshot) {
        var data = snapshot.data;
        return MarketModel.fromData(data);
      }).toList();

      return data;
    } else {
      return [];
    }
  }

  Future<List<MarketModel>> getAllMarkets() async {
    Query _collectionReference =
        GenericFirestoreService.db.collection(DatabaseRef);
    var snapShot = await _collectionReference.getDocuments();
    if (snapShot.documents.isNotEmpty) {
      var data = snapShot.documents.map((snapShot) {
        return MarketModel.fromData(snapShot.data);
      }).toList();
      return data;
    } else {
      return [];
    }
  }

  Future<List<MarketModel>> getMarketsByIds(List<String> markets) async {
    try {
      List<List<String>> subList = [];
      List<MarketModel> response = [];
      for (var i = 0; i < markets.length; i += 10) {
        subList.add(markets.sublist(
            i, i + 10 > markets.length ? markets.length : i + 10));
      }
      await Future.forEach(subList, (element) async {
        Query _collectionReference = GenericFirestoreService.db
            .collection(DatabaseRef)
            .where('id', whereIn: element);
        var snapshot = await _collectionReference.getDocuments();
        if (snapshot.documents.isNotEmpty) {
          response = [
            ...response,
            ...snapshot.documents.map((snapshot) {
              var data = snapshot.data;
              return MarketModel.fromData(data);
            }).toList()
          ];
        }
      });
      return response;
    } catch (e) {
      return [];
    }
  }

  Future<bool> setMarkets(List<MarketModel> markets) async {
    try {
      var batch = GenericFirestoreService.db.batch();
      await Future.forEach(markets, (MarketModel doc) async {
        var docRef = GenericFirestoreService.db
            .collection(DatabaseRef)
            .document(doc.id.toString());
        batch.setData(docRef, doc.toJson());
      });
      batch.commit();
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> removeMarkets(List<MarketModel> markets) async {
    try {
      var batch = GenericFirestoreService.db.batch();
      await Future.forEach(markets, (MarketModel doc) async {
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
}
