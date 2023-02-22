import 'dart:convert';

import 'package:clinicpro/models/patient_model.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../models/vital_sign_model.dart';
import '../models/vital_sign_latest_model.dart';

class VitalSigns with ChangeNotifier {
  final VitalSignLatest _summary = VitalSignLatest();
  List<VitalSign> _allVitalSignsForPatient = [];

  VitalSignLatest get summary {
    return _summary;
  }

  List<VitalSign> get allVitalSignsForPatient {
    return [..._allVitalSignsForPatient];
  }

  Future<void> fetchAllVitalSignsForPatient(String patientId) async {
    _allVitalSignsForPatient = [];
    //final url = Uri.https('rest-clinicpro.onrender.com', '/patients');
    final url = Uri.https('gp5.onrender.com', '/patients/$patientId/tests');
    try {
      final response = await http.get(url);
      final extractedData = json.decode(response.body)['data'] as dynamic;
      //print(extractedData);
      final List<VitalSign> loadedVitalSigns = [];
      if (extractedData != null) {
        extractedData.forEach((vitalSignData) {
          //print(patientData);
          loadedVitalSigns.add(VitalSign.fromJson(vitalSignData));
        });
      }
      //print(_patients[0].id);
      _allVitalSignsForPatient = loadedVitalSigns;
      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }

  Future<void> fetchLatestVitalSignsForPatient(Patient patient) async {
    _summary.setBloodPressure(null);
    _summary.setBloodOxygenLevel(null);
    _summary.setRespiratoryRate(null);
    _summary.setHeartBeatRate(null);
    if (patient.latestRecord?.bLOODPRESSURE != null) {
      final readings = await getVitalSign(
          '/patients/${patient.id}/tests/${patient.latestRecord!.bLOODPRESSURE}');
      _summary.setBloodPressure(readings);
    }
    if (patient.latestRecord?.bLOODOXYGENLEVEL != null) {
      final readings = await getVitalSign(
          '/patients/${patient.id}/tests/${patient.latestRecord!.bLOODOXYGENLEVEL}');
      _summary.setBloodOxygenLevel(readings);
    }
    if (patient.latestRecord?.rESPIRATORYRATE != null) {
      final readings = await getVitalSign(
          '/patients/${patient.id}/tests/${patient.latestRecord!.rESPIRATORYRATE}');
      _summary.setRespiratoryRate(readings);
    }
    if (patient.latestRecord?.hEARTBEATRATE != null) {
      final readings = await getVitalSign(
          '/patients/${patient.id}/tests/${patient.latestRecord!.hEARTBEATRATE}');
      _summary.setHeartBeatRate(readings);
    }
    if (_summary.heartBeatRate != null ||
        _summary.respiratoryRate != null ||
        _summary.bloodOxygenLevel != null ||
        _summary.bloodPressure != null) {
      notifyListeners();
    }
  }

  Future<String?> getVitalSign(String entryPoint) async {
    //const domain = 'rest-clinicpro.onrender.com';
    const domain = 'gp5.onrender.com';
    final url = Uri.https(domain, entryPoint);
    String? result;
    try {
      //throw Exception("Unit test http fail");
      final response = await http.get(url);
      switch (response.statusCode) {
        case 200:
          {
            final extractedData = json.decode(response.body)['data'] as dynamic;
            if (extractedData != null) {
              result = VitalSign.fromJson(extractedData).readings;
            }
          }
          break;
        default:
          {
            result = null;
          }
          break;
      }
    } catch (error) {
      throw Exception(error);
    }
    return result;
  }
}
