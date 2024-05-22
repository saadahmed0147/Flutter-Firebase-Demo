import 'package:firebase_1/Component/round_button.dart';
import 'package:firebase_1/Component/round_textfield.dart';
import 'package:firebase_1/Res/colors.dart';
import 'package:firebase_1/Routes/route_name.dart';
import 'package:firebase_1/Utils/utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class OTPVerificationScreen extends StatefulWidget {
  final verificationId;
  const OTPVerificationScreen({super.key, required this.verificationId});

  @override
  State<OTPVerificationScreen> createState() => _OTPVerificationScreenState();
}

class _OTPVerificationScreenState extends State<OTPVerificationScreen> {
  final otpController = TextEditingController();
  final _auth = FirebaseAuth.instance;
  bool _loading = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Verify'),
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
                      label: 'Enter the code sent to your phone',
                      hint: '123456',
                      inputType: TextInputType.number,
                      textEditingController: otpController,
                      prefixIcon: Icons.lock,
                    ),
                    Padding(
                        padding: const EdgeInsets.all(40.0),
                        child: RoundButton(
                            title: 'Verify',
                            onPress: () {
                              setState(() {
                                _loading = true;
                              });
                              final credential = PhoneAuthProvider.credential(
                                  verificationId: widget.verificationId,
                                  smsCode: otpController.text.toString());
                              try {
                                setState(() {
                                  _loading = false;
                                });
                                _auth.signInWithCredential(credential);
                                Navigator.pushNamed(
                                    context, RouteNames.postScreen);
                              } catch (e) {
                                setState(() {
                                  _loading = false;
                                });
                                Utils.flushBarErrorMessage(
                                    e.toString(), context);
                              }
                            }))
                  ])),
        ));
  }
}
