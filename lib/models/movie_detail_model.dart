// To parse this JSON MovieDetailModel, do
//MovieDetailModel
//     final jobsModel = jobsModelFromMap(jsonString);

class MovieDetailModel {
  MovieDetailModel({
    this.movieDtails,
    this.actors,
    this.writters,
    this.directors,
    this.trailerDuration,
    this.movieDuration,
    this.isFavourite,
    this.nextrecordId,
    this.preciousrecordId,
  });

  MovieDtails? movieDtails;
  List<Actor>? actors;
  List<Actor>? writters;
  List<Actor>? directors;
  String? trailerDuration;
  String? movieDuration;
  bool? isFavourite;
  int? preciousrecordId;
  int? nextrecordId;

  factory MovieDetailModel.fromMap(Map<String, dynamic> json) =>
      MovieDetailModel(
          nextrecordId: json["nextrecordId"],
          preciousrecordId: json["preciousrecordId"],
          movieDtails: MovieDtails.fromMap(json["movieDtails"]),
          actors: List<Actor>.from(json["actors"].map((x) => Actor.fromMap(x))),
          directors:
              List<Actor>.from(json["directors"].map((x) => Actor.fromMap(x))),
          movieDuration: json['movieDuration'],
          isFavourite: json['is_favourite'],
          trailerDuration: json['trailerDuration']);
}

class Actor {
  Actor({
    this.title,
    this.type,
    this.photo,
    this.bio,
  });

  String? title;
  String? type;
  String? photo;
  dynamic? bio;

  factory Actor.fromMap(Map<String, dynamic> json) => Actor(
        title: json["title"],
        type: json["type"],
        photo: json["photo"],
        bio: json["bio"],
      );
}

class MovieDtails {
  MovieDtails({
    this.id,
    this.name,
    this.gener,
    this.description,
    this.longDescription,
    this.thumbnail,
    this.trailer,
    this.type,
    this.studio,
    this.year,
    this.certificate,
    this.avgRunTime,
    this.video,
    this.language,
    this.runTime,
    this.amountRequired,
    this.amountGiven,
    this.poster,
    this.movieVideos,
  });
  int? id;
  String? name;
  String? gener;
  String? description;
  String? longDescription;
  String? thumbnail;
  String? trailer;
  String? type;
  String? studio;
  String? year;
  String? certificate;
  String? avgRunTime;
  String? video;
  String? language;
  int? runTime;
  int? amountRequired;
  int? amountGiven;
  String? poster;
  List<MovieVideo>? movieVideos;

  factory MovieDtails.fromMap(Map<String, dynamic> json) => MovieDtails(
        id: json["id"],
        name: json["name"],
        gener: json["gener"],
        description: json["description"],
        longDescription: json["longDescription"],
        thumbnail: json["thumbnail"],
        trailer: json["trailer"],
        type: json["type"],
        studio: json["studio"],
        year: json["year"],
        certificate: json["certificate"],
        avgRunTime: json["avg_run_time"],
        video: json["video"],
        language: json["language"],
        runTime: json["run_time"],
        amountRequired: json["amount_required"],
        amountGiven: json["amount_given"],
        poster: json["poster"],
        movieVideos: List<MovieVideo>.from(
            json["movie_videos"].map((x) => MovieVideo.fromMap(x))),
      );
}

class MovieVideo {
  MovieVideo({
    this.id,
    this.movieId,
    this.type,
    this.qualityType,
    this.qty,
    this.fileName,
  });

  int? id;
  int? movieId;
  QtyType? type;
  String? qualityType;
  String? qty;
  String? fileName;

  factory MovieVideo.fromMap(Map<String, dynamic> json) => MovieVideo(
        id: json["id"],
        movieId: json["movieId"],
        type: typeValues.map![json["type"]],
        qualityType: json["qualityType"],
        qty: json["qty"],
        fileName: json["fileName"],
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "movieId": movieId,
        "type": type,
        "qualityType": qualityType,
        "qty": qty,
        "fileName": fileName,
      };
}

enum QtyType { MOVIE, TRAILER }

final typeValues =
    EnumValues({"movie": QtyType.MOVIE, "trailer": QtyType.TRAILER});

class EnumValues<T> {
  Map<String, T>? map;
  Map<T, String>? reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    reverseMap ??= map!.map((k, v) => MapEntry(v, k));
    return reverseMap!;
  }
}
