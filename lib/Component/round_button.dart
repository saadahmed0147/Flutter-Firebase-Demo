import 'package:firebase_1/res/colors.dart';
import 'package:flutter/material.dart';

class RoundButton extends StatefulWidget {
  final String title;
  final bool loading;
  final VoidCallback onPress;
  const RoundButton({
    super.key,
    required this.title,
    required this.onPress,
    this.loading = false,
  });

  @override
  State<RoundButton> createState() => _RoundButtonState();
}

class _RoundButtonState extends State<RoundButton> {
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width * 1;
    final height = MediaQuery.of(context).size.height * 1;

    return widget.loading
        ? const CircularProgressIndicator(
            color: AppColors.blackColor,
          )
        : ElevatedButton(
            onPressed: widget.onPress,
            style: ElevatedButton.styleFrom(
                textStyle: const TextStyle(fontSize: 20),
                fixedSize: Size(width * .5, height * .06),
                backgroundColor: AppColors.blackColor,
                foregroundColor: AppColors.whiteColor),
            child: Text(widget.title),
          );
  }
}
