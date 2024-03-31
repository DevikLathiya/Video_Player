class HomeMovieModel {
  HomeMovieModel({
    this.continueWatch,
    this.sliders,
    this.pickup,
    this.recommended,
    this.hot,
    this.genre1,
    this.genre2,
    this.genre3,
  });

  HomeMovieModel.fromJson(dynamic json) {
    if (json['continue_watch'] != null) {
      continueWatch = [];
      json['continue_watch'].forEach((v) {
        continueWatch?.add(ContinueWatchElement.fromMap(v));
      });
    }
    if (json['sliders'] != null) {
      sliders = [];
      json['sliders'].forEach((v) {
        sliders?.add(Sliders.fromJson(v));
      });
    }
    if (json['pickup'] != null) {
      pickup = [];
      json['pickup'].forEach((v) {
        pickup?.add(Pickup.fromJson(v));
      });
    }
    if (json['recommended'] != null) {
      recommended = [];
      json['recommended'].forEach((v) {
        recommended?.add(Recommended.fromJson(v));
      });
    }
    if (json['hot'] != null) {
      hot = [];
      json['hot'].forEach((v) {
        hot?.add(Hot.fromJson(v));
      });
    }
    if (json['genre1'] != null) {
      genre1 = [];
      json['genre1'].forEach((v) {
        genre1?.add(Genre1.fromJson(v));
      });
    }
    if (json['genre2'] != null) {
      genre2 = [];
      json['genre2'].forEach((v) {
        genre2?.add(Genre2.fromJson(v));
      });
    }
    if (json['genre3'] != null) {
      genre3 = [];
      json['genre3'].forEach((v) {
        genre3?.add(Genre3.fromJson(v));
      });
    }
  }
  List<ContinueWatchElement>? continueWatch;
  List<Sliders>? sliders;
  List<Pickup>? pickup;
  List<Recommended>? recommended;
  List<Hot>? hot;
  List<Genre1>? genre1;
  List<Genre2>? genre2;
  List<Genre3>? genre3;
  HomeMovieModel copyWith({
    List<ContinueWatchElement>? continueWatch,
    List<Sliders>? sliders,
    List<Pickup>? pickup,
    List<Recommended>? recommended,
    List<Hot>? hot,
    List<Genre1>? genre1,
    List<Genre2>? genre2,
    List<Genre3>? genre3,
  }) =>
      HomeMovieModel(
        continueWatch: continueWatch ?? this.continueWatch,
        sliders: sliders ?? this.sliders,
        pickup: pickup ?? this.pickup,
        recommended: recommended ?? this.recommended,
        hot: hot ?? this.hot,
        genre1: genre1 ?? this.genre1,
        genre2: genre2 ?? this.genre2,
        genre3: genre3 ?? this.genre3,
      );
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (continueWatch != null) {
      map['continue_watch'] = continueWatch?.map((v) => v.toMap()).toList();
    }
    if (sliders != null) {
      map['sliders'] = sliders?.map((v) => v.toJson()).toList();
    }
    if (pickup != null) {
      map['pickup'] = pickup?.map((v) => v.toJson()).toList();
    }
    if (recommended != null) {
      map['recommended'] = recommended?.map((v) => v.toJson()).toList();
    }
    if (hot != null) {
      map['hot'] = hot?.map((v) => v.toJson()).toList();
    }
    if (genre1 != null) {
      map['genre1'] = genre1?.map((v) => v.toJson()).toList();
    }
    if (genre2 != null) {
      map['genre2'] = genre2?.map((v) => v.toJson()).toList();
    }
    if (genre3 != null) {
      map['genre3'] = genre3?.map((v) => v.toJson()).toList();
    }
    return map;
  }
}

class ContinueWatchElement {
  ContinueWatchElement({
    required this.id,
    required this.name,
    required this.thumbnail,
    required this.runTime,
    required this.continueWatch,
  });

  int id;
  String name;
  String thumbnail;
  String runTime;
  ContinueWatchContinueWatch continueWatch;

  factory ContinueWatchElement.fromMap(Map<String, dynamic> json) =>
      ContinueWatchElement(
        id: json["id"],
        name: json["name"],
        thumbnail: json["thumbnail"],
        runTime: json["run_time"],
        continueWatch:
            ContinueWatchContinueWatch.fromMap(json["continue_watch"]),
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "name": name,
        "thumbnail": thumbnail,
        "run_time": runTime,
        "continue_watch": continueWatch.toMap(),
      };
}

class ContinueWatchContinueWatch {
  ContinueWatchContinueWatch({
    required this.runTime,
    required this.userId,
    required this.movieId,
  });

  String runTime;
  int userId;
  int movieId;

  factory ContinueWatchContinueWatch.fromMap(Map<String, dynamic> json) =>
      ContinueWatchContinueWatch(
        runTime: json["run_time"],
        userId: json["user_id"],
        movieId: json["movie_id"],
      );

  Map<String, dynamic> toMap() => {
        "run_time": runTime,
        "user_id": userId,
        "movie_id": movieId,
      };
}

class Genre3 {
  Genre3({
    this.id,
    this.name,
    this.description,
    this.poster,
  });

  Genre3.fromJson(dynamic json) {
    id = json['id'];
    name = json['name'];
    description = json['description'];
    poster = json['poster'];
  }
  num? id;
  String? name;
  String? description;
  String? poster;
  Genre3 copyWith({
    num? id,
    String? name,
    String? description,
    String? poster,
  }) =>
      Genre3(
        id: id ?? this.id,
        name: name ?? this.name,
        description: description ?? this.description,
        poster: poster ?? this.poster,
      );
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['name'] = name;
    map['description'] = description;
    map['poster'] = poster;
    return map;
  }
}

class Genre2 {
  Genre2({
    this.id,
    this.name,
    this.description,
    this.poster,
  });

  Genre2.fromJson(dynamic json) {
    id = json['id'];
    name = json['name'];
    description = json['description'];
    poster = json['poster'];
  }
  num? id;
  String? name;
  String? description;
  String? poster;
  Genre2 copyWith({
    num? id,
    String? name,
    String? description,
    String? poster,
  }) =>
      Genre2(
        id: id ?? this.id,
        name: name ?? this.name,
        description: description ?? this.description,
        poster: poster ?? this.poster,
      );
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['name'] = name;
    map['description'] = description;
    map['poster'] = poster;
    return map;
  }
}

class Genre1 {
  Genre1({
    this.id,
    this.name,
    this.description,
    this.poster,
  });

  Genre1.fromJson(dynamic json) {
    id = json['id'];
    name = json['name'];
    description = json['description'];
    poster = json['poster'];
  }
  num? id;
  String? name;
  String? description;
  String? poster;
  Genre1 copyWith({
    num? id,
    String? name,
    String? description,
    String? poster,
  }) =>
      Genre1(
        id: id ?? this.id,
        name: name ?? this.name,
        description: description ?? this.description,
        poster: poster ?? this.poster,
      );
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['name'] = name;
    map['description'] = description;
    map['poster'] = poster;
    return map;
  }
}

class Hot {
  Hot({
    this.id,
    this.name,
    this.description,
    this.poster,
    this.type,
  });

  Hot.fromJson(dynamic json) {
    id = json['id'];
    name = json['name'];
    description = json['description'];
    poster = json['poster'];
    type = json['type'];
  }
  num? id;
  String? name;
  String? description;
  String? poster;
  String? type;
  Hot copyWith({
    num? id,
    String? name,
    String? description,
    String? poster,
    String? type,
  }) =>
      Hot(
        id: id ?? this.id,
        name: name ?? this.name,
        description: description ?? this.description,
        poster: poster ?? this.poster,
        type: type ?? this.type,
      );
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['name'] = name;
    map['description'] = description;
    map['poster'] = poster;
    map['type'] = type;
    return map;
  }
}

class Recommended {
  Recommended({
    this.id,
    this.name,
    this.description,
    this.poster,
  });

  Recommended.fromJson(dynamic json) {
    id = json['id'];
    name = json['name'];
    description = json['description'];
    poster = json['poster'];
  }
  num? id;
  String? name;
  String? description;
  String? poster;
  Recommended copyWith({
    num? id,
    String? name,
    String? description,
    String? poster,
  }) =>
      Recommended(
        id: id ?? this.id,
        name: name ?? this.name,
        description: description ?? this.description,
        poster: poster ?? this.poster,
      );
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['name'] = name;
    map['description'] = description;
    map['poster'] = poster;
    return map;
  }
}

class Pickup {
  Pickup({
    this.id,
    this.name,
    this.description,
    this.poster,
    this.thumbnail
  });

  Pickup.fromJson(dynamic json) {
    id = json['id'];
    name = json['name'];
    description = json['description'];
    poster = json['poster'];
    thumbnail = json['thumbnail'];
  }
  num? id;
  String? name;
  String? description;
  String? poster;
  String? thumbnail;
  Pickup copyWith({
    num? id,
    String? name,
    String? description,
    String? poster,
    String? thumbnail,
  }) =>
      Pickup(
        id: id ?? this.id,
        name: name ?? this.name,
        description: description ?? this.description,
        poster: poster ?? this.poster,
        thumbnail: thumbnail ?? this.thumbnail,
      );
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['name'] = name;
    map['description'] = description;
    map['poster'] = poster;
    map['thumbnail'] = thumbnail;
    return map;
  }
}

class Sliders {
  Sliders({
    this.id,
    this.sliderImage,
    this.movieId,
    this.title,
    this.type,
    this.status,
    this.isDelete,
    this.createdAt,
    this.updatedAt,
    this.thuslierImagembnail,
  });

  Sliders.fromJson(dynamic json) {
    id = json['id'];
    sliderImage = json['slider_image'];
    movieId = json['movie_id'];
    title = json['title'];
    type = json['type'];
    status = json['status'];
    isDelete = json['is_delete'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    thuslierImagembnail = json['thuslier_imagembnail'];
  }
  num? id;
  String? sliderImage;
  num? movieId;
  String? title;
  String? type;
  num? status;
  num? isDelete;
  String? createdAt;
  String? updatedAt;
  String? thuslierImagembnail;
  Sliders copyWith({
    num? id,
    String? sliderImage,
    num? movieId,
    String? title,
    String? type,
    num? status,
    num? isDelete,
    String? createdAt,
    String? updatedAt,
    String? thuslierImagembnail,
  }) =>
      Sliders(
        id: id ?? this.id,
        sliderImage: sliderImage ?? this.sliderImage,
        movieId: movieId ?? this.movieId,
        title: title ?? this.title,
        type: type ?? this.type,
        status: status ?? this.status,
        isDelete: isDelete ?? this.isDelete,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        thuslierImagembnail: thuslierImagembnail ?? this.thuslierImagembnail,
      );
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['slider_image'] = sliderImage;
    map['movie_id'] = movieId;
    map['title'] = title;
    map['type'] = type;
    map['status'] = status;
    map['is_delete'] = isDelete;
    map['created_at'] = createdAt;
    map['updated_at'] = updatedAt;
    map['thuslier_imagembnail'] = thuslierImagembnail;
    return map;
  }
}
