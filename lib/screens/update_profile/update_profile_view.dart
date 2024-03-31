import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hellomegha/core/notifier/providers.dart';
import 'package:hellomegha/core/urls/urls.dart';
import 'package:hellomegha/core/utils/app_images.dart';
import 'package:hellomegha/core/utils/strings.dart';
import 'package:hellomegha/core/utils/utils.dart';
import 'package:hellomegha/core/widgets/ab_button.dart';
import 'package:hellomegha/core/widgets/ab_text_input.dart';
import 'package:hellomegha/core/widgets/common_image.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:permission_handler/permission_handler.dart';

import 'package:hellomegha/screens/no_network.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

import '../register/register_view.dart';

class UpdateProfileView extends ConsumerStatefulWidget {
  const UpdateProfileView({Key? key}) : super(key: key);

  @override
  ConsumerState<UpdateProfileView> createState() => _UpdateProfileViewState();
}

class _UpdateProfileViewState extends ConsumerState<UpdateProfileView> {
  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _mailController = TextEditingController();
  final _mobileController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  File? pdfFile;
  File? image;
  String? imageurl;
  String defaultImage = AppImages.icBot;
  final accountNumber = TextEditingController();
  final ifscCode = TextEditingController();
  final aadhaNumber = TextEditingController();
  final voterId = TextEditingController();
  final panNumber = TextEditingController();
  bool change = false;
  final _focusNode = FocusNode();
  final _date = TextEditingController();
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
  DateTime? _selectedDate;
  var _currentSelectedValue;


  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    Connectivity().checkConnectivity().then((value) {
      if (value == ConnectivityResult.none) {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => NoNetwork()));
      }
      else {

        }
    });
  }
  @override
  void initState() {
    change = false;
    // TODO: implement initState
    super.initState();
    var userData = ref
        .read(baseViewModel)
        .kCurrentUser;
    print(userData);
    _firstNameController.text = userData!.firstname!;
    _lastNameController.text = userData.lastname!;
    _mobileController.text =
    userData.mobile != null && userData.mobile!.isNotEmpty
        ? userData.mobile.toString()
        : '';
    _mailController.text =
    userData.email != null && userData.email!.isNotEmpty
        ? userData.email.toString()
        : '';
    gp = userData.gender != null && userData.gender!.isNotEmpty
        ? userData.gender.toString()
        : 'male';
    _date.text = userData.dob != null && userData.dob!.isNotEmpty
        ? userData.dob.toString()
        : '';
    // var inputFormat = DateFormat('MMM dd, yyyy');
    // var date1 = inputFormat.parse(userData.dob.toString());
    //
    // var outputFormat = DateFormat('dd/MM/yyyy');
    // var date2 = outputFormat.format(date1);
    // _date.text=date2;
    _currentSelectedValue =
    userData.location != null && userData.location!.isNotEmpty
        ? userData.location.toString()
        : '';
    if (userData.userKyc != null) {
      accountNumber.text = userData.userKyc!.bankAccountNumber != null &&
          userData.userKyc!.bankAccountNumber!.isNotEmpty
          ? userData.userKyc!.bankAccountNumber.toString()
          : '';
      ifscCode.text = userData.userKyc!.ifscCode != null &&
          userData.userKyc!.ifscCode!.isNotEmpty
          ? userData.userKyc!.ifscCode.toString()
          : '';
      aadhaNumber.text = userData.userKyc!.aadhaarNumber != null &&
          userData.userKyc!.aadhaarNumber!.isNotEmpty
          ? userData.userKyc!.aadhaarNumber.toString()
          : '';
      voterId.text = userData.userKyc!.voterId != null &&
          userData.userKyc!.voterId!.isNotEmpty
          ? userData.userKyc!.voterId.toString()
          : '';
      panNumber.text = userData.userKyc!.panNumber != null &&
          userData.userKyc!.panNumber!.isNotEmpty
          ? userData.userKyc!.panNumber.toString()
          : '';
      pdfFile = userData.userKyc!.bankStatement != null &&
          userData.userKyc!.bankStatement!.isNotEmpty
          ? File(userData.userKyc!.bankStatement.toString())
          : File('');
      imageurl = userData.userKyc!.photo != null &&
          userData.userKyc!.photo!.isNotEmpty
          ? "${AppUrls.baseUrl}${userData.userKyc!.photo.toString()}"
          : '';
      // pdfFile!.path = userData.userKyc!.bankStatement != null &&
      //         userData.userKyc!.bankStatement!.isNotEmpty
      //     ? userData.userKyc!.bankStatement.toString()
      //     : '';
    }
  }


  _selectDate(BuildContext context) async {
    DateTime? newSelectedDate = await showDatePicker(
        context: context,
        initialDate: DateFormat('dd/MM/yyyy').parse(_date.text),
        // initialDate: _selectedDate!,
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
            offset: _date.text.length, affinity: TextAffinity.upstream));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(75.0),
        child: Padding(
          padding: const EdgeInsets.all(5.0),
          child: AppBar(
            leading: GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: const Padding(
                padding: EdgeInsets.only(left: 3.0),
                child: SizedBox(
                  height: 27,
                  child: Icon(
                    Icons.arrow_back,
                    color: Colors.amber,
                  ),
                ),
              ),
            ),
            elevation: 0,
            backgroundColor: Colors.white,
            title: Text(
              Strings.editAndUpdate,
              style: TextStyle(
                  fontFamily: Strings.robotoMedium,
                  fontSize: 21.0,
                  color: Colors.black),
            ),
            iconTheme: const IconThemeData(color: Colors.black),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image.asset('assets/logo_new.png', fit: BoxFit.cover, height: 170, width: MediaQuery.of(context).size.width,),
              Padding(
                padding: const EdgeInsets.only(top: 15.0),
                child: ABTextInput(
                  autoValidator: AutovalidateMode.onUserInteraction,
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
                  },
                  //hintText: Strings.enterEmailHere,
                  textInputType: TextInputType.emailAddress,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10.0),
                child: ABTextInput(
                  autoValidator: AutovalidateMode.onUserInteraction,
                  titleText: Strings.firstName.tr,
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
                child: ABTextInput(
                  autoValidator: AutovalidateMode.onUserInteraction,
                  titleText: Strings.mobile,
                  controller: _mobileController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter phone number'.tr;
                    }
                    return null;
                  },
                  // controller: _firstNameController,
                  // hintText: Strings.enterYourFastNameHere,
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
                          print("ontap");
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
                        Expanded(
                            child: RadioListTile(
                          activeColor: Colors.amber,
                          value: "male",
                          groupValue: gp,
                          title: Text("Male"),
                          onChanged: (String? value) {
                            setState(() {
                              gp = "male";
                            });
                          },
                        )),
                        Expanded(
                            child: RadioListTile(
                          activeColor: Colors.amber,
                          value: "female",
                          groupValue: gp,
                          title: Text("Female"),
                          onChanged: (String? value) {
                            setState(() {
                              gp = "female";
                            });
                          },
                        )),
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
                      right: MediaQuery.of(context).size.width * 0.075),
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
                          color: Colors.grey),
                      errorStyle:
                          TextStyle(color: Colors.redAccent, fontSize: 16.0),
                      // border: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0))
                    ),
                    isEmpty: _currentSelectedValue == '',
                    child: DropdownButtonHideUnderline(
                      child: DropdownButtonFormField<String>(
                        decoration: InputDecoration.collapsed(hintText: ''),
                        hint: Text("Select Your City".tr),
                        value: _currentSelectedValue,
                        focusNode: _focusNode,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'City is required'.tr;
                          }
                          return null;
                        },
                        isDense: true,
                        onChanged: (value) {
                          setState(() {
                            _currentSelectedValue = value!;
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
              ABButton(
                paddingTop: 10.0,
                paddingBottom: 30.0,
                paddingLeft: 25.0,
                paddingRight: 25.0,
                text: Strings.update,
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    ref.watch(authenticationProvider).userDataUpdateAPI(
                        context: context,
                        firstname: _firstNameController.text,
                        lastname: _lastNameController.text,
                        email: _mailController.text,
                        mobile: _mobileController.text,
                        dob: _date.text,
                        district: _currentSelectedValue,
                        gender: gp);
                  }

                  // Navigator.push(
                  //   context,
                  //   MaterialPageRoute(
                  //       builder: (context) => const VerifyOtpView()),
                  // );
                },
              ),
              // ref.watch(baseViewModel).kCurrentUser!.userKyc!.kycdropdown != null &&
              //     ref.watch(baseViewModel).kCurrentUser!.userKyc!.kycdropdown == "pending" ||
              //         ref.watch(baseViewModel).kCurrentUser!.userKyc!.kycdropdown == "unverified" ||
              //     ref.watch(baseViewModel).kCurrentUser!.userKyc!.kycdropdown == "verified" ||
              //     ref.watch(baseViewModel).kCurrentUser!.userKyc!.kycdropdown == "rejected"
              //     ? Column(
              //         children: [
              //           ListTile(
              //             title: Text("View KYC".tr,
              //                 style: TextStyle(
              //                     fontFamily: Strings.robotoMedium,
              //                     fontSize: 21.0,
              //                     color: Colors.black)),
              //             trailing: Switch(
              //               onChanged: (value) {
              //                 setState(() {
              //                   change = !change;
              //                   print(change);
              //                 });
              //               },
              //               value: change,
              //               activeColor: const Color(0xffFECC00),
              //               activeTrackColor: const Color(0xff535353),
              //             ),
              //           ),
              //           change
              //               ? Column(
              //                   children: [
              //                     Center(
              //                       child: Text(
              //                         Strings.kycUpdate,
              //                         style: TextStyle(
              //                             fontFamily: Strings.robotoMedium,
              //                             fontSize: 21.0,
              //                             color: Colors.black),
              //                       ),
              //                     ),
              //                     Row(
              //                       mainAxisAlignment: MainAxisAlignment.center,
              //                       children: [
              //                         Padding(
              //                           padding: const EdgeInsets.only(left: 20.0, top: 15),
              //                           child: ClipRRect(
              //                             borderRadius: BorderRadius.circular(5),
              //                             child: SizedBox(
              //                               height: 140,
              //                               width: 140,
              //                               child: imageurl != null
              //                                   ? Image.network(imageurl!)
              //                                   : Image.file(image!),
              //                             ),
              //                           ),
              //                         ),
              //                         //http://prabhu.yoursoftwaredemo.com/uploads/userKYC/1766852678295846.jpg
              //                         //http://prabhu.yoursoftwaredemo.com/uploads/userKYC/1766852678295846.jpg
              //                         Expanded(
              //                           child: Padding(
              //                             padding: const EdgeInsets.only(left: 20.0),
              //                             child: Column(
              //                               crossAxisAlignment: CrossAxisAlignment.start,
              //                               children: [
              //                                 ABButton(
              //                                   paddingTop: 15.0,
              //                                   paddingBottom: 0.0,
              //                                   paddingLeft: 10.0,
              //                                   paddingRight: 15.0,
              //                                   text: 'Upload'.tr,
              //                                   onPressed: () {
              //                                     pickImage();
              //                                     // setState(() {
              //                                     //   image;
              //                                     // });
              //                                   },
              //                                 ),
              //                               ],
              //                             ),
              //                           ),
              //                         ),
              //                       ],
              //                     ),
              //                     Padding(
              //                       padding: const EdgeInsets.only(top: 8.0),
              //                       child: ABTextInput(
              //                         autoValidator: AutovalidateMode.onUserInteraction,
              //                         helperText: "* required".tr,
              //                         textInputType: TextInputType.number,
              //                         isCustomInput:true,
              //                         titleText: 'Account Number'.tr,
              //                         validator: (value) {
              //                           if (value == null || value.isEmpty) {
              //                             return 'Enter Account Number'.tr;
              //                           }
              //                           if (value.length<9) {
              //                             return 'Account Number Should be 9 or more digit'.tr;
              //                           }
              //                           return null;
              //                         },
              //                         controller: accountNumber,
              //                         // hintText: Strings.enterYourFastNameHere,
              //                       ),
              //                     ),
              //                     Padding(
              //                       padding: const EdgeInsets.only(left: 25.0, right: 15),
              //                       child: Row(
              //                         crossAxisAlignment: CrossAxisAlignment.center,
              //                         children: [
              //                           Expanded(
              //                             child: Text(
              //                               pdfFile != null && pdfFile!.path!=''
              //                                   ? path.basename(pdfFile!.path)
              //                                   : 'Bank Statement'.tr,
              //                               style: TextStyle(
              //                                 fontFamily: Strings.robotoRegular,
              //                                 fontSize: 15.0,
              //                                 color: const Color(0xff535353),
              //                               ),
              //                             ),
              //                           ),
              //                           SizedBox(
              //                             width: 200,
              //                             child: ABButton(
              //                               paddingTop: 15.0,
              //                               paddingBottom: 0.0,
              //                               paddingLeft: 0.0,
              //                               paddingRight: 15.0,
              //                               text: 'Upload Bank Statement'.tr,
              //                               onPressed: () async {
              //                                 final permissionStatus =
              //                                 await Permission.storage.status;
              //                                 print(permissionStatus);
              //                                 if (permissionStatus.isDenied) {
              //                                   // Here just ask for the permission for the first time
              //                                   await Permission.storage.request();
              //
              //                                   // I noticed that sometimes popup won't show after user press deny
              //                                   // so I do the check once again but now go straight to appSettings
              //                                   if (permissionStatus.isDenied) {
              //                                     await openAppSettings();
              //                                   }
              //                                 } else if (permissionStatus.isPermanentlyDenied) {
              //                                   // Here open app settings for user to manually enable permission in case
              //                                   // where permission was permanently denied
              //                                   await openAppSettings();
              //                                 } else {
              //                                   FilePickerResult? result =
              //                                   await FilePicker.platform.pickFiles(
              //                                     type: FileType.custom,
              //                                     allowedExtensions: ['pdf'],
              //                                   );
              //
              //                                   if (result != null) {
              //                                     pdfFile = File(result.files.first.path!);
              //                                     setState(() {});
              //                                     // print("called moin $")
              //                                   }
              //                                 }
              //                                 // pickImage();
              //                                 // setState(() {
              //                                 //   image;
              //                                 // });
              //                               },
              //                             ),
              //                           )
              //                         ],
              //                       ),
              //                     ),
              //                     Padding(
              //                       padding: const EdgeInsets.only(top: 8.0),
              //                       child: ABTextInput(
              //                         autoValidator: AutovalidateMode.onUserInteraction,
              //                         titleText: 'IFSC Code',
              //                         helperText: "* required".tr,
              //                         validator: (value) {
              //                           if (value == null || value.isEmpty) {
              //                             return 'Enter IFSC Code'.tr;
              //                           }
              //                           if (value.length!=11) {
              //                             return 'IFSC Code must be 11 digit'.tr;
              //                           }
              //                           return null;
              //                         },
              //                         controller: ifscCode,
              //                         // hintText: Strings.enterYourFastNameHere,
              //                       ),
              //                     ),
              //                     Padding(
              //                       padding: const EdgeInsets.only(top: 8.0),
              //                       child: ABTextInput(
              //                         autoValidator: AutovalidateMode.onUserInteraction,
              //                         textInputType: TextInputType.number,
              //                         titleText: 'AADHAR Number'.tr,
              //                         helperText: "* required".tr,
              //                         validator: (value) {
              //                           if (value == null || value.isEmpty) {
              //                             return 'Enter aadhar number';
              //                           }
              //                           if (value.length!=12) {
              //                             return 'aadhar number must be 12 digit'.tr;
              //                           }
              //                           return null;
              //                         },
              //                         controller: aadhaNumber,
              //                         // hintText: Strings.enterYourFastNameHere,
              //                       ),
              //                     ),
              //                     Padding(
              //                       padding: const EdgeInsets.only(top: 8.0),
              //                       child: ABTextInput(
              //                         autoValidator: AutovalidateMode.onUserInteraction,
              //                         titleText: 'Voter ID'.tr,
              //                         helperText: "* required".tr,
              //                         validator: (value) {
              //                           if (value == null || value.isEmpty) {
              //                             return 'Enter Voter ID'.tr;
              //                           }
              //                           if (value.length<11) {
              //                             return 'Voter ID must be 11 digit'.tr;
              //                           }
              //                           return null;
              //                         },
              //                         controller: voterId,
              //                         // hintText: Strings.enterYourFastNameHere,
              //                       ),
              //                     ),
              //                     Padding(
              //                       padding: const EdgeInsets.only(top: 8.0),
              //                       child: ABTextInput(
              //                         autoValidator: AutovalidateMode.onUserInteraction,
              //                         helperText: "* required".tr,
              //                         titleText: 'Bank Name'.tr,
              //                         validator: (value) {
              //                           if (value == null || value.isEmpty) {
              //                             return 'Enter Bank Name'.tr;
              //                           }
              //                           return null;
              //                         },
              //                         controller: panNumber,
              //                         // hintText: Strings.enterYourFastNameHere,
              //                       ),
              //                     ),
              //                     (
              //                       //
              //                           ref.watch(baseViewModel)
              //                                     .kCurrentUser!
              //                                     .userKyc!
              //                                     .kycdropdown ==
              //                                 "rejected")
              //                         ? ABButton(
              //                             paddingTop: 40.0,
              //                             paddingBottom: 30.0,
              //                             paddingLeft: 25.0,
              //                             paddingRight: 25.0,
              //                             text: 'Update Kyc'.tr,
              //                             onPressed: () async {
              //
              //                               if (_formKey.currentState!.validate()) {
              //                                 if (image != null) {
              //                                   // print(pdfFile!.path);
              //                                   if (pdfFile != null) {
              //                                     ref
              //                                         .watch(
              //                                         authenticationProvider)
              //                                         .kycUpdateAPI(
              //                                       context: context,
              //                                       aadhaarNumber: aadhaNumber.text,
              //                                       panNumber: panNumber.text,
              //                                       voterId: voterId.text,
              //                                       bank: accountNumber.text,
              //                                       ifscCode: ifscCode.text,
              //                                       file:image!,
              //                                       pdfFile: pdfFile!=null?pdfFile!:File(''),
              //                                     );
              //                                   }
              //                                   else {
              //                                     handleApiError('Please select Pdf ', context);
              //                                   }
              //                                 } else {
              //                                   handleApiError('Please select Image ', context);
              //                                 }
              //                               } else {
              //                                 showSnackBar(
              //                                     backgroundColor: Colors.redAccent,
              //                                     message: "Please Fill up all the details".tr,
              //                                     context: context);
              //                               }
              //                             },
              //                           )
              //                         : SizedBox(),
              //                   ],
              //                 )
              //               : change &&
              //                       ref
              //                               .watch(baseViewModel)
              //                               .kCurrentUser!
              //                               .kyc !=
              //                           null &&
              //                       ref.watch(baseViewModel).kCurrentUser!.kyc!
              //                   ? Column(
              //                       children: [
              //                         Center(
              //                           child: Text(
              //                             Strings.kycUpdate,
              //                             style: TextStyle(
              //                                 fontFamily: Strings.robotoMedium,
              //                                 fontSize: 21.0,
              //                                 color: Colors.black),
              //                           ),
              //                         ),
              //                         Row(
              //                           mainAxisAlignment: MainAxisAlignment.center,
              //                           children: [
              //                             Padding(
              //                               padding: const EdgeInsets.only(left: 20.0, top: 15),
              //                               child: ClipRRect(
              //                                 borderRadius: BorderRadius.circular(5),
              //                                 child: SizedBox(
              //                                   height: 140,
              //                                   width: 140,
              //                                   child: imageurl != null
              //                                       ? Image.network(imageurl!)
              //                                       : Image.file(image!),
              //                                 ),
              //                               ),
              //                             ),
              //                             Expanded(
              //                               child: Padding(
              //                                 padding: const EdgeInsets.only(left: 20.0),
              //                                 child: Column(
              //                                   crossAxisAlignment: CrossAxisAlignment.start,
              //                                   children: [
              //                                     ABButton(
              //                                       paddingTop: 15.0,
              //                                       paddingBottom: 0.0,
              //                                       paddingLeft: 10.0,
              //                                       paddingRight: 15.0,
              //                                       text: 'Upload'.tr,
              //                                       onPressed: () {
              //                                         pickImage();
              //                                         // setState(() {
              //                                         //   image;
              //                                         // });
              //                                       },
              //                                     ),
              //                                   ],
              //                                 ),
              //                               ),
              //                             ),
              //                           ],
              //                         ),
              //                         Padding(
              //                           padding: const EdgeInsets.only(top: 8.0),
              //                           child: ABTextInput(
              //                             autoValidator: AutovalidateMode.onUserInteraction,
              //                             helperText: "* required".tr,
              //                             textInputType: TextInputType.number,
              //                             isCustomInput:true,
              //                             titleText: 'Account Number'.tr,
              //                             validator: (value) {
              //                               if (value == null || value.isEmpty) {
              //                                 return 'Enter Account Number'.tr;
              //                               }
              //                               if (value.length<9) {
              //                                 return 'Account Number Should be 9 or more digit'.tr;
              //                               }
              //                               return null;
              //                             },
              //                             controller: accountNumber,
              //                             // hintText: Strings.enterYourFastNameHere,
              //                           ),
              //                         ),
              //                         Padding(
              //                           padding: const EdgeInsets.only(left: 25.0, right: 15),
              //                           child: Row(
              //                             crossAxisAlignment: CrossAxisAlignment.center,
              //                             children: [
              //                               Expanded(
              //                                 child: Text(
              //                                   pdfFile != null
              //                                       ? path.basename(pdfFile!.path)
              //                                       : 'Bank Statement'.tr,
              //                                   style: TextStyle(
              //                                     fontFamily: Strings.robotoRegular,
              //                                     fontSize: 15.0,
              //                                     color: const Color(0xff535353),
              //                                   ),
              //                                 ),
              //                               ),
              //                               SizedBox(
              //                                 width: 200,
              //                                 child: ABButton(
              //                                   paddingTop: 15.0,
              //                                   paddingBottom: 0.0,
              //                                   paddingLeft: 0.0,
              //                                   paddingRight: 15.0,
              //                                   text: 'Upload Bank Statement'.tr,
              //                                   onPressed: () async {
              //                                     final permissionStatus =
              //                                     await Permission.storage.status;
              //                                     print(permissionStatus);
              //                                     if (permissionStatus.isDenied) {
              //                                       // Here just ask for the permission for the first time
              //                                       await Permission.storage.request();
              //
              //                                       // I noticed that sometimes popup won't show after user press deny
              //                                       // so I do the check once again but now go straight to appSettings
              //                                       if (permissionStatus.isDenied) {
              //                                         await openAppSettings();
              //                                       }
              //                                     } else if (permissionStatus.isPermanentlyDenied) {
              //                                       // Here open app settings for user to manually enable permission in case
              //                                       // where permission was permanently denied
              //                                       await openAppSettings();
              //                                     } else {
              //                                       FilePickerResult? result =
              //                                       await FilePicker.platform.pickFiles(
              //                                         type: FileType.custom,
              //                                         allowedExtensions: ['pdf'],
              //                                       );
              //
              //                                       if (result != null) {
              //                                         pdfFile = File(result.files.first.path!);
              //                                         setState(() {});
              //                                         // print("called moin $")
              //                                       }
              //                                     }
              //                                     // pickImage();
              //                                     // setState(() {
              //                                     //   image;
              //                                     // });
              //                                   },
              //                                 ),
              //                               )
              //                             ],
              //                           ),
              //                         ),
              //                         Padding(
              //                           padding: const EdgeInsets.only(top: 8.0),
              //                           child: ABTextInput(
              //                             autoValidator: AutovalidateMode.onUserInteraction,
              //                             titleText: 'IFSC Code',
              //                             helperText: "* required".tr,
              //                             validator: (value) {
              //                               if (value == null || value.isEmpty) {
              //                                 return 'Enter IFSC Code'.tr;
              //                               }
              //                               if (value.length!=11) {
              //                                 return 'IFSC Code must be 11 digit'.tr;
              //                               }
              //                               return null;
              //                             },
              //                             controller: ifscCode,
              //                             // hintText: Strings.enterYourFastNameHere,
              //                           ),
              //                         ),
              //                         Padding(
              //                           padding: const EdgeInsets.only(top: 8.0),
              //                           child: ABTextInput(
              //                             autoValidator: AutovalidateMode.onUserInteraction,
              //                             textInputType: TextInputType.number,
              //                             titleText: 'AADHAR Number'.tr,
              //                             helperText: "* required".tr,
              //                             validator: (value) {
              //                               if (value == null || value.isEmpty) {
              //                                 return 'Enter aadhar number';
              //                               }
              //                               if (value.length!=12) {
              //                                 return 'aadhar number must be 12 digit'.tr;
              //                               }
              //                               return null;
              //                             },
              //                             controller: aadhaNumber,
              //                             // hintText: Strings.enterYourFastNameHere,
              //                           ),
              //                         ),
              //                         Padding(
              //                           padding: const EdgeInsets.only(top: 8.0),
              //                           child: ABTextInput(
              //                             autoValidator: AutovalidateMode.onUserInteraction,
              //                             titleText: 'Voter ID'.tr,
              //                             helperText: "* required".tr,
              //                             validator: (value) {
              //                               if (value == null || value.isEmpty) {
              //                                 return 'Enter Voter ID'.tr;
              //                               }
              //                               if (value.length<11) {
              //                                 return 'Voter ID must be 11 digit'.tr;
              //                               }
              //                               return null;
              //                             },
              //                             controller: voterId,
              //                             // hintText: Strings.enterYourFastNameHere,
              //                           ),
              //                         ),
              //                         Padding(
              //                           padding: const EdgeInsets.only(top: 8.0),
              //                           child: ABTextInput(
              //                             autoValidator: AutovalidateMode.onUserInteraction,
              //                             helperText: "* required".tr,
              //                             titleText: 'Bank Name'.tr,
              //                             validator: (value) {
              //                               if (value == null || value.isEmpty) {
              //                                 return 'Enter Bank Name'.tr;
              //                               }
              //                               return null;
              //                             },
              //                             controller: panNumber,
              //                             // hintText: Strings.enterYourFastNameHere,
              //                           ),
              //                         ),
              //                         (
              //                             // ref
              //                         //     .watch(baseViewModel)
              //                         //     .kCurrentUser!
              //                         //     .userKyc!
              //                         //     .kycdropdown ==
              //                         //     "pending"||
              //                                 ref
              //                                         .watch(baseViewModel)
              //                                         .kCurrentUser!
              //                                         .userKyc!
              //                                         .kycdropdown ==
              //                                     "rejected")
              //                             ? ABButton(
              //                                 paddingTop: 40.0,
              //                                 paddingBottom: 30.0,
              //                                 paddingLeft: 25.0,
              //                                 paddingRight: 25.0,
              //                                 text: 'Update Kyc'.tr,
              //                                 onPressed: () async {
              //                                   if (_formKey.currentState!.validate()) {
              //                                     if (image != null) {
              //                                       // print(pdfFile!.path);
              //                                       if (pdfFile != null) {
              //                                         ref
              //                                             .watch(
              //                                             authenticationProvider)
              //                                             .kycUpdateAPI(
              //                                           context: context,
              //                                           aadhaarNumber: aadhaNumber.text,
              //                                           panNumber: panNumber.text,
              //                                           voterId: voterId.text,
              //                                           bank: accountNumber.text,
              //                                           ifscCode: ifscCode.text,
              //                                           file:image!,
              //                                           pdfFile: pdfFile!=null?pdfFile!:File(''),
              //                                         );
              //                                       }
              //                                       else {
              //                                         handleApiError('Please select Pdf ', context);
              //                                       }
              //                                     } else {
              //                                       handleApiError('Please select Image ', context);
              //                                     }
              //                                   } else {
              //                                     showSnackBar(
              //                                         backgroundColor: Colors.redAccent,
              //                                         message: "Please Fill up all the details".tr,
              //                                         context: context);
              //                                   }
              //                                 },
              //                               )
              //                             : SizedBox()
              //                       ],
              //                     )
              //                   : const SizedBox()
              //         ],
              //       )
              //     : SizedBox()
            ],
          ),
        ),
      ),
    );
  }

  Future<File> imageToFile({String? imageName}) async {
    final http.Response responseData = await http.get(Uri.parse(imageName!));
    var uint8list = responseData.bodyBytes;
    var buffer = uint8list.buffer;
    ByteData byteData = ByteData.view(buffer);
    var tempDir = await getTemporaryDirectory();
    File file = await File('${tempDir.path}/img').writeAsBytes(
        buffer.asUint8List(byteData.offsetInBytes, byteData.lengthInBytes));
    return file;
  }

  Future<File> getImageFileFromAssets(String path) async {
    final byteData = await rootBundle.load('assets/$path');

    final file = File('${(await getTemporaryDirectory()).path}/$path');
    await file.writeAsBytes(byteData.buffer
        .asUint8List(byteData.offsetInBytes, byteData.lengthInBytes));
    return file;
  }

  Future pickImage() async {
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (image == null) return;
      final imageTemp = File(image.path);
      imageurl=null;
      setState(() => this.image = imageTemp);
    } on PlatformException catch (e) {
      print('Failed to pick image: $e');
    }
  }
}
