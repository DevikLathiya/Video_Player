import 'package:flutter/material.dart';
import 'package:hellomegha/core/api_factory/api.dart';
import 'package:hellomegha/core/api_factory/api_end_points.dart';
import 'package:hellomegha/core/api_factory/prefs/pref_utils.dart';
import 'package:hellomegha/core/utils/utils.dart';
import 'package:hellomegha/models/home_music_model.dart';

class HomeMusicViewModel extends ChangeNotifier {
  HomeMusicModel? homeMusicModel;

  Future<void> homeMusicAPI({required BuildContext context}) async {
    var params = {};
    Api.request(
      method: HttpMethod.get,
      path: ApiEndPoints.homeMusic,
      params: params,
      token: await PrefUtils.getToken() ?? "",
      isAuthorization: true,
      isCustomResponse: true,
      context: context,
      onResponse: (response) async {
        if (response['status'] != "false") {
          homeMusicModel = HomeMusicModel.fromJson(response['data']);
          // showSuccessSnackbar(response['message'], context);
          notifyListeners();
        } else {
          handleApiError(response['message'], context);
        }
      },
    );
  }
}
