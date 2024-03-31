import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:hellomegha/core/api_factory/prefs/pref_utils.dart';
import 'package:hellomegha/core/notifier/providers.dart';
import 'package:hellomegha/core/utils/strings.dart';
import 'package:hellomegha/core/utils/utils.dart';
import 'package:hellomegha/core/widgets/ab_button.dart';
import 'package:hellomegha/core/widgets/ab_text_input.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';

import '../../ABLoginButton.dart';
import '../CommonWebView.dart';

import 'package:hellomegha/screens/no_network.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
class RegisterView extends ConsumerStatefulWidget {
  const RegisterView({Key? key}) : super(key: key);

  @override
  ConsumerState<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends ConsumerState<RegisterView> {
  final _formKey = GlobalKey<FormState>();

  final _firstNameController = TextEditingController();
  final _date = TextEditingController();
  final _lastNameController = TextEditingController();
  final _mailController = TextEditingController();
  final _mobileController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _isObscure = true;
  bool _isObscureConfirmpassword = true;
  final _focusNode = FocusNode();
  bool _isDisable = true;
  bool _isValid = false;
  bool _isValid2 = false;
  String gp = "male";
  var _currencies = [
    "Williamnagar",
    "Resubelpara",
    "Baghmara",
    "Tura",
    "Ampati",
    "Shillong",
    "Jowai",
    "Khliehriat",
    "Mawkyrwat",
    "Nongstoin",
    "Mairang",
    "Nongpoh",
    "Not A Resident Of Meghalaya",
  ];

  // @override
  // void initState() {
  //   super.initState();
  //   _mobileController.addListener(_validateInput);
  //   _focusNode.addListener(_validateInput);
  // }

  // void _validateInput() {
  //   setState(() {
  //     _isValid = _mobileController.text.length == 10 && _focusNode.hasFocus;
  //   });
  // }
  DateTime? _selectedDate;
  var _currentSelectedValue;
  _selectDate(BuildContext context) async {
    DateTime? newSelectedDate = await showDatePicker(
        context: context,
        initialDate: _selectedDate != null ? _selectedDate! : DateTime.now(),
        firstDate: DateTime(1940),
        lastDate: DateTime.now(),
        builder: (BuildContext context, Widget? child) {
          // return child!;
          return Theme(
            data: Theme.of(context).copyWith(
              colorScheme: ColorScheme.dark(
                primary: Colors.amber,
                onPrimary: Colors.black,
                surface: Colors.amber,
                onSurface: Colors.black,
              ),
              dialogBackgroundColor: Colors.white,
            ),
            child: child!,
          );
        });

    if (newSelectedDate != null) {
      _selectedDate = newSelectedDate;
      _date
        ..text = DateFormat('dd/MM/yyyy').format(_selectedDate!)
        ..selection = TextSelection.fromPosition(TextPosition(
            offset: _date.text.length,
            affinity: TextAffinity.upstream));
    }
  }

  gettoken() async {
    await Firebase.initializeApp();
    FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
    _firebaseMessaging.getToken().then((value){
      print("hello=====>$value");
      PrefUtils.setfcmToken(value!);
    });
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Connectivity().checkConnectivity().then((value) {
      if (value == ConnectivityResult.none) {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => NoNetwork()));
      }
      else
      {
        gettoken();
      }
    });



  }


  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
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
                  padding: const EdgeInsets.only(left: 23.0),
                  child: RichText(
                    text: TextSpan(
                        text: 'Let\'s Get'.tr,
                        style: TextStyle(
                            fontFamily: Strings.robotoMedium,
                            fontSize: 27.0,
                            color: Colors.black),
                        children: [
                          TextSpan(
                              text: ' Started'.tr,
                              style: TextStyle(
                                  fontFamily: Strings.robotoMedium,
                                  fontSize: 27.0,
                                  color: const Color(0xFFB0CB1F)))
                        ]),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 15.0),
                  child: ABTextInput(
                    //autoValidator: AutovalidateMode.onUserInteraction,
                    titleText: Strings.email,
                    controller: _mailController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return Strings.mailRequired;
                      }
                      if (!validateEmail(value)) {
                        return Strings.pleaseEnterAValidEmailAddress;
                      }
                      return null;
                      _isDisable=true;
                      setState(() {

                      });
                    },
                    autoValidator: AutovalidateMode.onUserInteraction,
                    //hintText: Strings.enterEmailHere,
                    textInputType: TextInputType.emailAddress,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 10.0),
                  child: ABTextInput(
                    // autoValidator: AutovalidateMode.onUserInteraction,
                    titleText: "First Name".tr,
                    controller: _firstNameController,
                    customInputFormatters: <TextInputFormatter>[
                      UpperCaseTextFormatter()
                    ],
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return Strings.pleaseEnterLastName;
                      }

                      return null;
                    },
                    autoValidator: AutovalidateMode.onUserInteraction,
                    //controller: _lastNameController,
                    // hintText: Strings.enterYourLastNameHere,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: ABTextInput(
                    autoValidator: AutovalidateMode.onUserInteraction,
                    titleText: Strings.lastName.tr,
                    controller: _lastNameController,
                    customInputFormatters: <TextInputFormatter>[
                      UpperCaseTextFormatter()
                    ],
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return Strings.pleaseEnterLastName;
                      }
                      return null;
                    },

                    // controller: _firstNameController,
                    // hintText: Strings.enterYourFastNameHere,
                  ),
                ),
                // Padding(
                //   padding: const EdgeInsets.only(top: 8.0),
                //   child: ABTextInput(
                //     autoValidator: AutovalidateMode.onUserInteraction,
                //     titleText: Strings.epic,
                //     validator: (value) {
                //       if (value == null || value.isEmpty) {
                //         return Strings.pleaseEnterFirstName;
                //       }
                //       return null;
                //     },
                //     // controller: _firstNameController,
                //     // hintText: Strings.enterYourFastNameHere,
                //   ),
                // ),
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
                          // focusNode: _focusNode,
                          keyboardType: TextInputType.phone,
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
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 10.0),
                  child: ABTextInput(
                    autoValidator: AutovalidateMode.onUserInteraction,
                    titleText: Strings.createPassword,
                    isPassword: _isObscure,
                    controller: _passwordController,
                    // hintText: Strings.enterPassword,
                    // isPassword: _isObscurePassword,
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
                        return 'Enter valid password'.tr;
                      }
                      return null;
                    },
                    onTap: () {
                      // if (!_passwordBool) {
                      //   _passwordBool = true;
                      // } else {
                      //   _passwordBool = false;
                      // }
                    },
                    // suffix: IconButton(
                    //   icon: Icon(_isObscurePassword
                    //       ? Icons.visibility_outlined
                    //       : Icons.visibility_off_outlined),
                    //   onPressed: () {
                    //     setState(() {
                    //       _isObscurePassword = !_isObscurePassword;
                    //     });
                    //   },
                    // ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 25.0),
                  child: Text(
                    'Password must contain 1 special,1 capital and 1 small character.'.tr,
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
                    // hintText: Strings.confirmPassword,
                    // isPassword: _isObscureConfirmPassword,
                    //  suffix: IconButton(
                    //    icon: Icon(_isObscureConfirmPassword
                    //        ? Icons.visibility_outlined
                    //        : Icons.visibility_off_outlined),
                    //    onPressed: () {
                    //      setState(() {
                    //        _isObscureConfirmPassword =
                    //        !_isObscureConfirmPassword;
                    //      });
                    //    },
                    //  ),
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
                          Strings.dob,
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
                          controller: _date,
                          keyboardType: TextInputType.none,
                          // focusNode: _focusNode,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Date Of Birth is required'.tr;
                            }
                            return null;
                          },
                          onTap: () {
                            _selectDate(context);
                          },
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
                          ),
                        ),
                      ),
                    ],
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
                          Strings.gender,
                          style: TextStyle(
                              fontFamily: Strings.robotoRegular,
                              letterSpacing: 0.01,
                              fontSize: 15.0,
                              color: Colors.grey),
                        ),
                      ),
                      Row(
                        children: [
                          Expanded(child: RadioListTile(activeColor: Colors.amber,value: "male",groupValue: gp,title: Text("Male"), onChanged: (String? value) { setState(() {
                            gp="male";
                          }); },)),
                          Expanded(child: RadioListTile(activeColor: Colors.amber,value: "female",groupValue: gp,title: Text("Female"), onChanged: (String? value) { setState(() {
                            gp="female";
                          }); },)),
                        ],
                      ),
                    ],
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
                          Strings.city,
                          style: TextStyle(
                              fontFamily: Strings.robotoRegular,
                              letterSpacing: 0.01,
                              fontSize: 15.0,
                              color: Colors.grey),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Container(
                    margin: EdgeInsets.only(
                        top: MediaQuery.of(context).size.height * 0.01,
                        left: MediaQuery.of(context).size.width * 0.072222,
                        right: MediaQuery.of(context).size.width * 0.075
                    ),
                    alignment: Alignment.topLeft,
                    child: InputDecorator(
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
                        labelStyle: TextStyle(
                            fontFamily: Strings.robotoRegular,
                            letterSpacing: 0.01,
                            fontSize: 15.0,
                            color:  Colors.grey),
                        errorStyle: TextStyle(color: Colors.redAccent, fontSize: 16.0),
                        hintText:'Select District'.tr,
                        // border: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0))
                      ),
                      isEmpty: _currentSelectedValue == '',
                      child: DropdownButtonHideUnderline(
                        child: DropdownButtonFormField<String>(
                          decoration: InputDecoration.collapsed(hintText: ''),
                          hint: Text("Select Your District".tr),
                          value: _currentSelectedValue,
                          focusNode: _focusNode,
                          validator: (value) {
                            if (value == null || value.isEmpty ) {
                              return 'District is required'.tr;
                            }
                            return null;
                          },
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          isDense: true,
                          onChanged: (value) {
                            setState(() {
                              _currentSelectedValue = value!;
                              if(_currentSelectedValue!="Not A Resident Of Meghalaya")
                              {
                                _isValid=true;
                              }
                            });
                          },
                          items: _currencies.map((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                  ),
                ),

                Visibility(child: ListTileTheme(
                  horizontalTitleGap: 0,
                  child: CheckboxListTile(
                    onChanged: (value) {
                      setState(() {
                        _isValid=value!;
                      });
                    }, value: _isValid,
                    title: Text("Are you resident of Meghalaya ?".tr),
                    controlAffinity: ListTileControlAffinity.leading,
                    checkColor: Colors.amber,
                    activeColor: Colors.white,
                  ),
                ),visible: _currentSelectedValue=="Not A Resident Of Meghalaya"?false:true),
                ListTileTheme(
                  horizontalTitleGap: 0,
                  child: CheckboxListTile(
                    onChanged: (value) {
                      setState(() {
                        _isValid2=value!;
                      });
                    }, value: _isValid2,

                    // title: Text("I am agree to terms and conditions"),
                    title: RichText(
                      text: TextSpan(style: TextStyle(color: Colors.black),text: 'I agree to '.tr, children: [
                        new TextSpan(
                          text: 'Terms & Conditions'.tr,
                          style: TextStyle(color: Colors.amber,decoration: TextDecoration.underline,),
                          recognizer: new TapGestureRecognizer()..onTap = () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => CommonWebView(title:"Privacy statement".tr,url: "http://prabhu.yoursoftwaredemo.com/termsofuse"),
                            ),
                          ),
                        )
                      ]),
                    ),
                    controlAffinity: ListTileControlAffinity.leading,
                    checkColor: Colors.amber,
                    activeColor: Colors.white,
                  ),
                ),
                ABLoginButton(
                  paddingTop: 10.0,
                  paddingBottom: 30.0,
                  paddingLeft: 25.0,
                  paddingRight: 25.0,
                  text: Strings.register,
                  onPressed:() async {
                    print(_currentSelectedValue=="Not A Resident Of Meghalaya"?0:1);
                    if (!_formKey.currentState!.validate()) {
                      showSnackBar(
                          backgroundColor: Colors.redAccent,
                          message: "Please Fill up all the details".tr,
                          context: context);
                    }
                    else
                    {
                      if((!_isValid && _currentSelectedValue=="Not A Resident Of Meghalaya") || (_isValid && _currentSelectedValue!="Not A Resident Of Meghalaya"))
                      {
                        if (_isValid2) {

                          //pref
                          PrefUtils.setfirstName(_firstNameController.text);
                          PrefUtils.setdistrict(_currentSelectedValue);
                          PrefUtils.setdob(_date.text);
                          PrefUtils.setemail(_mailController.text);
                          PrefUtils.setgender(gp);
                          PrefUtils.setlastName( _lastNameController.text);
                          PrefUtils.setmobile(_mobileController.text);
                          PrefUtils.setpassword(_confirmPasswordController.text);
                          PrefUtils.setmeg_user(_currentSelectedValue=="Not A Resident Of Meghalaya"?0:1);

                          ref.watch(authenticationProvider).checkmobileAPI(
                              context: context,
                              firstName: _firstNameController.text,
                              lastName: _lastNameController.text,
                              email: _mailController.text,
                              mobile: _mobileController.text,
                              password: _confirmPasswordController.text,
                              dob: _date.text,
                              district: _currentSelectedValue,
                              gender: gp,
                              fcmToken:await PrefUtils.getfcmToken(),
                              meg_user:_currentSelectedValue=="Not A Resident Of Meghalaya"?0:1
                          );
                          //
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
                        }
                        else
                        {
                          showSnackBar(
                              backgroundColor: Colors.redAccent,
                              message: "Please Check Terms & Conditions".tr,
                              context: context);
                        }
                      }
                      else
                      {
                        showSnackBar(
                            backgroundColor: Colors.redAccent,
                            message: "Please Check Are you resident of Meghalaya ?",
                            context: context);
                      }
                    }

                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
class UpperCaseTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    return TextEditingValue(
      text: capitalize(newValue.text),
      selection: newValue.selection,
    );
  }
}
String capitalize(String value) {
  if(value.trim().isEmpty) return "";
  return "${value[0].toUpperCase()}${value.substring(1).toLowerCase()}";
}