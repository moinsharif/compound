import 'package:compound/config.dart';
import 'package:compound/utils/colors_util.dart';
import 'package:compound/utils/timestamp_util.dart';
import 'package:flutter/material.dart';

class TimesheetModel {
  String id;
  String employeId;
  String employeeName;
  String propertyId;
  String propertyName;
  String checkInId;
  bool checkInByAdmin;
  WrappedDate dateCheckInByAdmin;
  WrappedDate dateCheckIn;
  WrappedDate dateCheckOut;
  String status;
  String commentByAdmin;
  bool isTemporaryPorter;
  bool isV2Entity;

  //UI helper Vars
  Color colorStatus;
  bool shiftActive;
  String startTime;
  String endTime;

  TimesheetModel(
      {this.id,
      this.employeId,
      this.employeeName,
      this.checkInId,
      this.propertyId,
      this.propertyName,
      this.dateCheckIn,
      this.dateCheckOut,
      this.checkInByAdmin,
      this.dateCheckInByAdmin,
      this.status,
      this.colorStatus,
      this.commentByAdmin,
      this.isTemporaryPorter});

  TimesheetModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    employeId = json['employeId'];
    employeeName = json['employeeName'];
    commentByAdmin = json['commentByAdmin'];
    propertyId = json['propertyId'];
    propertyName = json['propertyName'];
    checkInId = json['checkInId'];
    dateCheckIn = json['dateCheckIn'] == null
        ? null
        : WrappedDate.fromServer(json['dateCheckIn']);
    dateCheckOut = json['dateCheckOut'] == null
        ? null
        : WrappedDate.fromServer(json['dateCheckOut']);

    dateCheckInByAdmin = json['dateCheckInByAdmin'] == null
        ? null
        : WrappedDate.fromServer(json['dateCheckInByAdmin']);
    status = json['status'];
    isTemporaryPorter = json['isTemporaryPorter'];
    checkInByAdmin =
        json['checkInByAdmin'] != null ? json['checkInByAdmin'] : false;

    isV2Entity = json['app_version'] != null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['employeId'] = this.employeId;
    data['employeeName'] = this.employeeName;
    data['commentByAdmin'] = this.commentByAdmin;
    data['propertyId'] = this.propertyId;
    data['propertyName'] = this.propertyName;
    data['checkInId'] = this.checkInId;
    data['checkInByAdmin'] = this.checkInByAdmin;
    data['dateCheckInByAdmin'] =
        this.dateCheckInByAdmin != null ? this.dateCheckInByAdmin.utc() : null;
    data['dateCheckIn'] =
        this.dateCheckIn != null ? this.dateCheckIn.utc() : null;
    data['dateCheckOut'] =
        this.dateCheckOut != null ? this.dateCheckOut.utc() : null;
    data['isTemporaryPorter'] = this.isTemporaryPorter;
    data['status'] = this.status;
    data['app_version'] = Config.versionApp;
    return data;
  }
}
