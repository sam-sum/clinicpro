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
}
