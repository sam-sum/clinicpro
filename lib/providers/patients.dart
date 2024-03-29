import 'dart:collection';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../models/patient_model.dart';
import '../models/vital_sign_model.dart';
import '../assets/enum_filter_op.dart';
import '../assets/enum_test_category.dart';
import '../assets/enum_gender_selection.dart';

class Patients with ChangeNotifier {
  static const String HOST_URL = 'rest-clinicpro.onrender.com';

  List<Patient> _patients = [];

  List<Patient> get patients {
    return [..._patients];
  }

  Patient findById(String id) {
    return _patients.firstWhere((currentPatient) => currentPatient.id == id);
  }

  Future<void> fetchAllPatients() async {
    final url = Uri.https(HOST_URL, '/patients');
    try {
      final response = await http.get(url);
      final extractedData = json.decode(response.body)['data'] as dynamic;
      final List<Patient> loadedPatients = [];

      extractedData.forEach((patientData) {
        loadedPatients.add(Patient.fromJson(patientData));
      });
      _patients = loadedPatients;
      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }

  Future<Patient> updatePatient(Patient updatedPatient) async {
    var patientJson = updatedPatient.toJson();
    patientJson.removeWhere((key, value) => value == null);

    final url = Uri.https(HOST_URL, '/patients');
    final response = await http.patch(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(patientJson),
    );
    if (response.statusCode == 200) {
      if (jsonDecode(response.body)['success'] == true) {
        // update the current master list with the updated patient
        var newPatient = Patient.fromJson(jsonDecode(response.body)['data']);
        final int index = _patients
            .indexWhere(((patient1) => patient1.id == updatedPatient.id));
        if (index != -1) {
          _patients[index] = newPatient;
        }
        notifyListeners();
        return newPatient;
      } else {
        throw Exception(jsonDecode(response.body)['message']);
      }
    } else {
      throw Exception(jsonDecode(response.body)['message']);
    }
  }

  Future<Patient> createPatient(Patient patient) async {
    final url = Uri.https(HOST_URL, '/patients');
    //final url = Uri.https('rest-clinicpro.onrender.com', '/patients');
    final response = await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(patient.toJson()),
    );

    if (response.statusCode == 200) {
      if (jsonDecode(response.body)['success'] == true) {
        var newPatient = Patient.fromJson(jsonDecode(response.body));
        _patients.add(newPatient);
        notifyListeners();
        return newPatient;
      } else {
        throw Exception(jsonDecode(response.body)['message']);
      }
    } else {
      throw Exception(jsonDecode(response.body)['message']);
    }
  }

  Future<List<Patient>> fetchPatientsWithFilters({
    required FilterOp opUpperPressure,
    required int upperPressure,
    required FilterOp opLowerPressure,
    required int lowerPressure,
    required FilterOp opOxygenLevel,
    required int oxygenLevel,
    required FilterOp opRespiratoryRate,
    required int respiratoryRate,
    required FilterOp opHeartBeatRate,
    required int heartBeatRate,
    required FilterGender gender,
  }) async {
    final url = Uri.https(HOST_URL, '/tests');
    //final url = Uri.https('rest-clinicpro.onrender.com', '/tests');
    final List<VitalSign> loadedTests = [];
    List<VitalSign> uniqueTests = [];
    List<String> patientUpperPressureMatched = [];
    List<String> patientLowerPressureMatched = [];
    List<String> patientOxygenLevelMatched = [];
    List<String> patientRespiratoryRateMatched = [];
    List<String> patientHeartBeatRateMatched = [];
    List<Patient> filteredPatients = [];
    try {
      final response = await http.get(url);
      final extractedData = json.decode(response.body)['data'] as dynamic;
      extractedData.forEach((testData) {
        loadedTests.add(VitalSign.fromJson(testData));
      });
      //sort in patient ID + category + create date descending order
      loadedTests.sort((a, b) {
        return ("${b.patientId}${b.category}${b.createdAt}")
            .compareTo("${a.patientId}${a.category}${a.createdAt}");
      });
      //de-duplicate the list by patient ID + category by saving the keys in a temporary set
      var seen = <String>{};
      uniqueTests = loadedTests
          .where((aTest) => seen.add("${aTest.patientId}+${aTest.category}"))
          .toList();
      //filter and keep the isValid records only
      uniqueTests.retainWhere((testOne) {
        return testOne.isValid ?? false;
      });
      //apply FilterOp for blood pressure per input parameters
      if (opUpperPressure != FilterOp.nop) {
        patientUpperPressureMatched = _shortListReadings(
            TestCategory.BLOOD_PRESSURE,
            uniqueTests,
            opUpperPressure,
            upperPressure,
            false);
      }
      if (opLowerPressure != FilterOp.nop) {
        patientLowerPressureMatched = _shortListReadings(
            TestCategory.BLOOD_PRESSURE,
            uniqueTests,
            opLowerPressure,
            lowerPressure,
            true);
      }
      //apply FilterOp for oxygen level per input parameters
      if (opOxygenLevel != FilterOp.nop) {
        patientOxygenLevelMatched = _shortListReadings(
            TestCategory.BLOOD_OXYGEN_LEVEL,
            uniqueTests,
            opOxygenLevel,
            oxygenLevel,
            false);
      }
      //apply FilterOp for respiratory rate per input parameters
      if (opRespiratoryRate != FilterOp.nop) {
        patientRespiratoryRateMatched = _shortListReadings(
            TestCategory.RESPIRATORY_RATE,
            uniqueTests,
            opRespiratoryRate,
            respiratoryRate,
            false);
      }
      //apply FilterOp for heartBeat rate per input parameters
      if (opHeartBeatRate != FilterOp.nop) {
        patientHeartBeatRateMatched = _shortListReadings(
            TestCategory.HEARTBEAT_RATE,
            uniqueTests,
            opHeartBeatRate,
            heartBeatRate,
            false);
      }
      //make a Set of unique matched patient IDs
      Set<String> uniquePatientId = {};
      uniquePatientId.addAll(patientUpperPressureMatched);
      uniquePatientId.addAll(patientLowerPressureMatched);
      uniquePatientId.addAll(patientOxygenLevelMatched);
      uniquePatientId.addAll(patientRespiratoryRateMatched);
      uniquePatientId.addAll(patientHeartBeatRateMatched);
      //shortlist the patient list
      if (uniquePatientId.isNotEmpty) {
        //fetch the back end for a full patient list
        await fetchAllPatients();
        //filter the full patient list against the unique patient Ids
        final matchingSet = HashSet.from(uniquePatientId);
        filteredPatients =
            (_patients.where((item) => matchingSet.contains(item.id))).toList();
      }
      //filter the choice of gender
      if (gender != FilterGender.both) {
        if (gender == FilterGender.male) {
          filteredPatients.retainWhere((item) =>
              item.gender?.toLowerCase() == FilterGender.male.toShortString());
        } else {
          filteredPatients.retainWhere((item) =>
              item.gender?.toLowerCase() ==
              FilterGender.female.toShortString());
        }
      }
      notifyListeners();
      if (kDebugMode) {
        for (var item in filteredPatients) {
          print("${item.id}|${item.firstName}|${item.lastName}|");
        }
      }
      return filteredPatients;
    } catch (error) {
      rethrow;
    }
  }

  List<String> _shortListReadings(
      TestCategory readingCategory,
      List<VitalSign> testRecords,
      FilterOp operator,
      int value,
      bool isLowerValue) {
    int index =
        (isLowerValue) ? 1 : 0; // lower pressure has index 1, else has index 0
    Set<String> ids = {};
    switch (operator) {
      case FilterOp.greater:
        for (var testOne in testRecords) {
          if (testOne.category == readingCategory.toShortString()) {
            // The reading is a concat of lower pressure, upper pressure
            try {
              var upperValue =
                  double.parse((testOne.readings ?? '0,0').split(',')[index]);
              if (upperValue > value) {
                ids.add(testOne.patientId ?? '');
              }
            } catch (_) {}
          }
        }
        break;
      case FilterOp.less:
        for (var testOne in testRecords) {
          if (testOne.category == readingCategory.toShortString()) {
            // The reading is a concat of lower pressure, upper pressure
            try {
              var upperValue =
                  double.parse((testOne.readings ?? '0,0').split(',')[index]);
              if (upperValue < value) {
                ids.add(testOne.patientId ?? '');
              }
            } catch (_) {}
          }
        }
        break;
      case FilterOp.equal:
        for (var testOne in testRecords) {
          if (testOne.category == readingCategory.toShortString()) {
            // The reading is a concat of lower pressure, upper pressure
            try {
              var upperValue =
                  double.parse((testOne.readings ?? '0,0').split(',')[index]);
              if (upperValue == value) {
                ids.add(testOne.patientId ?? '');
              }
            } catch (_) {}
          }
        }
        break;
      case FilterOp.nop:
        break;
    }
    return ids.toList();
  }
}
