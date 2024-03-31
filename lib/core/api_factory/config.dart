import 'package:flutter/widgets.dart';

class Config {
  Config._();

  static const selfSignedCert = false;

  static const timeout = 60000;
  static const logNetworkRequest = true;
  static const logNetworkRequestHeader = true;
  static const logNetworkRequestBody = true;
  static const logNetworkResponseHeader = false;
  static const logNetworkResponseBody = true;
  static const logNetworkError = true;

  static const supportedLocales = <Locale>[
    Locale('en', ''),
    Locale('es', ''),
    Locale('ar', '')
  ];

  static const actionLocale = 'locale';
  static const int SIGNUP = 0;
  static const int SIGNIN = 1;
  static const String CURRENCY_SYMBOL = "€";
  static String FCM_TOKEN = "";
  static String deviceId = '';
  static String deviceBrand = '';
  static String deviceName = '';
  static String devicePlatformVersion = '';
  static String devicePlatformName = '';
  static String appVersion = '';


  static String firstName = '';
  static String lastName = '';
  static String mail = '';
  static String confirmPassword = '';

}
