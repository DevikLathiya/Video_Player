import 'package:flutter/material.dart';
import 'package:hellomegha/core/api_factory/api.dart';
import 'package:hellomegha/core/api_factory/api_end_points.dart';
import 'package:hellomegha/core/api_factory/prefs/pref_utils.dart';
import 'package:hellomegha/core/utils/utils.dart';
import 'package:hellomegha/models/home_all_model.dart';

import '../models/movie_list.dart';

class HomeAllViewModel extends ChangeNotifier {
  HomeAllModel? homeAllModel;
  MovieList? watchMovieList;
  Future<void> homeAPI({required BuildContext context}) async {
    var params = {};
    Api.request(
      method: HttpMethod.get,
      path: ApiEndPoints.homeAll,
      params: params,
      token: await PrefUtils.getToken() ?? "",
      isAuthorization: true,
      isCustomResponse: true,
      context: context,
      onResponse: (response) async {
        if (response['status'] != "false") {
          homeAllModel = HomeAllModel.fromJson(response['data']);
          // showSuccessSnackbar(response['message'], context);
          notifyListeners();
        } else {
          handleApiError(response['message'], context);
        }
      },
    );
  }

  Future<void> continueWatchingAPI({required BuildContext context}) async {
    var params = {};
    Api.request(
      method: HttpMethod.post,
      path: ApiEndPoints.watchContinueMovieList,
      params: params,
      token: await PrefUtils.getToken() ?? "",
      isAuthorization: true,
      isCustomResponse: true,
      context: context,
      isLoading: false,
      onResponse: (response) async {
        if (response['status'] != "false") {
          watchMovieList = MovieList.fromJson(response['data']);
          // showSuccessSnackbar(response['message'], context);
          notifyListeners();
        } else {
          handleApiError(response['message'], context);
        }
      },
    );
  }
}
