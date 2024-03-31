import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hellomegha/core/api_factory/prefs/pref_utils.dart';
import 'package:hellomegha/core/notifier/base_view_model.dart';
import 'package:hellomegha/core/notifier/providers.dart';
import 'package:hellomegha/core/urls/urls.dart';
import 'package:hellomegha/core/utils/strings.dart';
import 'package:hellomegha/core/utils/theme_config.dart';
import 'package:hellomegha/core/utils/utils.dart';
import 'package:hellomegha/core/widgets/ab_button.dart';
import 'package:hellomegha/core/widgets/ab_button_grey.dart';
import 'package:hellomegha/core/widgets/common_image.dart';
import 'package:hellomegha/screens/DownloadAllList.dart';
import 'package:hellomegha/screens/home/downloads_list_view.dart';
import 'package:hellomegha/screens/home/kyc_view.dart';
import 'package:hellomegha/screens/home/withdraw_coins_view.dart';
import 'package:hellomegha/screens/login/login_view.dart';
import 'package:hellomegha/screens/my_list/mylist_view.dart';
import 'package:hellomegha/screens/register/register_view.dart';
import 'package:hellomegha/screens/update_profile/update_profile_view.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import '../forgotpassword/forgot_password_screen.dart';
import '../notifications_view.dart';
import '../settings/settings_view.dart';
import 'package:hellomegha/screens/no_network.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class MoreView extends ConsumerStatefulWidget {
  const MoreView({Key? key}) : super(key: key);

  @override
  ConsumerState<MoreView> createState() => _MoreViewState();
}

class _MoreViewState extends ConsumerState<MoreView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(75.0),
        child: Padding(
          padding: const EdgeInsets.all(5.0),
          child: AppBar(
            titleSpacing: 0,
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
              'Profile Tab'.tr,
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
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 20.0),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(5),
                    child: SizedBox(
                      height: 140,
                      width: 120,
                      child: CommonImage(
                        imageUrl: ref
                            .watch(baseViewModel)
                            .kCurrentUser!
                            .userKyc!.photo !=
                            null &&
                            ref
                                .watch(baseViewModel)
                                .kCurrentUser!
                                .userKyc!
                                .photo!
                                .isNotEmpty
                            ? "${AppUrls.baseUrl}${ref.watch(baseViewModel).kCurrentUser?.userKyc!.photo!}"
                            : 'http://prabhu.yoursoftwaredemo.com/images/profile.jpg',
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                                ref.watch(baseViewModel).kCurrentUser!.firstname != null
                                    ? "${ref.watch(baseViewModel).kCurrentUser?.firstname!}"
                                    : "User",
                                style: TextStyle(
                                  fontFamily: Strings.robotoMedium,
                                  fontSize: 25.0,
                                  color: const Color(0xff272727),
                                )),
                            Text(
                                maxLines: 1,
                                ref.watch(baseViewModel).kCurrentUser!.lastname != null
                                    ? " ${ref.watch(baseViewModel).kCurrentUser?.lastname!}"
                                    : "User",
                                style: TextStyle(
                                  fontFamily: Strings.robotoMedium,
                                  fontSize: 25.0,
                                  color: const Color(0xff272727),
                                )),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 5.0),
                          child: Text(
                              ref.watch(baseViewModel).kCurrentUser!.userKyc!.kycdropdown !=
                                  null
                                  ? "KYC Status : ${capitalize("${ref.watch(baseViewModel).kCurrentUser?.userKyc!.kycdropdown!}")}"
                                  : "Pending".tr,
                              style: TextStyle(
                                fontFamily: Strings.robotoRegular,
                                fontSize: 15.0,
                                color: Colors.grey,
                              )),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 5.0),
                          child: Text(
                              ref.watch(baseViewModel).kCurrentUser!.mobile!=
                                  null
                                  ? "${ref.watch(baseViewModel).kCurrentUser!.mobile!}"
                                  : "".tr,
                              style: TextStyle(
                                fontFamily: Strings.robotoRegular,
                                fontSize: 15.0,
                                color: Colors.grey,
                              )),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 5.0),
                          child: Text(
                              ref.watch(baseViewModel).kCurrentUser!.email !=
                                  null
                                  ? "${ref.watch(baseViewModel).kCurrentUser?.email!}"
                                  : "No email".tr,
                              style: TextStyle(
                                fontFamily: Strings.robotoRegular,
                                fontSize: 15.0,
                                color: Colors.grey,
                              )),
                        ),

                        // ref.watch(baseViewModel).kCurrentUser!.userKyc!.kycdropdown !=
                        //     null && ref.watch(baseViewModel).kCurrentUser!.userKyc!.kycdropdown=="rejected"
                        //     ?Padding(
                        //   padding: const EdgeInsets.only(top: 5.0),
                        //   child: Text(
                        //       "Reason : ${ref.watch(baseViewModel).kCurrentUser?.userKyc!.reason}",
                        //       maxLines: 2,
                        //       style: TextStyle(
                        //         fontFamily: Strings.robotoRegular,
                        //         fontSize: 15.0,
                        //         color: Colors.red,
                        //       )),
                        // ):SizedBox(),
                        // ref.watch(baseViewModel).kCurrentUser!.userKyc!.kycdropdown !=
                        //     null && ref.watch(baseViewModel).kCurrentUser!.userKyc!.kycdropdown=="unverified"
                        //     ?Padding(
                        //   padding: const EdgeInsets.only(top: 5.0),
                        //   child: Text(
                        //       "Reason : Apply for KYC",
                        //       maxLines: 2,
                        //       style: TextStyle(
                        //         fontFamily: Strings.robotoRegular,
                        //         fontSize: 15.0,
                        //         color: Colors.red,
                        //       )),
                        // ):SizedBox(),
                        // ref.watch(baseViewModel).kCurrentUser!.userKyc!.kycdropdown !=
                        //     null && ref.watch(baseViewModel).kCurrentUser!.userKyc!.kycdropdown=="pending"
                        //     ?Padding(
                        //   padding: const EdgeInsets.only(top: 5.0),
                        //   child: Text(
                        //       "Reason : Waiting for Approval",
                        //       maxLines: 2,
                        //       style: TextStyle(
                        //         fontFamily: Strings.robotoRegular,
                        //         fontSize: 15.0,
                        //         color: Colors.red,
                        //       )),
                        // ):SizedBox(),
                        // ref.watch(baseViewModel).kCurrentUser!.userKyc!.kycdropdown !=
                        //     null && ref.watch(baseViewModel).kCurrentUser!.userKyc!.kycdropdown=="verified"
                        //     ?Padding(
                        //   padding: const EdgeInsets.only(top: 5.0),
                        //   child: Text(
                        //       "Reason : Already Verified",
                        //       maxLines: 2,
                        //       style: TextStyle(
                        //         fontFamily: Strings.robotoRegular,
                        //         fontSize: 15.0,
                        //         color: Colors.red,
                        //       )),
                        // ):SizedBox(),
                        Padding(
                          padding: const EdgeInsets.only(top: 15.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              SizedBox(
                                  height: 20,
                                  child: Container(
                                      decoration: const BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Color(0xFFFECC00),
                                      ),
                                      child:  Padding(
                                        padding: EdgeInsets.all(4.0),
                                        child: Image.asset("assets/coin.png"),
                                      ))),
                              Padding(
                                padding: const EdgeInsets.only(left: 10.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('Available Coins'.tr,
                                        style: TextStyle(
                                          fontFamily: Strings.robotoMedium,
                                          fontSize: 11.0,
                                          color: Colors.black,
                                        )),
                                    Text(
                                        ref
                                            .watch(baseViewModel)
                                            .kCurrentUser!
                                            .amount !=
                                            null
                                            ? "${ref.watch(baseViewModel).kCurrentUser?.amount!}"
                                            : "0",
                                        style: TextStyle(
                                          fontFamily: Strings.robotoRegular,
                                          fontSize: 18.0,
                                          color: Colors.grey,
                                        )),
                                  ],
                                ),
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 15),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const UpdateProfileView()),
                );
              },
              child: moreOptions(
                  const Icon(Icons.person, color: Colors.black), 'Manage Profile'.tr),
            ),
            ref.watch(baseViewModel).kCurrentUser!.meg_user != null &&
                ref.watch(baseViewModel).kCurrentUser!.meg_user==1 ?GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const KycView()),
                );
                // if (ref.watch(baseViewModel).kCurrentUser!.userKyc!.kycdropdown != null &&
                //     ref.watch(baseViewModel).kCurrentUser!.userKyc!.kycdropdown=="verified")
                // {
                //   showSnackBar(context: context, message: "Your KYC is verified");
                //   // if (ref.watch(baseViewModel).kCurrentUser!.kyc != null) {
                //   //   if (ref.watch(baseViewModel).kCurrentUser!.kyc!) {
                //   //
                //   //   }
                //   // }
                // }
                // else if(ref.watch(baseViewModel).kCurrentUser!.userKyc!.kycdropdown != null &&
                //     ref.watch(baseViewModel).kCurrentUser!.userKyc!.kycdropdown=="pending")
                // {
                //   handleApiError("Your KYC is under verification. Please try once its verified",context);
                // }
                // else if(ref.watch(baseViewModel).kCurrentUser!.userKyc!.kycdropdown != null &&
                //     ref.watch(baseViewModel).kCurrentUser!.userKyc!.kycdropdown=="rejected")
                // {
                //   handleApiError("Your KYC is rejected. Please reapply for KYC & Try again",context);
                // }
                // else if(ref.watch(baseViewModel).kCurrentUser!.userKyc!.kycdropdown != null &&
                //     ref.watch(baseViewModel).kCurrentUser!.userKyc!.kycdropdown=="unverified")
                // {
                //   Navigator.push(
                //     context,
                //     MaterialPageRoute(
                //         builder: (context) => const KycView()),
                //   );
                //   // handleApiError("Please apply for KYC & Try again",context);
                // }
              },
              child:ref.watch(baseViewModel).kCurrentUser!.userKyc!.kycdropdown != null &&
                  ref.watch(baseViewModel).kCurrentUser!.userKyc!.kycdropdown=="unverified" ?
              moreOptions(Icon(Icons.person, color: Colors.black), 'Apply KYC'.tr):
              moreOptions(Icon(Icons.person, color: Colors.black), 'Manage KYC'.tr),
            ):SizedBox(),
            GestureDetector(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                        const NotificationsView()));
              },
              child: moreOptions(
                  const Icon(Icons.notifications_none, color: Colors.black), 'Notifications'.tr),
            ),
            GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const MyListView()),
                  );
                },
                child: moreOptions(
                    const Icon(Icons.menu, color: Colors.black), 'My List'.tr)),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const DownloadAllList()),
                  // builder: (context) => const DownloadListView()),
                );
              },
              child: moreOptions(
                  const Icon(Icons.download_rounded, color: Colors.black),
                  'Downloads'.tr),
            ),
            GestureDetector(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const SettingScreen(),
                    ));
              },
              child: moreOptions(
                  const Icon(Icons.settings, color: Colors.black), 'Settings'),
            ),
            ref.watch(baseViewModel).kCurrentUser!.meg_user != null &&
                ref.watch(baseViewModel).kCurrentUser!.meg_user==1 ?
            GestureDetector(
              onTap: () {

                if (ref.watch(baseViewModel).kCurrentUser!.userKyc!.kycdropdown != null &&
                    ref.watch(baseViewModel).kCurrentUser!.userKyc!.kycdropdown=="verified")
                {

                  if (ref.watch(baseViewModel).kCurrentUser!.kyc != null) {
                    if (ref.watch(baseViewModel).kCurrentUser!.kyc!) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const WithdrawView()),
                      );
                    }
                  }
                }
                else if(ref.watch(baseViewModel).kCurrentUser!.userKyc!.kycdropdown != null &&
                    ref.watch(baseViewModel).kCurrentUser!.userKyc!.kycdropdown=="pending")
                {
                  handleApiError("Your KYC is under verification. Please try once its verified",context);
                }
                else if(ref.watch(baseViewModel).kCurrentUser!.userKyc!.kycdropdown != null &&
                    ref.watch(baseViewModel).kCurrentUser!.userKyc!.kycdropdown=="rejected")
                {
                  handleApiError("Your KYC is rejected. Please reapply for KYC & Try again",context);
                }
                else if(ref.watch(baseViewModel).kCurrentUser!.userKyc!.kycdropdown != null &&
                    ref.watch(baseViewModel).kCurrentUser!.userKyc!.kycdropdown=="unverified")
                {
                  handleApiError("Please apply for KYC & Try again",context);
                }
              },
              child: moreOptions(
                  const Icon(Icons.adjust_rounded, color: Colors.black),
                  'Earnings'.tr),
            ):SizedBox(),
            GestureDetector(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ForgotPasswordScreen(),
                    ));
              },
              child: moreOptions(
                  const Icon(Icons.password, color: Colors.black),
                  'Change Password'.tr),
            ),
            GestureDetector(
              onTap: () {
                _launchUrl();
              },
              child: moreOptions(
                  const Icon(Icons.call, color: Colors.black),
                  'Help'.tr),
            ),
            const SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  child: ABButtonGery(
                    paddingTop: 10.0,
                    paddingBottom: 10.0,
                    paddingLeft: 10.0,
                    paddingRight: 15.0,
                    text: 'Delete Account'.tr,
                    onPressed: () {
                      // Navigator.push(
                      //   context,
                      //   MaterialPageRoute(
                      //       builder: (context) => const RegisterView()),
                      // );
                      // var viewModel = BaseViewModel();
                      // viewModel.userDeleteAPI(context: context);

                      deleteAlertDialog(context);
                    },
                  ),
                ),
                Expanded(
                  child: ABButton(
                    paddingTop: 10.0,
                    paddingBottom: 10.0,
                    paddingLeft: 10.0,
                    paddingRight: 10.0,
                    text: 'Log Out'.tr,
                    onPressed: () async {
                      showSuccessSnackbar("Logout succesfully", context);
                      var viewModel = BaseViewModel();
                      viewModel.clearUser();
                      await PrefUtils.clearPrefs();
                      Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(
                          builder: (context) => const LoginView(),
                        ),
                            (route) => false,
                      );

                      // viewModel.logoutUserAPI(context: context);
                      // logoutAlertDialog(context);
                    },
                  ),
                ),
              ],
            ),
            // const SizedBox(height: 10),
            ABButton(
              paddingTop: 10.0,
              paddingBottom: 15.0,
              paddingLeft: 10.0,
              paddingRight: 10.0,
              text: 'Log Out From All Devices'.tr,
              onPressed: () {
                // var viewModel = BaseViewModel();
                // viewModel.logoutUserAPI(context: context);
                logoutAlertDialog(context);
              },
            )

          ],
        ),
      ),
    );
  }
  Future<void> _launchUrl() async {
    if (!await launchUrl(Uri.parse("tel://1800 572 4549"))) {
      throw Exception('Could not launch');
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
  Widget moreOptions(Icon icon, String titleText) {
    return Container(
        margin: const EdgeInsets.only(left: 15.0, right: 15.0, top: 12.0),
        decoration: BoxDecoration(
            color: const Color(0xFFF8FFD6),
            borderRadius: BorderRadius.circular(7.0),
            border: Border.all(width: 0.5, color: const Color(0xffeaf7b0))),
        child: Padding(
          padding: const EdgeInsets.all(4.0),
          child: Center(
            child: ListTile(
              leading: SizedBox(
                  height: 45,
                  child: Container(
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Color(0xFFFECC00),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: icon,
                      ))),
              title: Text(
                titleText,
                style: TextStyle(
                    fontFamily: Strings.robotoRegular,
                    fontSize: 15.0,
                    color: Colors.black),
              ),
              trailing: const Icon(
                Icons.arrow_forward_ios,
                color: Colors.black,
                size: 20,
              ),
            ),
          ),
        ));
  }

  logoutAlertDialog(BuildContext context) {
    showDialog<String>(
      context: context,
      builder: (BuildContext context) => Dialog(
        backgroundColor: Colors.white,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(5.0),
          ),
        ),
        alignment: Alignment.centerLeft,
        child: SizedBox(
          width: double.infinity,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 30.0, bottom: 10.0),
                child: Text(Strings.logout,
                    textAlign: TextAlign.start,
                    style: TextStyle(
                      fontFamily: Strings.robotoMedium,
                      color: ThemeColor.bodyGrey,
                      fontWeight: FontWeight.w700,
                      fontSize: 20.0,
                    )),
              ),
              Padding(
                padding: const EdgeInsets.all(15),
                child: Text(Strings.areYouSureDoYou,
                    textAlign: TextAlign.start,
                    style: TextStyle(
                        fontFamily: Strings.robotoMedium,
                        color: ThemeColor.bodyGrey,
                        height: 1.5,
                        fontWeight: FontWeight.w400,
                        fontSize: 16.0)),
              ),
              const SizedBox(height: 5),
              const Divider(
                color: Color(0xffDCDCDC),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Center(
                        child: Text(Strings.no,
                            style: TextStyle(
                                fontFamily: Strings.robotoMedium,
                                color: Colors.amber,
                                fontWeight: FontWeight.w500,
                                fontSize: 17.0)),
                      )),
                  TextButton(
                    onPressed: () {
                      var viewModel = BaseViewModel();
                      viewModel.logoutUserAPI(context: context);
                    },
                    child: Center(
                      child: Text(Strings.yes,
                          style: TextStyle(
                              fontFamily: Strings.robotoMedium,
                              color: Colors.amber,
                              fontWeight: FontWeight.w500,
                              fontSize: 17.0)),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }

  deleteAlertDialog(BuildContext context) {
    showDialog<String>(
      context: context,
      builder: (BuildContext context) => Dialog(
        backgroundColor: Colors.white,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10.0))),
        alignment: Alignment.centerLeft,
        child: SizedBox(
          width: double.infinity,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 30.0, bottom: 10.0),
                child: Text('Delete account',
                    textAlign: TextAlign.start,
                    style: TextStyle(
                      fontFamily: Strings.robotoMedium,
                      color: Colors.grey,
                      fontWeight: FontWeight.w700,
                      fontSize: 18.0,
                    )),
              ),
              Padding(
                padding: const EdgeInsets.all(15),
                child: Text("Are you sure, you want to delete the Account?",
                    textAlign: TextAlign.start,
                    style: TextStyle(
                        fontFamily: Strings.robotoMedium,
                        color: const Color(0xff585858),
                        fontWeight: FontWeight.normal,
                        fontSize: 15.0)),
              ),
              const Divider(
                color: Color(0xffDCDCDC),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Center(
                        child: Text("No",
                            style: TextStyle(
                                fontFamily: Strings.robotoMedium,
                                color: Colors.amber,
                                fontWeight: FontWeight.w500,
                                fontSize: 17.0)),
                      )),
                  TextButton(
                      onPressed: () {
                        var viewModel = BaseViewModel();
                        viewModel.userDeleteAPI(context: context);
                      },
                      child: Center(
                        child: Text("Yes",
                            style: TextStyle(
                                fontFamily: Strings.robotoMedium,
                                color: Colors.amber,
                                fontWeight: FontWeight.w500,
                                fontSize: 17.0)),
                      )),
                ],
              ),
              const SizedBox(
                height: 10,
              )
            ],
          ),
        ),
      ),
    );
  }
}
