import 'package:flutter/material.dart';
import 'package:hellomegha/MusicArtist/music_artist_model.dart';
import 'package:hellomegha/core/api_factory/api.dart';
import 'package:hellomegha/core/api_factory/api_end_points.dart';
import 'package:hellomegha/core/api_factory/prefs/pref_utils.dart';
import 'package:hellomegha/core/utils/utils.dart';

class MusicArtistListViewModel extends ChangeNotifier{
  List<MusicartistList>? musicartistList;


  Future<void> musicArtistListAPI({required BuildContext context}) async {
    var params = {};
    Api.request(
      method: HttpMethod.get,
      path: ApiEndPoints.musicartistlist,
      params: params,
      token: await PrefUtils.getToken() ?? "",
      isAuthorization: true,
      isCustomResponse: true,
      context: context,
      onResponse: (response) async {
        if (response['status'] != "false"){
          musicartistList = MovieArtistData.fromJson(response["data"]).musicartistList;
          print("ShortFilmList"+musicartistList![0].title.toString());
          // showSuccessSnackbar(response['message'], context);
          notifyListeners();
        }else {
          handleApiError(response['message'], context);
        }
      },
    );
  }


}