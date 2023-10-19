import 'package:compound/core/base/base_model.dart';

class EmployeeDetailModel extends BaseModel {
  String id;
  String userName;
  String firstName;
  String lastName;
  String phone;
  DateTime createdAt;
  String email;
  bool active;
  bool selected;
  Map<String, dynamic> wage;

  EmployeeDetailModel({
    this.id,
    this.userName,
    this.firstName,
    this.lastName,
    this.phone,
    this.createdAt,
    this.email,
    this.active,
    this.selected = false,
    this.wage = const {},
  });

  static EmployeeDetailModel fromData(Map<String, dynamic> data, {String id}) {
    return EmployeeDetailModel(
        id: id,
        userName: data['userName'],
        firstName: data['firstName'],
        lastName: data['lastName'],
        phone: data['phoneNumber'],
        createdAt: data['createdAt'] != null
            ? DateTime.fromMicrosecondsSinceEpoch(
                data['createdAt'].microsecondsSinceEpoch)
            : null,
        email: data['email'],
        selected: false,
        wage: Map<String, dynamic>.from(data['wage'] ?? {}),
        active: data['active']);
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userName': userName,
      'firstName': firstName,
      'lastName': lastName,
      'phoneNumber': phone,
      'createdAt': createdAt,
      'email': email,
      'wage': wage
    };
  }
}
