class RecoomendedMovieList {
  bool? status;
  String? message;
  Data? data;
  List? error;
  List? lLinks;

  RecoomendedMovieList(
      {this.status, this.message, this.data, this.error, this.lLinks});

  RecoomendedMovieList.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
    // if (json['error'] != null) {
    //   error = <Null>[];
    //   json['error'].forEach((v) {
    //     error!.add(new Null.fromJson(v));
    //   });
    // }
    // if (json['_links'] != null) {
    //   lLinks = <Null>[];
    //   json['_links'].forEach((v) {
    //     lLinks!.add(new Null.fromJson(v));
    //   });
    // }
  }


  @override
  String toString() {
    return 'RecoomendedMovieList{status: $status, message: $message, data: $data, error: $error, lLinks: $lLinks}';
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    // if (this.error != null) {
    //   data['error'] = this.error!.map((v) => v.toJson()).toList();
    // }
    // if (this.lLinks != null) {
    //   data['_links'] = this.lLinks!.map((v) => v.toJson()).toList();
    // }
    return data;
  }
}

class Data {
  List<Movielist>? movielist;

  @override
  String toString() {
    return 'Data{movielist: $movielist}';
  }

  Data({this.movielist});

  Data.fromJson(Map<String, dynamic> json) {
    if (json['movielist'] != null) {
      movielist = <Movielist>[];
      json['movielist'].forEach((v) {
        movielist!.add(new Movielist.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.movielist != null) {
      data['movielist'] = this.movielist!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Movielist {
  int? id;
  String? name;
  String? description;
  String? longDescription;
  String? type;
  String? poster;

  @override
  String toString() {
    return 'Movielist{id: $id, name: $name, description: $description, longDescription: $longDescription, type: $type, poster: $poster}';
  }

  Movielist(
      {this.id,
        this.name,
        this.description,
        this.longDescription,
        this.type,
        this.poster});

  Movielist.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    description = json['description'];
    longDescription = json['longDescription'];
    type = json['type'];
    poster = json['poster'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['description'] = this.description;
    data['longDescription'] = this.longDescription;
    data['type'] = this.type;
    data['poster'] = this.poster;
    return data;
  }
}