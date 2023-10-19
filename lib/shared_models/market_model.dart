class MarketModel {
  String id;
  String name;
  String state;
  String showName;

  MarketModel({this.name, this.state, this.id, this.showName});

  MarketModel.fromData(Map<String, dynamic> json) {
    id = json['id'].toString();
    name = json['name'];
    state = json['state'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['state'] = this.state;
    return data;
  }
}
