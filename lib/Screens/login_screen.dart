import 'package:firebase_1/Routes/route_name.dart';
import 'package:firebase_1/Utils/utils.dart';
import 'package:firebase_1/component/round_button.dart';
import 'package:firebase_1/component/round_textfield.dart';
import 'package:firebase_1/main.dart';
import 'package:firebase_1/res/colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final _firebaseAuth = FirebaseAuth.instance;
  bool _loading = false;
  FocusNode emailFocusNode = FocusNode();
  FocusNode passFocusNode = FocusNode();

  void onLogin() {
    setState(() {
      _loading = true;
    });
    _firebaseAuth
        .signInWithEmailAndPassword(
      email: emailController.text.toString(),
      password: passwordController.text.toString(),
    )
        .then((value) {
      setState(() {
        _loading = false;
      });
      Utils.flushBarErrorMessage('Login Successfully', context);
      Utils.flushBarErrorMessage(value.user!.email.toString(), context);
      Navigator.pushNamed(context, RouteNames.postScreen);
    }).onError((error, stackTrace) {
      setState(() {
        _loading = false;
      });
      Utils.flushBarErrorMessage(error.toString(), context);
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
    mq = MediaQuery.of(context).size;
    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor: AppColors.greenColor,
        appBar: AppBar(
          // title: const Text('Login'),
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
                    child: Text(
                      'LOGIN',
                      style: TextStyle(
                          fontSize: mq.height * 0.07,
                          fontWeight: FontWeight.w900,
                          color: AppColors.whiteColor),
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
                          // prefixIcon: Icons.email,
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
                          inputType: TextInputType.name,
                          // prefixIcon: Icons.lock,
                          textEditingController: passwordController,
                          isPasswordField: true,
                          validatorValue: 'Please Enter Password',
                          focusNode: passFocusNode,
                          onFieldSubmitted: (value) {
                            onLogin();
                          },
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 70),
                    child: RoundButton(
                        loading: _loading,
                        title: 'Login',
                        onPress: () {
                          if (_formKey.currentState!.validate()) {
                            onLogin();
                          }
                        }),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      const Text(
                        "Don't have an account?",
                        style: TextStyle(color: AppColors.whiteColor),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pushNamed(context, RouteNames.signUpScreen);
                        },
                        child: const Text(
                          'SignUp',
                          style: TextStyle(color: Color(0xff53b26e)),
                        ),
                      )
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: RoundButton(
                      title: 'Login with Phone',
                      onPress: () {
                        Navigator.pushNamed(
                            context, RouteNames.phoneNumberInputScreen);
                      },
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
