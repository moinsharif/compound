import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:compound/core/base/base_service.dart';
import 'package:compound/core/services/generic_firestore/generic_firestore.dart';
import 'package:compound/shared_models/payrrol_model.dart';
import 'package:compound/utils/timestamp_util.dart';
import 'package:flutter/material.dart';

class PayrollService extends BaseService {
  static const String DatabaseRef = "payroll";

  void setPayrollTransact(PayrollModel payroll, WriteBatch batch) async {
    var doc = GenericFirestoreService.db.collection(DatabaseRef).document();
    payroll.id = doc.documentID;
    batch.setData(doc, payroll.toJson());
  }

  Future<String> setPayroll(PayrollModel payroll) async {
    try {
      var doc = GenericFirestoreService.db.collection(DatabaseRef).document();
      payroll.id = doc.documentID;
      await GenericFirestoreService.db
          .collection(DatabaseRef)
          .document(doc.documentID)
          .setData(payroll.toJson());
      return 'success';
    } catch (e) {
      return null;
    }
  }

  Future<List<PayrollModel>> getAllPayroll(
      {WrappedDate start,
      WrappedDate end,
      String porterId,
      String propertyId}) async {
    var query = GenericFirestoreService.db
        .collection(DatabaseRef)
        .orderBy('createdAt', descending: true);
    if (start != null) {
      query = query.where('createdAt', isGreaterThanOrEqualTo: start.utc());
    }
    if (end != null) {
      query = query.where('createdAt', isLessThanOrEqualTo: end.utc());
    }
    if (porterId != null) {
      query = query.where('employeeId', isEqualTo: porterId);
    }
    if (propertyId != null) {
      query = query.where('propertyId', isEqualTo: propertyId);
    }
    var snapshot = await query.getDocuments();
    if (snapshot.documents.isNotEmpty) {
      if (snapshot.documents.isNotEmpty) {
        var data = snapshot.documents.map((snapshot) {
          var data = snapshot.data;
          return PayrollModel.fromJson(data);
        }).toList();
        return data;
      } else {
        return [];
      }
    }
    return [];
  }

  Future<List<PayrollModel>> getById(String id) async {
    var query = GenericFirestoreService.db.collection(DatabaseRef);
    var snapshot =
        await query.where('employeeId', isEqualTo: id).getDocuments();
    if (snapshot.documents.isNotEmpty) {
      if (snapshot.documents.isNotEmpty) {
        var data = snapshot.documents.map((snapshot) {
          var data = snapshot.data;
          return PayrollModel.fromJson(data);
        }).toList();
        return data;
      } else {
        return [];
      }
    }
    return [];
  }

  Future<List<PayrollModel>> getByIdAndRangeOfDate(
      String id, DateTimeRange range) async {
    var query = GenericFirestoreService.db
        .collection(DatabaseRef)
        .orderBy('createdAt', descending: true)
        .where('employeeId', isEqualTo: id)
        .where('createdAt', isGreaterThanOrEqualTo: range.start)
        .where('createdAt', isLessThanOrEqualTo: range.end);
    var snapshot = await query.getDocuments();
    if (snapshot.documents.isNotEmpty) {
      if (snapshot.documents.isNotEmpty) {
        var data = snapshot.documents.map((snapshot) {
          var data = snapshot.data;
          return PayrollModel.fromJson(data);
        }).toList();
        return data;
      } else {
        return [];
      }
    }
    return [];
  }
}
