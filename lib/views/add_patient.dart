import 'package:flutter/material.dart';
import 'package:clinicpro/utilities/styles.dart';

class AddPatient extends StatelessWidget {
  const AddPatient({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Styles.backgroundColor,
      child: const Text('Add Patient'),
    );
  }
}
