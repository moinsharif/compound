import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:compound/config.dart';
import 'package:compound/utils/timestamp_util.dart';

class WatchlistModel {
  String id;
  WrappedDate date;
  WrappedDate completionDate;
  String checkInId;
  String name;
  String image;
  String comment;
  String status;
  String propertyId;
  String propertyName;
  String porterId;
  String porterName;

  File imageFile;

  WatchlistModel(
      {this.id,
      this.date,
      this.name,
      this.image,
      this.comment,
      this.status,
      this.porterId,
      this.porterName,
      this.propertyName,
      this.propertyId,
      this.imageFile,
      this.completionDate,
      this.checkInId});

  WatchlistModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    date = WrappedDate.fromServer(json['date']);
    name = json['name'];
    image = json['image'];
    comment = json['comment'];
    propertyId = json['propertyId'];
    propertyName = json['propertyName'];
    porterId = json['porterId'];
    porterName = json['porterName'];
    status = json['status'];
    checkInId = json['checkInId'];
    completionDate = json['completionDate'] != null
        ? WrappedDate.fromServer(json['completionDate'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['date'] = this.date.utc();
    data['name'] = this.name;
    data['image'] = this.image;
    data['comment'] = this.comment;
    data['propertyId'] = this.propertyId;
    data['propertyName'] = this.propertyName;
    data['porterId'] = this.porterId;
    data['porterName'] = this.porterName;
    data['status'] = this.status;
    data['checkInId'] = this.checkInId;
    data['app_version'] = Config.versionApp;
    data['completionDate'] =
        this.completionDate != null ? this.completionDate.utc() : null;
    return data;
  }
}
