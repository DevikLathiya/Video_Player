class HomeVideoModel {
  HomeVideoModel({
    this.sliders,
    this.stories,
    this.influncer,
    this.scheme,
  });

  HomeVideoModel.fromJson(dynamic json) {
    if (json['sliders'] != null) {
      sliders = [];
      json['sliders'].forEach((v) {
        sliders?.add(Sliders.fromJson(v));
      });
    }
    if (json['stories'] != null) {
      stories = [];
      json['stories'].forEach((v) {
        stories?.add(Stories.fromJson(v));
      });
    }
    if (json['influncer'] != null) {
      influncer = [];
      json['influncer'].forEach((v) {
        influncer?.add(Influncer.fromJson(v));
      });
    }
    if (json['scheme'] != null) {
      scheme = [];
      json['scheme'].forEach((v) {
        scheme?.add(Scheme.fromJson(v));
      });
    }
  }
  List<Sliders>? sliders;
  List<Stories>? stories;
  List<Influncer>? influncer;
  List<Scheme>? scheme;
  HomeVideoModel copyWith({
    List<Sliders>? sliders,
    List<Stories>? stories,
    List<Influncer>? influncer,
    List<Scheme>? scheme,
  }) =>
      HomeVideoModel(
        sliders: sliders ?? this.sliders,
        stories: stories ?? this.stories,
        influncer: influncer ?? this.influncer,
        scheme: scheme ?? this.scheme,
      );
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (sliders != null) {
      map['sliders'] = sliders?.map((v) => v.toJson()).toList();
    }
    if (stories != null) {
      map['stories'] = stories?.map((v) => v.toJson()).toList();
    }
    if (influncer != null) {
      map['influncer'] = influncer?.map((v) => v.toJson()).toList();
    }
    if (scheme != null) {
      map['scheme'] = scheme?.map((v) => v.toJson()).toList();
    }
    return map;
  }
}

class Influncer {
  Influncer({
    this.id,
    this.name,
    this.description,
    this.poster,
    this.type,
  });

  Influncer.fromJson(dynamic json) {
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
  Influncer copyWith({
    num? id,
    String? name,
    String? description,
    String? poster,
    String? type,
  }) =>
      Influncer(
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

class Scheme {
  Scheme({
    this.id,
    this.name,
    this.description,
    this.poster,
    this.type,
  });

  Scheme.fromJson(dynamic json) {
    id = json['id'];
    name = json['name'];
    description = json['description'];
    poster = json['poster'];
    thumbnail = json['thumbnail'];
    type = json['type'];
  }
  num? id;
  String? name;
  String? description;
  String? poster;
  String? thumbnail;
  String? type;
  Influncer copyWith({
    num? id,
    String? name,
    String? description,
    String? poster,
    String? type,
  }) =>
      Influncer(
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
    thumbnail = json['thumbnail'];
  }
  num? id;
  String? name;
  String? description;
  String? poster;
  String? thumbnail;
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
    thumbnail = json['thumbnail'];
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
  String? thumbnail;
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
