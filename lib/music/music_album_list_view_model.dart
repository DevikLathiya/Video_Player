import 'package:flutter/material.dart';
import 'package:hellomegha/core/api_factory/api.dart';
import 'package:hellomegha/core/api_factory/api_end_points.dart';
import 'package:hellomegha/core/api_factory/prefs/pref_utils.dart';
import 'package:hellomegha/core/utils/utils.dart';
import 'package:hellomegha/music/music_album_list.dart';
import 'package:hellomegha/view_models/hot_videos_model_view.dart';

class MusicAlbumListViewModel extends ChangeNotifier{
  MusicAlbumList? musicAlbumList;
  List<AlbumList>? albumList;

  Future<void> musicListAPI({required BuildContext context}) async {
    var params = {};
    Api.request(
      method: HttpMethod.get,
      path: ApiEndPoints.musicAlbumList,
      params: params,
      token: await PrefUtils.getToken() ?? "",
      isAuthorization: true,
      isCustomResponse: true,
      context: context,
      onResponse: (response) async {
        if (response['status'] != "false"){
          albumList = Data.fromJson(response["data"]).albumList;
          print(albumList![0].thumbnailImage!);
         // showSuccessSnackbar(response['message'], context);
          notifyListeners();
        }else {
          handleApiError(response['message'], context);
        }
      },
    );
  }



}