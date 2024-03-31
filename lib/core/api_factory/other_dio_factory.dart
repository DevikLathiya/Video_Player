import 'dart:developer' show log;
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:hellomegha/core/api_factory/config.dart';
import 'package:hellomegha/core/api_factory/urls.dart';

enum ApiEnvironment { UAT, Dev, Prod }

extension APIEnvi on ApiEnvironment {
  String? get endpoint {
    switch (this) {
      case ApiEnvironment.UAT:
        return Urls.newServerUrl;
      case ApiEnvironment.Dev:
        return Urls.newServerUrl;
      case ApiEnvironment.Prod:
        return Urls.newServerUrl;
      default:
        return null;
    }
  }
}

typedef OnErrorNew = void Function(String error, Map<String, dynamic> data);
typedef OnResponseNew<BaseResponse> = void Function(BaseResponse response);

class DioFactoryNew {
  static final _singleton = DioFactoryNew._instance();

  static Dio? get dio => _singleton._dio;

  Dio? _dio;

  DioFactoryNew._instance() {
    _dio = Dio(
      BaseOptions(
       // baseUrl: ApiEnvironment.UAT.endpoint!,
        baseUrl: ApiEnvironment.Prod.endpoint!,
        // headers: {
        //   // HttpHeaders.userAgentHeader: _deviceName,
        //   // HttpHeaders.authorizationHeader: _authorization,
        //   // "device_id": Config.FCM_TOKEN,
        //   // "device_type": Platform.isIOS ? "I" : "A",
        //   // "language": Get.deviceLocale!.languageCode
        // },
        connectTimeout: Config.timeout,
        receiveTimeout: Config.timeout,
        sendTimeout: Config.timeout,
        contentType: Headers.formUrlEncodedContentType,
      ),
    );
    if (!kReleaseMode) {
      _dio!.interceptors.add(
        LogInterceptor(
          request: Config.logNetworkRequest,
          requestHeader: Config.logNetworkRequestHeader,
          requestBody: Config.logNetworkRequestBody,
          responseHeader: Config.logNetworkResponseHeader,
          responseBody: Config.logNetworkResponseBody,
          error: Config.logNetworkError,
          logPrint: (Object object) {
            log(object.toString(), name: 'dio');
          },
        ),
      );
    }
  }
}
