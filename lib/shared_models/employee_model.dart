import 'package:compound/core/base/base_model.dart';

class EmployeeModel extends BaseModel {
  String id;
  String legend;
  List<String> markers;
  List<String> properties;
  List<String> temporalProperties;

  static EmployeeModel builder(Map<String, dynamic> data) {
    return EmployeeModel.fromJson(data);
  }

  EmployeeModel(
      {this.id,
      this.legend,
      this.markers,
      this.properties,
      this.temporalProperties});

  EmployeeModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    legend = json['legend'];
    markers = json['markers']?.cast<String>() ?? [];
    properties =
        json['properties'] != null ? json['properties'].cast<String>() : [];
    temporalProperties = json['temporalProperties'] != null
        ? json['temporalProperties'].cast<String>()
        : [];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['legend'] = this.legend;
    data['markers'] = this.markers;
    data['properties'] = this.properties;
    data['temporalProperties'] = this.temporalProperties;
    return data;
  }
}
