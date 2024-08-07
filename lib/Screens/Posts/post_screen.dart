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

  void editPost(String postKey, String currentText) {
    final TextEditingController _textController =
        TextEditingController(text: currentText);
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Edit Post'),
          content: TextFormField(
            controller: _textController,
            decoration: const InputDecoration(hintText: 'Update post'),
            maxLines: null,
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                final updatedText = _textController.text.toString();
                if (updatedText.isNotEmpty) {
                  databaseRef.child(postKey).update({'text': updatedText})
                    .then((_) {
                      Navigator.of(context).pop();
                    }).onError((error, stackTrace) {
                      Utils.flushBarErrorMessage(error.toString(), context);
                    },);
                }else{
                  Utils.flushBarErrorMessage('Post can not be empty', context);
                }
              },
              child: const Text('Update'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height * 1;

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
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: RoundTextField(
                  hint: 'Search post',
                  prefixIcon: Icons.search,
                  label: 'Search',
                  inputType: TextInputType.text,
                  textEditingController: searchController,
                  onChange: (p0) {
                    setState(() {});
                  },
                ),
              ),
              SizedBox(
                height: height * .03,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Text(
                  'Posts',
                  style: TextStyle(
                      fontWeight: FontWeight.bold, fontSize: height * 0.025),
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
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                                onPressed: () {
                                  editPost(postKey!, text);
                                },
                                icon: const Icon(Icons.edit)),
                            IconButton(
                                onPressed: () {
                                  deletePost(postKey!);
                                },
                                icon: const Icon(Icons.delete)),
                          ],
                        ),
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
