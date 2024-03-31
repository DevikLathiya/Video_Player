class Leadership {
  bool? status;
  String? message;
  LeadershipData? data;

  Leadership({this.status, this.message, this.data});

  Leadership.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ? new LeadershipData.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class LeadershipData {
  List<LeadershipList>? leadershipList;

  LeadershipData({this.leadershipList});

  LeadershipData.fromJson(Map<String, dynamic> json) {
    if (json['leader_list'] != null) {
      leadershipList = <LeadershipList>[];
      json['leader_list'].forEach((v) {
        leadershipList!.add(new LeadershipList.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.leadershipList != null) {
      data['leader_list '] =
          this.leadershipList!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class LeadershipList {
  int? id;
  String? name;
  String? description;
  String? poster;
  String? type;

  LeadershipList(
      {this.id, this.name, this.description, this.poster, this.type});

  LeadershipList.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    description = json['description'];
    poster = json['poster'];
    type = json['type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['description'] = this.description;
    data['poster'] = this.poster;
    data['type'] = this.type;
    return data;
  }
}
