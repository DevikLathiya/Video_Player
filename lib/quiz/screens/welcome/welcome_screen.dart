import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:hellomegha/core/notifier/providers.dart';
import 'package:hellomegha/core/utils/dialogs.dart';
import 'package:hellomegha/core/utils/strings.dart';
import 'package:hellomegha/quiz/constants.dart';
import 'package:hellomegha/quiz/screens/quiz/quiz_screen.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class WelcomeScreen extends ConsumerStatefulWidget {
  @override
  ConsumerState<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends ConsumerState<WelcomeScreen> {

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    nointernet(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue,
      body: Stack(
        children: [
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Spacer(flex: 2), //2/6
                  Text(
                    "Let's Play Quiz,",
                    style: Theme.of(context).textTheme.headline4!.copyWith(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                 // Text("HI"),
                  Spacer(), // 1/6
                  // TextField(
                  //   decoration: InputDecoration(
                  //     filled: true,
                  //     fillColor: Colors.white,
                  //     hintText: "Full Name",
                  //     border: OutlineInputBorder(
                  //       borderRadius: BorderRadius.all(Radius.circular(12)),
                  //     ),
                  //   ),
                  // ),

                  Text(ref.watch(baseViewModel).kCurrentUser!.firstname != null
                      ? " Hi, ${ref.watch(baseViewModel).kCurrentUser?.firstname!}"
                      : "Hi, User",
                      style: TextStyle(
                        fontFamily: Strings.robotoMedium,
                        fontSize: 25.0,
                        color: Colors.white,
                      )),
                  Spacer(), // 1/6
                  InkWell(
                    onTap: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => QuizScreen(),
                        ),
                      );
                    },
                    child: Container(
                      width: double.infinity,
                      alignment: Alignment.center,
                      padding: EdgeInsets.all(kDefaultPadding * 0.75), // 15
                      decoration: BoxDecoration(
                        gradient: kPrimaryGradient,
                        borderRadius: BorderRadius.all(Radius.circular(12)),
                      ),
                      child: Text(
                        "Lets Start Quiz",
                        style: Theme.of(context)
                            .textTheme
                            .button!
                            .copyWith(color: Colors.black),
                      ),
                    ),
                  ),
                  Spacer(flex: 2), // it will take 2/6 spaces
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
