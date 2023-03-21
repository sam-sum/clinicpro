import 'dart:convert';

import 'package:clinicpro/models/patient_model.dart';
import 'package:clinicpro/providers/patients.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../assets/enum_test_category.dart';
import '../models/vital_sign_model.dart';
import '../models/vital_sign_latest_model.dart';

class VitalSigns with ChangeNotifier {
  static const String HOST_URL = 'rest-clinicpro.onrender.com';

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

  List<VitalSign> get bloodPressureRecords {
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
  }

  List<VitalSign> get bloodOxygenLevelRecords {
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
  }

  List<VitalSign> get respiratoryRateRecords {
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
  }

  List<VitalSign> get heatBeatRateRecords {
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
  }

  Future<void> fetchAllVitalSignsForPatient(String patientId) async {
    _currentPatientId = '';
    _allVitalSignsForPatient = [];
    final url = Uri.https(HOST_URL, '/patients/$patientId/tests');
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
                loadedVitalSigns.add(VitalSign.fromJson(vitalSignData));
              });
            }
            _currentPatientId = patientId;
            _allVitalSignsForPatient = loadedVitalSigns;
            //notifyListeners();
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
      if (kDebugMode) {
        print("latest blood pressure: ${patient.latestRecord!.bLOODPRESSURE!}");
      }
      final readings = await getVitalSign(
          '/patients/${patient.id}/tests/${patient.latestRecord!.bLOODPRESSURE}');
      _summary.setBloodPressure(readings);
    }
    if (patient.latestRecord?.bLOODOXYGENLEVEL != null &&
        patient.latestRecord!.bLOODOXYGENLEVEL!.isNotEmpty) {
      if (kDebugMode) {
        print(
            "latest blood oxygen level: ${patient.latestRecord!.bLOODOXYGENLEVEL!}");
      }
      final readings = await getVitalSign(
          '/patients/${patient.id}/tests/${patient.latestRecord!.bLOODOXYGENLEVEL}');
      _summary.setBloodOxygenLevel(readings);
    }
    if (patient.latestRecord?.rESPIRATORYRATE != null &&
        patient.latestRecord!.rESPIRATORYRATE!.isNotEmpty) {
      if (kDebugMode) {
        print(
            "latest respiratory rate: ${patient.latestRecord!.rESPIRATORYRATE!}");
      }
      final readings = await getVitalSign(
          '/patients/${patient.id}/tests/${patient.latestRecord!.rESPIRATORYRATE}');
      _summary.setRespiratoryRate(readings);
    }
    if (patient.latestRecord?.hEARTBEATRATE != null &&
        patient.latestRecord!.hEARTBEATRATE!.isNotEmpty) {
      if (kDebugMode) {
        print("latest heartbeat rate: ${patient.latestRecord!.hEARTBEATRATE!}");
      }
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
    final url = Uri.https(HOST_URL, entryPoint);
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

  Future<Patient> createVitalSign(
      Patients patientsProvider, Patient myPatient, VitalSign vs) async {
    var vsJson = vs.toJson();
    vsJson.removeWhere((key, value) => value == null);
    final url = Uri.https(HOST_URL, '/patients/${vs.patientId}/tests');
    final response = await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(vsJson),
    );

    if (response.statusCode == 200) {
      if (jsonDecode(response.body)['success'] == true) {
        var newVs = VitalSign.fromJson(jsonDecode(response.body)['data']);
        if (vs.patientId != _currentPatientId) {
          _allVitalSignsForPatient = [];
          _currentPatientId = vs.patientId!;
        }
        _allVitalSignsForPatient.add(newVs);
        final newPatient =
            updatePatientSummary(patientsProvider, myPatient, newVs);
        notifyListeners();
        return newPatient;
      } else {
        throw Exception(jsonDecode(response.body)['message']);
      }
    } else {
      throw Exception(jsonDecode(response.body)['message']);
    }
  }

  Future<Patient> updatePatientSummary(
      Patients patientsProvider, Patient myPatient, VitalSign newVs) async {
    var updatedPatient = Patient();
    (myPatient.latestRecord != null)
        ? updatedPatient.latestRecord = myPatient.latestRecord
        : updatedPatient.latestRecord = LatestRecord();
    // The backend does not allow empty attributes
    if (updatedPatient.latestRecord!.bLOODPRESSURE == null) {
      updatedPatient.latestRecord!.bLOODPRESSURE = 'null';
    }
    if (updatedPatient.latestRecord!.hEARTBEATRATE == null) {
      updatedPatient.latestRecord!.hEARTBEATRATE = 'null';
    }
    if (updatedPatient.latestRecord!.rESPIRATORYRATE == null) {
      updatedPatient.latestRecord!.rESPIRATORYRATE = 'null';
    }
    if (updatedPatient.latestRecord!.bLOODOXYGENLEVEL == null) {
      updatedPatient.latestRecord!.bLOODOXYGENLEVEL = 'null';
    }

    if (newVs.category == TestCategory.BLOOD_PRESSURE.toShortString()) {
      updatedPatient.latestRecord!.bLOODPRESSURE = newVs.id;
    } else if (newVs.category == TestCategory.HEARTBEAT_RATE.toShortString()) {
      updatedPatient.latestRecord!.hEARTBEATRATE = newVs.id;
    } else if (newVs.category ==
        TestCategory.RESPIRATORY_RATE.toShortString()) {
      updatedPatient.latestRecord!.rESPIRATORYRATE = newVs.id;
    } else if (newVs.category ==
        TestCategory.BLOOD_OXYGEN_LEVEL.toShortString()) {
      updatedPatient.latestRecord!.bLOODOXYGENLEVEL = newVs.id;
    }
    updatedPatient.id = myPatient.id;

    return await patientsProvider.updatePatient(updatedPatient);
  }

  Future<VitalSign> updateVitalSigns(VitalSign updatedVs) async {
    var updatedVsJson = updatedVs.toJson();
    // remove fields as required by the backend
    updatedVsJson.removeWhere((key, value) => value == null);
    updatedVsJson.removeWhere((key, value) => key == 'isValid');

    final url = Uri.https(
        HOST_URL, '/patients/${updatedVs.patientId}/tests/${updatedVs.id}');
    final response = await http.patch(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(updatedVsJson),
    );

    if (response.statusCode == 200) {
      if (jsonDecode(response.body)['success'] == true) {
        // update the current master list with the updated vs
        var newVs = VitalSign.fromJson(jsonDecode(response.body)['data']);
        final int index = _allVitalSignsForPatient
            .indexWhere(((vs1) => vs1.id == updatedVs.id));
        if (index != -1) {
          _allVitalSignsForPatient[index] = newVs;
        }
        notifyListeners();
        return newVs;
      } else {
        throw Exception(jsonDecode(response.body)['message']);
      }
    } else {
      throw Exception(jsonDecode(response.body)['message']);
    }
  }
}
