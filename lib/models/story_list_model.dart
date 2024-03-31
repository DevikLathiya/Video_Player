class StoryListModel {
  StoryListModel({
      this.storiesList,});

  StoryListModel.fromJson(dynamic json) {
    if (json['stories_list'] != null) {
      storiesList = [];
      json['stories_list'].forEach((v) {
        storiesList?.add(StoriesList.fromJson(v));
      });
    }
  }
  List<StoriesList>? storiesList;
StoryListModel copyWith({  List<StoriesList>? storiesList,
}) => StoryListModel(  storiesList: storiesList ?? this.storiesList,
);
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (storiesList != null) {
      map['stories_list'] = storiesList?.map((v) => v.toJson()).toList();
    }
    return map;
  }

}

class StoriesList {
  StoriesList({
      this.id, 
      this.name, 
      this.description, 
      this.poster, 
      this.type,});

  StoriesList.fromJson(dynamic json) {
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
StoriesList copyWith({  num? id,
  String? name,
  String? description,
  String? poster,
  String? type,
}) => StoriesList(  id: id ?? this.id,
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