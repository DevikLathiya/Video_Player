import 'package:flutter/material.dart';
import 'package:hellomegha/core/api_factory/api.dart';
import 'package:hellomegha/core/api_factory/api_end_points.dart';
import 'package:hellomegha/core/api_factory/prefs/pref_utils.dart';
import 'package:hellomegha/core/utils/utils.dart';
import 'package:hellomegha/models/comming_soon_movie_list_model.dart';

class CommingSoonViewModel extends ChangeNotifier {
  CommingSoonMovieListModel? commingSoonMovieListModel;

  Future<void> commingSoonAPI({required BuildContext context}) async {
    var params = {};
    Api.request(
      method: HttpMethod.get,
      path: ApiEndPoints.comingSoonMoviesList,
      params: params,
      token: await PrefUtils.getToken() ?? "",
      isAuthorization: true,
      isCustomResponse: true,
      context: context,
      onResponse: (response) async {
        print(">>>>>>>>>>>  >>>>> Response is ${response}");
        if (response['status'] != "false") {
          commingSoonMovieListModel =
              CommingSoonMovieListModel.fromJson(response);
          notifyListeners();
        } else {
          handleApiError(response['message'], context);
        }
      },
    );
  }

  Future<void> setReminderMovie(
      {required BuildContext context, String? movieID, int? reminder}) async {
    Api.request(
      method: HttpMethod.post,
      path: ApiEndPoints.reminderMovie,
      params: {"movieId": movieID, "isReminder": reminder},
      token: await PrefUtils.getToken() ?? "",
      isAuthorization: true,
      isCustomResponse: true,
      context: context,
      onResponse: (response) async {
        showSuccessSnackbar(response['message'], context);
      },
    );
  }
}
