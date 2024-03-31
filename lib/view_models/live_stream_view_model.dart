import 'package:flutter/material.dart';
import 'package:hellomegha/core/api_factory/api.dart';
import 'package:hellomegha/core/api_factory/api_end_points.dart';
import 'package:hellomegha/core/api_factory/prefs/pref_utils.dart';
import 'package:hellomegha/core/utils/utils.dart';
import 'package:hellomegha/models/live_stream_list_model.dart';
import 'package:hellomegha/models/movie_list.dart';

class LiveStreamViewModel extends ChangeNotifier {
  LiveStreamListModel? liveStreamList;

  Future<void> liveListAPI({required BuildContext context}) async {
    var params = {};
    Api.request(
      method: HttpMethod.get,
      path: ApiEndPoints.liveStream,
      params: params,
      token: await PrefUtils.getToken() ?? "",
      isAuthorization: true,
      isCustomResponse: true,
      context: context,
      onResponse: (response) async {
        print(response);
        if (response['status'] != "false") {
          liveStreamList = LiveStreamListModel.fromJson(response['data']);
          // showSuccessSnackbar(response['message'], context);
          notifyListeners();
        } else {
          handleApiError(response['message'], context);
        }
      },
    );
  }

  Future<void> liveStreamStatusAPI({
    required BuildContext context,
    required String status,
    required String liveStreamId,
  }) async {
    var params = {"status": status, "live_stream_id": liveStreamId};
    Api.request(
      method: HttpMethod.post,
      path: ApiEndPoints.liveStreamStatus,
      params: params,
      token: await PrefUtils.getToken() ?? "",
      isAuthorization: true,
      isCustomResponse: true,
      context: context,
      onResponse: (response) async {
        if (response['status'] != "false") {
          // movieList = MovieList.fromJson(response['data']);
          // showSuccessSnackbar(response['message'], context);
          // notifyListeners();
        } else {
          handleApiError(response['message'], context);
        }
      },
    );
  }


  Future<void> liveStreamStatusTwoAPI({
    required BuildContext context,
    required String status,
    required String liveStreamId,
  }) async {
    var params = {"status": status, "live_stream_id": liveStreamId};
    Api.request(
      method: HttpMethod.post,
      path: ApiEndPoints.liveStreamStatus,
      params: params,
      token: await PrefUtils.getToken() ?? "",
      isAuthorization: true,
      isCustomResponse: true,
      context: context,
      onResponse: (response) async {
        if (response['status'] != "false") {
          // movieList = MovieList.fromJson(response['data']);
          // showSuccessSnackbar(response['message'], context);
          // notifyListeners();
          Navigator.of(context).pop(true);
        } else {
          handleApiError(response['message'], context);
        }
      },
    );
  }
}
