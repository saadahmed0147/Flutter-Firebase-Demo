import 'package:country_picker/country_picker.dart';
import 'package:firebase_1/Component/round_button.dart';
import 'package:firebase_1/Component/round_textfield.dart';
import 'package:firebase_1/Res/colors.dart';
import 'package:firebase_1/Screens/otp_verification_screen.dart';
import 'package:firebase_1/Utils/utils.dart';
import 'package:firebase_1/main.dart';
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
  String countryCode = '+92';

  
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
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(50),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'OTP',
                        style: TextStyle(
                          fontSize: mq.height * 0.06,
                          fontWeight: FontWeight.w900,
                          color: AppColors.whiteColor,
                        ),
                      ),
                      Text(
                        'Verification',
                        style: TextStyle(
                          fontSize: mq.height * 0.06,
                          fontWeight: FontWeight.w900,
                          color: AppColors.whiteColor,
                        ),
                      ),
                    ],
                  ),
                ),
                Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: Container(
                        height: mq.height*0.07,
                        child: TextButton(style: TextButton.styleFrom(
                            backgroundColor: AppColors.lightGreenColor,
                            foregroundColor: AppColors.blackColor,
                            shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                            )
                        ),
                          onPressed: () {
                            showCountryPicker(
                              context: context,
                              showPhoneCode: true,
                              countryListTheme: const CountryListThemeData(backgroundColor: AppColors.lightGreenColor,
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(10),
                                  topRight: Radius.circular(10),
                                ),
                                inputDecoration: InputDecoration(
                                  hintText: 'Start typing to search',
                                  labelText: 'Search',
                                ),
                              ),
                              favorite: ['PK'],
                              onSelect: (Country value) {
                                setState(() {
                                  countryCode = '+${value.phoneCode}';
                                });
                              },
                            );
                          },
                          child: Text(countryCode),
                        ),
                      ),
                    ),SizedBox(width: mq.width*0.02,),
                    Expanded(
                      flex: 8,
                      child: RoundTextField(
                        label: 'Phone Number',
                        hint: '123 0456789',
                        inputType: TextInputType.phone,
                        textEditingController: phoneNumberController,
                        prefixIcon: Icons.call,
                        focusNode: textFieldFocus,
                        onFieldSubmitted: (p0) {
                          Utils.fieldFocusNode(
                              context, textFieldFocus, otpButtonFocus);
                        },
                      ),
                    ),
                  ],
                ),
                SizedBox(height: mq.height * 0.05),
                RoundButton(
                  focusNode: otpButtonFocus,
                  title: 'Get OTP',
                  loading: _loading,
                  onPress: () {
                    setState(() {
                      _loading = true;
                    });
                    if (phoneNumberController.text.isEmpty) {
                      Utils.flushBarErrorMessage(
                          'Please type your phone number', context);
                      setState(() {
                        _loading = false;
                      });
                    } else if (phoneNumberController.text.length < 10) {
                      Utils.flushBarErrorMessage(
                          'Please enter a valid phone number', context);
                      setState(() {
                        _loading = false;
                      });
                    } else {
                      String completePhoneNumber =
                          '$countryCode${phoneNumberController.text}';
                      _auth.verifyPhoneNumber(
                        phoneNumber: completePhoneNumber,
                        verificationCompleted: (_) {
                          setState(() {
                            _loading = false;
                          });
                        },
                        verificationFailed: (e) {
                          setState(() {
                            _loading = false;
                          });
                          Utils.flushBarErrorMessage(e.toString(), context);
                        },
                        codeSent: (String verificationId, int? token) {
                          phoneNumberController.clear;
                          setState(() {
                            _loading = false;
                          });
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  OTPVerificationScreen(verificationId: verificationId),
                            ),
                          );
                        },
                        codeAutoRetrievalTimeout: (e) {
                          Utils.flushBarErrorMessage(e.toString(), context);
                        },
                      );
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
