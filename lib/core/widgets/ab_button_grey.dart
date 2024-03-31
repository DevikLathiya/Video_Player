import 'package:flutter/material.dart';
import 'package:hellomegha/core/utils/strings.dart';

class ABButtonGery extends StatelessWidget {
  final Function() onPressed;
  final String? text;
  final double? paddingTop;
  final double? paddingBottom;
  final double? paddingLeft;
  final double? paddingRight;

  const ABButtonGery({
    Key? key,
    required this.onPressed,
    this.text,
    this.paddingTop,
    this.paddingBottom,
    this.paddingLeft,
    this.paddingRight,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
          top: paddingTop!,
          bottom: paddingBottom!,
          left: paddingLeft!,
          right: paddingRight!),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          elevation: 0,
          foregroundColor: Colors.white,
          backgroundColor: Colors.white,
          minimumSize: Size(MediaQuery.of(context).size.width,
              MediaQuery.of(context).size.height * 0.055),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(8.0)),
              side: BorderSide(color: Color(0xff515151))

          ),
        ),
        onPressed: onPressed,
        child: Text(text!,
            style: TextStyle(
                fontFamily: Strings.robotoRegular,
                color: Color(0xff535353),
                fontSize: 16)),
      ),
    );
  }
}
