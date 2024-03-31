import 'dart:developer';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hellomegha/core/api_factory/api.dart';
import 'package:hellomegha/core/api_factory/api_end_points.dart';
import 'package:hellomegha/core/api_factory/prefs/pref_utils.dart';
import 'package:hellomegha/core/api_factory/user_model.dart';
import 'package:hellomegha/screens/login/login_view.dart';

class BaseViewModel extends ChangeNotifier {
  bool _isConnected = false;
  int _selectedIndex = 0;
  int _position = 0;
  bool _otpStatus = false;
  UserModel? _kCurrentUser;

  int get selectedIndex => _selectedIndex;

  bool get isConnected => _isConnected;

  int get position => _position;

  bool get otpStatus => _otpStatus;

  UserModel? get kCurrentUser => _kCurrentUser;

  set kCurrentUser(UserModel? value) {
    _kCurrentUser = value;
    notifyListeners();
  }

  set selectedIndex(int value) {
    _selectedIndex = value;
    notifyListeners();
  }

  set isConnected(bool value) {
    _isConnected = value;
    notifyListeners();
  }

  set position(int value) {
    _position = value;
    notifyListeners();
  }

  set otpStatus(bool value) {
    _otpStatus = value;
    notifyListeners();
  }

  clearUser() {
    kCurrentUser = null;
    notifyListeners();
  }

  void onInit() async {
    Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
      log("Connectivity ${result.name}");
      if (result.name.toLowerCase() == "none") {
        selectedIndex = 1;
        Get.rawSnackbar(
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.redAccent,
          message: 'Please check you network',
        );

        isConnected = false;
      } else {
        selectedIndex = 0;
        isConnected = true;
      }
    });

    kCurrentUser = await PrefUtils.getUser();
  }

  logoutUserAPI({required BuildContext context}) async {
    Api.request(
      method: HttpMethod.get,
      path: ApiEndPoints.logout,
      params: {},
      context: context,
      isCustomResponse: true,
      token: await PrefUtils.getToken() ?? "",
      isAuthorization: true,
      onResponse: (response) async {
        clearUser();
        await PrefUtils.clearPrefs();
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
            builder: (context) => const LoginView(),
          ),
          (route) => false,
        );
      },
    );
  }

  userDeleteAPI({required BuildContext context}) async {
    Api.request(
      method: HttpMethod.get,
      path: ApiEndPoints.delete,
      params: {},
      context: context,
      token: await PrefUtils.getToken() ?? "",
      isAuthorization: true,
      isCustomResponse: true,
      onResponse: (response) async {
        clearUser();
        await PrefUtils.clearPrefs();
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
            builder: (context) => const LoginView(),
          ),
          (route) => false,
        );
      },
    );
  }
}
