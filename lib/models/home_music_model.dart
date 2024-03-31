class HomeMusicModel {
  HomeMusicModel({
    this.sliders,
    this.pickup,
    this.recommended,
    this.hot,
    this.albums,
    this.musicArtists,
  });


  @override
  String toString() {
    return 'HomeMusicModel{sliders: $sliders, pickup: $pickup, recommended: $recommended, hot: $hot, albums: $albums, musicArtists: $musicArtists}';
  }

  HomeMusicModel.fromJson(dynamic json) {
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
    if (json['albums'] != null) {
      albums = [];
      json['albums'].forEach((v) {
        albums?.add(Albums.fromJson(v));
      });
    }
    if (json['musicArtists'] != null) {
      musicArtists = [];
      json['musicArtists'].forEach((v) {
        musicArtists?.add(MusicArtists.fromJson(v));
      });
    }
  }
  List<Sliders>? sliders;
  List<Pickup>? pickup;
  List<Recommended>? recommended;
  List<Hot>? hot;
  List<Albums>? albums;
  List<MusicArtists>? musicArtists;
  HomeMusicModel copyWith({
    List<Sliders>? sliders,
    List<Pickup>? pickup,
    List<Recommended>? recommended,
    List<Hot>? hot,
    List<Albums>? albums,
    List<MusicArtists>? musicArtists,
  }) =>
      HomeMusicModel(
        sliders: sliders ?? this.sliders,
        pickup: pickup ?? this.pickup,
        recommended: recommended ?? this.recommended,
        hot: hot ?? this.hot,
        albums: albums ?? this.albums,
        musicArtists: musicArtists ?? this.musicArtists,
      );
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
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
    if (albums != null) {
      map['albums'] = albums?.map((v) => v.toJson()).toList();
    }
    if (musicArtists != null) {
      map['musicArtists'] = musicArtists?.map((v) => v.toJson()).toList();
    }
    return map;
  }
}

class Pickup {
  Pickup({
    this.id,
    this.name,
    this.description,
    this.poster,
  });

  Pickup.fromJson(dynamic json) {
    id = json['id'];
    name = json['name'];
    description = json['description'];
    poster = json['poster'];
  }
  num? id;
  String? name;
  String? description;
  String? poster;
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

class MusicArtists {
  MusicArtists({
    this.id,
    this.title,
    this.image,
    this.description,
    this.status,
    this.delete,
    this.createdAt,
    this.updatedAt,
  });

  MusicArtists.fromJson(dynamic json) {
    id = json['id'];
    title = json['title'];
    image = json['image'];
    description = json['description'];
    status = json['status'];
    delete = json['delete'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }
  num? id;
  String? title;
  String? image;
  String? description;
  num? status;
  num? delete;
  String? createdAt;
  dynamic updatedAt;
  MusicArtists copyWith({
    num? id,
    String? title,
    String? image,
    String? description,
    num? status,
    num? delete,
    String? createdAt,
    dynamic updatedAt,
  }) =>
      MusicArtists(
        id: id ?? this.id,
        title: title ?? this.title,
        image: image ?? this.image,
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
    map['image'] = image;
    map['description'] = description;
    map['status'] = status;
    map['delete'] = delete;
    map['created_at'] = createdAt;
    map['updated_at'] = updatedAt;
    return map;
  }
}

class Albums {
  Albums({
    this.id,
    this.name,
    this.thumbnailImage,
    this.coverImage,
    this.description,
    this.status,
    this.delete,
    this.createdAt,
    this.updatedAt,
  });

  Albums.fromJson(dynamic json) {
    id = json['id'];
    name = json['name'];
    thumbnailImage = json['thumbnail'];
    coverImage = json['cover_image'];
    description = json['description'];
    status = json['status'];
    delete = json['delete'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }
  num? id;
  String? name;
  String? thumbnailImage;
  String? coverImage;
  String? description;
  num? status;
  num? delete;
  String? createdAt;
  dynamic updatedAt;
  Albums copyWith({
    num? id,
    String? name,
    String? thumbnailImage,
    String? coverImage,
    String? description,
    num? status,
    num? delete,
    String? createdAt,
    dynamic updatedAt,
  }) =>
      Albums(
        id: id ?? this.id,
        name: name ?? this.name,
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
    map['name'] = name;
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

  @override
  String toString() {
    return 'Sliders{id: $id, sliderImage: $sliderImage, movieId: $movieId, title: $title, type: $type, status: $status, isDelete: $isDelete, createdAt: $createdAt, updatedAt: $updatedAt, thuslierImagembnail: $thuslierImagembnail, thumbnail: $thumbnail}';
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
