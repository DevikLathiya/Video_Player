class Download {
  String? taskId;
  String? movieName;
  String? fileName;
  String? poster;
  String? qty;
  String? movieId;
  String? movieUrl;
  Download(
      {this.taskId,
      required this.movieName,
      this.fileName,
      required this.poster,
      required this.qty,
      required this.movieUrl,
      required this.movieId});

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'movieName': movieName,
      'fileName': fileName,
      'poster': poster,
      'qty': qty,
      'movieId': movieId,
      'movieUrl': movieUrl,
      'taskId': taskId
    };
  }

  factory Download.fromMap(Map<String, dynamic> map) {
    return Download(
        movieName: map['movieName'],
        fileName: map['fileName'],
        poster: map['poster'],
        qty: map['qty'],
        movieId: map['movieId'],
        movieUrl: map['movieUrl'],
        taskId: map['taskId']);
  }
}
