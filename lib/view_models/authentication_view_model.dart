import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:hellomegha/Schemes/schemes_detail_view.dart';
import 'package:hellomegha/core/notifier/base_view_model.dart';
import 'package:hellomegha/screens/forgotpassword/chage_password_screen.dart';
import 'package:hellomegha/screens/home/kyc_view.dart';
import 'package:hellomegha/screens/home/withdraw_coins_view.dart';
import 'package:hellomegha/screens/login/login_view.dart';
import 'package:hellomegha/screens/verify_otp/verify_otp_view.dart';
import 'package:http_parser/http_parser.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:hellomegha/core/api_factory/api.dart';
import 'package:hellomegha/core/api_factory/api_end_points.dart';
import 'package:hellomegha/core/api_factory/prefs/pref_utils.dart';
import 'package:hellomegha/core/api_factory/user_model.dart';
import 'package:hellomegha/core/utils/utils.dart';
import 'package:hellomegha/screens/home/bottom_navigation_view.dart';

import '../core/notifier/providers.dart';

class AuthenticationViewModel extends ChangeNotifier {
  var token;
  var fcmtoken;


  void registerAPI({
    required BuildContext context,
    required String firstName,
    required String lastName,
    required String email,
    required String mobile,
    required String password,
    required String dob,
    required String district,
    required String gender,
    required String? fcmToken,
    required int? meg_user,

  }) {
    var params = {
      "firstname": firstName,
      "lastname": lastName,
      "email": email,
      "mobile": mobile,
      "password": password,
      "dob": dob,
      "location": district,
      "gender": gender,
      "fcmToken":fcmToken,
      "meg_user":meg_user,
    };
    Api.request(
      method: HttpMethod.post,
      path: ApiEndPoints.register,
      params: params,
      isCustomResponse: true,
      context: context,
      onResponse: (response) {
        print("====$response");
        if (response['status'] != false) {
          print("yes");
          token = response['data']['token'];
          showSuccessSnackbar(response['message'], context);
          PrefUtils.setToken(token);
          PrefUtils.setIsLoggedIn(true);
          userDataAPI(context: context);

        }
        else {
          print("no");
          // showSuccessSnackbar(response['message'], context);
          handleApiError(response['message'], context);
        }
      },
    );
  }

  Future<void> withdrawCoinsAPI(
      {required BuildContext context, required String coins}) async {
    var params = {
      "amount": coins,
    };
    Api.request(
      method: HttpMethod.post,
      path: ApiEndPoints.withdrawCoins,
      params: params,
      token: await PrefUtils.getToken() ?? "",
      isCustomResponse: true,
      isAuthorization: true,
      context: context,
      onResponse: (response) {
        if (response['status'] != false) {
          var userModel = UserModel.fromJson(response['data']);
          print("Hello called");
          PrefUtils.setUser(jsonEncode(userModel));
          showSuccessSnackbar(response['message'], context);
          // Navigator.pop(context);
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const WithdrawView()),
          );
        } else {
          handleApiError(response['message'], context);
        }
      },
    );
  }

  void loginAPI({
    required BuildContext context,
    required String email,
    required String password,
    required String? fcmToken,
  }) {
    var params = {
      "email": email,
      "password": password,
      "fcmToken":fcmToken
    };

    Api.request(
      method: HttpMethod.get,
      path: ApiEndPoints.login,
      params: params,
      context: context,
      isCustomResponse: true,
      onResponse: (response) {
        if (response['status'] != false) {
          token = response['data']['token'];
          PrefUtils.setToken(token);
          PrefUtils.setIsLoggedIn(true);
          showSuccessSnackbar("${response['message']}", context);
          userDataAPI(context: context);
        } else {
          print("error");
          showSuccessSnackbar(response['message'], context);
          // handleApiError(response['message'], context);
        }
      },
    );
  }
  void forgototpAPI({
    required BuildContext context,
    required String contact,
  }) {
    var params = {"contact": contact};

    var formData = FormData.fromMap({"contact": contact});

    Api.request(
      method: HttpMethod.post,
      path: ApiEndPoints.sendOTP,
      params: params,
      isUploadImage: true,
      formData: formData,
      context: context,
      isCustomResponse: true,
      onResponse: (response) {
        print("forgot$response");
        if (response['status'] != "false") {
          showSuccessSnackbar(response['message'], context);
          PrefUtils.setotp(response['data']['otp']);
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => VerifyOtpView(
                email: '',
                mobile: contact,
                isFromForgotpassword: true,
              ),
            ),
          );
        } else {
          handleApiError(response['message'], context);
        }
      },
    );
  }
  void otpAPI({
    required BuildContext context,
    required String mobile,
    String? firstName,
    String? lastName,
    String? email,
    String? password,
    String? dob,
    String? district,
    String? gender,
    String? fcmToken,
    int? meg_user,
  }) {
    var params = {"contact": mobile};

    var formData = FormData.fromMap({"contact": mobile});

    Api.request(
      method: HttpMethod.post,
      path: ApiEndPoints.regsendOTP,
      params: params,
      isUploadImage: true,
      formData: formData,
      context: context,
      isCustomResponse: true,
      onResponse: (response)  {
        print(response['data']['otp']);
        if (response['status'] != "false") {
          // print(firstName);
          // print(lastName);
          // print(email);
          // print(mobile);
          // print(password);
          // print(dob);
          // print(district);
          // print(fcmToken);
          // print(meg_user);

          showSuccessSnackbar(response['message'], context);
          PrefUtils.setotp(response['data']['otp']);
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  VerifyOtpView(mobile: mobile,email: email!, fcmToken: fcmToken,
                    firstName: firstName,district: district,dob: dob,
                    gender: gender,lastName: lastName,meg_user: meg_user,password: password,),
            ),
          );

        } else {
          handleApiError(response['message'], context);
        }
      },
    );
  }
  void checkmobileAPI({
    required BuildContext context,
    String? firstName,
    String? lastName,
    String? email,
    required String mobile,
    String? password,
    String? dob,
    String? district,
    String? gender,
    String? fcmToken,
    int? meg_user,
  }) {
    var params = {
      "email": email,
      "mobile": mobile,
    };
    Api.request(
      method: HttpMethod.post,
      path: ApiEndPoints.checkMobile,
      params: params,
      isCustomResponse: true,
      context: context,
      onResponse: (response) {
        print("====$response");
        if (response['status'] != false) {
          // showSuccessSnackbar(response['message'], context);
          // Navigator.pop(context);
          // ref.watch(authenticationProvider)
          //     .otpAPI(context: context, contact: widget.mobile);

          otpAPI(context: context, mobile:mobile,email: email!, fcmToken: fcmToken,
              firstName: firstName!,district: district!,dob: dob!,
              gender: gender!,lastName: lastName!,meg_user: meg_user,password: password!);

        }
        else {
          // showSuccessSnackbar(response['message'], context);
          handleApiError(response['message'], context);
        }
      },
    );
  }
  void validateOtpAPI({
    required BuildContext context,
    required String contact,
    required String otp,
    required bool isFromForgotPassword,
    required String firstName,
    required String lastName,
    required String email,
    required String password,
    required String dob,
    required String district,
    required String gender,
    required String? fcmToken,
    required int? meg_user,
  }) {
    var params = {
      "otp": otp,
      "contact": contact,
    };
    var formData = FormData.fromMap({
      "contact": contact,
      "otp": otp,
    });
    Api.request(
      method: HttpMethod.post,
      path: ApiEndPoints.validateOTP,
      params: params,
      context: context,
      formData: formData,
      isUploadImage: true,
      isCustomResponse: true,
      onResponse: (response) {
        print("Hello$response");

        if (response['status'] != "false") {
          if (isFromForgotPassword) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) => ChangePasswordScreen(
                    contact: contact,
                  )),
            );
          }
          else
          {

            PrefUtils.setfirstName(firstName);
            PrefUtils.setdistrict(district);
            PrefUtils.setdob(dob);
            PrefUtils.setemail(email);
            PrefUtils.setgender(gender);
            PrefUtils.setlastName(lastName);
            PrefUtils.setmobile(contact);
            PrefUtils.setpassword(password);
            PrefUtils.setmeg_user(meg_user!);
            token = response['data']['token'];

            registerAPI(context: context, firstName: firstName, lastName: lastName, email: email, mobile: contact, password: password, dob: dob, district: district, gender: gender, fcmToken: fcmToken, meg_user: meg_user);

            // ref.watch(authenticationProvider).registerAPI(
            //     context: context,
            //     firstName: _firstNameController.text,
            //     lastName: _lastNameController.text,
            //     email: _mailController.text,
            //     mobile: _mobileController.text,
            //     password: _confirmPasswordController.text,
            //     dob: _date.text,
            //     district: _currentSelectedValue,
            //     gender: gp,
            //     fcmToken:await PrefUtils.getfcmToken(),
            //     meg_user:_currentSelectedValue=="Not A Resident Of Meghalaya"?0:1
            // );
            // Navigator.pop(context);
          }
          showSuccessSnackbar(response['message'], context);
        } else {
          handleApiError(response['message'], context);
        }
      },
    );
  }

  void changePasswordAPI({
    required BuildContext context,
    required String contact,
    required String password,
  }) {
    var params = {
      "password": password,
      "contact": contact,
    };
    var formData = FormData.fromMap({
      "contact": contact,
      "password": password,
    });
    Api.request(
      method: HttpMethod.post,
      path: ApiEndPoints.changePassword,
      params: params,
      context: context,
      formData: formData,
      isUploadImage: true,
      isCustomResponse: true,
      onResponse: (response) {
        print("hello=$response");
        if (response['status'] != "false") {
          token = response['data']['token'];
          PrefUtils.setToken(token);
          PrefUtils.setIsLoggedIn(true);
          showSuccessSnackbar(response['message'], context);
          userDataAPI(context: context);


        } else {
          handleApiError(response['message'], context);
        }
      },
    );
  }

  Future<void> userDataAPI({required BuildContext context}) async {
    var params = {};
    Api.request(
      method: HttpMethod.get,
      path: ApiEndPoints.user,
      params: params,
      token: await PrefUtils.getToken() ?? "",
      isAuthorization: true,
      isCustomResponse: true,
      context: context,
      isLoading: true,
      onResponse: (response) async {
        print("res=$response");
        if (response['status'] != false) {
          var userModel = UserModel.fromJson(response['data']);
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) => const BottomNavigationView(index: 0),
            ),
          );
          PrefUtils.setUser(jsonEncode(userModel));
        } else {
          handleApiError(response['message'], context);
        }
      },
    );
  }

  void kycAPI({
    required File file,
    required File pdfFile,
    required BuildContext context,
    required String bank,
    required String ifscCode,
    required String aadhaarNumber,
    required String voterId,
    required String panNumber,
  }) async {
    print(pdfFile.path);
    String fileName = file.path.split('/').last;
    String fileName2 = pdfFile.path.split('/').last;
    FormData formData = FormData.fromMap(
      {
        "photo": await MultipartFile.fromFile(file.path,
            filename: fileName, contentType: MediaType('image', 'png')),
        "bank_account_number": bank,
        "ifsc_code": ifscCode,
        "bank_statement": pdfFile.path!=''?await MultipartFile.fromFile(pdfFile.path,
            filename: fileName2, contentType: MediaType('file', 'pdf')):'',
        "aadhaar_number": aadhaarNumber,
        "voter_id": voterId,
        "pan_number": panNumber
      },
    );

    print("Form=${formData.fields}");
    print("Form=${formData.files.length}");
    print("Form=${formData.files[0].value.filename}");
    // print("Form=${formData.files[1].value.filename}");

    Api.request(
      method: HttpMethod.post,
      path: ApiEndPoints.kyc,
      formData: formData,
      isUploadImage: true,
      token: await PrefUtils.getToken() ?? "",
      isCustomResponse: true,
      isAuthorization: true,
      context: context,
      onResponse: (response) async {
        print(response);
        if (response['status'] != "false") {
          showSuccessSnackbar(response['message'], context);
          userDataAPI(context: context);
          // Navigator.of(context).pushReplacement(
          //   MaterialPageRoute(
          //     builder: (context) => const BottomNavigationView(index: 0,),
          //   ),
          // );
        } else {
          handleApiError(response['message'], context);
        }
      },
      params: {},
    );
  }

  void userDataUpdateAPI({
    required BuildContext context,
    required String firstname,
    required String lastname,
    required String email,
    required String mobile,
    required String dob,
    required String district,
    required String gender,
  }) async {
    var params = {
      "firstname": firstname,
      "lastname": lastname,
      "email": email,
      "mobile": mobile,
      "dob": dob,
      "location": district,
      "gender": gender,
    };
    Api.request(
      method: HttpMethod.post,
      path: ApiEndPoints.updateBasicDetails,
      params: params,
      token: await PrefUtils.getToken() ?? "",
      isCustomResponse: true,
      isAuthorization: true,
      context: context,
      onResponse: (response) async {
        if (response['status'] != "false") {
          showSuccessSnackbar(response['message'], context);
          await PrefUtils.clearPrefs();
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(
              builder: (context) => const LoginView(),
            ),
                (route) => false,
          );
        } else {
          handleApiError(response['message'], context);
        }
      },
    );
  }

  void kycUpdateAPI({
    required File file,
    required File pdfFile,
    required BuildContext context,
    required String bank,
    required String ifscCode,
    required String aadhaarNumber,
    required String voterId,
    required String panNumber,
  }) async {
    String fileName = file.path.split('/').last;
    String fileName2 = pdfFile.path.split('/').last;
    print("===>$file===>$fileName");
    print("===>$pdfFile===>$fileName2");
    FormData formData = FormData.fromMap(
      {
        "photo": await MultipartFile.fromFile(file.path,
            filename: fileName, contentType: MediaType('image', 'jpg')),
        "bank_account_number": bank,
        "ifsc_code": ifscCode,
        "aadhaar_number": aadhaarNumber,
        "voter_id": voterId,
        "pan_number": panNumber,
        "bank_statement": pdfFile.path!=''?await MultipartFile.fromFile(pdfFile.path,
            filename: fileName2, contentType: MediaType('file', 'pdf')):'',
      },
    );
    var params = {
      // "photo": 'adasdasdasda',
      // "bank_account_number": bank,
      // "ifsc_code": ifscCode,
      // "bank_statement": 'asdasdasdas',
      // "aadhaar_number": aadhaarNumber,
      // "voter_id": voterId,
      // "pan_number": panNumber
    };
    Api.request(
      method: HttpMethod.post,
      path: ApiEndPoints.updateKycDetails,
      params: params,
      formData: formData,
      isUploadImage: true,
      token: await PrefUtils.getToken() ?? "",
      isCustomResponse: true,
      isAuthorization: true,
      context: context,
      onResponse: (response) async {
        print("=======$response");
        if (response['status'] != "false") {
          showSuccessSnackbar(response['message'], context);
          userDataAPI(context: context);
          await PrefUtils.clearPrefs();
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) => const KycView(),
            ),

          );
        } else {
          handleApiError(response['message'], context);
        }
      },
    );
  }
}
