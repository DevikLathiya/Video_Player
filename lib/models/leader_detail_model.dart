import 'movie_detail_model.dart';

class LeadershipDetailModel {
  LeadershipDetailModel({
    this.leaderDetails,
    this.nextrecordId,
    this.preciousrecordId,
  });

  LeadershipDetailModel.fromJson(dynamic json) {
    nextrecordId = json["nextrecordId"];
    preciousrecordId = json["preciousrecordId"];
    if (json['Leader_details'] != null) {
      leaderDetails = [];
      json['Leader_details'].forEach((v) {
        leaderDetails?.add(LeaderDetails.fromJson(v));
      });
    }
  }
  List<LeaderDetails>? leaderDetails;
  int? preciousrecordId;
  int? nextrecordId;
  LeadershipDetailModel copyWith({
    List<LeaderDetails>? schemeDetails,
  }) =>
      LeadershipDetailModel(
        leaderDetails: schemeDetails ?? this.leaderDetails,
      );
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (leaderDetails != null) {
      map['Leader_details'] = leaderDetails?.map((v) => v.toJson()).toList();
    }
    return map;
  }
}

class LeaderDetails {
  LeaderDetails(
      {this.id,
      this.gener,
      this.name,
      this.description,
      this.poster,
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
      this.isFavourite,
      this.movieVideos});

  LeaderDetails.fromJson(dynamic json) {
    id = json['id'];
    gener = json['gener'];
    name = json['name'];
    description = json['description'];
    poster = json['poster'];
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
    isFavourite = json['is_favourite'];
    movieVideos = (json['movie_videos'] as List)
        .map((e) => MovieVideo.fromMap(e))
        .toList();
  }

  num? id;
  String? gener;
  String? name;
  String? description;
  String? poster;
  String? studio;
  String? thumbnail;
  int? amountGiven;
  String? trailer;
  String? year;
  String? certificate;
  String? avgRunTime;
  String? video;
  String? language;
  String? type;
  int? runTime;
  bool? isFavourite;
  List<MovieVideo>? movieVideos;

  LeaderDetails copyWith(
          {num? id,
          String? gener,
          String? name,
          String? description,
          String? poster,
          String? studio,
          String? thumbnail,
          int? amountGiven,
          String? trailer,
          String? year,
          String? certificate,
          String? avgRunTime,
          String? video,
          String? language,
          String? type,
          int? runTime,
          bool? isFavourite,
          List<MovieVideo>? movieVideos}) =>
      LeaderDetails(
        id: id ?? this.id,
        gener: gener ?? this.gener,
        name: name ?? this.name,
        description: description ?? this.description,
        poster: poster ?? this.poster,
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
        isFavourite: isFavourite! ?? this.isFavourite,
        movieVideos: movieVideos ?? this.movieVideos,
      );

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['gener'] = gener;
    map['name'] = name;
    map['description'] = description;
    map['poster'] = poster;
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
    map['is_favourite'] = isFavourite;
    map['run_time'] = runTime;
    return map;
  }
}
