import 'dart:developer';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' as getmethod;
import 'package:hellomegha/core/api_factory/api_end_points.dart';
import 'package:hellomegha/core/api_factory/base_response.dart';
import '../utils/dialogs.dart';
import '../utils/utils.dart';
import 'dio_factory.dart';
import 'other_dio_factory.dart';

enum HttpMethod { delete, get, patch, post, put ,other }

class Api {
  static Future<void> request({
    required HttpMethod method,
    required String path,
    required Map params,
    bool isLoading = true,
    var formData = '',
    required BuildContext context,
    required OnResponse onResponse,
    bool isAuthorization = false,
    bool isUploadImage = false,
    bool isCustomResponse = false,
    String token = '',
  }) async {
    try {
      if (isLoading && path == ApiEndPoints.user) {
        showbottomLoading(context);
      } else if (isLoading) {
        showLoading(context);
      }
      String encryptedParams = "";
      String encodedParams = "";

      log("------original params------->>>>>>>>> $params");

      Response response;
      switch (method) {
        case HttpMethod.post:
          response = await DioFactory.dio!.post(
            path,
            options: Options(
              // headers: <String, dynamic>{
              //   'Authorization': 'Token',
              //   'api-key': token,
              // },
              // headers: {
              //   "Authorization":
              //   isAuthorization ? 'Bearer $token' : null,
              //   HttpHeaders.contentTypeHeader: "application/json",
              // },

              headers: {
                HttpHeaders.authorizationHeader:
                    isAuthorization ? 'Bearer $token' : null,
                HttpHeaders.contentTypeHeader: "application/json",
              },
              responseType: ResponseType.json,
            ),
            data: isUploadImage ? formData : params,
          );
          break;
        case HttpMethod.delete:
          response = await DioFactory.dio!.delete(
            path,
            options: Options(
              headers: {
                HttpHeaders.authorizationHeader:
                    isAuthorization ? 'Bearer $token' : null,
                HttpHeaders.contentTypeHeader: "application/json",
              },
              responseType: ResponseType.json,
            ),
            data: isUploadImage ? formData : params,
          );
          break;
        case HttpMethod.get:
          response = await DioFactory.dio!.get(
            path,
            options: Options(
              // headers: {
              //   "Authorization":
              //   isAuthorization ? 'Bearer $token' : null,
              //  // HttpHeaders.contentTypeHeader: "application/json",
              // },
              headers: {
                HttpHeaders.authorizationHeader:
                    isAuthorization ? 'Bearer $token' : null,
                HttpHeaders.contentTypeHeader: "application/json",
              },
              responseType: ResponseType.json,
            ),
            queryParameters: isUploadImage
                ? formData
                : isAuthorization
                    ? null
                    : params,
          );
          break;
        case HttpMethod.patch:
          response = await DioFactory.dio!.patch(
            path,
            options: Options(
              headers: {
                HttpHeaders.authorizationHeader:
                    isAuthorization ? 'Bearer $token' : null,
                HttpHeaders.contentTypeHeader: "application/json",
              },
              responseType: ResponseType.json,
            ),
            data: isUploadImage ? formData : params,
          );
          break;
        case HttpMethod.put:
          response = await DioFactory.dio!.put(
            path,
            options: Options(
              headers: {
                HttpHeaders.authorizationHeader:
                    isAuthorization ? 'Bearer $token' : null,
                HttpHeaders.contentTypeHeader: "application/json",
              },
              responseType: ResponseType.json,
            ),
            data: isUploadImage ? formData : params,
          );
          break;
        // case HttpMethod.other:
        //   response = await DioFactoryNew.dio!.get(
        //     path,
        //     options: Options(
        //       // headers: {
        //       //   "Authorization":
        //       //   isAuthorization ? 'Bearer $token' : null,
        //       //  // HttpHeaders.contentTypeHeader: "application/json",
        //       // },
        //       headers: {
        //         HttpHeaders.authorizationHeader:
        //         isAuthorization ? 'Bearer $token' : null,
        //         HttpHeaders.contentTypeHeader: "application/json",
        //       },
        //       responseType: ResponseType.json,
        //     ),
        //     queryParameters: isUploadImage
        //         ? formData
        //         : isAuthorization
        //         ? null
        //         : params,
        //   );
        //   break;
        default:
          return;
      }
      if (isLoading) {
        hideLoading(context);
      }
      if (isCustomResponse) {
        onResponse(response.data);
      } else {
        onResponse(BaseResponse.fromJson(response.data));
      }

      // if (isCustomResponse && method!=HttpMethod.other) {
      //   onResponse(response.data);
      // } else {
      //   onResponse(BaseResponse.fromJson(response.data));
      // }
      //
      // if (isCustomResponse && method==HttpMethod.other) {
      //   onResponse(response.data);
      // } else {
      //   onResponse(BaseResponse.fromJson(response.data));
      // }

    } catch (e) {
      if (path == ApiEndPoints.login) {
        handleApiError(
            "Email/Mobile & Password does not match with our record.", context);
      }
      hideLoading(context);
      dynamic errorMessage = "";
      if (e is DioError) {
        if (e.type == DioErrorType.connectTimeout ||
            e.type == DioErrorType.sendTimeout ||
            e.type == DioErrorType.receiveTimeout ||
            e.type == DioErrorType.other)
        {
          errorMessage = "Server unreachable".tr;
        }
        else if (e.type == DioErrorType.response) {
          // if (e.response!.statusCode == 401) {
            // handleApiError(e.response!.message, context);
            // PrefUtils.clearPrefs();
            // Navigator.of(context).pushAndRemoveUntil(
            //     MaterialPageRoute(
            //       builder: (context) => const LoginView(),
            //     ),
            //     (route) => false);
            // showSessionDialog(context);
          // }
          // final response = e.response;
          // print("error${response!.data["message"]}");
          // handleApiError(response.data["message"], context);
          // log("------response----->>>>>>>>>>>> $response");
          // if (response!.data["message"] != null &&
          //     response.data["message"].isNotEmpty) {
          //   errorMessage = response.data['message'];
          // } else if (response.data["errors"]["message"] != null &&
          //     response.data["errors"]["message"].isNotEmpty) {
          //   errorMessage = response.data["errors"]["message"];
          // } else {
          //   errorMessage = "Something went wrong";
          // }
        } else {
          errorMessage = "Request cancelled".tr;
        }
      } else {
        errorMessage = e.toString();
      }
    }
  }
}
