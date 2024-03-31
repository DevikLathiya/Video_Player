class SuggetionMusicVideoModel {
  SuggetionMusicVideoModel({
      this.suggestlist,});

  SuggetionMusicVideoModel.fromJson(dynamic json) {
    if (json['suggestlist'] != null) {
      suggestlist = [];
      json['suggestlist'].forEach((v) {
        suggestlist?.add(Suggestlist.fromJson(v));
      });
    }
  }
  List<Suggestlist>? suggestlist;
SuggetionMusicVideoModel copyWith({  List<Suggestlist>? suggestlist,
}) => SuggetionMusicVideoModel(  suggestlist: suggestlist ?? this.suggestlist,
);
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (suggestlist != null) {
      map['suggestlist'] = suggestlist?.map((v) => v.toJson()).toList();
    }
    return map;
  }

}

class Suggestlist {
  Suggestlist({
      this.id, 
      this.name, 
      this.description, 
      this.poster, 
      this.type,});

  Suggestlist.fromJson(dynamic json) {
    id = json['id'];
    name = json['name'];
    description = json['description'];
    poster = json['poster'];
    type = json['type'];
  }
  num? id;
  String? name;
  String? description;
  String? poster;
  String? type;
Suggestlist copyWith({  num? id,
  String? name,
  String? description,
  String? poster,
  String? type,
}) => Suggestlist(  id: id ?? this.id,
  name: name ?? this.name,
  description: description ?? this.description,
  poster: poster ?? this.poster,
  type: type ?? this.type,
);
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['name'] = name;
    map['description'] = description;
    map['poster'] = poster;
    map['type'] = type;
    return map;
  }

}