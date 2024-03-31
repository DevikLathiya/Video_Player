class MyListModel {
  MyListModel({
      this.userFavourite, 
      this.user,});

  MyListModel.fromJson(dynamic json) {
    if (json['user_favourite'] != null) {
      userFavourite = [];
      json['user_favourite'].forEach((v) {
        userFavourite?.add(UserFavourite.fromJson(v));
      });
    }
    user = json['user'] != null ? User.fromJson(json['user']) : null;
  }
  List<UserFavourite>? userFavourite;
  User? user;
MyListModel copyWith({  List<UserFavourite>? userFavourite,
  User? user,
}) => MyListModel(  userFavourite: userFavourite ?? this.userFavourite,
  user: user ?? this.user,
);
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (userFavourite != null) {
      map['user_favourite'] = userFavourite?.map((v) => v.toJson()).toList();
    }
    if (user != null) {
      map['user'] = user?.toJson();
    }
    return map;
  }

}

class User {
  User({
      this.id, 
      this.name, 
      this.email, 
      this.mobile, 
      this.emailVerifiedAt, 
      this.wallet, 
      this.earning, 
      this.status, 
      this.isDelete, 
      this.watchMin, 
      this.createdAt, 
      this.updatedAt,});

  User.fromJson(dynamic json) {
    id = json['id'];
    name = json['name'];
    email = json['email'];
    mobile = json['mobile'];
    emailVerifiedAt = json['email_verified_at'];
    wallet = json['wallet'];
    earning = json['earning'];
    status = json['status'];
    isDelete = json['is_delete'];
    watchMin = json['watch_min'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }
  num? id;
  String? name;
  String? email;
  String? mobile;
  dynamic emailVerifiedAt;
  num? wallet;
  num? earning;
  num? status;
  num? isDelete;
  dynamic watchMin;
  String? createdAt;
  String? updatedAt;
User copyWith({  num? id,
  String? name,
  String? email,
  String? mobile,
  dynamic emailVerifiedAt,
  num? wallet,
  num? earning,
  num? status,
  num? isDelete,
  dynamic watchMin,
  String? createdAt,
  String? updatedAt,
}) => User(  id: id ?? this.id,
  name: name ?? this.name,
  email: email ?? this.email,
  mobile: mobile ?? this.mobile,
  emailVerifiedAt: emailVerifiedAt ?? this.emailVerifiedAt,
  wallet: wallet ?? this.wallet,
  earning: earning ?? this.earning,
  status: status ?? this.status,
  isDelete: isDelete ?? this.isDelete,
  watchMin: watchMin ?? this.watchMin,
  createdAt: createdAt ?? this.createdAt,
  updatedAt: updatedAt ?? this.updatedAt,
);
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['name'] = name;
    map['email'] = email;
    map['mobile'] = mobile;
    map['email_verified_at'] = emailVerifiedAt;
    map['wallet'] = wallet;
    map['earning'] = earning;
    map['status'] = status;
    map['is_delete'] = isDelete;
    map['watch_min'] = watchMin;
    map['created_at'] = createdAt;
    map['updated_at'] = updatedAt;
    return map;
  }

}

class UserFavourite {
  UserFavourite({
      this.vid, 
      this.name, 
      this.thumbnail, 
      this.type,});

  UserFavourite.fromJson(dynamic json) {
    vid = json['vid'];
    name = json['name'];
    thumbnail = json['thumbnail'];
    type = json['type'];
  }
  num? vid;
  String? name;
  String? thumbnail;
  String? type;
UserFavourite copyWith({  num? vid,
  String? name,
  String? thumbnail,
  String? type,
}) => UserFavourite(  vid: vid ?? this.vid,
  name: name ?? this.name,
  thumbnail: thumbnail ?? this.thumbnail,
  type: type ?? this.type,
);
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['vid'] = vid;
    map['name'] = name;
    map['thumbnail'] = thumbnail;
    map['type'] = type;
    return map;
  }

}