import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:get/get.dart';
import '../../core/utils/strings.dart';
import '../../core/widgets/ab_button.dart';
import '../verify_otp/verify_otp_view.dart';

class ForgotPasswordScreen extends ConsumerStatefulWidget {
  const ForgotPasswordScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<ForgotPasswordScreen> createState() =>
      _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends ConsumerState<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _mobileController = TextEditingController();
  final _focusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        extendBodyBehindAppBar:true,
        appBar: AppBar(
            elevation: 0,
        backgroundColor: Colors.transparent,
        titleSpacing: 0
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Stack(
                children: [
                  SizedBox(
                    height: 220,
                    child: Image.asset(
                      'assets/suri_waterfall_near.jpeg',
                      fit: BoxFit.cover,
                    ),
                  ),
                  SizedBox(
                    height: 255,
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(100),
                        child: SizedBox(
                            width: 120.0,
                            child: Image.asset('assets/logo_new.png',
                                fit: BoxFit.fill)),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 35),
              Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: const EdgeInsets.only(left: 27.0, bottom: 10),
                  child: Text(
                    Strings.forgotPass,
                    style: TextStyle(
                        fontFamily: Strings.robotoMedium,
                        fontSize: 25.0,
                        color: Colors.black),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Column(
                  children: [
                    Container(
                      margin: EdgeInsets.only(
                          top: MediaQuery.of(context).size.height * 0.01,
                          left: MediaQuery.of(context).size.width * 0.072222,
                          right: MediaQuery.of(context).size.width * 0.075),
                      alignment: Alignment.topLeft,
                      child: Text(
                        Strings.mobileNumber,
                        style: TextStyle(
                            fontFamily: Strings.robotoRegular,
                            letterSpacing: 0.01,
                            fontSize: 15.0,
                            color: Colors.grey),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(
                          top: 10, left: 25, right: 25, bottom: 5),
                      child: TextFormField(
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        controller: _mobileController,
                        focusNode: _focusNode,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Mobile number is required'.tr;
                          } else if (value.length != 10) {
                            return 'Mobile number must be 10 digits'.tr;
                          }
                          return null;
                        },
                        inputFormatters: [
                          LengthLimitingTextInputFormatter(10),
                          FilteringTextInputFormatter.digitsOnly
                        ],
                        decoration: InputDecoration(
                          enabledBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                              color: Color(0xff515151),
                            ),
                            borderRadius: BorderRadius.circular(9),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                              vertical: 15, horizontal: 12),
                          hintStyle: TextStyle(
                            fontFamily: Strings.robotoMedium,
                            fontSize: 14,
                            color: const Color(0xff9aa4b0),
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(9),
                          ),
                          hintText: 'Enter 10 digits mobile'.tr,
                        ),
                        keyboardType: TextInputType.number,
                      ),
                    ),
                  ],
                ),
              ),
              ABButton(
                paddingTop: 30.0,
                paddingBottom: 15.0,
                paddingLeft: 25.0,
                paddingRight: 25.0,
                text: Strings.forgotPass,
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    FocusManager.instance.primaryFocus?.unfocus();
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => VerifyOtpView(
                          email: '',
                          mobile: _mobileController.text.trim(),
                          isFromForgotpassword: true,
                        ),
                      ),
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
