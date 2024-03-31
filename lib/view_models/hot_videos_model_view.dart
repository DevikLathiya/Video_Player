class HotVideos {
  bool? status;
  String? message;
  MovieHotData? data;

  HotVideos({this.status, this.message, this.data});

  HotVideos.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ? new MovieHotData.fromJson(json['data']) : null;
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

class MovieHotData {
  List<MovieHotList>? movieHotList;

  MovieHotData({this.movieHotList});

  MovieHotData.fromJson(Map<String, dynamic> json) {
    if (json['movie_hot_list'] != null) {
      movieHotList = <MovieHotList>[];
      json['movie_hot_list'].forEach((v) {
        movieHotList!.add(new MovieHotList.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.movieHotList != null) {
      data['movie_hot_list'] =
          this.movieHotList!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class MovieHotList {
  int? id;
  String? name;
  String? description;
  String? poster;
  String? type;

  MovieHotList({this.id, this.name, this.description, this.poster, this.type});

  MovieHotList.fromJson(Map<String, dynamic> json) {
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
