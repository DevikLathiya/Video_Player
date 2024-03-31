import 'package:flutter/material.dart';
import 'package:hellomegha/TodaysPicup/top_picked.dart';
import 'package:hellomegha/core/api_factory/api.dart';
import 'package:hellomegha/core/api_factory/api_end_points.dart';
import 'package:hellomegha/core/api_factory/prefs/pref_utils.dart';
import 'package:hellomegha/core/utils/utils.dart';

class TopPickedListViewModel extends ChangeNotifier{
  List<Suggestlist>? suggestList;


  Future<void> topPickedListAPI({required BuildContext context}) async {
    var params = {};
    Api.request(
      method: HttpMethod.get,
      path: ApiEndPoints.topPickedList,
      params: params,
      token: await PrefUtils.getToken() ?? "",
      isAuthorization: true,
      isCustomResponse: true,
      context: context,
      onResponse: (response) async {
        if (response['status'] != "false"){
          suggestList = TopPickedData.fromJson(response["data"]).suggestlist;
          print("TopPickedList"+suggestList![0].name.toString());

          // showSuccessSnackbar(response['message'], context);
          notifyListeners();
        }else {
          handleApiError(response['message'], context);
        }
      },
    );
  }


}