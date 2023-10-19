import 'package:cloud_functions/cloud_functions.dart';
import 'package:compound/core/base/base_service.dart';
import 'package:compound/core/exceptions/app_exception.dart';
import 'package:compound/core/services/shared_preferences/shared_preferences_service.dart';
import 'package:compound/shared_models/employee_model.dart';
import 'package:compound/shared_models/role_model.dart';
import 'package:compound/shared_models/user_model.dart';
import 'package:compound/core/services/analytics/analytics_service.dart';
import 'package:compound/core/services/authentication/authentication_service.dart';
import 'package:compound/core/services/firestore/firestore_service.dart';
import 'package:compound/core/services/generic_firestore/generic_firestore.dart';
import 'package:compound/locator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

class AuthenticationRepository {
  static const String UsersRef = "users";
  static const String RolesRef = "roles";

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirestoreService _firestoreService = locator<FirestoreService>();
  final AnalyticsService _analyticsService = locator<AnalyticsService>();
  final GenericFirestoreService<Role> _rolesService =
      GenericFirestoreService<Role>("roles", Role.builder);
  final GenericFirestoreService<EmployeeModel> _employeeService =
      GenericFirestoreService<EmployeeModel>(
          "employees", EmployeeModel.builder);
  final SharedPreferencesService _preferencesService =
      locator<SharedPreferencesService>();

  AuthenticationRepository() : super();

  Future logout() async {
    await _firebaseAuth.signOut();
  }

  Future<Map<String, dynamic>> loginWithEmail(
      {@required String email,
      @required String password,
      @required List<TYPEROLE> role}) async {
    try {
      var authResult = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      print('login $authResult');
      if (authResult.user != null) {
        var user = await loadCurrentUser(role: role);
        _analyticsService.logLogin();
        return user;
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  Future sendPasswordResetEmail({@required String email}) async {
    await _firebaseAuth.sendPasswordResetEmail(
      email: email,
    );
  }

  Future changePassword({@required String password}) async {
    final user = await _firebaseAuth.currentUser();
    await user.updatePassword(password);
  }

  Future<Map<String, dynamic>> signUpWithEmail(
      String password, User user, Role role) async {
    final HttpsCallable callable = CloudFunctions.instance
        .getHttpsCallable(functionName: 'register')
          ..timeout = const Duration(seconds: 30);

    var callData = user.toJson();
    callData["password"] = password;
    callData["role"] = role.active();

    var response = await callable.call(callData);
    if (response.data["result"]["status"] == 500) {
      throw SignUpException.create({
        "code": response.data["result"]["error"],
        "message": response.data["result"]["message"]
      });
    }

    await _firebaseAuth.signInWithEmailAndPassword(
      email: user.email,
      password: password,
    );

    var loadedCurrentUser = await loadCurrentUser();
    _analyticsService.logSignUp();
    return loadedCurrentUser;
  }

  Future<String> createUserFromAdmin({Map<String, dynamic> newUser}) async {
    final HttpsCallable callable = CloudFunctions.instance
        .getHttpsCallable(functionName: 'registerFromAdmin')
          ..timeout = const Duration(seconds: 30);

    var response = await callable.call(newUser);
    return response.data["message"];
  }

  Future<String> changePasswordByCloudFunction(
      String password, String uid, Role role) async {
    try {
      final HttpsCallable callable = CloudFunctions.instance
          .getHttpsCallable(functionName: 'changePassword')
            ..timeout = const Duration(seconds: 30);

      var callData = {};
      callData["uid"] = uid;
      callData["password"] = password;
      callData["role"] = role.active();

      var response = await callable.call(callData);
      if (response.data["status"] == 500) {
        return response.data["error"];
      }
      return response.data["error"];
    } catch (e) {
      print(e);
      return 'error';
    }
  }

  Future<Map<String, dynamic>> loadCurrentUser({List<TYPEROLE> role}) async {
    var user = await _firebaseAuth.currentUser();
    if (user != null) {
      var currentRole = await _rolesService.getById(user.uid);
      if (role != null) {
        await Future.forEach(
            role,
            (element) => {
                  if (currentRole.typeLevel.contains(describeEnum(element)))
                    {
                      currentRole = currentRole.copyWith(
                          RoleType.user,
                          describeEnum(element),
                          currentRole.value,
                          currentRole.typeLevel,
                          currentRole.level,
                          currentRole.employee)
                    }
                });
        if (!describeEnum(role).contains(currentRole.key)) {
          await _firebaseAuth.signOut();
          return {"error": "your user does not have sufficient permissions."};
        }
        _preferencesService.setCurrentRol(currentRole.key);
      } else {
        currentRole = currentRole.copyWith(
            RoleType.user,
            _preferencesService.getCurrentRole() ?? currentRole.key,
            currentRole.value,
            currentRole.typeLevel,
            currentRole.level,
            currentRole.employee);
      }
      var currentUser = await _firestoreService.getUser(user.uid);
      if (!currentUser.active) {
        await _firebaseAuth.signOut();
        return {"error": "Your user was deactivated."};
      }
      var currentEmployee = await _employeeService.getById(user.uid);
      await _analyticsService.setUserProperties(
        userId: user.uid,
        userRole: currentRole?.active(),
      );
      return {
        "user": currentUser,
        "role": currentRole,
        "employee": currentEmployee
      };
    } else {
      return null;
    }
  }

  Future updateCurrentUser({@required User newUser}) async {
    await _firestoreService.updateUser(newUser);
  }
}
