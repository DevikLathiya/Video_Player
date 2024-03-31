class StoryDetailModel {
  StoryDetailModel({
      this.storiesDetails,});

  StoryDetailModel.fromJson(dynamic json) {
    if (json['stories_details'] != null) {
      storiesDetails = [];
      json['stories_details'].forEach((v) {
        storiesDetails?.add(StoriesDetails.fromJson(v));
      });
    }
  }
  List<StoriesDetails>? storiesDetails;
StoryDetailModel copyWith({  List<StoriesDetails>? storiesDetails,
}) => StoryDetailModel(  storiesDetails: storiesDetails ?? this.storiesDetails,
);
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (storiesDetails != null) {
      map['stories_details'] = storiesDetails?.map((v) => v.toJson()).toList();
    }
    return map;
  }

}

class StoriesDetails {
  StoriesDetails({
    this.id,
    this.name,
    this.description,
    this.longDescription,
    this.poster,
    this.video,
    this.thumbnail,
    this.trailer,
    this.gener,
    this.type,
    this.updatedAt,
    this.city});

  StoriesDetails.fromJson(dynamic json) {
    id = json['id'];
    name = json['name'];
    description = json['description'];
    longDescription = json['longDescription'];
    poster = json['poster'];
    video = json['video'];
    thumbnail = json['thumbnail'];
    trailer = json['trailer'];
    gener = json['gener'];
    type = json['type'];
    updatedAt = json['updated_at'];
    city = json['city'];
  }
  num? id;
  String? name;
  String? description;
  String? longDescription;
  String? poster;
  String? video;
  String? thumbnail;
  String? trailer;
  String? gener;
  String? type;
  String? updatedAt;
  String? city;
StoriesDetails copyWith({  num? id,
  String? name,
  String? description,
  String? longDescription,
  String? poster,
  String? video,
  String? thumbnail,
  String? trailer,
  String? gener,
  String? type,
  String? updatedAt,
  String? city,
}) => StoriesDetails(  id: id ?? this.id,
  name: name ?? this.name,
  description: description ?? this.description,
  poster: poster ?? this.poster,
  video: video ?? this.video,
  thumbnail: thumbnail ?? this.thumbnail,
  trailer: trailer ?? this.trailer,
  longDescription: longDescription ?? this.longDescription,
  gener: gener ?? this.gener,
  type: type ?? this.type,
  updatedAt: updatedAt ?? this.updatedAt,
  city: city ?? this.city,

);
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['description'] = this.description;
    data['longDescription'] = this.longDescription;
    data['poster'] = this.poster;
    data['video'] = this.video;
    data['thumbnail'] = this.thumbnail;
    data['trailer'] = this.trailer;
    data['gener'] = this.gener;
    data['type'] = this.type;
    data['updated_at'] = this.updatedAt;
    data['city'] = this.city;
    return data;
  }

}