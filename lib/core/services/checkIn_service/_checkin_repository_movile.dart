import 'package:compound/core/base/base_service.dart';
import 'package:compound/core/services/authentication/authentication_service.dart';
import 'package:compound/core/services/generic_firestore/generic_firestore.dart';
import 'package:compound/core/services/shared_preferences/shared_preferences_service.dart';
import 'package:compound/locator.dart';
import 'package:compound/shared_models/checkIn_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:compound/shared_models/property_model.dart';
import 'package:compound/shared_services/property_service.dart';
import 'package:compound/utils/timestamp_util.dart';

class CheckInRepository extends BaseService {
  static const String DatabaseRef = "checkIns";
  final SharedPreferencesService _sharedPreferencesService =
      locator<SharedPreferencesService>();
  final AuthenticationService _authenticationService =
      locator<AuthenticationService>();
  final PropertyService _propertyService = locator<PropertyService>();

  Future<CheckInModel> getCheckIn(String id) async {
    try {
      var checkInData =
          await Firestore.instance.collection(DatabaseRef).document(id).get();
      if (checkInData.data == null) {
        return null;
      }
      return CheckInModel.fromJson(checkInData.data);
    } catch (e) {
      return null;
    }
  }

  Future<List<CheckInModel>> getCheckInsByDate(
      WrappedDate star, WrappedDate end) async {
    try {
      var snapshot = await Firestore.instance
          .collection(DatabaseRef)
          .where('dateCheckIn', isGreaterThanOrEqualTo: star.utc())
          .where('dateCheckIn', isLessThanOrEqualTo: end.utc())
          .getDocuments();
      if (snapshot.documents.isNotEmpty) {
        var data = snapshot.documents.map((snapshot) {
          var data = snapshot.data;
          return CheckInModel.fromJson(data);
        }).toList();
        return data;
      } else {
        return [];
      }
    } catch (e) {
      return [];
    }
  }

  Future<List<CheckInModel>> getCheckInsByDateAndEmployee(
      DateTime star, DateTime end, String employeeId) async {
    try {
      var snapshot = await Firestore.instance
          .collection(DatabaseRef)
          .where('employeedId', isEqualTo: employeeId)
          .where('dateCheckIn', isGreaterThanOrEqualTo: star)
          .where('dateCheckIn', isLessThanOrEqualTo: end)
          .getDocuments();
      if (snapshot.documents.isNotEmpty) {
        var data = snapshot.documents.map((snapshot) {
          var data = snapshot.data;
          return CheckInModel.fromJson(data);
        }).toList();
        return data;
      } else {
        return [];
      }
    } catch (e) {
      return [];
    }
  }

  Future<String> setCheckIn(CheckInModel checkin) async {
    try {
      await GenericFirestoreService.db
          .collection(DatabaseRef)
          .document(checkin.id)
          .setData(checkin.toJson());
      return 'success';
    } catch (e) {
      return null;
    }
  }

  void saveCheckInTransact(CheckInModel checkin, WriteBatch batch) {
      batch.setData(GenericFirestoreService.db
          .collection(DatabaseRef)
          .document(checkin.id),
          checkin.toJson());
  }

  Future<CheckInModel> lastCheckIn() async {
    try {
      var snapshot = await GenericFirestoreService.db
          .collection(DatabaseRef)
          .where('employeedId',
              isEqualTo: _authenticationService.currentUser.id)
          .orderBy('dateCheckIn', descending: true)
          .limit(1)
          .getDocuments();
      if (snapshot.documents.isNotEmpty) {
        return CheckInModel.fromJson(snapshot.documents[0].data);
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  Future<CheckInModel> firstCheckIn() async {
    try {
      var snapshot = await GenericFirestoreService.db
          .collection(DatabaseRef)
          .orderBy('dateCheckIn', descending: false)
          .limit(1)
          .getDocuments();
      if (snapshot.documents.isNotEmpty) {
        return CheckInModel.fromJson(snapshot.documents[0].data);
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  void updateCheckInTransact(CheckInModel entity, WriteBatch batch) {
    batch.updateData(
        GenericFirestoreService.db.collection(DatabaseRef).document(entity.id),
        entity.toJson());
  }

  Future<void> updateCheckIn(CheckInModel checkIn) async {
    try {
      await GenericFirestoreService.db
          .collection(DatabaseRef)
          .document(checkIn.id)
          .updateData(checkIn.toJson());
    } catch (e) {
      return null;
    }
  }

  Future<CheckInModel> loadCurrentCheckIn() async {
    String checkIn = _sharedPreferencesService.getCurrentCheckIn();
    if (checkIn != null) {
      return await this.getCheckIn(checkIn);
    } else {
      return null;
    }
  }

  Future<PropertyModel> getPropertyCheckIn(String id) async {
    return await _propertyService.getProperty(id);
  }

  void clearCheckIn() {
    _sharedPreferencesService.clearCurrentCheckIn();
  }
}
