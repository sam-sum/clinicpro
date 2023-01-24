import 'package:flutter/material.dart';
import 'package:clinicpro/utilities/styles.dart';
import 'package:clinicpro/models/patient_model.dart';

class MedicalRecords extends StatelessWidget {
  const MedicalRecords({Key? key}) : super(key: key);

  static const routeName = '/medicalRecords';

  @override
  Widget build(BuildContext context) {
    final patient = ModalRoute.of(context)!.settings.arguments as Patient;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Styles.backgroundColor,
        title: Text(
          'Medical Records',
          style: TextStyle(
            color: Styles.blackColor,
          ),
        ),
      ),
      body: Column(
        children: <Widget>[
          const Text('Medical Records'),
          Text("Patient ID: ${patient.id}"),
          Text("First Name: ${patient.firstName}"),
          Text("Last Name: ${patient.lastName}"),
        ],
      ),
    );
  }
}
