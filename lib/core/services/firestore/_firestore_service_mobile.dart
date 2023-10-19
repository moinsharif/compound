import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:compound/shared_models/user_model.dart';
import 'package:compound/core/services/firestore/firestore_service_intf.dart';
import 'package:flutter/services.dart';

class FirestoreService implements FirestoreServiceIntf {
  final CollectionReference _usersCollectionReference =
      Firestore.instance.collection('users');

  Future createUser(User user) async {
    try {
      await _usersCollectionReference.document(user.id).setData(user.toJson());
    } catch (e) {
      // TODO: Find or create a way to repeat error handling without so much repeated code
      if (e is PlatformException) {
        return e.message;
      }

      return e.toString();
    }
  }

  Future getUser(String uid) async {
    try {
      var userData = await _usersCollectionReference.document(uid).get();
      if (userData.data == null) {
        return null;
      }

      return User.fromData(userData.data);
    } catch (e) {
      // TODO: Find or create a way to repeat error handling without so much repeated code
      if (e is PlatformException) {
        return e.message;
      }

      return e.toString();
    }
  }

  Future updateUser(User user) async {
    try {
      await _usersCollectionReference
          .document(user.id)
          .updateData(user.toJson());
    } catch (e) {
      // TODO: Find or create a way to repeat error handling without so much repeated code
      if (e is PlatformException) {
        return e.message;
      }

      return e.toString();
    }
  }
}
