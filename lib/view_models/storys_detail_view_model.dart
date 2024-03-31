import 'package:flutter/material.dart';
import 'package:hellomegha/core/api_factory/api.dart';
import 'package:hellomegha/core/api_factory/api_end_points.dart';
import 'package:hellomegha/core/api_factory/prefs/pref_utils.dart';
import 'package:hellomegha/core/utils/utils.dart';
import 'package:hellomegha/models/movie_detail_model.dart';
import 'package:hellomegha/models/movie_list.dart';
import 'package:hellomegha/models/story_detail_model.dart';
import 'package:hellomegha/models/suggest_story_model.dart';

class StoryDetailViewModel extends ChangeNotifier{
  StoryDetailModel? storyDetailModel;
  SuggestStoryModel? suggestStoryModel;

  Future<void> storyDetailsAPI({required BuildContext context,  required String story}) async {
    var params = {};
    Api.request(
      method: HttpMethod.get,
      path: '${ApiEndPoints.storyDetail}/$story',
      params: params,
      token: await PrefUtils.getToken() ?? "",
      isAuthorization: true,
      isCustomResponse: true,
      context: context,
      onResponse: (response) async {
        if (response['status'] != "false"){
          storyDetailModel = StoryDetailModel.fromJson(response['data']);
         // showSuccessSnackbar(response['message'], context);
          notifyListeners();
        }else {
          handleApiError(response['message'], context);
        }
      },
    );
  }


  Future<void> suggestStoryAPI({required BuildContext context,  required String storyId,}) async {
    var params = {};
    Api.request(
      method: HttpMethod.get,
      path: '${ApiEndPoints.suggestStoryDetail}/$storyId',
      params: params,
      token: await PrefUtils.getToken() ?? "",
      isAuthorization: true,
      isCustomResponse: true,
      context: context,
      onResponse: (response) async {
        if (response['status'] != "false"){
          suggestStoryModel = SuggestStoryModel.fromJson(response['data']);
          // showSuccessSnackbar(response['message'], context);
          notifyListeners();
        }else {
          handleApiError(response['message'], context);
        }
      },
    );
  }


}