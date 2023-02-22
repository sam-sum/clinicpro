import 'package:clinicpro/widgets/stateless_button.dart';
import 'package:flutter/material.dart';

class SimpleDialogue extends AlertDialog {
  final String? header;
  final String? text;

  const SimpleDialogue({this.header, this.text, super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(15.0))),
      title: Text(header ?? ''),
      content: Text(text ?? ''),
      actions: <Widget>[
        StatelessButton(
          width: 100,
          buttonText: 'Okay',
          onPressed: () {
            Navigator.of(context).pop();
          },
        )
      ],
    );
  }
}
