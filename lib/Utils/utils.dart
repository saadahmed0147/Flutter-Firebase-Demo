import 'package:flutter/material.dart';
import 'package:another_flushbar/flushbar.dart';

class Utils {
  static void flushBarErrorMessage(String message, BuildContext context) {
    Flushbar(
      margin: const EdgeInsets.all(20),
      borderRadius: BorderRadius.circular(50),
      reverseAnimationCurve: Curves.easeInOut,
      message: message,
      duration: const Duration(seconds: 2),
      icon: const Icon(
        Icons.error,
        color: Colors.white,
      ),
      flushbarPosition: FlushbarPosition.BOTTOM,
    ).show(context);
  }

  static void fieldFocusNode(
    BuildContext context,
    FocusNode currentFocus,
    FocusNode nextFocus,
  ) {
    currentFocus.unfocus();
    FocusScope.of(context).requestFocus(nextFocus);
  }
}
