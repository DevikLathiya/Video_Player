import 'package:flutter/material.dart';
import 'package:hellomegha/core/api_factory/prefs/pref_utils.dart';
import 'package:hellomegha/core/notifier/providers.dart';
import 'package:hellomegha/core/utils/strings.dart';
import 'package:hellomegha/core/utils/theme_config.dart';
import 'package:hellomegha/core/utils/utils.dart';
import 'package:hellomegha/core/widgets/ab_button.dart';
import 'package:hellomegha/core/widgets/ab_button_grey.dart';
import 'package:hellomegha/screens/forgotpassword/chage_password_screen.dart';
import 'package:hellomegha/screens/login/login_view.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:get/get.dart';
import 'package:hellomegha/screens/no_network.dart';
import 'package:connectivity_plus/connectivity_plus.dart';


class VerifyOtpView extends ConsumerStatefulWidget {
  final String email;
  final String mobile;
  final String? firstName;
  final String? lastName;
  final String? password;
  final String? dob;
  final String? district;
  final String? gender;
  final String? fcmToken;
  final int? meg_user;
  bool isFromForgotpassword = false;
  VerifyOtpView(
      {Key? key,
        required this.email,
        required this.mobile,
        this.firstName,
        this.lastName,
        this.password,
        this.dob,
        this.district,
        this.gender,
        this.fcmToken,
        this.meg_user,
        this.isFromForgotpassword = false})
      : super(key: key);

  @override
  ConsumerState<VerifyOtpView> createState() => _VerifyOtpViewState();
}

class _VerifyOtpViewState extends ConsumerState<VerifyOtpView> {
  String otp = '';

  @override
  void initState() {
    if(!widget.isFromForgotpassword)
    {
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
        // ref
        //     .watch(authenticationProvider)
        //     .otpAPI(context: context, contact: widget.mobile);
      });
    }
    super.initState();
  }
  TextEditingController pincodeController=TextEditingController();

  // @override
  // void didChangeDependencies() {
  //   // TODO: implement didChangeDependencies
  //   super.didChangeDependencies();
  //   Connectivity().checkConnectivity().then((value) {
  //     if (value == ConnectivityResult.none) {
  //       Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => NoNetwork()));
  //     }
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 30),
            Padding(
              padding: const EdgeInsets.only(left: 20.0),
              child: RichText(
                text: TextSpan(
                    text: 'Please Verify\nYour'.tr,
                    style: TextStyle(
                        fontFamily: Strings.robotoMedium,
                        fontSize: 30.0,
                        color: Colors.black),
                    children: [
                      TextSpan(
                          text: ' OTP.',
                          style: TextStyle(
                              fontFamily: Strings.robotoMedium,
                              fontSize: 30.0,
                              color: const Color(0xFFB0CB1F)))
                    ]),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20.0, top: 45),
              child: Text('Enter the 5 digit code sent to'.tr,
                  style: TextStyle(
                    fontFamily: Strings.robotoRegular,
                    fontSize: 15.0,
                    color: const Color(0xff272727),
                  )),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20.0, top: 5, bottom: 15),
              child: Text(widget.mobile,
                  style: TextStyle(
                    fontFamily: Strings.robotoRegular,
                    fontSize: 15.0,
                    color: const Color(0xffA5A5A5),
                  )),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 5.0, bottom: 7),
              child: SizedBox(
                width: MediaQuery.of(context).size.width - 22,
                child: PinCodeTextField(
                  controller: pincodeController,
                  appContext: context,
                  enablePinAutofill: true,
                  pastedTextStyle: TextStyle(
                    color: Colors.green.shade600,
                    fontWeight: FontWeight.bold,
                  ),
                  length: 5,
                  obscureText: true,
                  animationType: AnimationType.fade,
                  pinTheme: PinTheme(
                    shape: PinCodeFieldShape.box,
                    borderRadius: BorderRadius.circular(7),
                    fieldHeight: 40,
                    fieldWidth: 40,
                    inactiveFillColor: Colors.white,
                    inactiveColor: Colors.grey,
                    selectedColor: Colors.black,
                    selectedFillColor: Colors.white,
                    activeFillColor: Colors.white,
                    activeColor: ThemeColor.border_bd_1,
                    fieldOuterPadding: const EdgeInsets.all(5),
                  ),
                  cursorColor: Colors.white,
                  animationDuration: const Duration(milliseconds: 300),
                  enableActiveFill: false,
                  // controller: _pinController,
                  keyboardType: TextInputType.number,
                  onChanged: (value) {
                    setState(() {
                      print("=>$value");
                      otp=value;
                    });
                  },
                  onCompleted: (val) async {
                    setState(() {
                      otp = val;
                    });
                    if (val.isNotEmpty) {
                      String otp2=await PrefUtils.getotp()??'';
                      if(otp==otp2)
                      {

                        if(widget.isFromForgotpassword)
                        {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ChangePasswordScreen(
                                  contact: widget.mobile,
                                )),
                          );
                        }
                        else
                        {
                          ref.watch(authenticationProvider).registerAPI(
                              context: context,
                              firstName: widget.firstName!,
                              lastName: widget.lastName!,
                              email: widget.email,
                              mobile: widget.mobile,
                              password: widget.password!,
                              dob: widget.dob!,
                              district:widget.district!,
                              gender: widget.gender!,
                              fcmToken: widget.fcmToken!,
                              meg_user: widget.meg_user!);
                        }

                      }
                      else
                      {
                        handleApiError("Please Enter Valid OTP", context);
                      }
                    }

                  },
                ),
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: ABButtonGery(
                    paddingTop: 30.0,
                    paddingBottom: 15.0,
                    paddingLeft: 20.0,
                    paddingRight: 25.0,
                    text: 'Resend OTP'.tr,
                    onPressed: () {
                      pincodeController.text="";
                      ref.watch(authenticationProvider).otpAPI(context: context, mobile: widget.mobile);
                      // Navigator.push(
                      //   context,
                      //   MaterialPageRoute(
                      //       builder: (context) => const RegisterView()),
                      // );
                    },
                  ),
                ),
                Expanded(
                  child: ABButton(
                    paddingTop: 30.0,
                    paddingBottom: 15.0,
                    paddingLeft: 20.0,
                    paddingRight: 25.0,
                    text: 'Verify OTP'.tr,
                    onPressed: otp.length==5?() async {
                      if(otp.isNotEmpty) {
                        String otp2=await PrefUtils.getotp()??'';
                        if(otp==otp2)
                        {
                          if(widget.isFromForgotpassword)
                          {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ChangePasswordScreen(
                                    contact: widget.mobile,
                                  )),
                            );
                          }
                          else
                          {
                            ref.watch(authenticationProvider).registerAPI(
                                context: context,
                                firstName: widget.firstName!,
                                lastName: widget.lastName!,
                                email: widget.email,
                                mobile: widget.mobile,
                                password: widget.password!,
                                dob: widget.dob!,
                                district:widget.district!,
                                gender: widget.gender!,
                                fcmToken: widget.fcmToken!,
                                meg_user: widget.meg_user!);
                          }
                        }
                        else
                        {
                          handleApiError("Please Enter Valid OTP", context);
                        }
                      }

                    }:null,
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
