class MusicVideoList {
  MusicVideoList({
    required this.status,
    required this.message,
    required this.data,
    required this.error,
    required this.links,
  });

  bool status;
  String message;
  Data data;
  List<dynamic> error;
  List<dynamic> links;

  factory MusicVideoList.fromMap(Map<String, dynamic> json) => MusicVideoList(
        status: json["status"],
        message: json["message"],
        data: Data.fromMap(json["data"]),
        error: List<dynamic>.from(json["error"].map((x) => x)),
        links: List<dynamic>.from(json["_links"].map((x) => x)),
      );

  Map<String, dynamic> toMap() => {
        "status": status,
        "message": message,
        "data": data.toMap(),
        "error": List<dynamic>.from(error.map((x) => x)),
        "_links": List<dynamic>.from(links.map((x) => x)),
      };
}

class Data {
  Data({
    required this.musicvideoList,
  });

  List<MusicvideoList> musicvideoList;

  factory Data.fromMap(Map<String, dynamic> json) => Data(
        musicvideoList: List<MusicvideoList>.from(
            json["musicvideo_list"].map((x) => MusicvideoList.fromMap(x))),
      );

  Map<String, dynamic> toMap() => {
        "musicvideo_list":
            List<dynamic>.from(musicvideoList.map((x) => x.toMap())),
      };
}

class MusicvideoList {
  MusicvideoList({
    required this.id,
    required this.name,
    required this.description,
    this.longDescription,
    required this.type,
    required this.poster,
  });

  int id;
  String name;
  String description;
  String? longDescription;
  String type;
  String poster;

  factory MusicvideoList.fromMap(Map<String, dynamic> json) => MusicvideoList(
        id: json["id"],
        name: json["name"],
        description: json["description"],
        longDescription: json["longDescription"],
        type: json["type"],
        poster: json["poster"],
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "name": name,
        "description": description,
        "longDescription": longDescription,
        "type": type,
        "poster": poster,
      };
}
