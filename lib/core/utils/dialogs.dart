import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:hellomegha/core/utils/strings.dart';
import 'package:hellomegha/core/utils/theme_config.dart';
import 'package:hellomegha/screens/no_network.dart';

showLoading(BuildContext context) {
  showDialog(
    context: context,
    builder: (context) => Center(
      child: SizedBox(
        height: 50.0.h,
        width: 50.0.w,
        child: const FittedBox(
          child: CircularProgressIndicator(
            strokeWidth: 3,
          ),
        ),
      ),
    ),
    barrierDismissible: false,
  );
}
showbottomLoading(BuildContext context) {
  showDialog(
    context: context,
    builder: (context) => Container(
      margin: EdgeInsets.only(bottom: 30),
      alignment: Alignment.bottomCenter,
      child: SizedBox(
        height: 50.0.h,
        width: 50.0.w,
        child: const FittedBox(
          child: CircularProgressIndicator(
            strokeWidth: 3,
          ),
        ),
      ),
    ),
    barrierDismissible: false,
  );
}
nointernet(context)
{
  Connectivity().checkConnectivity().then((value) {
    if (value == ConnectivityResult.none) {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => NoNetwork()));
    }
  });
}
hideLoading(BuildContext context) {
  Navigator.pop(context);
}

showSessionDialog(BuildContext context) {
  showDialog<String>(
    context: context,
    builder: (BuildContext context) => Dialog(
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(10.0),
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
              child: Text('Something went wrong'.tr,
                  textAlign: TextAlign.start,
                  style: TextStyle(
                    fontFamily: Strings.robotoMedium,
                    color: ThemeColor.bodyGrey,
                    fontWeight: FontWeight.w700,
                    fontSize: 17.0,
                  )),
            ),
            Padding(
              padding: const EdgeInsets.all(15),
              child: Text('Please try again'.tr,
                  textAlign: TextAlign.start,
                  style: TextStyle(
                      fontFamily: Strings.robotoMedium,
                      color: ThemeColor.bodyGrey,
                      height: 1.5,
                      fontWeight: FontWeight.w400,
                      fontSize: 15.0)),
            ),
            const SizedBox(height: 20),
            const Divider(
              color: Color(0xffDCDCDC),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Center(
                      child: Text('OK'.tr,
                          style: TextStyle(
                              fontFamily: Strings.robotoMedium,
                              color: const Color(0xff1B79EB),
                              fontWeight: FontWeight.w500,
                              fontSize: 17.0)),
                    )),
              ],
            ),
            const SizedBox(height: 5),
          ],
        ),
      ),
    ),
  );
}