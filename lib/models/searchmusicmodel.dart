class searchMusicModel {
  List<AlbumMp3List>? data;

  searchMusicModel({this.data});

  searchMusicModel.fromJson(Map<String, dynamic> json) {
    if (json['album_mp3_list'] != null) {
      data = <AlbumMp3List>[];
      json['album_mp3_list'].forEach((v) {
        data!.add(new AlbumMp3List.fromJson(v));
      });
    }
  }

  @override
  String toString() {
    return 'searchMusicModel{data: $data}';
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class AlbumMp3List
{
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

  AlbumMp3List(
      {
        this.id,
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

  AlbumMp3List.fromJson(Map<String, dynamic> json) {
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
  factory AlbumMp3List.fromMap(Map<String, dynamic> map) {
    return AlbumMp3List(
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

  @override
  String toString() {
    return 'AlbumMp3List{id: $id, title: $title, image: $image, description: $description, coverImage: $coverImage, file: $file, lyrics: $lyrics, newlyrics: $newlyrics, duration: $duration, newdescription: $newdescription, isFavourite: $isFavourite, mp3Status: $mp3Status}';
  }
}