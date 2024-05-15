import 'package:firebase_1/Posts/post_screen.dart';
import 'package:firebase_1/Routes/route_name.dart';
import 'package:firebase_1/Screens/login_screen.dart';
import 'package:firebase_1/Screens/signup_screen.dart';
import 'package:firebase_1/Screens/splash_screen.dart';
import 'package:flutter/material.dart';

class Routes {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case RouteNames.splashScreen:
        return MaterialPageRoute(
          builder: (context) => const SplashScreen(),
        );
      case RouteNames.loginScreen:
        return MaterialPageRoute(
          builder: (context) => const LoginScreen(),
        );
      case RouteNames.signUpScreen:
        return MaterialPageRoute(
          builder: (context) => const SignUpScreen(),
        );
      case RouteNames.postScreen:
        return MaterialPageRoute(
          builder: (context) => const PostScreen(),
        );

      default:
        return MaterialPageRoute(
          builder: (context) => const Scaffold(
            body: Center(
              child: Text('No Route Found!'),
            ),
          ),
        );
    }
  }
}
