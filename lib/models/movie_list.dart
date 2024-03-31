class MovieList {
  MovieList({
    this.movielist,
  });

  MovieList.fromJson(dynamic json) {
    if (json['movielist'] != null) {
      movielist = [];
      json['movielist'].forEach((v) {
        movielist?.add(Movielist.fromJson(v));
      });
    }
  }
  List<Movielist>? movielist;
  MovieList copyWith({
    List<Movielist>? movielist,
  }) =>
      MovieList(
        movielist: movielist ?? this.movielist,
      );
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (movielist != null) {
      map['movielist'] = movielist?.map((v) => v.toJson()).toList();
    }
    return map;
  }
}

class Movielist {
  Movielist({
    this.id,
    this.name,
    this.description,
    this.poster,
    this.videoSecond,
    this.type,
    this.totalVideoSecond,
    this.thumbnail,
    this.movieVideos,
  });

  Movielist.fromJson(dynamic json) {
    id = json['id'];
    name = json['name'];
    description = json['description'];
    poster = json['poster'];
    type = json['type'];
    videoSecond = json['videoSecond'];
    totalVideoSecond = json['totalVideoSecond'];
    thumbnail = json['thumbnail'];
    movieVideos = List<MovieVideo>.from(
        json["movie_videos"].map((x) => MovieVideo.fromMap(x)));
  }
  num? id;
  String? name;
  String? description;
  String? poster;
  String? thumbnail;
  String? type;
  String? videoSecond;
  String? totalVideoSecond;
  List<MovieVideo>? movieVideos;

  Movielist copyWith({
    num? id,
    String? name,
    String? description,
    String? poster,
    String? videoSecond,
    String? type,
    String? totalVideoSecond,
  }) =>
      Movielist(
          id: id ?? this.id,
          name: name ?? this.name,
          description: description ?? this.description,
          poster: poster ?? this.poster,
          type: type ?? this.type,
          videoSecond: videoSecond ?? this.videoSecond,
          totalVideoSecond: totalVideoSecond ?? this.totalVideoSecond);
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['name'] = name;
    map['description'] = description;
    map['poster'] = poster;
    return map;
  }
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
