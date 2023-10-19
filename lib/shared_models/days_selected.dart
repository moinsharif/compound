import 'package:cloud_firestore/cloud_firestore.dart';

class DaysSelected {
  int id;
  String nameDay;
  String shortNameDay;
  int rate;
  bool selected;
  Timestamp date;
  DaysSelected(
      {this.id,
      this.nameDay,
      this.shortNameDay,
      this.rate,
      this.date,
      this.selected = false});
  DaysSelected.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    nameDay = json['nameDay'];
    shortNameDay = json['shortNameDay'];
    rate = json['rate'];
    selected = json['id'] != null ? true : false;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['nameDay'] = this.nameDay;
    data['shortNameDay'] = this.shortNameDay;
    data['rate'] = this.rate;
    return data;
  }

  DaysSelected copyWith(
          {int id,
          String nameDay,
          String shortNameDay,
          int rate,
          bool selected}) =>
      DaysSelected(
          id: id ?? this.id,
          selected: selected ?? this.selected,
          nameDay: nameDay ?? this.nameDay,
          shortNameDay: shortNameDay ?? this.shortNameDay,
          rate: rate ?? this.rate);
}
