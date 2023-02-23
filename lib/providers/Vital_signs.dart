import 'dart:convert';

import 'package:clinicpro/models/patient_model.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../models/vital_sign_model.dart';
import '../models/vital_sign_latest_model.dart';

class VitalSigns with ChangeNotifier {
  String _currentPatientId = '';
  final VitalSignLatest _summary = VitalSignLatest();
  List<VitalSign> _allVitalSignsForPatient = [];

  VitalSignLatest get summary {
    return _summary;
  }

  List<VitalSign> getAllVitalSignsForPatient(String id) {
    if (_currentPatientId == id) {
      return [..._allVitalSignsForPatient];
    } else {
      return <VitalSign>[];
    }
  }

  List<VitalSign> getBloodPressureRecordsForPatient(String id) {
    if (_currentPatientId == id) {
      List<VitalSign> shortList = _allVitalSignsForPatient
          .where((record) =>
              record.category == 'BLOOD_PRESSURE' && record.isValid == true)
          .toList();
      //sort in date descending order
      shortList.sort((a, b) {
        return DateTime.parse(b.createdAt ?? '1971-01-01')
            .compareTo(DateTime.parse(a.createdAt ?? '1971-01-01'));
      });
      return shortList;
    } else {
      return <VitalSign>[];
    }
  }

  List<VitalSign> getBloodOxygenLevelRecordsForPatient(String id) {
    if (_currentPatientId == id) {
      List<VitalSign> shortList = _allVitalSignsForPatient
          .where((record) =>
              record.category == 'BLOOD_OXYGEN_LEVEL' && record.isValid == true)
          .toList();
      //sort in date descending order
      shortList.sort((a, b) {
        return DateTime.parse(b.createdAt ?? '1971-01-01')
            .compareTo(DateTime.parse(a.createdAt ?? '1971-01-01'));
      });
      return shortList;
    } else {
      return <VitalSign>[];
    }
  }

  List<VitalSign> getRespiratoryRateRecordsForPatient(String id) {
    if (_currentPatientId == id) {
      List<VitalSign> shortList = _allVitalSignsForPatient
          .where((record) =>
              record.category == 'RESPIRATORY_RATE' && record.isValid == true)
          .toList();
      //sort in date descending order
      shortList.sort((a, b) {
        return DateTime.parse(b.createdAt ?? '1971-01-01')
            .compareTo(DateTime.parse(a.createdAt ?? '1971-01-01'));
      });
      return shortList;
    } else {
      return <VitalSign>[];
    }
  }

  List<VitalSign> getHeatBeatRateRecordsForPatient(String id) {
    if (_currentPatientId == id) {
      List<VitalSign> shortList = _allVitalSignsForPatient
          .where((record) =>
              record.category == 'HEARTBEAT_RATE' && record.isValid == true)
          .toList();
      //sort in date descending order
      shortList.sort((a, b) {
        return DateTime.parse(b.createdAt ?? '1971-01-01')
            .compareTo(DateTime.parse(a.createdAt ?? '1971-01-01'));
      });
      return shortList;
    } else {
      return <VitalSign>[];
    }
  }

  Future<void> fetchAllVitalSignsForPatient(String patientId) async {
    _currentPatientId = '';
    _allVitalSignsForPatient = [];
    //final url = Uri.https('rest-clinicpro.onrender.com', '/patients');
    final url = Uri.https('gp5.onrender.com', '/patients/$patientId/tests');
    try {
      final response = await http.get(url);
      switch (response.statusCode) {
        case 200:
          {
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
            _currentPatientId = patientId;
            _allVitalSignsForPatient = loadedVitalSigns;
            notifyListeners();
          }
          break;
        default:
          {
            throw Exception(response.reasonPhrase);
          }
      }
    } catch (error) {
      rethrow;
    }
  }

  Future<void> fetchLatestVitalSignsForPatient(Patient patient) async {
    _summary.setBloodPressure(null);
    _summary.setBloodOxygenLevel(null);
    _summary.setRespiratoryRate(null);
    _summary.setHeartBeatRate(null);
    if (patient.latestRecord?.bLOODPRESSURE != null &&
        patient.latestRecord!.bLOODPRESSURE!.isNotEmpty) {
      print("latest blood pressure: ${patient.latestRecord!.bLOODPRESSURE!}");
      final readings = await getVitalSign(
          '/patients/${patient.id}/tests/${patient.latestRecord!.bLOODPRESSURE}');
      _summary.setBloodPressure(readings);
    }
    if (patient.latestRecord?.bLOODOXYGENLEVEL != null &&
        patient.latestRecord!.bLOODOXYGENLEVEL!.isNotEmpty) {
      print(
          "latest blood oxygen level: ${patient.latestRecord!.bLOODOXYGENLEVEL!}");
      final readings = await getVitalSign(
          '/patients/${patient.id}/tests/${patient.latestRecord!.bLOODOXYGENLEVEL}');
      _summary.setBloodOxygenLevel(readings);
    }
    if (patient.latestRecord?.rESPIRATORYRATE != null &&
        patient.latestRecord!.rESPIRATORYRATE!.isNotEmpty) {
      print(
          "latest respiratory rate: ${patient.latestRecord!.rESPIRATORYRATE!}");
      final readings = await getVitalSign(
          '/patients/${patient.id}/tests/${patient.latestRecord!.rESPIRATORYRATE}');
      _summary.setRespiratoryRate(readings);
    }
    if (patient.latestRecord?.hEARTBEATRATE != null &&
        patient.latestRecord!.hEARTBEATRATE!.isNotEmpty) {
      print("latest heartbeat rate: ${patient.latestRecord!.hEARTBEATRATE!}");
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
            //print(extractedData);
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
