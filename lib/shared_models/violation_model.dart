import 'package:compound/config.dart';
import 'package:compound/shared_models/location_model.dart';
import 'package:compound/shared_models/property_model.dart';
import 'package:compound/utils/timestamp_util.dart';

class ViolationModel {
  String id;
  WrappedDate createdAt;
  String checkInId;
  String propertyId;
  String employeeName;
  String employeeId;
  List<String> violationType;
  String description;
  String unit;
  List<String> images;
  LocationModel location;
  PropertyModel property;
  bool reportWasGenerated;
  bool activeEdit = false;
  Map<String, dynamic> createdAtTz;

  ViolationModel(WrappedDate createdAtDt,
      {this.id,
      this.checkInId,
      this.propertyId,
      this.employeeName,
      this.employeeId,
      this.violationType,
      this.location,
      this.description,
      this.unit,
      this.images,
      this.property,
      this.reportWasGenerated = false,
      this.activeEdit = false}) {
    this.createdAt = createdAtDt;
    this.createdAtTz = TimestampUtils.timezone();
  }

  ViolationModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    createdAt = WrappedDate.fromServer(json['createdAt']);
    checkInId = json['checkInId'];
    propertyId = json['propertyId'];
    violationType = json['violationType'] != null
        ? List<String>.from(json['violationType'])
        : [];
    employeeName = json['employeeName'];
    employeeId = json['employeeId'];
    location = json['location'] != null
        ? new LocationModel.fromJson(json['location'])
        : new LocationModel();
    description = json['description'];
    unit = json['unit'];
    reportWasGenerated = json['reportWasGenerated'];
    images = json['images'].cast<String>();
    createdAtTz = json['createdAtTz'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['createdAt'] = this.createdAt.utc();
    data['checkInId'] = this.checkInId;
    data['propertyId'] = this.propertyId;
    data['violationType'] =
        this.violationType != null ? this.violationType : [];
    data['description'] = this.description;
    data['unit'] = this.unit;
    data['employeeName'] = this.employeeName;
    data['employeeId'] = this.employeeId;
    data['reportWasGenerated'] = this.reportWasGenerated;
    data['location'] = this.location != null ? this.location.toJson() : null;
    data['images'] = this.images;
    data['createdAtTz'] = this.createdAtTz;
    data['app_version'] = Config.versionApp;
    return data;
  }
}
