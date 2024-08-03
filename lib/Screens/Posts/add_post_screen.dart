import 'package:firebase_1/Res/colors.dart';
import 'package:firebase_1/Utils/utils.dart';
import 'package:firebase_1/component/round_button.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class AddPostScreen extends StatefulWidget {
  const AddPostScreen({super.key});

  @override
  State<AddPostScreen> createState() => _AddPostScreenState();
}

class _AddPostScreenState extends State<AddPostScreen> {
  TextEditingController textFieldController = TextEditingController();
  final databaseRef = FirebaseDatabase.instance.ref('Post');
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height * 1;
    FocusNode textFieldFocus = FocusNode();
    FocusNode buttonFocus = FocusNode();

    bool loading = false;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Post'),
        centerTitle: true,
        backgroundColor: AppColors.blackColor,
        foregroundColor: AppColors.whiteColor,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(30),
          child: Column(
            children: [
              SizedBox(
                height: height * .1,
              ),
              TextFormField(
                onFieldSubmitted: (value) {
                  Utils.fieldFocusNode(context, textFieldFocus, buttonFocus);
                },
                focusNode: textFieldFocus,
                controller: textFieldController,
                maxLines: 8,
                decoration: InputDecoration(
                  hintText: "What's in your mind?",
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide:
                          const BorderSide(color: AppColors.blackColor)),
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide:
                          const BorderSide(color: AppColors.blackColor)),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide:
                          const BorderSide(color: AppColors.blackColor)),
                ),
              ),
              SizedBox(
                height: height * .1,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  RoundButton(
                      focusNode: buttonFocus,
                      loading: loading,
                      title: 'Add',
                      onPress: () {
                        setState(() {
                          loading = true;
                        });
                        databaseRef
                            .child(DateTime.now()
                                .microsecondsSinceEpoch
                                .toString())
                            .set({
                          'text': textFieldController.text.toString(),
                          'id': DateTime.now().microsecondsSinceEpoch.toString()
                        })
                          ..then((value) {
                            setState(() {
                              loading = false;
                            });
                            textFieldController.clear();
                            Utils.flushBarErrorMessage('Post Added', context);
                          })
                          ..onError((error, stackTrace) {
                            setState(() {
                              loading = false;
                            });
                        
                            Utils.flushBarErrorMessage(
                                error.toString(), context);
                          });
                      }),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
