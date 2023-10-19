import 'package:compound/config.dart';
import 'package:compound/shared_models/location_model.dart';
import 'package:compound/shared_models/property_model.dart';
import 'package:compound/utils/timestamp_util.dart';
import 'package:geolocator/geolocator.dart';

enum STATUSCHECKIN {
  programed,
  inprogressanycheckin,
  inprogresssomecheckin,
  inprogresssallcheckin,
  completed
}

class CheckInModel {
  String id;
  String marketId;
  String marketName;
  String propertyId;
  String propertyName;
  String units;
  String employeedId;
  String employeedName;
  String image;
  String imageCheckIn;
  String imageCheckOut;
  String commentByAdmin;
  int wage;
  bool checkInByAdmin;
  bool documentIncidents;
  bool isTemporaryPorter;
  LocationModel locationCheckIn;
  LocationModel locationCheckOut;

  WrappedDate dateCheckInByAdmin;
  WrappedDate dateCheckIn;
  WrappedDate dateCheckOut;
  Map<String, dynamic> dateCheckInByAdminTz;
  Map<String, dynamic> dateCheckInTz;
  Map<String, dynamic> dateCheckOutTz;
  PropertyModel property;

  CheckInModel(
      {this.id,
      this.marketId,
      this.marketName,
      this.propertyId,
      this.propertyName,
      this.commentByAdmin,
      this.units,
      this.dateCheckIn,
      this.dateCheckOut,
      this.employeedId,
      this.employeedName,
      this.checkInByAdmin,
      this.dateCheckInByAdmin,
      this.locationCheckIn,
      this.locationCheckOut,
      this.documentIncidents,
      this.wage,
      this.image,
      this.imageCheckIn,
      this.imageCheckOut,
      this.property,
      this.dateCheckInByAdminTz,
      this.dateCheckInTz,
      this.dateCheckOutTz,
      this.isTemporaryPorter});

  Future<Position> getPosition() async {
    if (property.lat == null || property.lng == null) {
      //TODO get address position;
      return null;
    }

    return Position(longitude: property.lng, latitude: property.lat);
  }

  CheckInModel.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        propertyId = json['propertyId'],
        propertyName = json['propertyName'],
        marketId = json['marketId'],
        marketName = json['marketName'],
        units = json['unit'],
        documentIncidents = json['documentIncidents'],
        commentByAdmin = json['commentByAdmin'],
        wage = json['wage'],
        dateCheckIn = json['dateCheckIn'] == null
            ? null
            : WrappedDate.fromServer(json['dateCheckIn']),
        dateCheckOut = json['dateCheckOut'] == null
            ? null
            : WrappedDate.fromServer(json['dateCheckOut']),
        employeedId = json['employeedId'],
        employeedName = json['employeedName'],
        locationCheckIn = json['locationCheckIn'] != null
            ? new LocationModel.fromJson(json['locationCheckIn'])
            : new LocationModel(),
        locationCheckOut = json['locationCheckOut'] != null
            ? new LocationModel.fromJson(json['locationCheckOut'])
            : new LocationModel(),
        checkInByAdmin = json['checkInByAdmin'],
        dateCheckInByAdmin = json['dateCheckInByAdmin'] != null
            ? WrappedDate.fromServer(json['dateCheckInByAdmin'])
            : null,
        image = json['image'],
        imageCheckOut = json['imageCheckOut'],
        imageCheckIn = json['imageCheckIn'],
        dateCheckInTz = json['dateCheckInTz'],
        dateCheckOutTz = json['dateCheckOutTz'],
        dateCheckInByAdminTz = json['dateCheckInByAdminTz'],
        isTemporaryPorter = json['isTemporaryPorter'];

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['propertyId'] = this.propertyId;
    data['commentByAdmin'] = this.commentByAdmin;
    data['propertyName'] = this.propertyName;
    data['documentIncidents'] = this.documentIncidents;
    data['marketId'] = this.marketId;
    data['marketName'] = this.marketName;
    data['wage'] = this.wage;
    data['unit'] = this.units;
    data['employeedId'] = this.employeedId;
    data['employeedName'] = this.employeedName;
    data['checkInByAdmin'] = this.checkInByAdmin;
    data['isTemporaryPorter'] = this.isTemporaryPorter;
    data['locationCheckIn'] =
        this.locationCheckIn != null ? this.locationCheckIn.toJson() : null;
    data['locationCheckOut'] =
        this.locationCheckOut != null ? this.locationCheckOut.toJson() : null;
    data['image'] = this.image;
    data['imageCheckOut'] = this.imageCheckOut;
    data['imageCheckIn'] = this.imageCheckIn;
    data['dateCheckInTz'] = this.dateCheckInTz;
    data['dateCheckOutTz'] = this.dateCheckOutTz;
    data['dateCheckInByAdminTz'] = this.dateCheckInByAdminTz;
    data['dateCheckInByAdmin'] =
        this.dateCheckInByAdmin != null ? this.dateCheckInByAdmin.utc() : null;
    data['dateCheckIn'] =
        this.dateCheckIn != null ? this.dateCheckIn.utc() : null;
    data['dateCheckOut'] =
        this.dateCheckOut != null ? this.dateCheckOut.utc() : null;
    data['app_version'] = Config.versionApp;
    return data;
  }
}
