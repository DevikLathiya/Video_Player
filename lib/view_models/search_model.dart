import 'package:flutter/material.dart';
import 'package:hellomegha/core/api_factory/api.dart';
import 'package:hellomegha/core/api_factory/api_end_points.dart';
import 'package:hellomegha/core/api_factory/prefs/pref_utils.dart';
import 'package:hellomegha/core/utils/utils.dart';
import 'package:hellomegha/models/searchmodel.dart';
import 'package:hellomegha/screens/notification_model.dart';

class SearchModel extends ChangeNotifier{
  List<Data>? searchdata;


  Future<void> SearchModelAPI({required BuildContext context,required String keyword,required String type}) async {
    var params = {
      "keyword": "$keyword",
      "type": "$type"
    };
    Api.request(
      method: HttpMethod.post,
      path: ApiEndPoints.search,
      params: params,
      token: await PrefUtils.getToken() ?? "",
      isAuthorization: true,
      isCustomResponse: true,
      context: context,
      isLoading: false,
      onResponse: (response) async {
        print(response);
        if (response['status'] != "false"){
          searchdata = searchModel.fromJson(response['data']).data;
          // showSuccessSnackbar(response['message'], context);
          notifyListeners();
        }else {
          handleApiError(response['message'], context);
        }
      },
    );
  }


}