import 'package:flutter/material.dart';
import 'package:hellomegha/core/api_factory/api.dart';
import 'package:hellomegha/core/api_factory/api_end_points.dart';
import 'package:hellomegha/core/api_factory/prefs/pref_utils.dart';
import 'package:hellomegha/core/utils/utils.dart';
import 'package:hellomegha/models/movie_detail_model.dart';
import 'package:hellomegha/models/scheme_detail_model.dart';
import 'package:hellomegha/models/suggest_scheme_model.dart';

class SchemeDetailViewModel extends ChangeNotifier {
  SchemeDetailModel? schemeDetailModel;
  SuggestSchemeModel? suggestSchemeModel;

  Future<void> schemeDetailsAPI({
    required BuildContext context,
    required String schemeId,
    void Function(List<MovieVideo>, int previousId, int nextId)? videos,
  }) async {
    var params = {};
    Api.request(
      method: HttpMethod.get,
      path: '${ApiEndPoints.schemeDetail}/$schemeId',
      params: params,
      token: await PrefUtils.getToken() ?? "",
      isAuthorization: true,
      isCustomResponse: true,
      context: context,
      onResponse: (response) async {
        if (response['status'] != "false") {
          schemeDetailModel = SchemeDetailModel.fromJson(response['data']);
          if (videos != null) {
            if (schemeDetailModel!.schemeDetails!.first.movieVideos != null ||
                schemeDetailModel!
                    .schemeDetails!.first.movieVideos!.isNotEmpty) {
              final movies = schemeDetailModel!
                  .schemeDetails!.first.movieVideos!
                  .where(((element) => element.type == QtyType.MOVIE))
                  .toList();

              movies.sort(
                  (a, b) => int.parse(a.qty!).compareTo(int.parse(b.qty!)));
              videos.call(movies, schemeDetailModel!.preciousrecordId ?? -1,
                  schemeDetailModel!.nextrecordId ?? -1);
            }
          }

          notifyListeners();
          if (schemeId.isNotEmpty) {
            suggestSchemeAPI(context: context, schemeId: schemeId);
          }
        } else {
          handleApiError(response['message'], context);
        }
      },
    );
  }

  Future<void> suggestSchemeAPI({
    required BuildContext context,
    required String schemeId,
  }) async {
    var params = {};
    Api.request(
      method: HttpMethod.get,
      path: '${ApiEndPoints.schemeSuggest}/7',
      params: params,
      token: await PrefUtils.getToken() ?? "",
      isAuthorization: true,
      isCustomResponse: true,
      context: context,
      onResponse: (response) async {
        if (response['status'] != "false") {
          suggestSchemeModel = SuggestSchemeModel.fromJson(response['data']);
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
        print("fav=$response");
        if (fav == '1') {
          schemeDetailModel!.schemeDetails![0].isFavourite = true;
        } else {
          schemeDetailModel!.schemeDetails![0].isFavourite = false;
        }
        notifyListeners();
      },
    );
  }
}
