import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hellomegha/core/api_factory/api.dart';
import 'package:hellomegha/core/api_factory/api_end_points.dart';
import 'package:hellomegha/core/api_factory/prefs/pref_utils.dart';
import 'package:hellomegha/core/utils/utils.dart';
import 'package:hellomegha/models/quiz_model.dart';
import 'package:hellomegha/quiz/models/Questions.dart';
import 'package:hellomegha/quiz/screens/quiz/quiz_screen.dart';
import 'package:hellomegha/quiz/screens/score/score_screen.dart';
import 'package:hellomegha/quiz/screens/welcome/welcome_screen.dart';
import 'package:intl/intl.dart';

class WinnerViewModel extends ChangeNotifier{


  Future<void> WinnerListAPI({required BuildContext context}) async {

    var params = {
      "date":"2023-05-27",
      "type":1
    };
    Api.request(
      method: HttpMethod.other,
      path: ApiEndPoints.winner,
      params: params,
      token: await PrefUtils.getToken() ?? "",
      isAuthorization: true,
      isCustomResponse: true,
      context: context,
      onResponse: (response) async {
        print("winner=$response");
        if (response['status'] != "false"){

        }else {
          handleApiError(response['message'], context);
        }
      },
    );
  }



}