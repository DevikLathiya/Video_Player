import 'package:flutter/material.dart';
import 'package:hellomegha/core/api_factory/api.dart';
import 'package:hellomegha/core/api_factory/api_end_points.dart';
import 'package:hellomegha/core/api_factory/prefs/pref_utils.dart';
import 'package:hellomegha/core/utils/utils.dart';
import 'package:hellomegha/models/searchmusicmodel.dart';

class SearchMusicModel extends ChangeNotifier{
  List<AlbumMp3List>? searchmusicdata;


  Future<void> SearchMusicModelAPI({required BuildContext context,required String search}) async {
    var params = {
      "search": "$search",
    };
    Api.request(
      method: HttpMethod.post,
      path: ApiEndPoints.search_music,
      params: params,
      token: await PrefUtils.getToken() ?? "",
      isAuthorization: true,
      isCustomResponse: true,
      context: context,
      isLoading: false,
      onResponse: (response) async {
        print("search=$response");
        if (response['status'] != "false"){
          searchmusicdata = searchMusicModel.fromJson(response['data']).data;
          print("length=${searchmusicdata!.length}");
          // showSuccessSnackbar(response['message'], context);
          notifyListeners();
        }else {
          handleApiError(response['message'], context);
        }
      },
    );
  }


}