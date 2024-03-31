import 'package:flutter/material.dart';
import 'package:hellomegha/core/api_factory/api.dart';
import 'package:hellomegha/core/api_factory/api_end_points.dart';
import 'package:hellomegha/core/api_factory/prefs/pref_utils.dart';
import 'package:hellomegha/core/utils/utils.dart';
import 'package:hellomegha/models/scheme_detail_model.dart';
import 'package:hellomegha/models/suggest_leader_model.dart';
import 'package:hellomegha/models/suggest_scheme_model.dart';

import '../models/leader_detail_model.dart';
import 'package:hellomegha/models/movie_detail_model.dart';
class LeadershipDetailViewModel extends ChangeNotifier {
  LeadershipDetailModel? leaderDetailModel;
  SuggestLeaderModel? suggestleaderModel;

  Future<void> LeadershipDetailsAPI({
    required BuildContext context,
    required String LeadershipId,
    void Function(List<MovieVideo>, int previousId, int nextId)? videos,
  }) async {
    var params = {};
    Api.request(
      method: HttpMethod.get,
      path: '${ApiEndPoints.leaderDetail}/$LeadershipId',
      params: params,
      token: await PrefUtils.getToken() ?? "",
      isAuthorization: true,
      isCustomResponse: true,
      context: context,
      onResponse: (response) async {
        if (response['status'] != "false") {
          leaderDetailModel = LeadershipDetailModel.fromJson(response['data']);
          if (videos != null) {
            if (leaderDetailModel!.leaderDetails!.first.movieVideos != null ||
                leaderDetailModel!
                    .leaderDetails!.first.movieVideos!.isNotEmpty) {
              final movies = leaderDetailModel!
                  .leaderDetails!.first.movieVideos!
                  .where(((element) => element.type == QtyType.MOVIE))
                  .toList();

              movies.sort(
                      (a, b) => int.parse(a.qty!).compareTo(int.parse(b.qty!)));
              videos.call(movies, leaderDetailModel!.preciousrecordId ?? -1,
                  leaderDetailModel!.nextrecordId ?? -1);
            }
          }

          notifyListeners();
          if (LeadershipId.isNotEmpty) {
            suggestLeadershipAPI(context: context, LeadershipId: LeadershipId);
          }
          
          // notifyListeners();
         
        } else {
          handleApiError(response['message'], context);
        }
      },
    );
  }

  Future<void> suggestLeadershipAPI({
    required BuildContext context,
    required String LeadershipId,
  }) async {
    var params = {};
    Api.request(
      method: HttpMethod.get,
      path: '${ApiEndPoints.suggestLeader}/7',
      params: params,
      token: await PrefUtils.getToken() ?? "",
      isAuthorization: true,
      isCustomResponse: true,
      context: context,
      onResponse: (response) async {
        if (response['status'] != "false") {
          suggestleaderModel = SuggestLeaderModel.fromJson(response['data']);
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
          leaderDetailModel!.leaderDetails![0].isFavourite = true;
        } else {
          leaderDetailModel!.leaderDetails![0].isFavourite = false;
        }
        notifyListeners();
      },
    );
  }

}
