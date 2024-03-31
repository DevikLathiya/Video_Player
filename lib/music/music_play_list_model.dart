class MusicPlayList {
  bool? status;
  String? message;
  MusicPlayListData? data;
  List<Null>? error;
  List<Null>? lLinks;

  MusicPlayList(
      {this.status, this.message, this.data, this.error, this.lLinks});

  MusicPlayList.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ? new MusicPlayListData.fromJson(json['data']) : null;
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

class MusicPlayListData {
  List<AlbumMp3List>? albumMp3List;

  MusicPlayListData({this.albumMp3List});

  MusicPlayListData.fromJson(Map<String, dynamic> json) {
    if (json['album_mp3_list'] != null) {
      albumMp3List = <AlbumMp3List>[];
      json['album_mp3_list'].forEach((v) {
        albumMp3List!.add(new AlbumMp3List.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.albumMp3List != null) {
      data['album_mp3_list'] =
          this.albumMp3List!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class AlbumMp3List {
  int? id;
  String? title;
  String? image;
  String? description;
  String? coverImage;
  String? file;
  String? lyrics;
  int? isFavourite;

  AlbumMp3List(
      {this.id,
        this.title,
        this.image,
        this.description,
        this.coverImage,
        this.file,
        this.lyrics,
        this.isFavourite,});
  factory AlbumMp3List.fromMap(Map<String, dynamic> map) {
    return AlbumMp3List(
        id : map['id'],
        title : map['title'],
        image : map['image'],
        description : map['description'],
        coverImage : map['cover_image'],
        file : map['file'],
        lyrics : map['lyrics'],
        isFavourite : map['is_favourite'],
    );
  }

  @override
  String toString() {
    return 'AlbumMp3List{id: $id, title: $title, image: $image, description: $description, coverImage: $coverImage, file: $file, lyrics: $lyrics, isFavourite: $isFavourite}';
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id':id,
      'title':title,
      'image':image,
      'description':description,
      'coverImage':coverImage,
      'file':file,
      'lyrics':lyrics,
      'isFavourite':isFavourite,

    };
  }
  AlbumMp3List.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    image = json['image'];
    description = json['description'];
    coverImage = json['cover_image'];
    file = json['file'];
    lyrics = json['lyrics'];
    isFavourite = json["is_favourite"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['image'] = this.image;
    data['description'] = this.description;
    data['cover_image'] = this.coverImage;
    data['file'] = this.file;
    data['lyrics'] = this.lyrics;
    data["is_favourite"] = this.isFavourite;
    return data;
  }
}
