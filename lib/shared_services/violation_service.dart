import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:compound/core/base/base_service.dart';
import 'package:compound/locator.dart';
import 'package:compound/shared_models/property_model.dart';
import 'package:compound/shared_models/violation_model.dart';
import 'package:compound/core/services/generic_firestore/generic_firestore.dart';
import 'package:compound/shared_services/property_service.dart';
import 'package:compound/utils/timestamp_util.dart';

class ViolationService extends BaseService {
  final PropertyService _propertyService = locator<PropertyService>();
  static const String DatabaseRef = "violations";
  static int _itemsPerPage = 10;
  DocumentSnapshot _lastDocument;
  bool _gettingMore = false;
  bool _moreToFetch = true;

  void defaultValues() {
    _lastDocument = null;
    _gettingMore = false;
    _moreToFetch = true;
  }

  Future<List<ViolationModel>> getFirstViolations(
      {WrappedDate start, WrappedDate end, String propertyId}) async {
    try {
      defaultValues();
      Query query = GenericFirestoreService.db
          .collection(DatabaseRef)
          .orderBy('createdAt', descending: true)
          .limit(_itemsPerPage);
      if (start != null) {
        query = query.where('createdAt', isGreaterThanOrEqualTo: start.utc());
      }
      if (end != null) {
        query = query.where('createdAt', isLessThanOrEqualTo: end.utc());
      }
      if (propertyId != null) {
        query = query.where('propertyId', isEqualTo: propertyId);
      }
      QuerySnapshot snapshot = await query.getDocuments();
      if (snapshot.documents.isNotEmpty) {
        _lastDocument = snapshot.documents.last;
        List<PropertyModel> properties = [];
        var data = await Future.wait(snapshot.documents.map((snapshot) async {
          var data = snapshot.data;
          ViolationModel violation = ViolationModel.fromJson(data);
          PropertyModel property = properties.firstWhere(
            (e) => e.id == data['propertyId'],
            orElse: () => null,
          );
          if (property != null) {
            violation.property = property;
            return violation;
          }
          property = await _propertyService.getProperty(data['propertyId']);
          violation.property = property;
          return violation;
        }).toList());
        return data;
      }
      return [];
    } catch (e) {
      return [];
    }
  }

  Future<List<ViolationModel>> getMoreViolations(
      {WrappedDate start, WrappedDate end, String propertyId}) async {
    try {
      if (!_moreToFetch) {
        return [];
      }

      if (_gettingMore) {
        return [];
      }
      _gettingMore = true;
      Query query = GenericFirestoreService.db
          .collection(DatabaseRef)
          .orderBy('createdAt', descending: true)
          .startAfterDocument(_lastDocument)
          .limit(_itemsPerPage);
      if (start != null) {
        query = query.where('createdAt', isGreaterThanOrEqualTo: start.utc());
      }
      if (end != null) {
        query = query.where('createdAt', isLessThanOrEqualTo: end.utc());
      }
      if (propertyId != null) {
        query = query.where('propertyId', isEqualTo: propertyId);
      }
      QuerySnapshot snapshot = await query.getDocuments();
      if (snapshot.documents.isNotEmpty) {
        _lastDocument = snapshot.documents.last;
        if (snapshot.documents.length < _itemsPerPage) {
          _moreToFetch = false;
        }
        _gettingMore = false;
        List<PropertyModel> properties = [];
        var data = await Future.wait(snapshot.documents.map((snapshot) async {
          var data = snapshot.data;
          ViolationModel violation = ViolationModel.fromJson(data);
          PropertyModel property = properties.firstWhere(
            (e) => e.id == data['propertyId'],
            orElse: () => null,
          );
          if (property != null) {
            violation.property = property;
            return violation;
          }
          property = await _propertyService.getProperty(data['propertyId']);
          violation.property = property;
          return violation;
        }).toList());
        return data;
      }
      return [];
    } catch (e) {
      return [];
    }
  }

  Future<void> sendReport(List<String> ids) async {
    try {
      final HttpsCallable callable = CloudFunctions.instance
          .getHttpsCallable(functionName: 'sendViolationsReport')
        ..timeout = const Duration(seconds: 30);

      var callData = {"violationsIds": ids};
      await callable.call(callData);
      await setReportInViolation(ids);
    } catch (e) {}
  }

  Future<void> sendReportWatchlist(List<String> ids) async {
    try {
      final HttpsCallable callable = CloudFunctions.instance
          .getHttpsCallable(functionName: 'sendWatchlistReport')
        ..timeout = const Duration(seconds: 30);

      var callData = {"watchlistIds": ids};
      await callable.call(callData);
    } catch (e) {}
  }

  Future<bool> setReportInViolation(List<String> ids) async {
    try {
      var batch = GenericFirestoreService.db.batch();
      await Future.forEach(ids, (String doc) async {
        var docRef =
            GenericFirestoreService.db.collection(DatabaseRef).document(doc);
        batch.updateData(docRef, {'reportWasGenerated': true});
      });
      batch.commit();
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<String> setViolation(ViolationModel violation) async {
    try {
      await GenericFirestoreService.db
          .collection(DatabaseRef)
          .document(violation.id)
          .setData(violation.toJson());
      return 'success';
    } catch (e) {
      return null;
    }
  }

  void setViolationTransact(ViolationModel entity, WriteBatch batch) async {
    batch.setData(
        GenericFirestoreService.db.collection(DatabaseRef).document(entity.id),
        entity.toJson());
  }

  Future<List<ViolationModel>> getLastFiveViolations() async {
    try {
      var snapshot = await GenericFirestoreService.db
          .collection(DatabaseRef)
          .where('propertyId')
          .orderBy('createdAt', descending: true)
          .limit(5)
          .getDocuments();
      if (snapshot.documents.isNotEmpty) {
        List<PropertyModel> properties = [];
        var data = await Future.wait(snapshot.documents.map((snapshot) async {
          var data = snapshot.data;
          ViolationModel violation = ViolationModel.fromJson(data);
          PropertyModel property = properties.firstWhere(
            (e) => e.id == data['propertyId'],
            orElse: () => null,
          );
          if (property != null) {
            violation.property = property;
            return violation;
          }
          property = await _propertyService.getProperty(data['propertyId']);
          violation.property = property;
          return violation;
        }).toList());
        return data;
      }
      return [];
    } catch (e) {
      return [];
    }
  }

  Future<List<ViolationModel>> getViolations(
      {WrappedDate start, WrappedDate end, String propertyId}) async {
    try {
      var query = GenericFirestoreService.db
          .collection(DatabaseRef)
          .orderBy('createdAt', descending: true);
      if (start != null) {
        query = query.where('createdAt', isGreaterThanOrEqualTo: start.utc());
      }
      if (end != null) {
        query = query.where('createdAt', isLessThanOrEqualTo: end.utc());
      }
      if (propertyId != null) {
        query = query.where('propertyId', isEqualTo: propertyId);
      }
      var snapshot = await query.getDocuments();
      if (snapshot.documents.isNotEmpty) {
        List<PropertyModel> properties = [];
        var data = await Future.wait(snapshot.documents.map((snapshot) async {
          var data = snapshot.data;
          ViolationModel violation = ViolationModel.fromJson(data);
          PropertyModel property = properties.firstWhere(
            (e) => e.id == data['propertyId'],
            orElse: () => null,
          );
          if (property != null) {
            violation.property = property;
            return violation;
          }
          property = await _propertyService.getProperty(data['propertyId']);
          violation.property = property;
          return violation;
        }).toList());
        return data;
      }
      return [];
    } catch (e) {
      return [];
    }
  }

  Future<List<ViolationModel>> getViolationsById(String propertyId) async {
    try {
      var snapshot = await GenericFirestoreService.db
          .collection(DatabaseRef)
          .where('propertyId', isEqualTo: propertyId)
          .orderBy('createdAt', descending: true)
          .getDocuments();
      if (snapshot.documents.isNotEmpty) {
        List<PropertyModel> properties = [];
        var data = await Future.wait(snapshot.documents.map((snapshot) async {
          var data = snapshot.data;
          ViolationModel violation = ViolationModel.fromJson(data);
          PropertyModel property = properties.firstWhere(
            (e) => e.id == data['propertyId'],
            orElse: () => null,
          );
          if (property != null) {
            violation.property = property;
            return violation;
          }
          property = await _propertyService.getProperty(data['propertyId']);
          violation.property = property;
          return violation;
        }).toList());
        return data;
      }
      return [];
    } catch (e) {
      return [];
    }
  }

  Future<List<ViolationModel>> getViolationsByChackInId(
      String checkInId) async {
    try {
      var snapshot = await GenericFirestoreService.db
          .collection(DatabaseRef)
          .where('checkInId', isEqualTo: checkInId)
          .orderBy('createdAt', descending: true)
          .getDocuments();
      if (snapshot.documents.isNotEmpty) {
        List<PropertyModel> properties = [];
        var data = await Future.wait(snapshot.documents.map((snapshot) async {
          var data = snapshot.data;
          ViolationModel violation = ViolationModel.fromJson(data);
          PropertyModel property = properties.firstWhere(
            (e) => e.id == data['propertyId'],
            orElse: () => null,
          );
          if (property != null) {
            violation.property = property;
            return violation;
          }
          property = await _propertyService.getProperty(data['propertyId']);
          violation.property = property;
          return violation;
        }).toList());
        return data;
      }
      return [];
    } catch (e) {
      return [];
    }
  }

  Future<bool> checkViolationsByCheckInId(String checkInId) async {
    try {
      var snapshot = await GenericFirestoreService.db
          .collection(DatabaseRef)
          .where('checkInId', isEqualTo: checkInId)
          .orderBy('createdAt', descending: true)
          .limit(1)
          .getDocuments();
      if (snapshot.documents.isNotEmpty) {
        return true;
      }
      return false;
    } catch (e, st) {
      handleException(e, "checkViolationsByCheckInId", st);
      throw e;
    }
  }
}
