import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hellomegha/core/utils/dialogs.dart';
import 'package:hellomegha/quiz/controllers/question_controller.dart';

import 'components/body.dart';

class QuizScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    nointernet(context);
    QuestionController _controller = Get.put(QuestionController());
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.blue,
      appBar: AppBar(
        // Fluttter show the back button automatically
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          TextButton(onPressed: _controller.nextQuestion, child: Text("")),
        ],
      ),
      body: Stack(children: [
        Container(
          height:MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          // Below is the code for Linear Gradient.
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFFB0CB1F), Colors.white,Colors.white,Colors.white, Color(0xFFFECC00)],
              begin: Alignment.bottomRight,
              end: Alignment.topLeft,
            ),
          ),
        ),
        Body()
      ]),
    );
  }
}
