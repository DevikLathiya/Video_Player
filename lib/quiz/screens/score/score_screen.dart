import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hellomegha/core/notifier/base_view_model.dart';
import 'package:hellomegha/core/notifier/providers.dart';
import 'package:hellomegha/core/utils/dialogs.dart';
import 'package:hellomegha/core/widgets/ab_button.dart';
import 'package:hellomegha/core/widgets/ab_button_grey.dart';
import 'package:hellomegha/quiz/constants.dart';
import 'package:hellomegha/quiz/controllers/question_controller.dart';
import 'package:hellomegha/view_models/quiz_view_model.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class ScoreScreen extends ConsumerStatefulWidget {
  @override
  ConsumerState<ScoreScreen> createState() => _ScoreScreenState();
}

class _ScoreScreenState extends ConsumerState<ScoreScreen> {

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    nointernet(context);
  }

  @override
  Widget build(BuildContext context) {
    QuestionController _qnController = Get.put(QuestionController());
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Container(
            height:MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            // Below is the code for Linear Gradient.
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFFB0CB1F), Colors.white,Color(0xFFFFE343),Colors.white, Color(0xFFFECC00)],
                begin: Alignment.bottomRight,
                end: Alignment.topLeft,
              ),
            ),
          ),
          Column(
            children: [
              Spacer(flex: 1),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                 Image.asset('assets/icon_image.jpeg', fit: BoxFit.cover, height: 50, width: 150),
                 SizedBox(width: 40),
                 Image.asset('assets/daily_quiz.png', fit: BoxFit.cover, height: 90, width: 120)
                ],
              ),
              SizedBox(
                height: 40,
              ),
              // Text(
              //   "Score",
              //   style: Theme.of(context)
              //       .textTheme
              //       .headline3!
              //       .copyWith(color: Colors.black),
              // ),
              // Spacer(),
              // Text(
              //   "${_qnController.correctAns * 10}/${_qnController.questions.length * 10}",
              //   style: Theme.of(context)
              //       .textTheme
              //       .headline4!
              //       .copyWith(color: Colors.black),
              // ),
              Stack(
                children: [
                  Column(
                    children: [
                      SizedBox(
                        height: 50,
                      ),
                      Center(
                        child: Container(
                          margin: EdgeInsets.symmetric(horizontal: kDefaultPadding),
                          padding: EdgeInsets.all(kDefaultPadding),
                          width: 320,
                          height: 430,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(15),
                              boxShadow: [
                                BoxShadow(
                                    color: Colors.grey,
                                    blurRadius: 2.0,
                                    offset: Offset(0, -0))
                              ]
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              SizedBox(
                                height: 30,
                              ),
                              Text(
                                "Your score",
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyText2!
                                    .copyWith(color: Colors.grey),
                              ),
                              SizedBox(height: 5),
                              Text(
                                "${_qnController.numOfCorrectAns * 10}/${_qnController.questions.length * 10}",
                               // "${_qnController.correctAns * 10}/${_qnController.questions.length * 10}",
                                style: Theme.of(context)
                                    .textTheme
                                    .headline5!
                                    .copyWith(color: Colors.red),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 8.0, right: 8.0, top: 20),
                                child: Text(
                                  "Looks like you have answered one or more questions incorrectly. Try your luck with other games.",
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyText2!
                                      .copyWith(color: Colors.black, height: 1.4),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              ABButton(
                                paddingTop: 30.0,
                                paddingBottom: 15.0,
                                paddingLeft: 10.0,
                                paddingRight: 10.0,
                                text: 'Play & Collect Coins',
                                onPressed: () {
                                  var viewModel = BaseViewModel();
                                  viewModel.logoutUserAPI(context: context);
                                },
                              ),
                              ABButtonGery(
                                paddingTop: 10.0,
                                paddingBottom: 15.0,
                                paddingLeft: 10.0,
                                paddingRight: 15.0,
                                text: 'Play & Collect Coins',
                                onPressed: () {
                                },
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 8.0, right: 8.0, top: 20),
                                child: Text(
                                  "Terms & Conditions",
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyText2!
                                      .copyWith(color: Colors.amber),
                                  textAlign: TextAlign.center,
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  Center(
                    child: SizedBox(
                      height: 100,
                      width: 100,
                      child: Image.asset('assets/crown.png',
                          fit: BoxFit.contain),
                    ),
                  )
                ],
              ),
              Spacer(flex: 2),
            ],
          )
        ],
      ),
    );
  }
}
