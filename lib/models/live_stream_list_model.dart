class LiveStreamListModel {
  LiveStreamListModel({
      this.livestream,});

  LiveStreamListModel.fromJson(dynamic json) {
    if (json['livestream'] != null) {
      livestream = [];
      json['livestream'].forEach((v) {
        livestream?.add(Livestream.fromJson(v));
      });
    }
  }
  List<Livestream>? livestream;
LiveStreamListModel copyWith({  List<Livestream>? livestream,
}) => LiveStreamListModel(  livestream: livestream ?? this.livestream,
);
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (livestream != null) {
      map['livestream'] = livestream?.map((v) => v.toJson()).toList();
    }
    return map;
  }

}

class Livestream {
  int? id;
  String? image;
  String? description;
  String? dateTime;
  String? type;
  String? link;
  int? userId;
  String? userName;
  int? isDelete;
  int? status;
  String? createdAt;
  String? updatedAt;

  Livestream(
      {this.id,
        this.image,
        this.description,
        this.dateTime,
        this.type,
        this.link,
        this.userId,
        this.userName,
        this.isDelete,
        this.status,
        this.createdAt,
        this.updatedAt});

  Livestream.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    image = json['image'];
    description = json['description'];
    dateTime = json['date_time'];
    type = json['type'];
    link = json['link'];
    userId = json['user_id'];
    userName = json['user_name'];
    isDelete = json['is_delete'];
    status = json['status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['image'] = this.image;
    data['description'] = this.description;
    data['date_time'] = this.dateTime;
    data['type'] = this.type;
    data['link'] = this.link;
    data['user_id'] = this.userId;
    data['user_name'] = this.userName;
    data['is_delete'] = this.isDelete;
    data['status'] = this.status;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}