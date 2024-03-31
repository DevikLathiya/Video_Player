class searchModel {
  List<Data>? data;

  searchModel({this.data});

  searchModel.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(new Data.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Data {
  String? name;
  int? id;
  String? description;
  String? thumbnail;
  String? poster;
  String? type;

  Data({this.id,this.name, this.description, this.thumbnail, this.poster,this.type});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    description = json['description'];
    thumbnail = json['thumbnail'];
    poster = json['poster'];
    type = json['type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['id'] = this.id;
    data['description'] = this.description;
    data['thumbnail'] = this.thumbnail;
    data['poster'] = this.poster;
    data['type'] = this.type;
    return data;
  }
}