import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:hellomegha/core/utils/strings.dart';
import 'package:get/get.dart';
import 'package:hellomegha/screens/home/bottom_navigation_view.dart';
class NoNetwork extends StatefulWidget {
  const NoNetwork({Key? key}) : super(key: key);

  @override
  State<NoNetwork> createState() => _NoNetworkState();
}

class _NoNetworkState extends State<NoNetwork> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: 100,
            height: 100,
              child: Image.asset('assets/no_network.png', fit: BoxFit.cover)),
          Padding(
            padding: const EdgeInsets.all(28.0),
            child: Center(
              child: Column(
                children: [
                  Text(
                    'No Internet connection found'.tr,
                    style: TextStyle(
                        fontFamily: Strings.robotoMedium,
                        fontSize: 16.0,
                        color: Colors.black),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'Check your connection'.tr,
                      style: TextStyle(
                          fontFamily: Strings.robotoMedium,
                          fontSize: 14.0,
                          color: Colors.grey),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      Connectivity().checkConnectivity().then((value) {
                        if (value == ConnectivityResult.none) {
                          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => NoNetwork()));
                        }
                        else
                          {
                            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => BottomNavigationView(index: 0,)));
                          }
                      });
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        'Tap to retry'.tr,
                        style: TextStyle(
                            decoration: TextDecoration.underline,
                            fontFamily: Strings.robotoMedium,
                            fontSize: 16.0,
                            color: Color(0xFFFECC00)),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
