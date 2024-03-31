import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hellomegha/core/notifier/providers.dart';
import 'package:hellomegha/core/urls/urls.dart';
import 'package:hellomegha/core/utils/app_images.dart';
import 'package:hellomegha/core/utils/strings.dart';
import 'package:hellomegha/core/utils/utils.dart';
import 'package:hellomegha/core/widgets/ab_button.dart';
import 'package:hellomegha/core/widgets/ab_text_input.dart';
import 'package:hellomegha/core/widgets/common_image.dart';
import 'package:hellomegha/screens/CommonWebView.dart';
import 'package:hellomegha/screens/home/ViewPdf.dart';
import 'package:hellomegha/screens/register/register_view.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;
import 'package:hellomegha/screens/no_network.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:get/get.dart';
class KycView extends ConsumerStatefulWidget {
  const KycView({Key? key}) : super(key: key);

  @override
  ConsumerState<KycView> createState() => _KycViewState();
}

class _KycViewState extends ConsumerState<KycView> {
  File? image;
  String defaultImage = AppImages.icBot;
  final accountNumber = TextEditingController();
  final ifscCode = TextEditingController();
  final aadhaNumber = TextEditingController();
  final voterId = TextEditingController();
  final panNumber = TextEditingController();

  File? pdfFile;
  final _formKey = GlobalKey<FormState>();
  String? imageurl;
  bool read=false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    var userData = ref
        .read(baseViewModel)
        .kCurrentUser;
    if (userData!.userKyc != null) {
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
      print("url=$imageurl");
      print("url=$pdfFile");
      if(userData.userKyc!.kycdropdown!=null && userData.userKyc!.kycdropdown=="rejected" || userData.userKyc!.kycdropdown=="unverified")
      {
        read=false;
      }
      else
      {
        read=true;
      }
      // else if(userData.userKyc!.kycdropdown!=null && userData.userKyc!.kycdropdown=="unverified")
      //   {
      //     read=true;
      //   }
    }
  }
  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    Connectivity().checkConnectivity().then((value) {
      if (value == ConnectivityResult.none) {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => NoNetwork()));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(70.0),
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
            titleSpacing: 0,
            backgroundColor: Colors.white,
            title: Text(
              'KYC ',
              style: TextStyle(
                  fontFamily: Strings.robotoMedium,
                  fontSize: 21.0,
                  color: Colors.black),
            ),
            // actions: [
            //   // const Padding(
            //   //   padding: EdgeInsets.only(right: 15.0),
            //   //   child: Icon(Icons.search_rounded),
            //   // ),
            //   Padding(
            //     padding: const EdgeInsets.only(right: 15.0),
            //     child: Container(
            //       decoration: const BoxDecoration(
            //         shape: BoxShape.circle,
            //         color: Color(0xFFFECC00),
            //       ),
            //       child: const Padding(
            //         padding: EdgeInsets.all(4.0),
            //         child: Icon(Icons.person_rounded, color: Colors.white),
            //       ),
            //     ),
            //   )
            // ],
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
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  imageurl != ''?Padding(
                    padding: const EdgeInsets.only(left: 20.0, top: 15),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(5),
                      child: SizedBox(
                        height: 140,
                        width: 140,
                        child: imageurl != '' || imageurl !=null
                            ? CommonImage(imageUrl: imageurl!)
                            : CommonImage(imageUrl: 'http://prabhu.yoursoftwaredemo.com/images/profile.jpg'),
                      ),
                    ),
                  ):image != null || image !=''?Padding(
                    padding: const EdgeInsets.only(left: 20.0, top: 15),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(5),
                      child: SizedBox(
                        height: 140,
                        width: 140,
                        child:image != null
                            ? Image.file(image!)
                            : CommonImage(imageUrl: 'http://prabhu.yoursoftwaredemo.com/images/profile.jpg'),
                      ),
                    ),
                  ):
                  Padding(
                    padding: const EdgeInsets.only(left: 20.0, top: 15),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(5),
                      child: SizedBox(
                        height: 140,
                        width: 140,
                        child: CommonImage(imageUrl: 'http://prabhu.yoursoftwaredemo.com/images/profile.jpg'),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ABButton(
                            paddingTop: 15.0,
                            paddingBottom: 0.0,
                            paddingLeft: 10.0,
                            paddingRight: 15.0,
                            text: 'Upload Image'.tr,
                            onPressed: ref.watch(baseViewModel).kCurrentUser!.userKyc!.kycdropdown != null &&
                                ref.watch(baseViewModel).kCurrentUser!.userKyc!.kycdropdown=="rejected" ||
                                ref.watch(baseViewModel).kCurrentUser!.userKyc!.kycdropdown=="unverified"?() {
                              if(imageurl != '' || imageurl !=null)
                              {
                                pickImage();
                              }
                              else if(image != null || image !='')
                              {
                                pickImage();
                              }
                              else
                              {
                                Future.value(null);
                              }
                              // setState(() {
                              //   image;
                              // });
                            }:null,
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: ABTextInput(
                  isEnabled: read,
                  autoValidator: AutovalidateMode.onUserInteraction,
                  helperText: "* required".tr,
                  textInputType: TextInputType.number,
                  isCustomInput:true,
                  titleText: 'Account Number'.tr,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Enter Account Number'.tr;
                    }
                    if (value.length<9) {
                      return 'Account Number Should be 9 or more digit'.tr;
                    }
                    return null;
                  },
                  controller: accountNumber,
                  // hintText: Strings.enterYourFastNameHere,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 25.0, right: 15),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Container(
                        margin: EdgeInsets.only(top: 15),
                        alignment: Alignment.center,
                        child: Text(
                          // textAlign: TextAlign.center,
                          maxLines: 1,
                          pdfFile!.path != ''
                              ? path.basename(pdfFile!.path)
                              : 'Bank Statement'.tr,
                          style: TextStyle(
                            fontFamily: Strings.robotoRegular,
                            fontSize: 15.0,
                            color: const Color(0xff535353),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 200,
                      child: ABButton(
                        paddingTop: 15.0,
                        paddingBottom: 0.0,
                        paddingLeft: 0.0,
                        paddingRight: 15.0,
                        text: pdfFile!.path != ''?'View Bank Statement'.tr:'Upload Bank Statement'.tr,
                        onPressed: () async {
                          if(pdfFile!.path=='' )
                            {
                              final permissionStatus =
                              await Permission.storage.status;
                              print(permissionStatus);
                              if (permissionStatus.isDenied) {
                                // Here just ask for the permission for the first time
                                await Permission.storage.request();

                                // I noticed that sometimes popup won't show after user press deny
                                // so I do the check once again but now go straight to appSettings
                                if (permissionStatus.isDenied) {
                                  await openAppSettings();
                                }
                              } else if (permissionStatus.isPermanentlyDenied) {
                                // Here open app settings for user to manually enable permission in case
                                // where permission was permanently denied
                                await openAppSettings();
                              } else {
                                FilePickerResult? result =
                                await FilePicker.platform.pickFiles(
                                  type: FileType.custom,
                                  allowedExtensions: ['pdf'],
                                );

                                if (result != null) {
                                  pdfFile = File(result.files.first.path!);
                                  setState(() {});
                                  // print("called moin $")
                                }
                              }
                            }
                          else
                            {
                              // Navigator.push(
                              //   context,
                              //   MaterialPageRoute(
                              //     builder: (context) => CommonWebView(title:"Bank Statement".tr,url: "http://prabhu.yoursoftwaredemo.com/${pdfFile!.path}"),
                              //   ),
                              // );
                              Navigator.push(context, MaterialPageRoute(builder: (context) =>ViewPdf(path: "http://prabhu.yoursoftwaredemo.com/${pdfFile!.path}") ,));
                            }
                        },
                      ),
                    )
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: ABTextInput(
                  isEnabled: read,
                  autoValidator: AutovalidateMode.onUserInteraction,
                  titleText: 'IFSC Code',
                  helperText: "* required".tr,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Enter IFSC Code'.tr;
                    }
                    if (value.length!=11) {
                      return 'IFSC Code must be 11 digit'.tr;
                    }
                    return null;
                  },
                  controller: ifscCode,
                  // hintText: Strings.enterYourFastNameHere,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: ABTextInput(
                  isEnabled: read,
                  autoValidator: AutovalidateMode.onUserInteraction,
                  textInputType: TextInputType.number,
                  titleText: 'AADHAR Number'.tr,
                  helperText: "* required".tr,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Enter aadhar number';
                    }
                    if (value.length!=12) {
                      return 'aadhar number must be 12 digit'.tr;
                    }
                    return null;
                  },
                  controller: aadhaNumber,
                  // hintText: Strings.enterYourFastNameHere,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: ABTextInput(
                  isEnabled: read,
                  autoValidator: AutovalidateMode.onUserInteraction,
                  titleText: 'Voter ID'.tr,
                  helperText: "* required".tr,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Enter Voter ID'.tr;
                    }
                    if (value.length<11) {
                      return 'Voter ID must be 11 digit'.tr;
                    }
                    return null;
                  },
                  controller: voterId,
                  // hintText: Strings.enterYourFastNameHere,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: ABTextInput(
                  isEnabled: read,
                  customInputFormatters: <TextInputFormatter>[
                    UpperCaseTextFormatter()
                  ],
                  autoValidator: AutovalidateMode.onUserInteraction,
                  helperText: "* required".tr,
                  titleText: 'Bank Name'.tr,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Enter Bank Name'.tr;
                    }
                    return null;
                  },
                  controller: panNumber,
                  // hintText: Strings.enterYourFastNameHere,
                ),
              ),

              ABButton(
                paddingTop: 10.0,
                paddingBottom: 30.0,
                paddingLeft: 25.0,
                paddingRight: 25.0,
                text: ref.watch(baseViewModel).kCurrentUser!.userKyc!.kycdropdown != null &&
                    ref.watch(baseViewModel).kCurrentUser!.userKyc!.kycdropdown=="unverified"?
                    'Apply KYC'.tr:
                ref.watch(baseViewModel).kCurrentUser!.userKyc!.kycdropdown=="rejected"?'Update KYC'.tr:
                ref.watch(baseViewModel).kCurrentUser!.userKyc!.kycdropdown=="pending"?'Pending KYC'.tr:
                'KYC Verified'.tr,
                onPressed: ref.watch(baseViewModel).kCurrentUser!.userKyc!.kycdropdown != null &&
                    ref.watch(baseViewModel).kCurrentUser!.userKyc!.kycdropdown=="rejected" ||
                    ref.watch(baseViewModel).kCurrentUser!.userKyc!.kycdropdown=="unverified"?() async {
                  if (_formKey.currentState!.validate()) {
                    if (image != null) {
                      // print(pdfFile!.path);
                      if (pdfFile != null) {
                        if(ref.watch(baseViewModel).kCurrentUser!.userKyc!.kycdropdown != null &&
                            ref.watch(baseViewModel).kCurrentUser!.userKyc!.kycdropdown=="rejected")
                        {
                          ref.watch(authenticationProvider).kycUpdateAPI(
                            context: context,
                            aadhaarNumber: aadhaNumber.text,
                            panNumber: panNumber.text.length > 0
                                ? panNumber.text
                                : "",
                            voterId: voterId.text,
                            bank: accountNumber.text,
                            ifscCode: ifscCode.text,
                            file: image!,
                            pdfFile: pdfFile!=null?pdfFile!:File(''),
                          );
                        }
                        else
                        {
                          ref
                              .watch(
                              authenticationProvider)
                              .kycAPI(
                            context: context,
                            aadhaarNumber: aadhaNumber.text,
                            panNumber: panNumber.text,
                            voterId: voterId.text,
                            bank: accountNumber.text,
                            ifscCode: ifscCode.text,
                            file:image!,
                            pdfFile: pdfFile!=null?pdfFile!:File(''),
                          );
                        }
                      }
                      else {
                        handleApiError('Please select Pdf ', context);
                      }
                    } else {
                      handleApiError('Please select Image ', context);
                    }
                  } else {
                    showSnackBar(
                        backgroundColor: Colors.redAccent,
                        message: "Please Fill up all the details".tr,
                        context: context);
                  }
                }:null,
              ),
            ],
          ),
        ),
      ),
    );
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
      setState(() => this.image = imageTemp);
    } on PlatformException catch (e) {
      print('Failed to pick image: $e');
    }
  }
}
