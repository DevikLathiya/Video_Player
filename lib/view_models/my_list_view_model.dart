import 'package:flutter/material.dart';
import 'package:hellomegha/core/api_factory/api.dart';
import 'package:hellomegha/core/api_factory/api_end_points.dart';
import 'package:hellomegha/core/api_factory/prefs/pref_utils.dart';
import 'package:hellomegha/core/utils/utils.dart';
import 'package:hellomegha/models/my_list_model.dart';
import 'package:hellomegha/screens/notification_model.dart';

class MyListViewModel extends ChangeNotifier{
  MyListModel? myListModel;


  Future<void> myListAPI({required BuildContext context}) async {
    var params = {

    };
    Api.request(
      method: HttpMethod.post,
      path: ApiEndPoints.myList,
      params: params,
      token: await PrefUtils.getToken() ?? "",
      isAuthorization: true,
      isCustomResponse: true,
      context: context,
      onResponse: (response) async {
        if (response['status'] != "false"){
          myListModel = MyListModel.fromJson(response['data']);

          // showSuccessSnackbar(response['message'], context);
          notifyListeners();
        }else {
          handleApiError(response['message'], context);
        }
      },
    );
  }


}