import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:compound/config.dart';
import 'package:compound/core/base/base_service.dart';
import 'package:compound/core/services/generic_firestore/generic_firestore.dart';
import 'package:compound/shared_models/activityLog_model.dart';

class ActivityLogService extends BaseService {
  static const String DatabaseRef = "activity_log";
  Random _random = new Random();

  Future<String> setActivityLog(ActivityLogModel activity) async {
    try {
      await GenericFirestoreService.db
          .collection(DatabaseRef)
          .document()
          .setData(activity.toJson());
      return 'success';
    } catch (e) {
      return null;
    }
  }

  void saveActivityLogTransact(
      ActivityLogModel activity, WriteBatch batch) async {
    batch.setData(GenericFirestoreService.db.collection(DatabaseRef).document(),
        activity.toJson());
  }

  Future<List<ActivityLogModel>> getAllActivityLog(
      {DateTime start,
      DateTime end,
      String porterId,
      String propertyId}) async {
    var query = GenericFirestoreService.db
        .collection(DatabaseRef)
        .limit(30)
        .orderBy('createdAt', descending: true);
    if (start != null) {
      query = query.where('createdAt', isGreaterThanOrEqualTo: start);
    }
    if (end != null) {
      query = query.where('createdAt',
          isLessThanOrEqualTo:
              end.add(Duration(hours: 23, minutes: 59, seconds: 59)));
    }
    if (porterId != null) {
      query = query.where('porterId', isEqualTo: porterId);
    }
    if (propertyId != null) {
      query = query.where('propertyId', isEqualTo: propertyId);
    }
    var snapshot = await query.getDocuments();
    if (snapshot.documents.isNotEmpty) {
      var data = snapshot.documents.map((snapshot) {
        var data = snapshot.data;
        ActivityLogModel activity = ActivityLogModel.fromJson(data);
        if (Config.activeBrand == 1) {
          activity.description =
              activity.description.replaceAll('Violation', Config.oneViolation);
        }
        activity.colors = new BarColorCustom(
          r: _random.nextInt(255),
          g: _random.nextInt(255),
          b: _random.nextInt(255),
        );
        return activity;
      }).toList();
      return data;
    } else {
      return [];
    }
  }
}
