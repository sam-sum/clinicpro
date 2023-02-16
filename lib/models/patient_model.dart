import 'dart:core';

class Patient {
  late String id;
  late String idCardNumber;
  late String firstName;
  late String lastName;
  late String gender;
  late String bedNumber;
  late String dateOfBirth;
  late double height;
  late double weight;
  late String photoUrl;
  late String phoneNumber;
  late String email;
  late String address;
  late String postalCode;
  late String doctor;
  late String emergencyContact;
  late String medicalNotes;
  late String medicalAllergies;
  late String disabled;
  late String bloodPressure;
  late String respiratoryRate;
  late String bloodOxygenLevel;
  late String heartBeatRate;
  late String createdAt;
  late String updatedAt;

  Patient(
    this.id,
    this.idCardNumber,
    this.firstName,
    this.lastName,
    this.gender,
    this.bedNumber,
    this.dateOfBirth,
    this.height,
    this.weight,
    this.photoUrl,
    this.phoneNumber,
    this.email,
    this.address,
    this.postalCode,
    this.doctor,
    this.emergencyContact,
    this.medicalNotes,
    this.medicalAllergies,
    this.disabled,
    this.bloodPressure,
    this.respiratoryRate,
    this.bloodOxygenLevel,
    this.heartBeatRate,
    this.createdAt,
    this.updatedAt,
  );

  Patient.overview(
    this.id,
    this.idCardNumber,
    this.firstName,
    this.lastName,
    this.gender,
    this.bedNumber,
    this.dateOfBirth,
    this.height,
    this.weight,
    this.photoUrl,
    this.phoneNumber,
    this.address,
    this.postalCode,
    this.medicalAllergies,
    this.disabled,
    this.medicalNotes,
    this.doctor,
  );

  factory Patient.fromJson(Map<String, dynamic> json) {
    return Patient.overview(
        json['id'],
        json['idCardNumber'],
        json['firstName'],
        json['lastName'],
        json['gender'],
        json['bedNumber'],
        json['dateOfBirth'],
        double.parse(json['height'].toString()),
        double.parse(json['weight'].toString()),
        json['photoUrl'],
        json['phoneNumber'].toString(),
        json['address'],
        json['postalCode'] ?? '',
        json['medicalAllergies'].toString(),
        json['disabled'].toString(),
        json['medicalNotes'] ?? '',
        json['doctor'] ?? '');
  }
}
