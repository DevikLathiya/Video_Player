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
import 'package:hellomegha/screens/home/kyc_view.dart';
import 'package:intl/intl.dart';

class QuizViewModel extends ChangeNotifier{
  QuizModel? quizModel;

  Future<void> quizListAPI({required BuildContext context, String? type}) async {
    var now =  DateTime.now();
    var formatter =  DateFormat('yyyy-MM-dd');
    String formattedDate = formatter.format(now);
    log(formattedDate); // 2023-01-25
    var params = {
      "date": '2022-12-19',
      //"date": formattedDate,
      "type": '1'
      //"type": type
    };
    Api.request(
      method: HttpMethod.get,
      path: ApiEndPoints.quizQns,
      params: params,
      token: await PrefUtils.getToken() ?? "",
      isAuthorization: true,
      isCustomResponse: true,
      context: context,
      onResponse: (response) async {
        print("Quiz=${response}");
        if (response['status'] != "false"){
          quizModel = QuizModel.fromJson(response['data']);
         var data = response['data']['quiz'];
        // log('-----------------------$data---------------------');
          if (data is List) {
            sample_data = data;
          } else {
            print("json is not list");
          }
          if(quizModel!.quiz![0].status != 2){

          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => QuizScreen(),
              ));
          }else{
            showSuccessSnackbar('quiz completed', context);
          }
         // showSuccessSnackbar(response['message'], context);
          notifyListeners();
        }else {
          handleApiError(response['message'], context);
        }
      },
    );
  }


  Future<void> quizResultAPI({required BuildContext context, String? score}) async {
    var params = {
      "score": score,
      "quiz_type": '1'
    };
    Api.request(
      method: HttpMethod.post,
      path: ApiEndPoints.quizSaveResult,
      params: params,
      token: await PrefUtils.getToken() ?? "",
      isAuthorization: true,
      isCustomResponse: true,
      context: context,
      onResponse: (response)  {

        print("Hello $response");
        if (response['status'] == true){
          showSuccessSnackbar(response['message'], context);

          Get.off(()=>ScoreScreen());
          // movieList = MovieList.fromJson(response['data']);
         // showSuccessSnackbar(response['message'], context);
         // notifyListeners();
        }else {
          handleApiError(response['message'], context);
        }
      },
    );
  }



}