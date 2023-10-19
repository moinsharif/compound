import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:compound/core/base/base_service.dart';
import 'package:compound/core/services/authentication/authentication_service.dart';
import 'package:compound/core/services/generic_firestore/generic_firestore.dart';
import 'package:compound/locator.dart';
import 'package:compound/shared_models/employee_detail_model.dart';
import 'package:compound/shared_models/employee_model.dart';
import 'package:compound/shared_models/user_model.dart';
import 'package:flutter/foundation.dart';

class EmployeesService extends BaseService {
  static const String DatabaseRef = "users";

  List<List<EmployeeDetailModel>> _allPagedResults = [];
  StreamController<List<EmployeeDetailModel>> _pageController;
  final CollectionReference _collectionReference =
      GenericFirestoreService.db.collection(DatabaseRef);
  final AuthenticationService _authenticationService =
      locator<AuthenticationService>();

  DocumentSnapshot _lastDocument;
  bool _hasMoreData = true;

  Future<String> assignProperty(
      String idEmployee, String idProperty, String market) async {
    var document = await GenericFirestoreService.db
        .collection("employees")
        .document(idEmployee)
        .get();
    if (document.exists) {
      var model = document.data;
      if (model['properties'] == null) {
        model['properties'] = [idProperty];
      } else if (!model['properties'].contains(idProperty)) {
        model['properties'].add(idProperty);
        if (model['markers'] == null) {
          model['markers'] = [market];
        } else if (!model['markers'].contains(market)) {
          model['markers'].add(market);
        }
      } else {
        return "Property already assigned to this porter";
      }
      await GenericFirestoreService.db
          .collection("employees")
          .document(idEmployee)
          .setData(model, merge: true);
      return "success";
    }

    return "The selected porter does not exist";
  }

  Future<String> assignPropertyByPorters(
      List<String> idEmployee, String idProperty, String market) async {
    var document = await GenericFirestoreService.db
        .collection("employees")
        .where('id', whereIn: idEmployee)
        .getDocuments();
    if (document.documents.isNotEmpty) {
      var batch = GenericFirestoreService.db.batch();
      await Future.forEach(document.documents, (model) {
        dynamic obj = model.data;
        if (obj['properties'] == null) {
          obj['properties'] = [idProperty];
        } else if (!obj['properties'].contains(idProperty)) {
          obj['properties'] = [...obj['properties'], idProperty];
          if (obj['markers'] == null) {
            obj['markers'] = [market];
          } else if (!obj['markers'].contains(market)) {
            obj['markers'] = [...obj['markers'], market];
          }
        } else {
          return "Property already assigned to this porter";
        }
        var docRef = GenericFirestoreService.db
            .collection('employees')
            .document(obj['id']);
        batch.setData(docRef, obj);
      });
      await batch.commit();
      return 'success';
    } else {
      return null;
    }
  }

  Future<String> assignTemporalPropertyByPorters(
      List<String> idEmployee, String idProperty, String market) async {
    var document = await GenericFirestoreService.db
        .collection("employees")
        .where('id', whereIn: idEmployee)
        .getDocuments();
    if (document.documents.isNotEmpty) {
      var batch = GenericFirestoreService.db.batch();
      await Future.forEach(document.documents, (model) {
        dynamic obj = model.data;
        if (obj['temporalProperties'] == null) {
          obj['temporalProperties'] = [idProperty];
        } else if (!obj['temporalProperties'].contains(idProperty)) {
          obj['temporalProperties'] = [
            ...obj['temporalProperties'],
            idProperty
          ];
          if (obj['markers'] == null) {
            obj['markers'] = [market];
          } else if (!obj['markers'].contains(market)) {
            obj['markers'] = [...obj['markers'], market];
          }
        } else {
          return "Property already assigned to this porter";
        }
        var docRef = GenericFirestoreService.db
            .collection('employees')
            .document(obj['id']);
        batch.setData(docRef, obj);
      });
      await batch.commit();
      return 'success';
    } else {
      return null;
    }
  }

  Future<String> removePropertyByPorters(
      List<String> idEmployee, String idProperty) async {
    var document = await GenericFirestoreService.db
        .collection("employees")
        .where('id', whereIn: idEmployee)
        .getDocuments();
    if (document.documents.isNotEmpty) {
      var batch = GenericFirestoreService.db.batch();
      await Future.forEach(document.documents, (model) {
        dynamic obj = model.data;
        if (obj['properties'].contains(idProperty)) {
          obj['properties'].removeWhere((element) => element == idProperty);
        } else {
          return "Property isn't assigned to this porter";
        }
        var docRef = GenericFirestoreService.db
            .collection('employees')
            .document(obj['id']);
        batch.setData(docRef, obj);
      });
      await batch.commit();
      return 'success';
    } else {
      return null;
    }
  }

  Future<String> updateEmployee(EmployeeModel employee) async {
    try {
      await GenericFirestoreService.db
          .collection("employees")
          .document(employee.id)
          .updateData(employee.toJson());
      return 'success';
    } catch (e) {
      return null;
    }
  }

  void updateEmployeeTransact(EmployeeModel employee, WriteBatch batch) async {
      batch.updateData(GenericFirestoreService.db
          .collection("employees")
          .document(employee.id),
          employee.toJson());
  }

  Future<void> editWage(String idEmployee, Map<String, dynamic> wage) async {
    try {
      return await GenericFirestoreService.db
          .collection("users")
          .document(idEmployee)
          .setData({'wage': wage}, merge: true);
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future<List<EmployeeDetailModel>> getUsers(bool isEmployee) async {
    try {
      Query _collectionReference = GenericFirestoreService.db
          .collection(DatabaseRef)
          //.where("active", isEqualTo: true)
          .where("isEmployee", isEqualTo: isEmployee);
      var snapshot = await _collectionReference.getDocuments();
      if (snapshot.documents.isNotEmpty) {
        var data = snapshot.documents.map((snapshot) {
          var data = snapshot.data;
          return EmployeeDetailModel.fromData(data, id: snapshot.documentID);
        }).toList();
        return data;
      } else {
        return [];
      }
    } catch (e) {
      return [];
    }
  }

  Future<List<EmployeeDetailModel>> getEmployeesAll(
      {bool isEmployee = true}) async {
    try {
      Query _collectionReference = GenericFirestoreService.db
          .collection(DatabaseRef)
          .where("active", isEqualTo: true)
          .orderBy('lastName', descending: false);
      if (isEmployee) {
        _collectionReference =
            _collectionReference.where("isEmployee", isEqualTo: true);
      }
      var snapshot = await _collectionReference.getDocuments();
      if (snapshot.documents.isNotEmpty) {
        var data = snapshot.documents.map((snapshot) {
          var data = snapshot.data;
          return EmployeeDetailModel.fromData(data, id: snapshot.documentID);
        }).toList();
        return data;
      } else {
        return [];
      }
    } catch (e) {
      return [];
    }
  }

  Future<List<EmployeeDetailModel>> getEmployeesAndAdmins() async {
    try {
      Query _collectionReference = GenericFirestoreService.db
          .collection(DatabaseRef)
          .where("active", isEqualTo: true)
          .orderBy('lastName', descending: false);
      var snapshot = await _collectionReference.getDocuments();
      if (snapshot.documents.isNotEmpty) {
        var data = snapshot.documents.map((snapshot) {
          var data = snapshot.data;
          return EmployeeDetailModel.fromData(data, id: snapshot.documentID);
        }).toList();
        return data;
      } else {
        return [];
      }
    } catch (e) {
      return [];
    }
  }

  Future<List<User>> getEmployeesAllLikeUser({bool active = true}) async {
    try {
      Query _collectionReference = GenericFirestoreService.db
          .collection(DatabaseRef)
          .orderBy('lastName', descending: false);
      if (_authenticationService.currentRole.key !=
          describeEnum(TYPEROLE.super_admin)) {
        _collectionReference.where("isEmployee", isEqualTo: true);
      }
      if (active == true) {
        _collectionReference =
            _collectionReference.where("active", isEqualTo: true);
      }
      var snapshot = await _collectionReference.getDocuments();
      if (snapshot.documents.isNotEmpty) {
        var data = snapshot.documents.map((snapshot) {
          var data = snapshot.data;
          return User.fromData(data);
        }).toList();
        return data;
      } else {
        return [];
      }
    } catch (e) {
      return [];
    }
  }

  Future<List<User>> getEmployeesAllLikeUserMessages() async {
    try {
      Query _collectionReference = GenericFirestoreService.db
          .collection(DatabaseRef)
          .orderBy('lastName', descending: false)
          .where("active", isEqualTo: true);
      var snapshot = await _collectionReference.getDocuments();
      if (snapshot.documents.isNotEmpty) {
        var data = snapshot.documents.map((snapshot) {
          var data = snapshot.data;
          return User.fromData(data);
        }).toList();
        return data;
      } else {
        return [];
      }
    } catch (e) {
      return [];
    }
  }

  Stream startStream({limit, tag}) {
    if (_pageController != null && !_pageController.isClosed)
      _pageController.close();

    _pageController = StreamController<List<EmployeeDetailModel>>.broadcast();
    _lastDocument = null;
    _allPagedResults.clear();
    _hasMoreData = true;
    fetchPage(limit: limit, tag: tag);
    return _pageController.stream;
  }

  void dispose() {
    if (_pageController != null && !_pageController.isClosed)
      _pageController.close();
  }

  void fetchPage({limit, tag}) async {
    var query = _collectionReference
        .where("active", isEqualTo: true)
        .where("isEmployee", isEqualTo: true)
        .orderBy('lastName', descending: false)
        .limit(limit);

    if (_lastDocument != null) {
      query = query.startAfterDocument(_lastDocument);
    }

    if (!_hasMoreData) return;

    var currentRequestIndex = _allPagedResults.length;

    var snapshot = await query.getDocuments();
    if (snapshot.documents.isNotEmpty) {
      var articles = snapshot.documents.map((snapshot) {
        var data = snapshot.data;
        return EmployeeDetailModel.fromData(data, id: snapshot.documentID);
      }).toList();

      var pageExists = currentRequestIndex < _allPagedResults.length;
      if (pageExists) {
        _allPagedResults[currentRequestIndex] = articles;
      } else {
        _allPagedResults.add(articles);
      }

      if (_pageController.isClosed) return;

      _pageController.add(articles);

      if (currentRequestIndex == _allPagedResults.length - 1) {
        _lastDocument = snapshot.documents.last;
      }

      _hasMoreData = articles.length == limit;
    } else {
      if (!_pageController.isClosed) _pageController.add([]);
    }
  }
}
