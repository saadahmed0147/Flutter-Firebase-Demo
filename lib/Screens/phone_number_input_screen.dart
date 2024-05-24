import 'package:firebase_1/Component/round_button.dart';
import 'package:firebase_1/Component/round_textfield.dart';
import 'package:firebase_1/Res/colors.dart';
import 'package:firebase_1/Screens/otp_verification_screen.dart';
import 'package:firebase_1/Utils/utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class PhoneNumberInputScreen extends StatefulWidget {
  const PhoneNumberInputScreen({super.key});

  @override
  State<PhoneNumberInputScreen> createState() => _PhoneNumberInputScreenState();
}

class _PhoneNumberInputScreenState extends State<PhoneNumberInputScreen> {
  final phoneNumberController = TextEditingController();
  final _auth = FirebaseAuth.instance;
  bool _loading = false;
  FocusNode textFieldFocus = FocusNode();
  FocusNode otpButtonFocus = FocusNode();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Login'),
          automaticallyImplyLeading: true,
          centerTitle: true,
          backgroundColor: AppColors.blackColor,
          foregroundColor: AppColors.whiteColor,
        ),
        body: Center(
          child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    RoundTextField(
                      label: 'Phone Number',
                      hint: '+92 123 0456789',
                      inputType: TextInputType.phone,
                      textEditingController: phoneNumberController,
                      prefixIcon: Icons.call,
                      focusNode: textFieldFocus,
                      onFieldSubmitted: (p0) {
                        Utils.fieldFocusNode(
                            context, textFieldFocus, otpButtonFocus);
                      },
                    ),
                    Padding(
                      padding: const EdgeInsets.all(40.0),
                      child: RoundButton(
                          focusNode: otpButtonFocus,
                          title: 'Get OTP',
                          loading: _loading,
                          onPress: () {
                            setState(() {
                              _loading = true;
                            });
                            _auth.verifyPhoneNumber(
                                phoneNumber: phoneNumberController.text,
                                verificationCompleted: (_) {
                                  setState(() {
                                    _loading = false;
                                  });
                                },
                                verificationFailed: (e) {
                                  setState(() {
                                    _loading = false;
                                  });
                                  Utils.flushBarErrorMessage(
                                      e.toString(), context);
                                },
                                codeSent: (String verificationId, int? token) {
                                  setState(() {
                                    _loading = false;
                                  });
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            OTPVerificationScreen(
                                                verificationId: verificationId),
                                      ));
                                },
                                codeAutoRetrievalTimeout: (e) {
                                  Utils.flushBarErrorMessage(
                                      e.toString(), context);
                                });
                          }),
                    )
                  ])),
        ));
  }
}
