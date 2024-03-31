import 'package:flutter/material.dart';
import 'package:hellomegha/Stories/Stories.dart';
import 'package:hellomegha/core/api_factory/api.dart';
import 'package:hellomegha/core/api_factory/api_end_points.dart';
import 'package:hellomegha/core/api_factory/prefs/pref_utils.dart';
import 'package:hellomegha/core/utils/utils.dart';

class StoriesListViewModel extends ChangeNotifier{
  List<StoriesList>? storiesList;


  Future<void> storiesListAPI({required BuildContext context}) async {
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
        print("Hello $response");
        if (response['status'] != "false"){
          storiesList = StoriesData.fromJson(response["data"]).stories_list;
          print("StoriesList"+storiesList![0].name.toString());
          // showSuccessSnackbar(response['message'], context);
          notifyListeners();
        }else {
          handleApiError(response['message'], context);
        }
      },
    );
  }


}