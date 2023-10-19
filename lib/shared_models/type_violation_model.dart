class TypeViolationModel {
  String id;
  String name;

  TypeViolationModel({this.id, this.name});

  TypeViolationModel.fromData(Map<String, dynamic> json, {String id})
      : id = id,
        name = json['name'];

  Map<String, dynamic> toJson() {
    return {'id': id, 'name': name};
  }
}
