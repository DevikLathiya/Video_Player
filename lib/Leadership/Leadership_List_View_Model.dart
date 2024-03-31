import 'package:flutter/material.dart';
import 'package:hellomegha/Leadership/Leadership_model.dart';
import 'package:hellomegha/Shortfilms/shortfilm_model.dart';
import 'package:hellomegha/core/api_factory/api.dart';
import 'package:hellomegha/core/api_factory/api_end_points.dart';
import 'package:hellomegha/core/api_factory/prefs/pref_utils.dart';
import 'package:hellomegha/core/utils/utils.dart';

class LeadershipListViewModel extends ChangeNotifier{
  List<LeadershipList>? leadershipLists;


  Future<void> LeadershipListAPI({required BuildContext context}) async {
    var params = {};
    Api.request(
      method: HttpMethod.get,
      path: ApiEndPoints.leader_list,
      params: params,
      token: await PrefUtils.getToken() ?? "",
      isAuthorization: true,
      isCustomResponse: true,
      context: context,
      onResponse: (response) async {
        print("====>$response");
        if (response['status'] != "false"){
          leadershipLists = LeadershipData.fromJson(response["data"]).leadershipList;
          print("ShortFilmList$leadershipLists");
          // showSuccessSnackbar(response['message'], context);
          notifyListeners();
        }else {
          handleApiError(response['message'], context);
        }
      },
    );
  }


}