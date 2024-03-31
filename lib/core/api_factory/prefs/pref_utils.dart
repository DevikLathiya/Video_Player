import 'dart:convert';
import 'package:hellomegha/core/api_factory/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../utils/strings.dart';
import 'pref_keys.dart';

class PrefUtils {
  PrefUtils();

  static setToken(String token) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.setString(PrefKeys.token, token);
  }

  static Future<String?> getToken() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.getString(PrefKeys.token);
  }
  static setfcmToken(String token) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.setString(PrefKeys.fcmtoken, token);
  }

  static Future<String?> getfcmToken() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.getString(PrefKeys.fcmtoken);
  }
  static setfirstName(String token) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.setString(PrefKeys.firstName, token);
  }
  static setlastName(String token) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.setString(PrefKeys.lastName, token);
  }
  static setotp(String token) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.setString(PrefKeys.otp, token);
  }
  static setemail(String token) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.setString(PrefKeys.email, token);
  }
  static setmobile(String token) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.setString(PrefKeys.mobile, token);
  }
  static setpassword(String token) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.setString(PrefKeys.password, token);
  }
  static setdob(String token) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.setString(PrefKeys.dob, token);
  }
  static setdistrict(String token) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.setString(PrefKeys.district, token);
  }
  static setgender(String token) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.setString(PrefKeys.gender, token);
  }
  static setmeg_user(int token) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.setInt(PrefKeys.meg_user, token);
  }
  static Future<String?> getfirstName() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.getString(PrefKeys.firstName);
  }
  static Future<String?> getlastName() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.getString(PrefKeys.lastName);
  }
  static Future<String?> getemail() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.getString(PrefKeys.email);
  }
  static Future<String?> getmobile() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.getString(PrefKeys.mobile);
  }
  static Future<String?> getpassword() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.getString(PrefKeys.password);
  }
  static Future<String?> getotp() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.getString(PrefKeys.otp);
  }
  static Future<String?> getdob() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.getString(PrefKeys.dob);
  }
  static Future<String?> getdistrict() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.getString(PrefKeys.district);
  }
  static Future<String?> getgender() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.getString(PrefKeys.gender);
  }
  static Future<int?> getmeg_user() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.getInt(PrefKeys.meg_user);
  }

  static setIsLoggedIn(bool isLoggedIn) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.setBool(PrefKeys.isLoggedIn, isLoggedIn);
  }

  static Future<bool?> getIsLoggedIn() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.getBool(PrefKeys.isLoggedIn);
  }

  static setTheme(bool isDarkTheme) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.setBool(PrefKeys.darkTheme, isDarkTheme);
  }

  static Future<bool> getIsDarkTheme() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.getBool(PrefKeys.darkTheme) ?? false;
  }

  static setUser(String userData) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.setString(PrefKeys.user, userData);
  }
  static setlanguage(String userData) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.setString(PrefKeys.language, userData);
  }
  static Future<String> getlanguage() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.getString(PrefKeys.language) ?? PrefKeys.english;
  }
  static setNoti(int no) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.setInt(PrefKeys.noofnotification, no);
  }
  static Future<int> getNoti() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.getInt(PrefKeys.noofnotification) ?? 0;
  }

  static setUserGeoCoding(String userLocation) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.setString(PrefKeys.userGeoCoding, userLocation);
  }

  static clearPrefs() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.clear();
  }

  static Future<UserModel> getUser() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    Map<String, dynamic> user =
    jsonDecode(preferences.getString(PrefKeys.user) ?? "{}");
    return UserModel.fromJson(user);
  }

}
