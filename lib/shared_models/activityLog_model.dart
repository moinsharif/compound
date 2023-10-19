import 'package:compound/shared_models/location_model.dart';
import 'package:compound/utils/timestamp_util.dart';

class BarColorCustom {
  int r, g, b;
  BarColorCustom({this.r, this.g, this.b});
}

class ActivityLogModel {
  String id;
  String description;
  String editedBy;
  WrappedDate createdAt;
  String porterId;
  String propertyId;
  String adminId;
  LocationModel location;
  BarColorCustom colors;
  String entityId;

  ActivityLogModel(
      {this.id,
      this.description,
      this.editedBy,
      this.createdAt,
      this.porterId,
      this.propertyId,
      this.location,
      this.adminId,
      this.colors,
      this.entityId});

  ActivityLogModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    description = json['description'];
    editedBy = json['editedBy'];
    createdAt = json['createdAt'] != null
        ? WrappedDate.fromServer(json['createdAt'])
        : null;
    porterId = json['porterId'];
    propertyId = json['propertyId'];
    location = json['location'] != null
        ? new LocationModel.fromJson(json['location'])
        : new LocationModel();
    adminId = json['adminId'];
    entityId = json['entityId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['description'] = this.description;
    data['editedBy'] = this.editedBy;
    data['porterId'] = this.porterId;
    data['propertyId'] = this.propertyId;
    data['location'] = this.location != null ? this.location.toJson() : null;
    data['adminId'] = this.adminId;
    data['entityId'] = this.entityId;
    data['createdAt'] = this.createdAt != null ? this.createdAt.utc() : null;
    return data;
  }
}
