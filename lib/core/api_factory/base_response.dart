class BaseResponse {
  Map<String, dynamic>? data;
  List? error;
  bool? status;
  String? message;

  BaseResponse({this.data, this.error, this.status, this.message});

  factory BaseResponse.fromJson(Map<String, dynamic> json) {
    return BaseResponse(
      data: json['data'],
      error: json['errors'] != null
          ? (json['errors'] as List).map((i) => i).toList()
          : null,
      status: json['status'],
      message: json['message'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['message'] = message;
    if (this.data != null) {
      data['data'] = this.data;
    }

    if (error != null) {
      data['errors'] = error!.map((v) => v).toList();
    }

    return data;
  }
}
