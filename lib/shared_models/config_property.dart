import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:compound/shared_models/days_selected.dart';
import 'package:compound/shared_models/porter_model.dart';

class ConfigProperty {
  Timestamp createdAt;
  Timestamp endDate;
  String startTime;
  String endTime;
  bool end;
  String dateInit;
  List<DaysSelected> daysSelected;
  List<Porter> porters;

  ConfigProperty(
      {this.createdAt,
      this.startTime,
      this.endTime,
      this.endDate,
      this.end,
      this.dateInit,
      this.daysSelected,
      this.porters = const []});

  ConfigProperty.fromJson(Map<String, dynamic> json) {
    createdAt = json['createdAt'];
    startTime = json['startTime'];
    endTime = json['endTime'];
    endDate = json['endDate'];
    end = json['end'];
    dateInit = json['dateInit'];
    daysSelected = [];
    porters = [];
    if (json["daysSelected"] != null) {
      json["daysSelected"].forEach((v) {
        daysSelected.add(new DaysSelected.fromJson(v));
      });
    }
    if (json["porters"] != null) {
      json["porters"].forEach((v) {
        porters.add(new Porter.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['createdAt'] = this.createdAt;
    data['endDate'] = this.endDate;
    data['startTime'] = this.startTime;
    data['endTime'] = this.endTime;
    data['end'] = this.end;
    data['dateInit'] = this.dateInit;
    data['daysSelected'] = this.daysSelected != null
        ? this.daysSelected.map((x) => x.toJson()).toList()
        : [];
    data['porters'] = this.porters != null
        ? this.porters.map((x) => x.toJson()).toList()
        : [];
    data['days'] = this.daysSelected != null
        ? this.daysSelected.map((x) => x.nameDay).toList()
        : [];
    return data;
  }

  ConfigProperty copyWith(
      {Timestamp createdAt,
      Timestamp endDate,
      String startTime,
      String endTime,
      bool end,
      String dateInit,
      List<DaysSelected> daysSelected,
      List<Porter> porters}) {
    return ConfigProperty(
        createdAt: createdAt ?? this.createdAt,
        endDate: endDate ?? this.endDate,
        startTime: startTime ?? this.startTime,
        endTime: endTime ?? this.endTime,
        end: end ?? this.end,
        dateInit: dateInit ?? this.dateInit,
        daysSelected: daysSelected ?? this.daysSelected,
        porters: porters ?? this.porters);
  }
}
