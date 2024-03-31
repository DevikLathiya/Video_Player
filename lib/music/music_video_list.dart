import 'package:flutter/material.dart';
import 'package:hellomegha/core/api_factory/api.dart';
import 'package:hellomegha/core/api_factory/api_end_points.dart';
import 'package:hellomegha/core/api_factory/prefs/pref_utils.dart';
import 'package:hellomegha/core/utils/utils.dart';
import 'package:hellomegha/music/music_video_model.dart';

class MusicVideoListViewModel extends ChangeNotifier {
  MusicVideoList? musicAlbumList;
  List<MusicvideoList>? musicVideoList;

  Future<void> musicListAPI({required BuildContext context}) async {
    var params = {};
    Api.request(
      method: HttpMethod.get,
      path: ApiEndPoints.musicList,
      params: params,
      token: await PrefUtils.getToken() ?? "",
      isAuthorization: true,
      isCustomResponse: true,
      context: context,
      onResponse: (response) async {
        if (response['status'] != "false") {
          musicVideoList = Data.fromMap(response["data"]).musicvideoList;
          // showSuccessSnackbar(response['message'], context);
          notifyListeners();
        } else {
          handleApiError(response['message'], context);
        }
      },
    );
  }
}
