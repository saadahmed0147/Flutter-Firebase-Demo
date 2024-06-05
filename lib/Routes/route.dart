import 'package:firebase_1/Screens/Posts/add_post_screen.dart';
import 'package:firebase_1/Screens/Posts/post_screen.dart';
import 'package:firebase_1/Routes/route_name.dart';
import 'package:firebase_1/Screens/login_screen.dart';
import 'package:firebase_1/Screens/otp_verification_screen.dart';
import 'package:firebase_1/Screens/phone_number_input_screen.dart';
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
      case RouteNames.phoneNumberInputScreen:
        return MaterialPageRoute(
          builder: (context) => const PhoneNumberInputScreen(),
        );
      case RouteNames.otpVerificationScreen:
        final arg = settings.arguments as Map<String, String>;
        return MaterialPageRoute(
          builder: (context) => OTPVerificationScreen(
            verificationId: arg['verificationId']!,
          ),
        );
      case RouteNames.addPostScreen:
        return MaterialPageRoute(
          builder: (context) => const AddPostScreen(),
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
