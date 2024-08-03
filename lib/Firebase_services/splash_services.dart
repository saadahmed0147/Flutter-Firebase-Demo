import 'dart:async';

import 'package:firebase_1/Routes/route_name.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SplashServices {
  void isLogin(BuildContext context) {
    final firebaseAuth = FirebaseAuth.instance;
    final user = firebaseAuth.currentUser;

    if (user != null) {
      debugPrint(user.toString());
      Timer(const Duration(seconds: 3), () {
        Navigator.pushReplacementNamed(context, RouteNames.postScreen);
      });
    } else {
      Timer(const Duration(seconds: 3), () {
        Navigator.pushReplacementNamed(context, RouteNames.loginScreen);
      });
    }
  }
}
