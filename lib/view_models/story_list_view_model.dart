import 'package:flutter/material.dart';
import 'package:hellomegha/core/api_factory/api.dart';
import 'package:hellomegha/core/api_factory/api_end_points.dart';
import 'package:hellomegha/core/api_factory/prefs/pref_utils.dart';
import 'package:hellomegha/core/utils/utils.dart';
import 'package:hellomegha/models/movie_list.dart';
import 'package:hellomegha/models/story_list_model.dart';

class StoryListViewModel extends ChangeNotifier{
  StoryListModel? storyListModel;


  Future<void> storyListAPI({required BuildContext context}) async {
    var params = {};
    Api.request(
      method: HttpMethod.get,
      path: ApiEndPoints.stories_list,
      params: params,
      token: await PrefUtils.getToken() ?? "",
      isAuthorization: true,
      isCustomResponse: true,
      context: context,
      onResponse: (response) async {
        if (response['status'] != "false"){
          storyListModel = StoryListModel.fromJson(response['data']);
         // showSuccessSnackbar(response['message'], context);
          notifyListeners();
        }else {
          handleApiError(response['message'], context);
        }
      },
    );
  }


}