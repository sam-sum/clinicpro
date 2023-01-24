import 'package:flutter/material.dart';
import 'package:clinicpro/utilities/styles.dart';
import 'package:clinicpro/models/patient_model.dart';
import 'package:clinicpro/views/medical_records.dart';

class PatientDetails extends StatelessWidget {
  const PatientDetails({Key? key}) : super(key: key);

  static const routeName = '/patientDetails';

  @override
  Widget build(BuildContext context) {
    final patient = ModalRoute.of(context)!.settings.arguments as Patient;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Styles.backgroundColor,
        title: Text(
          'Patient Details',
          style: TextStyle(
            color: Styles.blackColor,
          ),
        ),
      ),
      body: Column(
        children: <Widget>[
          const Text('Patient Details'),
          Text("Patient ID: ${patient.id}"),
          Text("First Name: ${patient.firstName}"),
          Text("Last Name: ${patient.lastName}"),
          const SizedBox(
            height: 30,
          ),
          ElevatedButton(
            onPressed: () {
              // When the user taps the button,
              // navigate to a named route and
              // provide the arguments as a
              // parameter.
              Navigator.pushNamed(
                context,
                MedicalRecords.routeName,
                arguments: patient,
              );
            },
            child: const Text(
                'This is to simulate a click on the edit medical icon'),
          ),
        ],
      ),
    );
  }
}
