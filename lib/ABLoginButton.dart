import 'package:flutter/material.dart';
import 'package:hellomegha/core/utils/strings.dart';

class ABLoginButton extends StatelessWidget {
  final Future<Null> Function()? onPressed;
  final String? text;
  final double? paddingTop;
  final double? paddingBottom;
  final double? paddingLeft;
  final double? paddingRight;

  const ABLoginButton({
    Key? key,
    // required this.onPressed,
    this.text,
    this.paddingTop,
    this.paddingBottom,
    this.paddingLeft,
    this.paddingRight,
    this.onPressed,
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
          foregroundColor: Colors.white,
          backgroundColor: const Color(0xffFDB706),
          minimumSize: Size(MediaQuery.of(context).size.width,
              MediaQuery.of(context).size.height * 0.055),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(8.0)),
          ),
        ),
        onPressed:onPressed,
        child: Text(text!,
            style: TextStyle(
                fontFamily: Strings.robotoRegular,
                color: Colors.black,
                fontSize: 16)),
      ),
    );
  }
}
