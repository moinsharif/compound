import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:compound/core/base/base_service.dart';
import 'package:compound/core/services/generic_firestore/generic_firestore.dart';
import 'package:compound/shared_models/property_model.dart';
import 'package:intl/intl.dart';

class PropertyService extends BaseService {
  static const String DatabaseRef = "properties";
  DocumentSnapshot nextDocumentSnapshot;
  DocumentSnapshot prevDocumentSnapshot;
  List<DocumentSnapshot> prevDocumentSnapshotList = [];

  Future<PropertyModel> getProperty(String id) async {
    try {
      var porpertyData =
          await Firestore.instance.collection(DatabaseRef).document(id).get();
      if (porpertyData.data == null) {
        return null;
      }
      return PropertyModel.fromData(porpertyData.data,
          id: porpertyData.data["id"]);
    } catch (e, st) {
      handleException(e, "getProperty", st);
      return null;
    }
  }

  Future<String> updateProperty(
      String propertyId, Map<String, dynamic> payload) async {
    try {
      await Firestore.instance
          .collection(DatabaseRef)
          .document(propertyId)
          .updateData(payload);
      return 'success';
    } catch (e, st) {
      handleException(e, "updateProperty", st);
      return null;
    }
  }

  void updatePropertyTransact(PropertyModel model, WriteBatch batch) async {
    batch.updateData(
        GenericFirestoreService.db.collection(DatabaseRef).document(model.id),
        model.toJson());
  }

  Future<String> updatePropertyFlag(
      String propertyId, bool flagged, String text) async {
    try {
      await Firestore.instance
          .collection(DatabaseRef)
          .document(propertyId)
          .updateData({'flagged': flagged, 'specialInstructions': text});
      return 'success';
    } catch (e) {
      return null;
    }
  }

  Future<String> updateTextViolation(String violationId, String text) async {
    try {
      await Firestore.instance
          .collection('violations')
          .document(violationId)
          .updateData({'description': text});
      return 'success';
    } catch (e) {
      return null;
    }
  }

  Future<List<PropertyModel>> getProperties(List<String> properties) async {
    try {
      List<List<String>> subList = [];
      List<PropertyModel> response = [];
      for (var i = 0; i < properties.length; i += 10) {
        subList.add(properties.sublist(
            i, i + 10 > properties.length ? properties.length : i + 10));
      }
      String today = DateFormat('EEEE').format(DateTime.now());
      await Future.forEach(subList, (element) async {
        Query _collectionReference = GenericFirestoreService.db
            .collection(DatabaseRef)
            .where('active', isEqualTo: true)
            .where('id', whereIn: element);
        var snapshot = await _collectionReference.getDocuments();
        if (snapshot.documents.isNotEmpty) {
          response = [
            ...response,
            ...snapshot.documents.map((snapshot) {
              var data = snapshot.data;
              return PropertyModel.fromData(data, id: snapshot.documentID);
            }).toList()
          ];
          response.removeWhere((element) =>
              element.configProperty.daysSelected
                      .indexWhere((e) => e.nameDay == today) ==
                  -1 ||
              element.configProperty.end &&
                  DateTime.now()
                      .isAfter(element.configProperty.endDate.toDate()));
        }
      });
      return response;
    } catch (e) {
      return [];
    }
  }

  Future<List<PropertyModel>> getTemporalProperties(
      List<String> properties) async {
    try {
      DateTime today = DateTime.now();
      Query _collectionReference = GenericFirestoreService.db
          .collection(DatabaseRef)
          .where('id', whereIn: properties);
      var snapshot = await _collectionReference.getDocuments();
      if (snapshot.documents.isNotEmpty) {
        var data = snapshot.documents.map((snapshot) {
          var data = snapshot.data;
          return PropertyModel.fromData(data, id: snapshot.documentID);
        }).toList();
        data.removeWhere((e) =>
            e.configProperty.porters
                .where((element) => (element.temporary != null &&
                    element.temporary == true &&
                    element.temporaryDate.local().year == today.year &&
                    element.temporaryDate.local().month == today.month &&
                    element.temporaryDate.local().day == today.day))
                .length ==
            0);
        return data;
      } else {
        return [];
      }
    } catch (e) {
      return [];
    }
  }

  Future<List<PropertyModel>> getPropertiesByFilter(
      {String propertyId, DateTime date}) async {
    try {
      Query _collectionReference = GenericFirestoreService.db
          .collection(DatabaseRef)
          .where('active', isEqualTo: true);
      if (propertyId != null) {
        _collectionReference =
            _collectionReference.where('id', isEqualTo: propertyId.toString());
      }
      if (date != null) {
        _collectionReference = _collectionReference.where('createdAt',
            isGreaterThanOrEqualTo: date);
      }
      var snapshot = await _collectionReference.getDocuments();
      if (snapshot.documents.isNotEmpty) {
        var data = snapshot.documents.map((snapshot) {
          var data = snapshot.data;
          return PropertyModel.fromData(data, id: snapshot.documentID);
        }).toList();
        return data;
      } else {
        return [];
      }
    } catch (e) {
      return [];
    }
  }

  Future<List<PropertyModel>> getPropertiesAll(bool active) async {
    try {
      Query _collectionReference =
          GenericFirestoreService.db.collection(DatabaseRef);
      if (active != null && active) {
        _collectionReference =
            _collectionReference.where('active', isEqualTo: active);
      }
      var snapshot = await _collectionReference.getDocuments();
      if (snapshot.documents.isNotEmpty) {
        var data = snapshot.documents.map((snapshot) {
          var data = snapshot.data;
          return PropertyModel.fromData(data, id: snapshot.documentID);
        }).toList();
        data.sort((a, b) => a.propertyName.compareTo(b.propertyName));
        return data;
      } else {
        return [];
      }
    } catch (e) {
      return [];
    }
  }

  Future<List<PropertyModel>> getPropertiesActive() async {
    try {
      Query _collectionReference = GenericFirestoreService.db
          .collection(DatabaseRef)
          .where('active', isEqualTo: true);
      var snapshot = await _collectionReference.getDocuments();
      if (snapshot.documents.isNotEmpty) {
        var data = snapshot.documents.map((snapshot) {
          var data = snapshot.data;
          return PropertyModel.fromData(data, id: snapshot.documentID);
        }).toList();
        return data;
      } else {
        return [];
      }
    } catch (e) {
      return [];
    }
  }

  Future<List<PropertyModel>> getPropertiesBySchedule() async {
    try {
      Query _collectionReference = GenericFirestoreService.db
          .collection(DatabaseRef)
          .where('active', isEqualTo: true);
      var snapshot = await _collectionReference.getDocuments();
      if (snapshot.documents.isNotEmpty) {
        List<PropertyModel> listProperties = [];
        await Future.wait(snapshot.documents.map((snapshot) async {
          var snap =
              PropertyModel.fromData(snapshot.data, id: snapshot.documentID);
          if (!snap.configProperty.end &&
              snap.configProperty.daysSelected != null) {
            listProperties = [
              ...listProperties,
              PropertyModel.fromData(snap.toJson(), id: snapshot.documentID)
            ];
          } else if ((snap.configProperty.daysSelected != null &&
              snap.configProperty.end &&
              snap.configProperty.endDate
                  .toDate()
                  .isAfter(new DateTime.now()))) {
            listProperties = [
              ...listProperties,
              PropertyModel.fromData(snap.toJson(), id: snapshot.documentID)
            ];
          }
        }).toList());
        return listProperties;
      } else {
        return [];
      }
    } catch (e, st) {
      handleException(e, "getPropertiesBySchedule", st);
      return [];
    }
  }

  Future<List<PropertyModel>> getPropertiesByUnassigned() async {
    try {
      Query _collectionReference = GenericFirestoreService.db
          .collection(DatabaseRef)
          .where('active', isEqualTo: true);
      var snapshot = await _collectionReference.getDocuments();
      if (snapshot.documents.isNotEmpty) {
        List<PropertyModel> listProperties = [];
        await Future.wait(snapshot.documents.map((snapshot) async {
          var snap =
              PropertyModel.fromData(snapshot.data, id: snapshot.documentID);
          if (snap.configProperty.daysSelected == null ||
              snap.configProperty.end &&
                  snap.configProperty.endDate
                      .toDate()
                      .isBefore(new DateTime.now())) {
            listProperties = [
              ...listProperties,
              PropertyModel.fromData(snap.toJson(), id: snapshot.documentID)
            ];
          }
        }).toList());
        // data.removeWhere((element) => element != null);
        return listProperties;
      } else {
        return [];
      }
    } catch (e) {
      return [];
    }
  }

  Future<List<PropertyModel>> getPaginatedProperties(
      {int itemsPerPage = 4,
      bool next = true,
      String search = '',
      bool cleanPaginate = false,
      bool showInactiveProp = false}) async {
    try {
      if (cleanPaginate) {
        nextDocumentSnapshot = null;
        prevDocumentSnapshot = null;
        prevDocumentSnapshotList = [];
      }
      List<PropertyModel> _propertiesAux = [];
      // NEXT PAGE
      if (next && nextDocumentSnapshot != null) {
        Query _collectionReference = GenericFirestoreService.db
            .collection(DatabaseRef)
            .orderBy('propertyName', descending: false)
            .startAfterDocument(nextDocumentSnapshot)
            .limit(itemsPerPage);
        if (search != null && search != '') {
          if (search.length > 0) {
            search = capitalize(search);
          }
          _collectionReference = _collectionReference.where(
            'propertyName',
            isGreaterThanOrEqualTo: search,
            isLessThanOrEqualTo: search + '~',
          );
        }
        if (!showInactiveProp) {
          _collectionReference =
              _collectionReference.where('active', isEqualTo: true);
        }
        var snapshot = await _collectionReference.getDocuments();
        prevDocumentSnapshotList.add(prevDocumentSnapshot);
        nextDocumentSnapshot =
            snapshot.documents[snapshot.documents.length - 1];
        prevDocumentSnapshot = snapshot.documents[0];
        snapshot.documents.map((snapshot) {
          _propertiesAux.add(PropertyModel.fromData(snapshot.data)
              .copyWith(id: snapshot.documentID));
        }).toList();
        // PREV PAGE
      } else if (!next && prevDocumentSnapshot != null) {
        DocumentSnapshot _prev = prevDocumentSnapshotList.removeLast();
        Query _q = GenericFirestoreService.db
            .collection(DatabaseRef)
            .orderBy('propertyName', descending: false)
            .startAtDocument(_prev)
            .where('active', isEqualTo: showInactiveProp)
            .limit(itemsPerPage);
        if (search != null && search != '') {
          if (search != null && search != '') {
            if (search.length > 0) {
              search = capitalize(search);
            }
          }
          _q = _q.where('propertyName',
              isGreaterThanOrEqualTo: search, isLessThan: search + '~');
        }
        if (!showInactiveProp) {
          _q = _q.where('active', isEqualTo: true);
        }
        QuerySnapshot _querySnapshot = await _q.getDocuments();
        nextDocumentSnapshot =
            _querySnapshot.documents[_querySnapshot.documents.length - 1];
        prevDocumentSnapshot = _querySnapshot.documents[0];
        _querySnapshot.documents.map((snapshot) {
          _propertiesAux.add(PropertyModel.fromData(snapshot.data)
              .copyWith(id: snapshot.documentID));
        }).toList();
        // FIRST LOAD
      } else {
        Query _collectionReference = GenericFirestoreService.db
            .collection(DatabaseRef)
            .orderBy('propertyName', descending: false)
            .limit(itemsPerPage);
        if (search != null && search != '') {
          if (search.length > 0) {
            search = capitalize(search);
          }
          _collectionReference = _collectionReference.where(
            'propertyName',
            isGreaterThanOrEqualTo: search,
            isLessThanOrEqualTo: search + '~',
          );
        }
        if (!showInactiveProp) {
          _collectionReference =
              _collectionReference.where('active', isEqualTo: true);
        }
        var snapshot = await _collectionReference.getDocuments();
        nextDocumentSnapshot =
            snapshot.documents[snapshot.documents.length - 1];
        prevDocumentSnapshot = snapshot.documents[0];
        if (snapshot.documents.isNotEmpty) {
          snapshot.documents.map((snapshot) {
            _propertiesAux.add(PropertyModel.fromData(snapshot.data)
                .copyWith(id: snapshot.documentID));
          }).toList();
        }
      }
      return _propertiesAux;
    } catch (e) {
      print(e);
      return [];
    }
  }

  capitalize(String s) => s[0].toUpperCase() + s.substring(1);

  Future<String> addProperty(PropertyModel data) async {
    try {
      var doc = GenericFirestoreService.db.collection(DatabaseRef).document();
      await GenericFirestoreService.db
          .collection(DatabaseRef)
          .document(doc.documentID)
          .setData(data.copyWith(id: doc.documentID).toJson());
      return doc.documentID;
    } catch (e) {
      print(e);
      return null;
    }
  }
}
