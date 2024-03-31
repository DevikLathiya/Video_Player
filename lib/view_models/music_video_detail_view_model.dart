import 'package:flutter/material.dart';
import 'package:hellomegha/core/api_factory/api.dart';
import 'package:hellomegha/core/api_factory/api_end_points.dart';
import 'package:hellomegha/core/api_factory/prefs/pref_utils.dart';
import 'package:hellomegha/core/utils/utils.dart';
import 'package:hellomegha/models/movie_detail_model.dart';
import 'package:hellomegha/models/music_video_detail_model.dart';
import 'package:hellomegha/models/suggetion_music_video_model.dart';

class MusicVideoDetailViewModel extends ChangeNotifier {
  MusicVideoDetailModel? musicVideoDetailModel;
  SuggetionMusicVideoModel? suggestMusicVideoModel;

  Future<void> musicVideoDetailsAPI({
    required BuildContext context,
    required String Id,
    void Function(List<MovieVideo>, int previousId, int nextId)? videos,
  }) async {
    var params = {};
    Api.request(
      method: HttpMethod.get,
      path: '${ApiEndPoints.musicVideoDetail}/$Id',
      params: params,
      token: await PrefUtils.getToken() ?? "",
      isAuthorization: true,
      isCustomResponse: true,
      context: context,
      onResponse: (response) async {
        if (response['status'] != "false") {
          musicVideoDetailModel =
              MusicVideoDetailModel.fromJson(response['data']);
          if (videos != null) {
            if (musicVideoDetailModel!.musicDtails!.movieVideos != null ||
                musicVideoDetailModel!.musicDtails!.movieVideos!.isNotEmpty) {
              final movies = musicVideoDetailModel!.musicDtails!.movieVideos!
                  .where(((element) => element.type == QtyType.MOVIE))
                  .toList();

              movies.sort(
                  (a, b) => int.parse(a.qty!).compareTo(int.parse(b.qty!)));
              videos.call(movies, musicVideoDetailModel!.preciousrecordId ?? -1,
                  musicVideoDetailModel!.nextrecordId ?? -1);
            }
          }
       
          if(musicVideoDetailModel!.musicDtails!.gener != null && musicVideoDetailModel!.musicDtails!.gener!.isNotEmpty){
          suggestMusicVideoAPI(
              context: context, Id: musicVideoDetailModel!.musicDtails!.gener!);
       
          }
          notifyListeners();
        } else {
          handleApiError(response['message'], context);
        }
      },
    );
  }

  Future<void> suggestMusicVideoAPI({
    required BuildContext context,
    required String Id,
  }) async {
    var params = {};
    Api.request(
      method: HttpMethod.get,
      path: '${ApiEndPoints.musicVideoSuggest}/$Id',
      params: params,
      token: await PrefUtils.getToken() ?? "",
      isAuthorization: true,
      isCustomResponse: true,
      context: context,
      onResponse: (response) async {
        if (response['status'] != "false") {
          suggestMusicVideoModel =
              SuggetionMusicVideoModel.fromJson(response['data']);
          // showSuccessSnackbar(response['message'], context);
          notifyListeners();
        } else {
          handleApiError(response['message'], context);
        }
      },
    );
  }
}
