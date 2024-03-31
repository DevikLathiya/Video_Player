class LatestMusicListModel {
  bool? status;
  String? message;
  Data? data;
  List? error;
  List? lLinks;

  LatestMusicListModel(
      {this.status, this.message, this.data, this.error, this.lLinks});

  LatestMusicListModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
    // if (json['error'] != null) {
    //   error = <Null>[];
    //   json['error'].forEach((v) {
    //     error!.add(new Null.fromJson(v));
    //   });
    // }
    // if (json['_links'] != null) {
    //   lLinks = <Null>[];
    //   json['_links'].forEach((v) {
    //     lLinks!.add(new Null.fromJson(v));
    //   });
    // }
  }


  @override
  String toString() {
    return 'LatestMusicListModel{status: $status, message: $message, data: $data, error: $error, lLinks: $lLinks}';
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    // if (this.error != null) {
    //   data['error'] = this.error!.map((v) => v.toJson()).toList();
    // }
    // if (this.lLinks != null) {
    //   data['_links'] = this.lLinks!.map((v) => v.toJson()).toList();
    // }
    return data;
  }
}

class Data {
  List<Mp3List>? musiclist;

  @override
  String toString() {
    return 'Data{movielist: $musiclist}';
  }

  Data({this.musiclist});

  Data.fromJson(Map<String, dynamic> json) {
    if (json['album_mp3_list'] != null) {
      musiclist = <Mp3List>[];
      json['album_mp3_list'].forEach((v) {
        musiclist!.add(new Mp3List.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.musiclist != null) {
      data['album_mp3_list'] = this.musiclist!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Mp3List {
  int? id;
  String? title;
  String? image;
  String? description;
  String? coverImage;
  String? file;
  String? lyrics;
  String? newlyrics;
  String? duration;
  String? newdescription;
  int? isFavourite;
  int? mp3Status;



  Mp3List(
      {this.id,
        this.title,
        this.image,
        this.description,
        this.coverImage,
        this.file,
        this.lyrics,
        this.newlyrics,
        this.duration,
        this.newdescription,
        this.isFavourite,
        this.mp3Status});

  Mp3List.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    image = json['image'];
    description = json['description'];
    coverImage = json['cover_image'];
    file = json['file'];
    lyrics = json['lyrics'];
    newlyrics = json['newlyrics'];
    duration = json['duration'];
    newdescription = json['newdescription'];
    isFavourite = json['is_favourite'];
    mp3Status = json['mp3Status'];
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
    data['newlyrics'] = this.newlyrics;
    data['duration'] = this.duration;
    data['newdescription'] = this.newdescription;
    data['is_favourite'] = this.isFavourite;
    data['mp3Status'] = this.mp3Status;
    return data;
  }
  factory Mp3List.fromMap(Map<String, dynamic> map) {
    return Mp3List(
        id : map['id'],
        title : map['title'],
        image : map['image'],
        description : map['description'],
        coverImage : map['cover_image'],
        file : map['file'],
        lyrics : map['lyrics'],
        newlyrics : map['newlyrics'],
        duration : map['duration'],
        newdescription : map['newdescription'],
        isFavourite : map['is_favourite'],
        mp3Status : map['mp3Status']);
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
      'newlyrics':newlyrics,
      'duration':duration,
      'newdescription':newdescription,
      'isFavourite':isFavourite,
      'mp3Status':mp3Status
    };
  }
  @override
  String toString() {
    return 'AlbumMp3List{id: $id, title: $title, image: $image, description: $description, coverImage: $coverImage, file: $file, lyrics: $lyrics, newlyrics: $newlyrics, duration: $duration, newdescription: $newdescription, isFavourite: $isFavourite, mp3Status: $mp3Status}';
  }
}