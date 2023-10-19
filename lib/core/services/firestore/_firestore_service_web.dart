import 'dart:async';

import 'package:compound/core/services/firestore/firestore_service_intf.dart';
import 'package:firebase/firebase.dart' as fb;
import 'package:firebase/firestore.dart' as fs;

import 'package:compound/shared_models/user_model.dart';
import 'package:flutter/services.dart';

class FirestoreService implements FirestoreServiceIntf {
  fs.Firestore store = fb.firestore();

  fs.CollectionReference _usersCollectionReference;

  FirestoreService() {
    this._usersCollectionReference = store.collection('users');
  }

  fs.DocumentSnapshot _lastDocument;
  bool _hasMorePosts = true;

  Future createUser(User user) async {
    try {
      await _usersCollectionReference.doc(user.id).set(user.toJson());
    } catch (e) {
      // TODO: Find or create a way to repeat error handling without so much repeated code
      if (e is PlatformException) {
        return e.message;
      }

      return e.toString();
    }
  }

  // Future updateUser(User user) async {
  //   try {
  //     await _usersCollectionReference.doc(user.id).update(data: user.toJson());
  //   } catch (e) {
  //     // TODO: Find or create a way to repeat error handling without so much repeated code
  //     if (e is PlatformException) {
  //       return e.message;
  //     }

  //     return e.toString();
  //   }
  // }

  Future getUser(String uid) async {
    try {
      var userData = await _usersCollectionReference.doc(uid).get();
      if (userData.data == null) {
        return null;
      }

      return User.fromData(userData.data());
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
      await this
          ._usersCollectionReference
          .doc(user.id)
          .update(data: user.toJson());
    } catch (e) {
      // TODO: Find or create a way to repeat error handling without so much repeated code
      if (e is PlatformException) {
        return e.message;
      }

      return e.toString();
    }
  }
}
