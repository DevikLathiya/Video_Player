class FavouriteList {
  bool? status;
  String? message;
  UserFavouriteList? data;
  List<Null>? error;
  List<Null>? lLinks;

  FavouriteList(
      {this.status, this.message, this.data, this.error, this.lLinks});

  FavouriteList.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ? new UserFavouriteList.fromJson(json['data']) : null;
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
class UserFavouriteList {
  List<UserFavourite>? userFavourite;

  UserFavouriteList({this.userFavourite});

  UserFavouriteList.fromJson(Map<String, dynamic> json) {
    if (json['userFavourite'] != null) {
      userFavourite = <UserFavourite>[];
      json['userFavourite'].forEach((v) {
        userFavourite!.add(new UserFavourite.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.userFavourite != null) {
      data['userFavourite'] =
          this.userFavourite!.map((v) => v.toJson()).toList();
    }
    return data;
  }

  @override
  String toString() {
    return 'UserFavouriteList{userFavourite: $userFavourite}';
  }
}

class UserFavourite {


  int? id;
  String? title;
  String? image;
  String? description;
  String? duration;
  String? album;
  String? genre;
  String? artist;
  String? coverImage;
  String? file;
  String? lyrics;
  String? newlyrics;
  String? newdescription;
  int? status;
  int? delete;
  String? createdAt;
  String? updatedAt;
  int? userId;
  int? mp3Id;

  UserFavourite(
      {this.id,
        this.title,
        this.image,
        this.description,
        this.duration,
        this.album,
        this.genre,
        this.artist,
        this.coverImage,
        this.file,
        this.lyrics,
        this.newlyrics,
        this.newdescription,
        this.status,
        this.delete,
        this.createdAt,
        this.updatedAt,
        this.userId,
        this.mp3Id});

  UserFavourite.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    image = json['image'];
    description = json['description'];
    duration = json['duration'];
    album = json['album'];
    genre = json['genre'];
    artist = json['artist'];
    coverImage = json['cover_image'];
    file = json['file'];
    lyrics = json['lyrics'];
    newlyrics = json['newlyrics'];
    newdescription = json['newdescription'];
    status = json['status'];
    delete = json['delete'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    userId = json['user_id'];
    mp3Id = json['mp3_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['image'] = this.image;
    data['description'] = this.description;
    data['duration'] = this.duration;
    data['album'] = this.album;
    data['genre'] = this.genre;
    data['artist'] = this.artist;
    data['cover_image'] = this.coverImage;
    data['file'] = this.file;
    data['lyrics'] = this.lyrics;
    data['newlyrics'] = this.newlyrics;
    data['newdescription'] = this.newdescription;
    data['status'] = this.status;
    data['delete'] = this.delete;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['user_id'] = this.userId;
    data['mp3_id'] = this.mp3Id;
    return data;
  }

  @override
  String toString() {
    return 'UserFavourite{id: $id, title: $title, image: $image, description: $description, duration: $duration, album: $album, genre: $genre, artist: $artist, coverImage: $coverImage, file: $file, lyrics: $lyrics, newlyrics: $newlyrics, newdescription: $newdescription, status: $status, delete: $delete, createdAt: $createdAt, updatedAt: $updatedAt, userId: $userId, mp3Id: $mp3Id}';
  }
}

