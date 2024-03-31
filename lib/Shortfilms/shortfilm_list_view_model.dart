import 'package:flutter/material.dart';
import 'package:hellomegha/Shortfilms/shortfilm_model.dart';
import 'package:hellomegha/core/api_factory/api.dart';
import 'package:hellomegha/core/api_factory/api_end_points.dart';
import 'package:hellomegha/core/api_factory/prefs/pref_utils.dart';
import 'package:hellomegha/core/utils/utils.dart';

class ShortFilmListViewModel extends ChangeNotifier{
  List<SthortflimList>? shortflimLists;


  Future<void> shortfilmListAPI({required BuildContext context}) async {
    var params = {};
    Api.request(
      method: HttpMethod.get,
      path: ApiEndPoints.shortflim_list,
      params: params,
      token: await PrefUtils.getToken() ?? "",
      isAuthorization: true,
      isCustomResponse: true,
      context: context,
      onResponse: (response) async {
        if (response['status'] != "false"){
          shortflimLists = ShortfilmData.fromJson(response["data"]).sthortflimList;
          print("ShortFilmList"+shortflimLists![0].name.toString());
          // showSuccessSnackbar(response['message'], context);
          notifyListeners();
        }else {
          handleApiError(response['message'], context);
        }
      },
    );
  }


}