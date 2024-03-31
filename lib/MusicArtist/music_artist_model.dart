class MusicArtist {
  bool? status;
  String? message;
  MovieArtistData? data;

  MusicArtist({this.status, this.message, this.data});

  MusicArtist.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ? new MovieArtistData.fromJson(json['data']) : null;

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

class MovieArtistData {
  List<MusicartistList>? musicartistList;

  MovieArtistData({this.musicartistList});

  MovieArtistData.fromJson(Map<String, dynamic> json) {
    if (json['Musicartist_list'] != null) {
      musicartistList = <MusicartistList>[];
      json['Musicartist_list'].forEach((v) {
        musicartistList!.add(new MusicartistList.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.musicartistList != null) {
      data['Musicartist_list'] =
          this.musicartistList!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class MusicartistList {
  int? id;
  String? title;
  String? image;
  String? description;

  MusicartistList({this.id, this.title, this.image, this.description});

  MusicartistList.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    image = json['image'];
    description = json['description'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['image'] = this.image;
    data['description'] = this.description;
    return data;
  }
}
