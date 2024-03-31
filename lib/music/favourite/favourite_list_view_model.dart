import 'package:flutter/material.dart';
import 'package:hellomegha/TodaysPicup/top_picked.dart';
import 'package:hellomegha/core/api_factory/api.dart';
import 'package:hellomegha/core/api_factory/api_end_points.dart';
import 'package:hellomegha/core/api_factory/prefs/pref_utils.dart';
import 'package:hellomegha/core/utils/utils.dart';
import 'package:hellomegha/music/favourite/favourite_list_model.dart';
import 'package:hellomegha/music/music_album_list.dart';
import 'package:hellomegha/music/music_play_list_model.dart';

class FavouriteListViewModel extends ChangeNotifier{
  List<UserFavourite>? favouriteList;
  Future<void> favouriteListAPI({required BuildContext context}) async {
    var params = {};
    Api.request(
      method: HttpMethod.post,
      path: ApiEndPoints.favourite_mp3,
      params: params,
      token: await PrefUtils.getToken() ?? "",
      isAuthorization: true,
      isCustomResponse: true,
      context: context,
      onResponse: (response) async {
        if (response['status'] != "false"){
          favouriteList = UserFavouriteList.fromJson(response["data"]).userFavourite;
          print("TopPickedList==$favouriteList");
          // showSuccessSnackbar(response['message'], context);
          notifyListeners();
        }else {
          handleApiError(response['message'], context);
        }
      },
    );
  }


}