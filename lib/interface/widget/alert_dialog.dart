import 'package:flutter/material.dart';

class CustomAlertDialog extends StatelessWidget {
  final String textTitle;
  final String textMessage;
  final String textNegative = "Cancel";
  final String textPositive = "Continue";
  final Function onNegative;
  final Function onPositive;
  const CustomAlertDialog(
      {super.key,
      required this.textTitle,
      required this.textMessage,
      required this.onNegative,
      required this.onPositive});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(textTitle),
      content: Text(textMessage),
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      actions: [
        ElevatedButton(
          child: Text(textPositive),
          onPressed: () => onPositive(),
        ),
        ElevatedButton(
          child: Text(textNegative),
          onPressed: () => onNegative(),
        ),
      ],
    );
  }
}
