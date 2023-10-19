import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:compound/utils/timestamp_util.dart';

class PayrollModel {
  String id;
  int wage;
  String employeeId;
  String employeeName;
  String propertyId;
  String propertyName;
  String propertyAddress;
  String checkInId;
  WrappedDate createdAt;

  PayrollModel(
      {this.id,
      this.wage,
      this.employeeId,
      this.employeeName,
      this.propertyId,
      this.propertyName,
      this.propertyAddress,
      this.createdAt,
      this.checkInId});


  PayrollModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    wage = json['wage'];
    employeeId = json['employeeId'];
    employeeName = json['employeeName'];
    propertyId = json['propertyId'];
    createdAt = WrappedDate.fromServer(json['createdAt']);
    propertyName = json['propertyName'];
    propertyAddress = json['propertyAddress'];
    checkInId = json['checkInId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['wage'] = this.wage;
    data['employeeId'] = this.employeeId;
    data['employeeName'] = this.employeeName;
    data['propertyId'] = this.propertyId;
    data['propertyName'] = this.propertyName;
    data['propertyAddress'] = this.propertyAddress;
    data['createdAt'] = this.createdAt.utc();
    data['checkInId'] = this.checkInId;
    return data;
  }
}
