import 'home_all_model.dart';

class HomeAllModel {
  HomeAllModel({
    this.sliders,
    this.continueWatch,
    this.pickup,
    this.stories,
    this.shortFilms,
    this.album,
    this.schemes,
    this.recommended,
    this.hot,
    this.leaders
  });

  HomeAllModel.fromJson(dynamic json) {
    if (json['sliders'] != null) {
      sliders = [];
      json['sliders'].forEach((v) {
        sliders?.add(Sliders.fromJson(v));
      });
    }
    if (json['continue_watch'] != null) {
      continueWatch = [];
      json['continue_watch'].forEach((v) {
        continueWatch?.add(ContinueWatch.fromMap(v));
      });
    }
    if (json['pickup'] != null) {
      pickup = [];
      json['pickup'].forEach((v) {
        pickup?.add(Pickup.fromJson(v));
      });
    }
    if (json['stories'] != null) {
      stories = [];
      json['stories'].forEach((v) {
        stories?.add(Stories.fromJson(v));
      });
    }
    if (json['short_films'] != null) {
      shortFilms = [];
      json['short_films'].forEach((v) {
        shortFilms?.add(ShortFilms.fromJson(v));
      });
    }
    if (json['album'] != null) {
      album = [];
      json['album'].forEach((v) {
        album?.add(Album.fromJson(v));
      });
    }
    if (json['schemes'] != null) {
      schemes = [];
      json['schemes'].forEach((v) {
        schemes?.add(Schemes.fromJson(v));
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
    if (json['Leaders'] != null) {
      leaders = [];
      json['Leaders'].forEach((v) {
        leaders?.add(Leaders.fromJson(v));
      });
    }
  }
  List<Sliders>? sliders;
  List<dynamic>? continueWatch;
  List<Pickup>? pickup;
  List<Stories>? stories;
  List<ShortFilms>? shortFilms;
  List<Album>? album;
  List<Schemes>? schemes;
  List<Recommended>? recommended;
  List<Hot>? hot;
  List<Leaders>? leaders;

  HomeAllModel copyWith({
    List<Sliders>? sliders,
    List<dynamic>? continueWatch,
    List<Pickup>? pickup,
    List<Stories>? stories,
    List<ShortFilms>? shortFilms,
    List<Album>? album,
    List<Schemes>? schemes,
    List<Recommended>? recommended,
    List<Hot>? hot,
    List<Leaders>? leaders,
  }) =>
      HomeAllModel(
          sliders: sliders ?? this.sliders,
          continueWatch: continueWatch ?? this.continueWatch,
          pickup: pickup ?? this.pickup,
          stories: stories ?? this.stories,
          shortFilms: shortFilms ?? this.shortFilms,
          album: album ?? this.album,
          schemes: schemes ?? this.schemes,
          recommended: recommended ?? this.recommended,
          hot: hot ?? this.hot,
          leaders:leaders??this.leaders
      );
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (sliders != null) {
      map['sliders'] = sliders?.map((v) => v.toJson()).toList();
    }
    if (continueWatch != null) {
      map['continue_watch'] = continueWatch?.map((v) => v.toJson()).toList();
    }
    if (pickup != null) {
      map['pickup'] = pickup?.map((v) => v.toJson()).toList();
    } if (leaders != null) {
      map['leaders'] = leaders?.map((v) => v.toJson()).toList();
    }
    if (stories != null) {
      map['stories'] = stories?.map((v) => v.toJson()).toList();
    }
    if (shortFilms != null) {
      map['short_films'] = shortFilms?.map((v) => v.toJson()).toList();
    }
    if (album != null) {
      map['album'] = album?.map((v) => v.toJson()).toList();
    }
    if (schemes != null) {
      map['schemes'] = schemes?.map((v) => v.toJson()).toList();
    }
    if (recommended != null) {
      map['recommended'] = recommended?.map((v) => v.toJson()).toList();
    }
    if (hot != null) {
      map['hot'] = hot?.map((v) => v.toJson()).toList();
    }if (leaders != null) {
      map['leaders'] = leaders?.map((v) => v.toJson()).toList();
    }
    return map;
  }
}
class Leaders {
  int? id;
  String? name;
  String? description;
  String? longDescription;
  String? type;
  String? poster;
  String? thumbnail;
  String? gener;
  dynamic studio;
  int? amountGiven;
  String? year;
  String? certificate;
  String? avgRunTime;
  String? language;
  int? runTime;
  dynamic amountRequired;

  Leaders(
      {this.id,
        this.name,
        this.description,
        this.longDescription,
        this.type,
        this.poster,
        this.thumbnail,
        this.gener,
        this.studio,
        this.amountGiven,
        this.year,
        this.certificate,
        this.avgRunTime,
        this.language,
        this.runTime,
        this.amountRequired});

  Leaders.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    description = json['description'];
    longDescription = json['longDescription'];
    type = json['type'];
    poster = json['poster'];
    thumbnail = json['thumbnail'];
    gener = json['gener'];
    studio = json['studio'];
    amountGiven = json['amount_given'];
    year = json['year'];
    certificate = json['certificate'];
    avgRunTime = json['avg_run_time'];
    language = json['language'];
    runTime = json['run_time'];
    amountRequired = json['amount_required'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['description'] = this.description;
    data['longDescription'] = this.longDescription;
    data['type'] = this.type;
    data['poster'] = this.poster;
    data['thumbnail'] = this.thumbnail;
    data['gener'] = this.gener;
    data['studio'] = this.studio;
    data['amount_given'] = this.amountGiven;
    data['year'] = this.year;
    data['certificate'] = this.certificate;
    data['avg_run_time'] = this.avgRunTime;
    data['language'] = this.language;
    data['run_time'] = this.runTime;
    data['amount_required'] = this.amountRequired;
    return data;
  }
}
class ContinueWatch {
  ContinueWatch({
    required this.id,
    required this.name,
    required this.thumbnail,
    required this.runTime,
  });

  int id;
  String name;
  String thumbnail;
  String runTime;

  factory ContinueWatch.fromMap(Map<String, dynamic> json) => ContinueWatch(
    id: json["id"],
    name: json["name"],
    thumbnail: json["thumbnail"],
    runTime: json["run_time"],
  );

  Map<String, dynamic> toMap() => {
    "id": id,
    "name": name,
    "thumbnail": thumbnail,
    "run_time": runTime,
  };
}

class Hot {
  Hot({
    this.id,
    this.name,
    this.description,
    this.poster,
    this.type,
    this.thumbnail,
  });

  Hot.fromJson(dynamic json) {
    id = json['id'];
    name = json['name'];
    description = json['description'];
    poster = json['poster'];
    type = json['type'];
    thumbnail = json['thumbnail'];
  }
  num? id;
  String? name;
  String? description;
  String? poster;
  String? type;
  String? thumbnail;
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
    this.thumbnail,
  });

  Recommended.fromJson(dynamic json) {
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

class Schemes {
  Schemes({
    this.id,
    this.name,
    this.description,
    this.poster,
    this.type,
    this.thumbnail,
  });

  Schemes.fromJson(dynamic json) {
    id = json['id'];
    name = json['name'];
    description = json['description'];
    poster = json['poster'];
    type = json['type'];
    thumbnail = json['thumbnail'];
  }
  num? id;
  String? name;
  dynamic description;
  String? poster;
  String? type;
  String? thumbnail;
  Schemes copyWith({
    num? id,
    String? name,
    dynamic description,
    String? poster,
    String? type,
  }) =>
      Schemes(
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

class Album {
  Album({
    this.id,
    this.title,
    this.thumbnailImage,
    this.coverImage,
    this.description,
    this.status,
    this.delete,
    this.createdAt,
    this.updatedAt,
  });

  Album.fromJson(dynamic json) {
    id = json['id'];
    title = json['title'];
    thumbnailImage = json['thumbnail_image'];
    coverImage = json['cover_image'];
    description = json['description'];
    status = json['status'];
    delete = json['delete'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }
  num? id;
  String? title;
  String? thumbnailImage;
  String? coverImage;
  String? description;
  num? status;
  num? delete;
  String? createdAt;
  dynamic updatedAt;
  Album copyWith({
    num? id,
    String? title,
    String? thumbnailImage,
    String? coverImage,
    String? description,
    num? status,
    num? delete,
    String? createdAt,
    dynamic updatedAt,
  }) =>
      Album(
        id: id ?? this.id,
        title: title ?? this.title,
        thumbnailImage: thumbnailImage ?? this.thumbnailImage,
        coverImage: coverImage ?? this.coverImage,
        description: description ?? this.description,
        status: status ?? this.status,
        delete: delete ?? this.delete,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['title'] = title;
    map['thumbnail_image'] = thumbnailImage;
    map['cover_image'] = coverImage;
    map['description'] = description;
    map['status'] = status;
    map['delete'] = delete;
    map['created_at'] = createdAt;
    map['updated_at'] = updatedAt;
    return map;
  }
}

class ShortFilms {
  ShortFilms({
    this.id,
    this.name,
    this.description,
    this.poster,
    this.type,
    this.thumbnail,
  });

  ShortFilms.fromJson(dynamic json) {
    id = json['id'];
    name = json['name'];
    description = json['description'];
    poster = json['poster'];
    type = json['type'];
    thumbnail = json['thumbnail'];
  }
  num? id;
  String? name;
  String? description;
  String? poster;
  String? type;
  String? thumbnail;
  ShortFilms copyWith({
    num? id,
    String? name,
    String? description,
    String? poster,
    String? type,
  }) =>
      ShortFilms(
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

class Stories {
  Stories({
    this.id,
    this.name,
    this.description,
    this.poster,
  });

  Stories.fromJson(dynamic json) {
    id = json['id'];
    name = json['name'];
    description = json['description'];
    poster = json['poster'];
  }
  num? id;
  String? name;
  String? description;
  String? poster;
  Stories copyWith({
    num? id,
    String? name,
    String? description,
    String? poster,
  }) =>
      Stories(
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
    this.thumbnail,
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
  }) =>
      Pickup(
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
    num? type,
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
        type: type.toString() ?? this.type,
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
