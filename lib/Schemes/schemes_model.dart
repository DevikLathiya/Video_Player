class Schemes {
  bool? status;
  String? message;
  SchemesData? data;

  Schemes({this.status, this.message, this.data});

  Schemes.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ? new SchemesData.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class SchemesData {
  List<SchemesList>? schemesList;

  SchemesData({this.schemesList});

  SchemesData.fromJson(Map<String, dynamic> json) {
    if (json['schemes_list'] != null) {
      schemesList = <SchemesList>[];
      json['schemes_list'].forEach((v) {
        schemesList!.add(new SchemesList.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.schemesList != null) {
      data['schemes_list'] =
          this.schemesList!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class SchemesList {
  int? id;
  String? name;
  String? description;
  String? poster;
  String? type;

  SchemesList(
      {this.id, this.name, this.description, this.poster, this.type});

  SchemesList.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    description = json['description'];
    poster = json['poster'];
    type = json['type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['description'] = this.description;
    data['poster'] = this.poster;
    data['type'] = this.type;
    return data;
  }
}
