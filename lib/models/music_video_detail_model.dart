import 'movie_detail_model.dart';

class MusicVideoDetailModel {
  MusicVideoDetailModel(
      {this.musicDtails,
      this.nextrecordId,
      this.preciousrecordId,
      this.actors,
      this.isFavourite});

  MusicVideoDetailModel.fromJson(dynamic json) {
    nextrecordId = json["nextrecordId"];
    preciousrecordId = json["preciousrecordId"];

    musicDtails = json['musicDtails'] != null
        ? MusicDtails.fromJson(json['musicDtails'])
        : null;

    if (json['actors'] != null && json['actors'].isNotEmpty) {
      actors = [];
      json['actors'].forEach((v) {
        actors?.add(Actors.fromJson(v));
      });
    }
    isFavourite = json['is_favourite'];
  }
  MusicDtails? musicDtails;
  List<Actors>? actors;
  int? preciousrecordId;
  int? nextrecordId;

  bool? isFavourite;
  MusicVideoDetailModel copyWith({
    MusicDtails? musicDtails,
    List<Actors>? actors,
  }) =>
      MusicVideoDetailModel(
        musicDtails: musicDtails ?? this.musicDtails,
        actors: actors ?? this.actors,
      );
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (musicDtails != null) {
      map['musicDtails'] = musicDtails?.toJson();
    }
    if (actors != null) {
      map['actors'] = actors?.map((v) => v.toJson()).toList();
    }
    return map;
  }
}

class Actors {
  Actors({
    this.title,
    this.type,
    this.photo,
    this.bio,
  });

  Actors.fromJson(dynamic json) {
    title = json['title'];
    type = json['type'];
    photo = json['photo'];
    bio = json['bio'];
  }
  String? title;
  String? type;
  String? photo;
  dynamic bio;
  Actors copyWith({
    String? title,
    String? type,
    String? photo,
    dynamic bio,
  }) =>
      Actors(
        title: title ?? this.title,
        type: type ?? this.type,
        photo: photo ?? this.photo,
        bio: bio ?? this.bio,
      );
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['title'] = title;
    map['type'] = type;
    map['photo'] = photo;
    map['bio'] = bio;
    return map;
  }
}

class MusicDtails {
  MusicDtails({
    this.id,
    this.name,
    this.description,
    this.poster,
    this.gener,
    this.studio,
    this.thumbnail,
    this.amountGiven,
    this.trailer,
    this.year,
    this.certificate,
    this.avgRunTime,
    this.video,
    this.language,
    this.type,
    this.runTime,
    this.movieVideos,
  });

  MusicDtails.fromJson(dynamic json) {
    id = json['id'];
    name = json['name'];
    description = json['description'];
    poster = json['poster'];
    gener = json['gener'];
    studio = json['studio'];
    thumbnail = json['thumbnail'];
    amountGiven = json['amount_given'];
    trailer = json['trailer'];
    year = json['year'];
    certificate = json['certificate'];
    avgRunTime = json['avg_run_time'];
    video = json['video'];
    language = json['language'];
    type = json['type'];
    runTime = json['run_time'];
    runTime = json['is_favourite'];
    movieVideos = (json['movie_videos'] as List)
        .map((e) => MovieVideo.fromMap(e))
        .toList();
  }
  num? id;
  String? name;
  String? description;
  String? poster;
  String? gener;
  String? studio;
  String? thumbnail;
  num? amountGiven;
  String? trailer;
  dynamic year;
  dynamic certificate;
  dynamic avgRunTime;
  String? video;
  String? language;
  String? type;
  int? runTime;
  List<MovieVideo>? movieVideos;

  MusicDtails copyWith(
          {num? id,
          String? name,
          String? description,
          String? poster,
          String? gener,
          String? studio,
          String? thumbnail,
          num? amountGiven,
          String? trailer,
          dynamic year,
          dynamic certificate,
          dynamic avgRunTime,
          String? video,
          String? language,
          String? type,
          int? runTime,
          List<MovieVideo>? movieVideos}) =>
      MusicDtails(
          id: id ?? this.id,
          name: name ?? this.name,
          description: description ?? this.description,
          poster: poster ?? this.poster,
          gener: gener ?? this.gener,
          studio: studio ?? this.studio,
          thumbnail: thumbnail ?? this.thumbnail,
          amountGiven: amountGiven ?? this.amountGiven,
          trailer: trailer ?? this.trailer,
          year: year ?? this.year,
          certificate: certificate ?? this.certificate,
          avgRunTime: avgRunTime ?? this.avgRunTime,
          video: video ?? this.video,
          language: language ?? this.language,
          type: type ?? this.type,
          runTime: runTime ?? this.runTime,
          movieVideos: movieVideos ?? this.movieVideos);
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['name'] = name;
    map['description'] = description;
    map['poster'] = poster;
    map['gener'] = gener;
    map['studio'] = studio;
    map['thumbnail'] = thumbnail;
    map['amount_given'] = amountGiven;
    map['trailer'] = trailer;
    map['year'] = year;
    map['certificate'] = certificate;
    map['avg_run_time'] = avgRunTime;
    map['video'] = video;
    map['language'] = language;
    map['type'] = type;
    map['run_time'] = runTime;
    return map;
  }
}
