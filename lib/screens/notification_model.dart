class NotificationModel {
  NotificationModel({
      this.notifications,});

  NotificationModel.fromJson(dynamic json) {
    if (json['notifications'] != null) {
      notifications = [];
      json['notifications'].forEach((v) {
        notifications?.add(Notifications.fromJson(v));
      });
    }
  }
  List<Notifications>? notifications;
NotificationModel copyWith({  List<Notifications>? notifications,
}) => NotificationModel(  notifications: notifications ?? this.notifications,
);
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (notifications != null) {
      map['notifications'] = notifications?.map((v) => v.toJson()).toList();
    }
    return map;
  }

}

class Notifications {
  Notifications({
      this.nId, 
      this.image, 
      this.type, 
      this.name, 
      this.description, 
      this.movieId,});

  Notifications.fromJson(dynamic json) {
    nId = json['nId'];
    image = json['image'];
    type = json['type'];
    name = json['name'];
    description = json['description'];
    movieId = json['movie_id'];
  }
  num? nId;
  String? image;
  String? type;
  String? name;
  String? description;
  num? movieId;
Notifications copyWith({  num? nId,
  String? image,
  String? type,
  String? name,
  String? description,
  num? movieId,
}) => Notifications(  nId: nId ?? this.nId,
  image: image ?? this.image,
  type: type ?? this.type,
  name: name ?? this.name,
  description: description ?? this.description,
  movieId: movieId ?? this.movieId,
);
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['nId'] = nId;
    map['image'] = image;
    map['type'] = type;
    map['name'] = name;
    map['description'] = description;
    map['movie_id'] = movieId;
    return map;
  }

}