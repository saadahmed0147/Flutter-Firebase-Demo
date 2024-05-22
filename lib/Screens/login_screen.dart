import 'package:firebase_1/Routes/route_name.dart';
import 'package:firebase_1/Utils/utils.dart';
import 'package:firebase_1/component/round_button.dart';
import 'package:firebase_1/component/round_textfield.dart';
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
    return PopScope(
      canPop: false,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Login'),
          automaticallyImplyLeading: false,
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
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      RoundTextField(
                        label: 'Email',
                        hint: 'saadahmed@gmail.com',
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
                        hint: "*********",
                        inputType: TextInputType.number,
                        prefixIcon: Icons.lock,
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
                  padding: const EdgeInsets.only(top: 70, bottom: 10),
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
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Don't have an account?"),
                    TextButton(
                      onPressed: () {
                        Navigator.pushNamed(context, RouteNames.signUpScreen);
                      },
                      child: const Text('SignUp'),
                    )
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: RoundButton(
                    title: 'Login with Phone',
                    backgroundColor: AppColors.whiteColor,
                    foregroundColor: AppColors.blackColor,
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
    );
  }
}
