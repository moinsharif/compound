import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:compound/core/exceptions/app_exception.dart';
import 'package:compound/core/services/generic_firestore/generic_firestore.dart';
import 'package:compound/shared_models/employee_model.dart';
import 'package:compound/shared_models/role_model.dart';
import 'package:compound/shared_models/user_model.dart';
import 'package:compound/utils/encrypt_utils.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

import 'authentication_repository.dart';

class AuthenticationService {
  String loginWorkflow;
  User _currentUser;
  Role _currentRole;
  int _indexPage = 0;
  EmployeeModel _currentEmploye;
  User get currentUser => _currentUser;
  set currentUser(User user) {
    this._currentUser = user;
  }

  int get indexPage => _indexPage;
  set indexPage(int index) {
    this._indexPage = index;
  }

  Role get currentRole => _currentRole;
  EmployeeModel get currentEmploye => _currentEmploye;

  AuthenticationRepository _repository;
  BehaviorSubject<bool> loginStatusChangeStream = BehaviorSubject<bool>();
  BehaviorSubject<String> textAppBarStream = BehaviorSubject<String>();
  BehaviorSubject<AuthStatePage> pageStateStream =
      BehaviorSubject<AuthStatePage>();
  BehaviorSubject<int> indexMenuButtonStream = BehaviorSubject<int>();
  StreamSubscription<DocumentSnapshot> _employeeListener;

  AuthenticationService() {
    _repository = AuthenticationRepository();
  }

  void dispose() {
    if (loginStatusChangeStream != null && !loginStatusChangeStream.isClosed)
      loginStatusChangeStream.close();
    if (pageStateStream != null && !pageStateStream.isClosed)
      pageStateStream.close();
    if (textAppBarStream != null && !textAppBarStream.isClosed)
      textAppBarStream.close();
    if (indexMenuButtonStream != null && !indexMenuButtonStream.isClosed)
      indexMenuButtonStream.close();
  }

  void authStatusPage(AuthStatePage state) {
    pageStateStream.add(state);
  }

  void changeTextAppBarStream(String text) {
    textAppBarStream.add(text);
  }

  void changeindexMenuButtonStream(int index) {
    this.indexPage = index;
    indexMenuButtonStream.add(index);
  }

  Future logout() async {
    _currentRole = null;
    _currentUser = null;
    _currentEmploye = null;
    this._unlistenEmployeeChanges();
    pageStateStream.add(AuthStatePage.LOGIN);
    this.onLogOut();
    return await _repository.logout();
  }

  Future<String> sendPasswordResetEmail({@required String email}) async {
    try {
      await _repository.sendPasswordResetEmail(email: email);
      return "success";
    } catch (e) {
      switch (e.code) {
        case "ERROR_INVALID_EMAIL":
          return "Invalid Email";
          break;
        case "ERROR_USER_NOT_FOUND":
          return "Invalid Email";
          break;
        default:
          return "failure";
      }
    }
  }

  Future<String> loginWithEmail(
      {@required String email,
      @required String password,
      @required List<TYPEROLE> role}) async {
    try {
      var currentData = await _repository.loginWithEmail(
          email: email, password: password, role: role);
      if (currentData["error"] != null) {
        return currentData["error"];
      } else if (currentData != null) {
        _currentRole = currentData["role"];
        _currentUser = currentData["user"];
        _currentEmploye = currentData["employee"];
        listenEmployeeChanges();
        if (_currentRole == null || _currentUser == null) {
          return "0";
        }
        if (_currentUser.changePassword) {
          this.onLogin();
        }

        return "1";
      } else {
        return "0";
      }
    } catch (error) {
      var appException = ChangePasswordException.create(error);
      return appException.getMessage();
    }
  }

  void _unlistenEmployeeChanges() {
    try {
      if (_employeeListener != null) {
        _employeeListener.cancel();
      }
    } catch (e) {}
  }

  void listenEmployeeChanges() {
    this._unlistenEmployeeChanges();

    _employeeListener = GenericFirestoreService.db
        .collection("employees")
        .document(_currentEmploye.id)
        .snapshots()
        .listen((snapshot) async {
      try {
        if (snapshot.data != null) {
          this._currentEmploye = EmployeeModel.fromJson(snapshot.data);
        }
      } catch (e) {}
    });
  }

  Future<dynamic> signUpWithEmail(String password, User user, Role role) async {
    try {
      var result = await _repository.signUpWithEmail(password, user, role);

      _currentRole = result["role"];
      _currentUser = result["user"];
      _currentEmploye = result["employee"];
      if (_currentRole == null || _currentUser == null) {
        return "0";
      }
      if (_currentUser.changePassword) {
        this.onLogin();
      }
      return result;
    } on AppException catch (e1) {
      throw e1;
    } catch (error) {
      throw SignUpException.create(error);
    }
  }

  Future<dynamic> changePasswordCloudF(
      String password, String uid, Role role) async {
    try {
      return await _repository.changePasswordByCloudFunction(
          password, uid, role);
    } catch (error) {
      throw error;
    }
  }

  Future<String> changePassword({
    @required String newPassword,
  }) async {
    try {
      await _repository.changePassword(password: newPassword);
      return "1";
    } catch (error) {
      var appException = ChangePasswordException.create(error);
      return appException.getMessage();
    }
  }

  Future<String> updateCurrentUser({
    @required User newUser,
  }) async {
    try {
      await _repository.updateCurrentUser(newUser: newUser);
      this.onLogin();
      return "1";
    } catch (error) {
      return error;
    }
  }

  Future<String> createUser({
    @required Map<String, dynamic> newUser,
  }) async {
    try {
      return await _repository.createUserFromAdmin(newUser: newUser);
    } catch (error) {
      return error;
    }
  }

  Future<bool> isUserLoggedIn() async {
    try {
      if (_currentUser != null) {
        return true;
      }

      var currentData = await _repository.loadCurrentUser();
      if (currentData != null) {
        _currentRole = currentData["role"];
        _currentUser = currentData["user"];
        _currentEmploye = currentData["employee"];
        if (_currentRole != null && _currentUser != null) {
          return true;
        } else {
          return false;
        }
      } else {
        return false;
      }
    } catch (e) {
      print(e);
      return false;
    }
  }

  bool isUserChangePassword() {
    try {
      if (_currentUser != null && _currentUser.changePassword) {
        return true;
      }
      print(EncryptUtils.decryptData(_currentUser.temporalPassword));
      return false;
    } catch (e) {
      return false;
    }
  }

  onLogin() {
    loginStatusChangeStream.add(true);
  }

  onLogOut() {
    loginStatusChangeStream.add(false);
  }
}

enum AuthStatePage {
  LOGIN,
  SIGNUP,
  SIGNUPCONFIRMATION,
  FORGOTPIN,
}

enum TYPEROLE { admin, user_tier_1, super_admin }
