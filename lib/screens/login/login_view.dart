import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:hellomegha/core/api_factory/prefs/pref_utils.dart';
import 'package:hellomegha/core/utils/strings.dart';
import 'package:hellomegha/core/utils/utils.dart';
import 'package:hellomegha/core/widgets/ab_button.dart';
import 'package:hellomegha/core/widgets/ab_button_grey.dart';
import 'package:hellomegha/core/widgets/ab_text_input.dart';
import 'package:hellomegha/screens/forgotpassword/forgot_password_screen.dart';
import 'package:hellomegha/screens/register/register_view.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../ABLoginButton.dart';
import '../../core/notifier/providers.dart';

class LoginView extends ConsumerStatefulWidget {
  const LoginView({Key? key}) : super(key: key);

  @override
  ConsumerState<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends ConsumerState<LoginView> {
  final _formKey = GlobalKey<FormState>();
  final _mailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isObscure = true;
  gettoken() async {
    await Firebase.initializeApp();
    FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
    _firebaseMessaging.getToken().then((value){
      print("hello=====>$value");
      PrefUtils.setfcmToken(value!);
    });
  }
  bool _isDisable = true;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    gettoken();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                    Strings.login,
                    style: TextStyle(
                        fontFamily: Strings.robotoMedium,
                        fontSize: 25.0,
                        color: Colors.black),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 0.0),
                child: ABTextInput(
                    titleText: Strings.emailOrMobile,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Enter Email or Mobile Number".tr;
                      }
                      // else if (!validateEmail(value)) {
                      //   return Strings.pleaseEnterAValidEmailAddress;
                      // }

                      return null;
                    },
                    autoValidator: AutovalidateMode.onUserInteraction,
                    controller: _mailController,
                    customInputFormatters: [
                      FilteringTextInputFormatter.allow(
                        RegExp("[a-zA-Z0-9@.]"),
                      ),
                      LengthLimitingTextInputFormatter(50),
                      FilteringTextInputFormatter.deny(' ')
                    ]),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 5.0),
                child: ABTextInput(
                  titleText: Strings.password,
                  isPassword: _isObscure,
                  validator: (value) {
                    // if (value == null || value.isEmpty) {
                    //   return Strings.passwordRequired;
                    // }
                    if (value == null ||
                        value.isEmpty ||
                        value.length <= 7 ||
                        !validatePassword(value)) {
                      return Strings.enterValidPassword;
                    }

                    return null;

                  },
                  autoValidator: AutovalidateMode.onUserInteraction,
                  // onChange: (value) {
                  //   if (value == null || value.isEmpty) {
                  //     return Strings.passwordRequired;
                  //   }
                  // },
                  controller: _passwordController,
                  suffix: IconButton(
                    icon: Icon(_isObscure
                        ? Icons.visibility_outlined
                        : Icons.visibility_off_outlined),
                    onPressed: () {
                      setState(() {
                        _isObscure = !_isObscure;
                      });
                    },
                  ),
                ),
              ),
              ABLoginButton(
                paddingTop: 30.0,
                paddingBottom: 0.0,
                paddingLeft: 25.0,
                paddingRight: 25.0,
                text: Strings.login,
                onPressed:() async {
                  if (_formKey.currentState!.validate()) {
                    FocusManager.instance.primaryFocus?.unfocus();
                    ref.watch(authenticationProvider).loginAPI(
                        context: context,
                        email: _mailController.text,
                        password: _passwordController.text,
                        fcmToken: await PrefUtils.getfcmToken()
                    );
                  }
                },
              ),
              Align(
                alignment: Alignment.centerRight,
                child: Padding(
                  padding: const EdgeInsets.only(right: 25.0),
                  child: TextButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const ForgotPasswordScreen(),
                          ));
                    },
                    child: Text(
                      Strings.forgotPassword,
                      style: const TextStyle(fontSize: 12, color: Colors.black),
                    ),
                  ),
                ),
              ),
              ABButtonGery(
                paddingTop: 0.0,
                paddingBottom: 15.0,
                paddingLeft: 25.0,
                paddingRight: 25.0,
                text: Strings.notRegistered,
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const RegisterView()),
                  );
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
