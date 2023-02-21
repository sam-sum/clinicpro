import 'package:clinicpro/views/patient_details.dart';
import 'package:flutter/material.dart';
import 'package:clinicpro/utilities/styles.dart';
import 'package:clinicpro/models/patient_model.dart';
import 'package:provider/provider.dart';
import '../providers/Patients.dart';

class OverviewDemo extends StatefulWidget {
  const OverviewDemo({Key? key}) : super(key: key);

  @override
  State<OverviewDemo> createState() => _OverviewDemoState();
}

class _OverviewDemoState extends State<OverviewDemo> {
  var _isInit = true;
  var _isLoading = false;

  @override
  void didChangeDependencies() {
    if (_isInit) {
      setState(() {
        _isLoading = true;
      });
      Provider.of<Patients>(context).fetchAllPatients().then((_) {
        setState(() {
          _isLoading = false;
        });
      });
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final patientsData = Provider.of<Patients>(context);

    return Material(
      color: Styles.backgroundColor,
      child: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const Text('Overview'),
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
                      PatientDetails.routeName,
                      arguments: patientsData.patients[0],
                    );
                  },
                  child: const Text(
                      'This is to simulate a click on a patient list item'),
                ),
              ],
            ),
    );
  }
}
