import 'package:flutter/material.dart';
import 'package:hellomegha/core/api_factory/api.dart';
import 'package:hellomegha/core/api_factory/api_end_points.dart';
import 'package:hellomegha/core/api_factory/prefs/pref_utils.dart';
import 'package:hellomegha/core/utils/utils.dart';
import 'package:hellomegha/music/music_album_list.dart';
import 'package:hellomegha/music/music_play_list_model.dart';
import 'package:hellomegha/view_models/hot_videos_model_view.dart';

class MusicPlayListViewModel extends ChangeNotifier{
  List<AlbumMp3List>? playList;

  Future<void> musicPlayListAPI({required BuildContext context}) async {
    var params = {};
    Api.request(
      method: HttpMethod.get,
      path: ApiEndPoints.albummusic,
      params: params,
      token: await PrefUtils.getToken() ?? "",
      isAuthorization: true,
      isCustomResponse: true,
      context: context,
      onResponse: (response) async {
        if (response['status'] != "false"){
          playList = MusicPlayListData.fromJson(response["data"]).albumMp3List;
          print(playList![0].title!);
         // showSuccessSnackbar(response['message'], context);
          notifyListeners();
        }else {
          handleApiError(response['message'], context);
        }
      },
    );
  }



}