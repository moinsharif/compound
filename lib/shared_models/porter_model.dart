import 'package:compound/utils/timestamp_util.dart';

class Porter {
  String id;
  String firstName;
  String lastName;
  bool active;
  bool temporary;
  WrappedDate temporaryDate;

  Porter(
      {this.id,
      this.active,
      this.temporary,
      this.temporaryDate,
      this.firstName,
      this.lastName});

  Porter.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    active = json['active'];
    temporary = json['temporary'];
    temporaryDate = json['temporary_date'] != null
        ? WrappedDate.fromServer(json['temporary_date'])
        : null;
    firstName = json['firstName'];
    lastName = json['lastName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['active'] = this.active;
    data['temporary'] = this.temporary;
    data['temporary_date'] =
        this.temporaryDate != null ? this.temporaryDate.utc() : null;
    data['firstName'] = this.firstName;
    data['lastName'] = this.lastName;
    return data;
  }
}
