import 'package:flutter/material.dart';
import 'package:clinicpro/utilities/styles.dart';
import 'package:clinicpro/views/patient_details.dart';
import 'package:clinicpro/models/patient_model.dart';

class Search extends StatelessWidget {
  const Search({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Styles.backgroundColor,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          const Text('Search'),
          const SizedBox(
            height: 30,
          ),
          ElevatedButton(
            onPressed: () {
              // When the user taps the button,
              // navigate to a named route and
              // provide the arguments as a
              // parameter.
              // Navigator.pushNamed(
              //   context,
              //   PatientDetails.routeName,
              //   arguments: Patient(
              //       '1',
              //       'XYZ962438',
              //       'Peter',
              //       'Parker',
              //       '',
              //       '',
              //       '',
              //       150,
              //       80,
              //       '',
              //       '',
              //       '',
              //       '',
              //       '',
              //       '',
              //       '',
              //       '',
              //       '',
              //       '',
              //       '',
              //       '',
              //       '',
              //       '',
              //       '',
              //       ''),
              // );
            },
            child: const Text(
                'This is to simulate a click on a patient list item'),
          ),
        ],
      ),
    );
  }
}
