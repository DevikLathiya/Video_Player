class MusicAlbumList {
  bool? status;
  String? message;
  Data? data;

  MusicAlbumList({this.status, this.message, this.data});

  MusicAlbumList.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
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

class Data {
  List<AlbumList>? albumList;

  Data({this.albumList});

  Data.fromJson(Map<String, dynamic> json) {
    if (json['Album_list'] != null) {
      albumList = <AlbumList>[];
      json['Album_list'].forEach((v) {
        albumList!.add(new AlbumList.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.albumList != null) {
      data['Album_list'] = this.albumList!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class AlbumList {
  int? id;
  String? title;
  String? thumbnailImage;
  String? coverImage;
  String? description;

  AlbumList(
      {this.id,
        this.title,
        this.thumbnailImage,
        this.coverImage,
        this.description});

  AlbumList.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    thumbnailImage = json['thumbnail_image'];
    coverImage = json['cover_image'];
    description = json['description'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['thumbnail_image'] = this.thumbnailImage;
    data['cover_image'] = this.coverImage;
    data['description'] = this.description;
    return data;
  }
}
