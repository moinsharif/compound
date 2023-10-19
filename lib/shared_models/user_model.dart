class User {
  final String id;
  final String userName;
  final String firstName;
  final String lastName;
  final String phoneNumber;
  final String email;
  final String img;
  final String temporalPassword;
  final DateTime createdAt;
  final bool changePassword;
  final bool active;
  final bool isEmployee;

  User({
    this.id,
    this.userName,
    this.firstName,
    this.lastName,
    this.phoneNumber,
    this.email,
    this.img,
    this.createdAt,
    this.temporalPassword,
    this.isEmployee,
    this.active,
    this.changePassword,
  });

  User copyWith(
          {String id,
          String userName,
          String firstName,
          String lastName,
          String phoneNumber,
          String email,
          String img,
          String temporalPassword,
          DateTime createdAt,
          bool isEmployee,
          bool active,
          bool changePassword}) =>
      User(
          id: id ?? this.id,
          userName: userName ?? this.userName,
          lastName: lastName ?? this.lastName,
          firstName: firstName ?? this.firstName,
          phoneNumber: phoneNumber ?? this.phoneNumber,
          email: email ?? this.email,
          img: img ?? this.img,
          createdAt: createdAt ?? this.createdAt,
          temporalPassword: temporalPassword ?? this.temporalPassword,
          isEmployee: isEmployee ?? this.isEmployee,
          active: active ?? this.active,
          changePassword: changePassword ?? this.changePassword);

  User.fromData(Map<String, dynamic> data)
      : id = data['id'],
        userName = data['userName'],
        firstName = data['firstName'],
        lastName = data['lastName'],
        phoneNumber = data['phoneNumber'],
        changePassword = data['changePassword'],
        active = data['active'],
        isEmployee = data['isEmployee'],
        img = data['img'],
        createdAt = DateTime.fromMicrosecondsSinceEpoch(
            data['createdAt'].microsecondsSinceEpoch),
        temporalPassword = data['temporalPassword'],
        email = data['email'];

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userName': userName,
      'firstName': firstName,
      'lastName': lastName,
      'phoneNumber': phoneNumber,
      'changePassword': changePassword,
      'active': active,
      'isEmployee': isEmployee,
      'img': img,
      'createdAt': createdAt,
      'temporalPassword': temporalPassword,
      'email': email
    };
  }
}
