import 'package:flutter/material.dart';
import 'package:hellomegha/core/api_factory/api.dart';
import 'package:hellomegha/core/api_factory/api_end_points.dart';
import 'package:hellomegha/core/api_factory/prefs/pref_utils.dart';
import 'package:hellomegha/core/utils/utils.dart';
import 'package:hellomegha/models/movie_detail_model.dart';
import 'package:hellomegha/models/suggest_movie_model.dart';
import 'package:hellomegha/models/video_player_next_previous_model.dart';

class MovieDetailViewModel extends ChangeNotifier {
  MovieDetailModel? movieDetails;
  SuggestMovieModel? suggestMovieModel;

  Future<void> moviesDetailsAPI(
      {required BuildContext context,
      required String movieId,
      Function(
        VideoPlayerNextPreviousModel moviedetail,
      )?
          onSuccess,
      QtyType? videoType,
      bool? isLoading}) async {
    var params = {};
    Api.request(
      method: HttpMethod.get,
      path: '${ApiEndPoints.movieDetails}/$movieId',
      params: params,
      token: await PrefUtils.getToken() ?? "",
      isAuthorization: true,
      isCustomResponse: true,
      context: context,
      isLoading: isLoading ?? true,
      onResponse: (response) async {
        if (response['status'] != "false") {
          movieDetails = MovieDetailModel.fromMap(response['data']);
          if(movieDetails!.movieDtails!.gener != null && movieDetails!.movieDtails!.gener!.isNotEmpty){
          suggestMovieAPI(
              context: context, movieId: movieDetails!.movieDtails!.gener!);
          }

          // showSuccessSnackbar(response['message'], context);
          if (onSuccess != null) {
            final videos = movieDetails!.movieDtails!.movieVideos!
                .where(((element) => element.type == videoType))
                .toList();
            videos
                .sort((a, b) => int.parse(a.qty!).compareTo(int.parse(b.qty!)));
            Map<String, String> urls = {};
            for (var element in videos) {
              urls[element.qty!] = element.fileName!;
            }
            onSuccess.call(VideoPlayerNextPreviousModel(
              movieId: movieDetails!.movieDtails!.id.toString(),
              previousMovieId: movieDetails!.preciousrecordId.toString(),
              nextMovieId: movieDetails!.nextrecordId.toString(),
              urls: urls,
              movieName: movieDetails!.movieDtails!.name!,
              amountGiven: movieDetails!.movieDtails!.amountGiven ?? 0,
              sid: movieDetails!.movieDtails!.studio ?? "",
            ));
          }
          notifyListeners();
        } else {
          handleApiError(response['message'], context);
        }
      },
    );
  }

  Future<void> suggestMovieAPI({
    required BuildContext context,
    required String movieId,
  }) async {
    var params = {};
    Api.request(
      method: HttpMethod.get,
      path: '${ApiEndPoints.suggestMovies}/1',
      params: params,
      token: await PrefUtils.getToken() ?? "",
      isAuthorization: true,
      isCustomResponse: true,
      context: context,
      onResponse: (response) async {
        if (response['status'] != "false") {
          suggestMovieModel = SuggestMovieModel.fromJson(response['data']);
          // showSuccessSnackbar(response['message'], context);
          notifyListeners();
        } else {
          handleApiError(response['message'], context);
        }
      },
    );
  }

  Future<void> updateFavourite(
      {required BuildContext context,
      required String videoId,
      required String fav}) async {
    var params = {"vid": videoId, "fav": fav};
    Api.request(
      method: HttpMethod.post,
      path: ApiEndPoints.updateFavourite,
      params: params,
      token: await PrefUtils.getToken() ?? "",
      isAuthorization: true,
      isCustomResponse: true,
      context: context,
      onResponse: (response) async {
        if (fav == '1') {
          movieDetails!.isFavourite = true;
        } else {
          movieDetails!.isFavourite = false;
        }

        notifyListeners();
      },
    );
  }
}
