import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:hellomegha/core/notifier/providers.dart';
import 'package:hellomegha/screens/home/bottom_navigation_view.dart';
import 'package:hellomegha/screens/login/login_view.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class Splash extends ConsumerStatefulWidget {
  final bool isLoggedIn;

  const Splash({
    required this.isLoggedIn,
    Key? key,
  }) : super(key: key);

  @override
  ConsumerState<Splash> createState() => _SplashState();
}

class _SplashState extends ConsumerState<Splash> {
  @override
  void initState() {
    Connectivity().checkConnectivity().then((value) {
      Future.delayed(
        const Duration(seconds: 3),
        () {
          if (widget.isLoggedIn) {
            if (value == ConnectivityResult.none) {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const BottomNavigationView(index: 1),
                  ));
            } else {
              ref.watch(authenticationProvider).userDataAPI(context: context);
            }
          } else {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const LoginView()),
            );
          }
        },
      );
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            // Below is the code for Linear Gradient.
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xFFB0CB1F),
                  Colors.white,
                  Colors.white,
                  Colors.white,
                  Color(0xFFFECC00)
                ],
                begin: Alignment.bottomRight,
                end: Alignment.topLeft,
              ),
            ),
          ),
          Container(
            // alignment: Alignment.center,
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: Image.asset('assets/logo_new.png')),

        ],
      ),
    );
  }
}
