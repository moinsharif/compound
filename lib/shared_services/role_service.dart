import 'package:compound/core/base/base_service.dart';
import 'package:compound/core/services/authentication/authentication_service.dart';
import 'package:compound/core/services/generic_firestore/generic_firestore.dart';

class RoleService extends BaseService {
  static const String DatabaseRef = "roles";

  Future<String> updateRoles(String userUid, TYPEROLE rol) async {
    try {
      await GenericFirestoreService.db
          .collection(DatabaseRef)
          .document(userUid)
          .updateData(rol == TYPEROLE.admin
              ? {'admin': true, 'user_tier_1': true}
              : {'admin': false, 'user_tier_1': true});
      return "1";
    } catch (e) {
      return null;
    }
  }
}
