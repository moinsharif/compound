import 'package:compound/core/base/base_model.dart';

enum RoleType { user }

class Role extends BaseModel {
  static String defaultRole = "user_tier_1";
  final List<String> typeLevel;
  final bool value;
  final String key;
  final RoleType type;
  final int level;
  final bool employee;

  static Role builder(Map<String, dynamic> data) {
    return Role.fromJson(data);
  }

  Role(this.type, this.key, this.value,
      {this.typeLevel = const [], this.level = 1, this.employee = false});

  Role copyWith(
    RoleType type,
    String key,
    bool value,
    List<String> typeLevel,
    int level,
    bool employee,
  ) =>
      Role(type ?? this.type, key ?? this.key, value ?? this.value,
          typeLevel: typeLevel ?? this.typeLevel,
          level: level ?? this.level,
          employee: employee ?? this.employee);

  static Role fromJson(Map<String, dynamic> data) {
    List<String> typeLevel = [];
    int level = 1;
    RoleType type;
    String okey;
    bool ovalue;
    bool employee = false;
    data.forEach((key, value) {
      if (value == true) {
        if (key.indexOf("user") >= 0 && value == true) {
          type = RoleType.user;
          typeLevel.add(key);
          okey = key;
          ovalue = value;
          employee = true;
        } else if (key.indexOf("admin") >= 0 && value == true) {
          type = RoleType.user;
          typeLevel.add(key);
          okey = key;
          ovalue = value;
        } else if (key.indexOf("super") >= 0 && value == true) {
          type = RoleType.user;
          typeLevel.add(key);
          okey = key;
          ovalue = value;
        }
      }
    });

    return Role(type, okey, ovalue,
        typeLevel: typeLevel, level: level, employee: employee);
  }

  Map<String, dynamic> toJson() {
    return {key: value};
  }

  String active() {
    return key;
  }
}
