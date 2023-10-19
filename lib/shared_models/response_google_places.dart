class ResultModel {
  List<Results> results;

  ResultModel({this.results});

  ResultModel.fromJson(Map<String, dynamic> json) {
    if (json['candidates'] != null) {
      results = [];
      json['candidates'].forEach((v) {
        results.add(new Results.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.results != null) {
      data['candidates'] = this.results.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Results {
  Geometry geometry;
  String name;
  String vicinity;
  String formattedAddress;

  Results({this.geometry, this.name, this.vicinity, this.formattedAddress});

  Results.fromJson(Map<String, dynamic> json) {
    geometry = json['geometry'] != null
        ? new Geometry.fromJson(json['geometry'])
        : null;
    name = json['name'];
    vicinity = json['vicinity'];
    formattedAddress = json['formatted_address'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.geometry != null) {
      data['geometry'] = this.geometry.toJson();
    }
    data['name'] = this.name;
    data['vicinity'] = this.vicinity;
    data['formatted_address'] = this.formattedAddress;
    return data;
  }
}

class Geometry {
  Location location;

  Geometry({this.location});

  Geometry.fromJson(Map<String, dynamic> json) {
    location = json['location'] != null
        ? new Location.fromJson(json['location'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.location != null) {
      data['location'] = this.location.toJson();
    }
    return data;
  }
}

class Location {
  double lat;
  double lng;

  Location({this.lat, this.lng});

  Location.fromJson(Map<String, dynamic> json) {
    lat = json['lat'];
    lng = json['lng'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['lat'] = this.lat;
    data['lng'] = this.lng;
    return data;
  }
}
