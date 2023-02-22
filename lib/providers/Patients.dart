import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../models/patient_model.dart';

class Patients with ChangeNotifier {
  List<Patient> _patients = [];

  List<Patient> get patients {
    return [..._patients];
  }

  Patient findById(String id) {
    return _patients.firstWhere((currentPatient) => currentPatient.id == id);
  }

  Future<void> fetchAllPatients() async {
    final url = Uri.https('gp5.onrender.com', '/patients');
    //final url = Uri.https('rest-clinicpro.onrender.com', '/patients');
    try {
      final response = await http.get(url);
      final extractedData = json.decode(response.body)['data'] as dynamic;
      //print(extractedData);
      final List<Patient> loadedPatients = [];

      extractedData.forEach((patientData) {
        //print(patientData);
        loadedPatients.add(Patient.fromJson(patientData));
      });
      _patients = loadedPatients;
      //print(_patients[0].id);
      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }

  Future<void> updatePatient(String id, Patient newPatient) async {
    await Future.delayed(const Duration(seconds: 3));
    //throw Exception("test update error");
  }
}
