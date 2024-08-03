import 'package:firebase_1/Component/round_button.dart';
import 'package:firebase_1/Component/round_textfield.dart';
import 'package:firebase_1/Res/colors.dart';
import 'package:firebase_1/Routes/route_name.dart';
import 'package:firebase_1/Utils/utils.dart';
import 'package:firebase_1/main.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class OTPVerificationScreen extends StatefulWidget {
  final String verificationId;
  const OTPVerificationScreen({super.key, required this.verificationId});

  @override
  State<OTPVerificationScreen> createState() => _OTPVerificationScreenState();
}

class _OTPVerificationScreenState extends State<OTPVerificationScreen> {
  final otpController = TextEditingController();
  final _auth = FirebaseAuth.instance;
  bool _loading = false;
  FocusNode textFieldFocus = FocusNode();
  FocusNode otpButtonFocus = FocusNode();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
     backgroundColor: AppColors.greenColor,
      appBar: AppBar(
        automaticallyImplyLeading: true,
        centerTitle: true,
        backgroundColor: AppColors.lightGreenColor,
        foregroundColor: AppColors.whiteColor,
      ),
      body: Center(
        child: Padding(
            padding: const EdgeInsets.all(50),
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [ Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Verification',
                        style: TextStyle(
                          fontSize: mq.height * 0.06,
                          fontWeight: FontWeight.w900,
                          color: AppColors.whiteColor,
                        ),
                      ),
                      Text(
                        'Code',
                        style: TextStyle(
                          fontSize: mq.height * 0.06,
                          fontWeight: FontWeight.w900,
                          color: AppColors.whiteColor,
                        ),
                      ),
                    ],
                  ),
                ),
                  RoundTextField(
                    label: 'Enter the code sent to your phone',
                    hint: '123456',
                    inputType: TextInputType.number,
                    textEditingController: otpController,
                    prefixIcon: Icons.lock,
                    focusNode: textFieldFocus,
                    onFieldSubmitted: (p0) {
                      Utils.fieldFocusNode(
                          context, textFieldFocus, otpButtonFocus);
                    },
                  ),
                    SizedBox(height: mq.height * 0.05),
                  RoundButton(
                      title: 'Verify',
                      focusNode: otpButtonFocus,
                      onPress: () async {
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
                          await _auth.signInWithCredential(credential);
                          Navigator.pushNamed(
                              context, RouteNames.postScreen);
                        } catch (e) {
                          setState(() {
                            _loading = false;
                          });
                          Utils.flushBarErrorMessage(e.toString(), context);
                        }
                      })
                ])),
      ),
    );
  }
}
