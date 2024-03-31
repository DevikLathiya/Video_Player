import 'package:flutter/material.dart';
import 'package:hellomegha/core/utils/strings.dart';
import 'package:hellomegha/core/utils/theme_config.dart';

var currencySymbol = "₹";

void showSnackBar(
    {required BuildContext context,
    required String message,
    Color? backgroundColor,
    Duration? duration}) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      duration: duration ?? const Duration(seconds: 2),
      backgroundColor: backgroundColor ?? Colors.black87,
      content: Text(message),
    ),
  );
}

handleApiError(errorMessage, BuildContext context) {
  showSnackBar(
      backgroundColor: Colors.redAccent,
      message: errorMessage,
      context: context);
}

showWarning(message, BuildContext context) {
  showSnackBar(
    backgroundColor: Colors.blueAccent,
    message: message,
    context: context,
    duration: const Duration(seconds: 3),
  );
}


showSuccessSnackbar(String message, BuildContext context) {
  showSnackBar(
      backgroundColor: Colors.green, message: message, context: context);
}

bool validatePassword(String password) {
  return RegExp(
          r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~?]).{8,}$')
      .hasMatch(password);
}

bool validateEmail(String email) {
  return RegExp(
          r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
      .hasMatch(email);
}

bool validURL(String url) {
  return Uri.parse(url).isAbsolute;
}
