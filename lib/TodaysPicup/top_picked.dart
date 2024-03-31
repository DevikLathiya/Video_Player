class TopPicked {
  bool? status;
  String? message;
  TopPickedData? data;

  TopPicked({this.status, this.message, this.data});

  TopPicked.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ? new TopPickedData.fromJson(json['data']) : null;

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

class TopPickedData {
  List<Suggestlist>? suggestlist;

  TopPickedData({this.suggestlist});

  TopPickedData.fromJson(Map<String, dynamic> json) {
    if (json['suggestlist'] != null) {
      suggestlist = <Suggestlist>[];
      json['suggestlist'].forEach((v) {
        suggestlist!.add(new Suggestlist.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.suggestlist != null) {
      data['suggestlist'] = this.suggestlist!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Suggestlist {
  int? id;
  String? name;
  String? description;
  String? poster;

  Suggestlist({this.id, this.name, this.description, this.poster});

  Suggestlist.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    description = json['description'];
    poster = json['poster'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['description'] = this.description;
    data['poster'] = this.poster;
    return data;
  }
}
