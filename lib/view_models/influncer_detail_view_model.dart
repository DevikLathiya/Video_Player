import 'package:flutter/material.dart';
import 'package:hellomegha/core/api_factory/api.dart';
import 'package:hellomegha/core/api_factory/api_end_points.dart';
import 'package:hellomegha/core/api_factory/prefs/pref_utils.dart';
import 'package:hellomegha/core/utils/utils.dart';
import 'package:hellomegha/models/influncer_detail_model.dart';
import 'package:hellomegha/models/suggest_infulencer_model.dart';

import '../models/movie_detail_model.dart';

class InfluncerDetailViewModel extends ChangeNotifier {
  InfulencerDetailModel? infulencerDetailModel;
  SuggestInfulencerModel? suggestInfulencerModel;

  Future<void> infuncerDetailsAPI({
    required BuildContext context,
    required String id,
    void Function(List<MovieVideo>, int previos, int next)? videos,
  }) async {
    var params = {};
    Api.request(
      method: HttpMethod.get,
      path: '${ApiEndPoints.influncerDetails}/$id',
      params: params,
      token: await PrefUtils.getToken() ?? "",
      isAuthorization: true,
      isCustomResponse: true,
      context: context,
      onResponse: (response) async {
        if (response['status'] != "false") {
          infulencerDetailModel =
              InfulencerDetailModel.fromJson(response['data']);
          if (videos != null) {
            if (infulencerDetailModel!.schemeDetails!.first.movieVideos !=
                    null ||
                infulencerDetailModel!
                    .schemeDetails!.first.movieVideos!.isNotEmpty) {
              final movies = infulencerDetailModel!
                  .schemeDetails!.first.movieVideos!
                  .where(((element) => element.type == QtyType.MOVIE))
                  .toList();

              movies.sort(
                  (a, b) => int.parse(a.qty!).compareTo(int.parse(b.qty!)));
              videos.call(movies, infulencerDetailModel!.preciousrecordId ?? -1,
                  infulencerDetailModel!.nextrecordId ?? -1);
            }
          }
          if (infulencerDetailModel!.schemeDetails![0].gener != null &&
              infulencerDetailModel!.schemeDetails![0].gener!.isNotEmpty) {
            suggestInfluncerAPI(
                context: context,
                id: infulencerDetailModel!.schemeDetails![0].gener!);
          }

          notifyListeners();
        } else {
          handleApiError(response['message'], context);
        }
      },
    );
  }

  Future<void> suggestInfluncerAPI({
    required BuildContext context,
    required String id,
  }) async {
    var params = {};
    Api.request(
      method: HttpMethod.get,
      path: '${ApiEndPoints.suggestInfluncerDetails}/18',
      params: params,
      token: await PrefUtils.getToken() ?? "",
      isAuthorization: true,
      isCustomResponse: true,
      context: context,
      onResponse: (response) async {
        if (response['status'] != "false") {
          suggestInfulencerModel =
              SuggestInfulencerModel.fromJson(response['data']);
          // showSuccessSnackbar(response['message'], context);
          notifyListeners();
        } else {
          handleApiError(response['message'], context);
        }
      },
    );
  }

  Future<void> updateFavourite(
      {required BuildContext context,
      required String videoId,
      required String fav}) async {
    var params = {"vid": videoId, "fav": fav};
    Api.request(
      method: HttpMethod.post,
      path: ApiEndPoints.updateFavourite,
      params: params,
      token: await PrefUtils.getToken() ?? "",
      isAuthorization: true,
      isCustomResponse: true,
      context: context,
      onResponse: (response) async {
        if (fav == '1') {
          infulencerDetailModel!.schemeDetails![0].isFavourite = true;
        } else {
          infulencerDetailModel!.schemeDetails![0].isFavourite = false;
        }

        notifyListeners();
      },
    );
  }
}
