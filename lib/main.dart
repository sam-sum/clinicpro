import 'package:clinicpro/providers/vital_signs.dart';
import 'package:flutter/material.dart';
import 'package:clinicpro/providers/patients.dart';
import 'package:clinicpro/utilities/styles.dart';
import 'package:provider/provider.dart';
import 'widgets/bottom_nav.dart';
import 'views/login.dart';
import 'views/patient_details.dart';
import 'views/medical_records.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(
          value: Patients(),
        ),
        ChangeNotifierProvider.value(
          value: VitalSigns(),
        ),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primaryColor: Styles.primaryColor,
          backgroundColor: Styles.backgroundColor,
        ),
        home: const Login(),
        routes: {
          BottomNav.routeName: (context) => const BottomNav(),
          PatientDetails.routeName: (context) => const PatientDetails(),
          MedicalRecords.routeName: (context) => const MedicalRecords(),
        },
      ),
    );
  }
}
