import 'package:flutter/material.dart';
import 'package:hellomegha/Schemes/schemes_model.dart';
import 'package:hellomegha/Shortfilms/shortfilm_model.dart';
import 'package:hellomegha/core/api_factory/api.dart';
import 'package:hellomegha/core/api_factory/api_end_points.dart';
import 'package:hellomegha/core/api_factory/prefs/pref_utils.dart';
import 'package:hellomegha/core/utils/utils.dart';

class SchemesListViewModel extends ChangeNotifier{
  List<SchemesList>? schemesLists;


  Future<void> schemesListAPI({required BuildContext context}) async {
    var params = {};
    Api.request(
      method: HttpMethod.get,
      path: ApiEndPoints.schemes_list,
      params: params,
      token: await PrefUtils.getToken() ?? "",
      isAuthorization: true,
      isCustomResponse: true,
      context: context,
      onResponse: (response) async {
        if (response['status'] != "false"){
          schemesLists = SchemesData.fromJson(response["data"]).schemesList;
          print("ShortFilmList"+schemesLists![0].name.toString());
          // showSuccessSnackbar(response['message'], context);
          notifyListeners();
        }else {
          handleApiError(response['message'], context);
        }
      },
    );
  }


}