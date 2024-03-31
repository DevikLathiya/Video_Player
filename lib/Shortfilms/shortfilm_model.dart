class Shortfalls {
  bool? status;
  String? message;
  ShortfilmData? data;

  Shortfalls({this.status, this.message, this.data});

  Shortfalls.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ? new ShortfilmData.fromJson(json['data']) : null;
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

class ShortfilmData {
  List<SthortflimList>? sthortflimList;

  ShortfilmData({this.sthortflimList});

  ShortfilmData.fromJson(Map<String, dynamic> json) {
    if (json['sthortflim_list'] != null) {
      sthortflimList = <SthortflimList>[];
      json['sthortflim_list'].forEach((v) {
        sthortflimList!.add(new SthortflimList.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.sthortflimList != null) {
      data['sthortflim_list'] =
          this.sthortflimList!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class SthortflimList {
  int? id;
  String? name;
  String? description;
  String? poster;
  String? type;

  SthortflimList(
      {this.id, this.name, this.description, this.poster, this.type});

  SthortflimList.fromJson(Map<String, dynamic> json) {
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
