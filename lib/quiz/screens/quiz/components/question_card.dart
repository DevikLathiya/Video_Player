import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hellomegha/core/widgets/common_image.dart';
import 'package:hellomegha/quiz/controllers/question_controller.dart';
import 'package:hellomegha/quiz/models/Questions.dart';


import '../../../constants.dart';
import 'option.dart';

class QuestionCard extends StatelessWidget {
  const QuestionCard({
    Key? key,
    // it means we have to pass this
    required this.question,
  }) : super(key: key);

  final Question question;

  @override
  Widget build(BuildContext context) {
    QuestionController _controller = Get.put(QuestionController());
    return Container(
      margin: EdgeInsets.symmetric(horizontal: kDefaultPadding),
      padding: EdgeInsets.all(kDefaultPadding),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
                color: Colors.grey, //New
                blurRadius: 2.0,
                offset: Offset(0, -0))
          ]
      ),
      child: SingleChildScrollView(
        child: Column(
          children: [
            Text(
              question.question,
              style: Theme.of(context)
                  .textTheme
                  .headline6!
                  .copyWith(color: kBlackColor),
            ),

            question.image!="http://prabhu.yoursoftwaredemo.com/1" ? Padding(
            padding: const EdgeInsets.all(8.0),
            child: CommonImage(imageUrl: question.image),
          ) : const SizedBox(),
            // question.image.isNotEmpty && question.image != '1' ? IconButton(
            //   icon: const Icon(Icons.play_arrow),
            //   iconSize: 32.0,
            //   onPressed: () {},
            // ) : const SizedBox(),
            SizedBox(height: kDefaultPadding / 2),
            ...List.generate(
              question.options.length,
              (index) => Option(
                index: index,
                text: question.options[index],
                press: () => _controller.checkAns(question, index),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
