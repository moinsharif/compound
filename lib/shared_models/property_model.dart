import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:compound/shared_models/config_property.dart';

class PropertyModel {
  String id;
  bool active;
  String propertyName;
  String address;
  double lat;
  double lng;
  String marketId;
  String marketName;
  String units;
  String phone;
  int totalViolations;
  String specialInstructions;
  bool flagged;
  Timestamp updatedAt;
  DateTime dateVisited;
  Timestamp createdAt;
  ConfigProperty configProperty;
  List<String> emails;

  PropertyModel(
      {this.id,
      this.active,
      this.propertyName,
      this.address,
      this.lat,
      this.lng,
      this.units,
      this.marketName,
      this.marketId,
      this.phone,
      this.totalViolations,
      this.specialInstructions,
      this.flagged,
      this.dateVisited,
      this.updatedAt,
      this.createdAt,
      this.configProperty,
      this.emails});

  PropertyModel.fromData(Map<String, dynamic> data, {String id})
      : id = id,
        active = data['active'],
        propertyName = data['propertyName'],
        address = data['address'],
        lat = data['lat'],
        lng = data['lng'],
        units = data['units'],
        marketName = data['marketName'],
        marketId = data['marketId'],
        phone = data['phone'],
        totalViolations = data['totalViolations'],
        specialInstructions = data['specialInstructions'],
        flagged = data['flagged'] ?? false,
        updatedAt = data['updatedAt'],
        dateVisited = data['dateVisited'] == null
            ? null
            : DateTime.fromMicrosecondsSinceEpoch(
                data['dateVisited'].microsecondsSinceEpoch),
        createdAt = data['createdAt'],
        configProperty = data['configProperty'] != null
            ? new ConfigProperty.fromJson(data['configProperty'])
            : null,
        emails = data['emails']?.cast<String>() ?? [];

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'active': active,
      'propertyName': propertyName,
      'address': address,
      'lat': lat,
      'lng': lng,
      'units': units,
      'marketName': marketName,
      'marketId': marketId,
      'phone': phone,
      'totalViolations': totalViolations,
      'specialInstructions': specialInstructions,
      'flagged': flagged,
      'updatedAt': updatedAt,
      'dateVisited': dateVisited,
      'createdAt': createdAt,
      if (configProperty != null) 'configProperty': configProperty.toJson(),
      'emails': emails
    };
  }

  PropertyModel copyWith(
      {String id,
      bool active,
      String propertyName,
      String address,
      double lat,
      double lng,
      String marketId,
      String marketName,
      String units,
      String phone,
      int totalViolations,
      String specialInstructions,
      bool flagged,
      Timestamp updatedAt,
      Timestamp dateVisited,
      Timestamp createdAt,
      ConfigProperty configProperty,
      List<String> emails}) {
    return PropertyModel(
        id: id ?? this.id,
        active: active ?? this.active,
        propertyName: propertyName ?? this.propertyName,
        address: address ?? this.address,
        lat: lat ?? this.lat,
        lng: lng ?? this.lng,
        marketId: marketId ?? this.marketId,
        marketName: marketName ?? this.marketName,
        units: units ?? this.units,
        phone: phone ?? this.phone,
        totalViolations: totalViolations ?? this.totalViolations,
        specialInstructions: specialInstructions ?? this.specialInstructions,
        flagged: flagged ?? this.flagged,
        updatedAt: updatedAt ?? this.updatedAt,
        dateVisited: dateVisited ?? this.dateVisited,
        createdAt: createdAt ?? this.createdAt,
        configProperty: configProperty ?? this.configProperty,
        emails: emails ?? this.emails);
  }
}
