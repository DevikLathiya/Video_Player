import 'package:flutter/material.dart';
import 'package:hellomegha/core/utils/dialogs.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../core/notifier/providers.dart';
import '../../core/utils/strings.dart';
import '../../core/utils/utils.dart';
import '../../core/widgets/ab_button.dart';
import '../../core/widgets/ab_text_input.dart';
import 'package:get/get.dart';
class ChangePasswordScreen extends ConsumerStatefulWidget {
  final String contact;
  const ChangePasswordScreen({Key? key, required this.contact})
      : super(key: key);

  @override
  ConsumerState<ChangePasswordScreen> createState() =>
      _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends ConsumerState<ChangePasswordScreen> {
  final _formKey = GlobalKey<FormState>();

  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _isObscure = true;
  bool _isObscureConfirmpassword = true;
  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    nointernet(context);
    // Connectivity().checkConnectivity().then((value) {
    //   if (value == ConnectivityResult.none) {
    //     Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => NoNetwork()));
    //   }
    // });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image.asset('assets/logo_new.png', fit: BoxFit.cover, height: 170, width: MediaQuery.of(context).size.width,),
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
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.only(top: 10.0),
                child: ABTextInput(
                  autoValidator: AutovalidateMode.onUserInteraction,
                  titleText: Strings.newPassword,
                  isPassword: _isObscure,
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
                  validator: (value) {
                    if (value == null ||
                        value.isEmpty ||
                        value.length <= 7 ||
                        !validatePassword(value)) {
                      return Strings.enterValidPassword;
                    }
                    return null;
                  },
                  onTap: () {},
                ),
              ),
               Padding(
                padding: EdgeInsets.only(left: 25.0),
                child: Text(
                  'Password must contain 1 special,1 capital and 1 small character'.tr,
                  style: TextStyle(fontSize: 10, color: Colors.black),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10.0),
                child: ABTextInput(
                  autoValidator: AutovalidateMode.onUserInteraction,
                  isPassword: _isObscureConfirmpassword,
                  titleText: Strings.confirmPassword,
                  controller: _confirmPasswordController,
                  validator: (value) {
                    if (value == null || value.isEmpty || value.length <= 7) {
                      return 'Password required min length 7'.tr;
                    } else if (value != _passwordController.text) {
                      return Strings.passwordNotMatch;
                    }
                    return null;
                  },
                  suffix: IconButton(
                    icon: Icon(_isObscureConfirmpassword
                        ? Icons.visibility_outlined
                        : Icons.visibility_off_outlined),
                    onPressed: () {
                      setState(() {
                        _isObscureConfirmpassword = !_isObscureConfirmpassword;
                      });
                    },
                  ),
                ),
              ),
              ABButton(
                paddingTop: 40.0,
                paddingBottom: 30.0,
                paddingLeft: 25.0,
                paddingRight: 25.0,
                text: Strings.changePassword,
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    ref.watch(authenticationProvider).changePasswordAPI(
                        context: context,
                        contact: widget.contact,
                        password: _passwordController.text.trim());
                  }

                  // Navigator.push(
                  //   context,
                  //   MaterialPageRoute(
                  //       builder: (context) => const VerifyOtpView()),
                  // );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
