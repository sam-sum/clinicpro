import 'package:clinicpro/views/patient_details.dart';
import 'package:flutter/material.dart';
import 'package:clinicpro/utilities/styles.dart';
import 'package:clinicpro/models/patient_model.dart';
import 'package:provider/provider.dart';
import '../assets/enum_filter_op.dart';
import '../assets/enum_gender_selection.dart';
import '../providers/patients.dart';

class OverviewDemo extends StatefulWidget {
  const OverviewDemo({Key? key}) : super(key: key);

  @override
  State<OverviewDemo> createState() => _OverviewDemoState();
}

class _OverviewDemoState extends State<OverviewDemo> {
  var _isInit = true;
  var _isLoading = false;
  List<Patient> _filteredPatients = [];

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

  void getFilteredPatients() async {
    setState(() {
      _isLoading = true;
    });
    _filteredPatients = await Provider.of<Patients>(context, listen: false)
        .fetchPatientsWithFilters(
      opUpperPressure: FilterOp.greater,
      upperPressure: 199,
      opLowerPressure: FilterOp.nop,
      lowerPressure: 0,
      opOxygenLevel: FilterOp.nop,
      oxygenLevel: 0,
      opRespiratoryRate: FilterOp.nop,
      respiratoryRate: 0,
      opHeartBeatRate: FilterOp.nop,
      heartBeatRate: 0,
      gender: FilterGender.female,
    );
    setState(() {
      _isLoading = false;
    });
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
              children: [
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
                ElevatedButton(
                  onPressed: () {
                    getFilteredPatients();
                  },
                  child: const Text('This is to simulate a filter on patients'),
                ),
                Column(
                    children: _filteredPatients.map((one) {
                  return Text("${one.id}|${one.firstName}|${one.lastName}|");
                }).toList()),
              ],
            ),
    );
  }
}
