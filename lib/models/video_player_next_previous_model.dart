// ignore_for_file: public_member_api_docs, sort_constructors_first
class VideoPlayerNextPreviousModel {
  String movieId;
  String? previousMovieId;
  String? nextMovieId;
  Map<String, String> urls;
  String movieName;
  String sid;
  int amountGiven;
  String? seekTo;

  VideoPlayerNextPreviousModel({
    required this.movieId,
    required this.previousMovieId,
    required this.nextMovieId,
    required this.urls,
    required this.movieName,
    required this.sid,
    required this.amountGiven,
    this.seekTo,
  });
}
