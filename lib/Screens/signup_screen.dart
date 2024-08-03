import 'package:firebase_1/Routes/route_name.dart';
import 'package:firebase_1/Utils/utils.dart';
import 'package:firebase_1/component/round_button.dart';
import 'package:firebase_1/component/round_textfield.dart';
import 'package:firebase_1/main.dart';
import 'package:firebase_1/res/colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  bool _loading = false;
  final _formKey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  FocusNode emailFocusNode = FocusNode();
  FocusNode passFocusNode = FocusNode();

  void onSignUp() {
    setState(() {
      _loading = true;
    });
    _firebaseAuth
        .createUserWithEmailAndPassword(
            email: emailController.text.toString(),
            password: passwordController.text.toString())
        .then((value) {
      Utils.flushBarErrorMessage('Sign Up Successfully', context);
      setState(() {
        _loading = false;
      });
      Navigator.pushNamed(context, RouteNames.loginScreen);
    }).onError((error, stackTrace) {
      debugPrint(error.toString());
      Utils.flushBarErrorMessage(error.toString(), context);
      setState(() {
        _loading = false;
      });
    });
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(backgroundColor: AppColors.greenColor,
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
                    child: Text(
                      'SIGN UP',
                      style: TextStyle(
                          fontSize: mq.height * 0.07,
                          fontWeight: FontWeight.w900,color: AppColors.whiteColor),
                    ),
                  ),
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      RoundTextField(
                        label: 'Email',
                        hint: 'Email',
                        inputType: TextInputType.emailAddress,
                        prefixIcon: Icons.email,
                        textEditingController: emailController,
                        validatorValue: 'Please Enter Email',
                        focusNode: emailFocusNode,
                        onFieldSubmitted: (value) {
                          Utils.fieldFocusNode(
                              context, emailFocusNode, passFocusNode);
                        },
                      ),
                      RoundTextField(
                        label: 'Password',
                        hint: 'Password',
                        inputType: TextInputType.visiblePassword,
                        prefixIcon: Icons.lock,
                        textEditingController: passwordController,
                        isPasswordField: true,
                        validatorValue: 'Please Enter Password',
                        focusNode: passFocusNode,
                        onFieldSubmitted: (value) {
                          onSignUp();
                        },
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 70 ),
                  child: RoundButton(
                      loading: _loading,
                      title: 'Sign Up',
                      onPress: () async {
                        if (_formKey.currentState!.validate()) {
                          onSignUp();
                        }
                      }),
                ),
               Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    const Text("Already have an account?",style: TextStyle(color: AppColors.whiteColor),),
                    TextButton(
                      onPressed: () {
                        Navigator.pushNamed(context, RouteNames.loginScreen);
                      },
                        child: const Text('Login',style: TextStyle(color: Color(0xff53b26e)),),
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
