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
  }

  Future<Patient> createPatient(Patient patient) async {
    final response = await http.post(
      Uri.parse('https://gp5.onrender.com/patients'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(patient.toJson()),
    );

    if (response.statusCode == 200) {
      if (jsonDecode(response.body)['success'] == true) {
        return Patient.fromJson(jsonDecode(response.body));
      } else {
        throw Exception(jsonDecode(response.body)['message']);
      }
    } else {
      throw Exception(jsonDecode(response.body)['message']);
    }
  }
}
