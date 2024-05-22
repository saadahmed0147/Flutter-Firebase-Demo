import 'package:firebase_1/Res/colors.dart';
import 'package:firebase_1/Routes/route_name.dart';
import 'package:firebase_1/Utils/utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class PostScreen extends StatefulWidget {
  const PostScreen({super.key});

  @override
  State<PostScreen> createState() => _PostScreenState();
}

class _PostScreenState extends State<PostScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: AppColors.blackColor,
        foregroundColor: AppColors.whiteColor,
        title: const Text('Posts'),
        centerTitle: true,
        actions: [
          IconButton(
              onPressed: () {
                FirebaseAuth.instance.signOut().then((value) =>
                    Navigator.pushNamed(context, RouteNames.loginScreen)
                      ..onError((error, stackTrace) =>
                          Utils.flushBarErrorMessage(
                              error.toString(), context)));
              },
              icon: const Icon(Icons.exit_to_app))
        ],
      ),
      body: const Center(
        child: Text('Post Screen'),
      ),
    );
  }
}
