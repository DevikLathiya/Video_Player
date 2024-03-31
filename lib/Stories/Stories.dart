class Stories {
  bool? status;
  String? message;
  StoriesData? data;

  Stories({this.status, this.message, this.data});

  Stories.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ? new StoriesData.fromJson(json['data']) : null;

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

class StoriesData {
  List<StoriesList>? stories_list;

  StoriesData({this.stories_list});

  StoriesData.fromJson(Map<String, dynamic> json) {
    if (json['stories_list'] != null) {
      stories_list = <StoriesList>[];
      json['stories_list'].forEach((v) {
        stories_list!.add(new StoriesList.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.stories_list != null) {
      data['stories_list'] = this.stories_list!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class StoriesList {
  dynamic? id;
  String? name;
  String? description;
  String? poster;

  StoriesList({this.id, this.name, this.description, this.poster});

  StoriesList.fromJson(Map<String, dynamic> json) {
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
