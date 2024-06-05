import 'package:firebase_1/Component/round_textfield.dart';
import 'package:firebase_1/Res/colors.dart';
import 'package:firebase_1/Routes/route_name.dart';
import 'package:firebase_1/Utils/utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';

class PostScreen extends StatefulWidget {
  const PostScreen({super.key});

  @override
  State<PostScreen> createState() => _PostScreenState();
}

class _PostScreenState extends State<PostScreen> {
  final databaseRef = FirebaseDatabase.instance.ref('Post');
  TextEditingController searchController = TextEditingController();

  void deletePost(String postKey) {
    databaseRef.child(postKey).remove().then((value) {
      Utils.flushBarErrorMessage('Post Deleted', context);
    }).onError((error, stackTrace) {
      Utils.flushBarErrorMessage(error.toString(), context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
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
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: RoundTextField(
                  prefixIcon: Icons.search,
                  label: 'Search',
                  inputType: TextInputType.text,
                  textEditingController: searchController,
                  onChange: (p0) {
                    setState(() {});
                  },
                ),
              ),
              Expanded(
                child: FirebaseAnimatedList(
                  query: databaseRef,
                  itemBuilder: (context, snapshot, animation, index) {
                    final text = snapshot.child('text').value.toString();
                    final postKey = snapshot.key;
                    if (searchController.text.isEmpty) {
                      return ListTile(
                        title: Text(
                          snapshot.child('text').value.toString(),
                        ),
                        subtitle: Text(snapshot.child('id').value.toString()),
                        trailing: IconButton(
                            onPressed: () {
                              deletePost(postKey!);
                            },
                            icon: const Icon(Icons.delete)),
                      );
                    } else if (text
                        .toLowerCase()
                        .contains(searchController.text.toLowerCase())) {
                      return ListTile(
                        title: Text(
                          snapshot.child('text').value.toString(),
                        ),
                        subtitle: Text(snapshot.child('id').value.toString()),
                        trailing: IconButton(
                            onPressed: () {
                              deletePost(postKey!);
                            },
                            icon: const Icon(Icons.delete)),
                      );
                    } else {
                      return Container();
                    }
                  },
                ),
              )
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.pushNamed(context, RouteNames.addPostScreen);
          },
          backgroundColor: AppColors.blackColor,
          foregroundColor: AppColors.whiteColor,
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}
