// import 'dart:core';

// class Patient {
//   late String id;
//   late String idCardNumber;
//   late String firstName;
//   late String lastName;
//   late String gender;
//   late String bedNumber;
//   late String dateOfBirth;
//   late double height;
//   late double weight;
//   late String photoUrl;
//   late String phoneNumber;
//   late String email;
//   late String address;
//   late String postalCode;
//   late String doctor;
//   late String emergencyContact;
//   late String medicalNotes;
//   late String medicalAllergies;
//   late String disabled;
//   late String bloodPressure;
//   late String respiratoryRate;
//   late String bloodOxygenLevel;
//   late String heartBeatRate;
//   late String createdAt;
//   late String updatedAt;

//   Patient(
//     this.id,
//     this.idCardNumber,
//     this.firstName,
//     this.lastName,
//     this.gender,
//     this.bedNumber,
//     this.dateOfBirth,
//     this.height,
//     this.weight,
//     this.photoUrl,
//     this.phoneNumber,
//     this.email,
//     this.address,
//     this.postalCode,
//     this.doctor,
//     this.emergencyContact,
//     this.medicalNotes,
//     this.medicalAllergies,
//     this.disabled,
//     this.bloodPressure,
//     this.respiratoryRate,
//     this.bloodOxygenLevel,
//     this.heartBeatRate,
//     this.createdAt,
//     this.updatedAt,
//   );

//   Patient.overview(
//     this.id,
//     this.idCardNumber,
//     this.firstName,
//     this.lastName,
//     this.gender,
//     this.bedNumber,
//     this.dateOfBirth,
//     this.height,
//     this.weight,
//     this.photoUrl,
//     this.phoneNumber,
//     this.address,
//     this.postalCode,
//     this.medicalAllergies,
//     this.disabled,
//     this.medicalNotes,
//     this.doctor,
//   );

//   factory Patient.fromJson(Map<String, dynamic> json) {
//     return Patient.overview(
//         json['id'],
//         json['idCardNumber'],
//         json['firstName'],
//         json['lastName'],
//         json['gender'],
//         json['bedNumber'],
//         json['dateOfBirth'],
//         double.parse(json['height'].toString()),
//         double.parse(json['weight'].toString()),
//         json['photoUrl'],
//         json['phoneNumber'].toString(),
//         json['address'],
//         json['postalCode'] ?? '',
//         json['medicalAllergies'].toString(),
//         json['disabled'].toString(),
//         json['medicalNotes'] ?? '',
//         json['doctor'] ?? '');
//   }
// }

class Response {
  bool? success;
  int? status;
  String? message;
  List<Patient>? data;

  Response({this.success, this.status, this.message, this.data});

  Response.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = <Patient>[];
      json['data'].forEach((v) {
        data!.add(new Patient.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Patient {
  LatestRecord? latestRecord;
  String? sId;
  String? id;
  String? idCardNumber;
  String? firstName;
  String? lastName;
  String? gender;
  String? bedNumber;
  String? dateOfBirth;
  double? height;
  double? weight;
  String? photoUrl;
  int? phoneNumber;
  String? address;
  String? postalCode;
  bool? medicalAllergies;
  bool? disabled;
  String? createdAt;
  String? updatedAt;
  int? iV;
  String? medicalNotes;
  String? doctor;
  String? email;

  Patient(
      {this.latestRecord,
      this.sId,
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
      this.createdAt,
      this.updatedAt,
      this.iV,
      this.medicalNotes,
      this.doctor,
      this.email});

  Patient.fromJson(Map<String, dynamic> json) {
    latestRecord = json['latestRecord'] != null
        ? LatestRecord.fromJson(json['latestRecord'])
        : null;
    sId = json['_id'];
    id = json['id'];
    idCardNumber = json['idCardNumber'];
    firstName = json['firstName'];
    lastName = json['lastName'];
    gender = json['gender'];
    bedNumber = json['bedNumber'];
    dateOfBirth = json['dateOfBirth'];
//    height = json['height'];
//   weight = json['weight'];
    try {
      height = double.parse(json['height'].toString());
    } catch (error) {
      height = null;
    }
    try {
      weight = double.parse(json['weight'].toString());
    } catch (error) {
      weight = null;
    }
    photoUrl = json['photoUrl'];
    phoneNumber = json['phoneNumber'];
    address = json['address'];
    postalCode = json['postalCode'];
    medicalAllergies = json['medicalAllergies'];
    disabled = json['disabled'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
    medicalNotes = json['medicalNotes'];
    doctor = json['doctor'];
    email = json['email'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.latestRecord != null) {
      data['latestRecord'] = this.latestRecord!.toJson();
    }
    data['_id'] = this.sId;
    data['id'] = this.id;
    data['idCardNumber'] = this.idCardNumber;
    data['firstName'] = this.firstName;
    data['lastName'] = this.lastName;
    data['gender'] = this.gender;
    data['bedNumber'] = this.bedNumber;
    data['dateOfBirth'] = this.dateOfBirth;
    data['height'] = this.height;
    data['weight'] = this.weight;
    data['photoUrl'] = this.photoUrl;
    data['phoneNumber'] = this.phoneNumber;
    data['address'] = this.address;
    data['postalCode'] = this.postalCode;
    data['medicalAllergies'] = this.medicalAllergies;
    data['disabled'] = this.disabled;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['__v'] = this.iV;
    data['medicalNotes'] = this.medicalNotes;
    data['doctor'] = this.doctor;
    data['email'] = this.email;
    return data;
  }
}

class LatestRecord {
  String? bLOODPRESSURE;
  String? hEARTBEATRATE;
  String? bLOODOXYGENLEVEL;
  String? rESPIRATORYRATE;

  LatestRecord(
      {this.bLOODPRESSURE,
      this.hEARTBEATRATE,
      this.bLOODOXYGENLEVEL,
      this.rESPIRATORYRATE});

  LatestRecord.fromJson(Map<String, dynamic> json) {
    bLOODPRESSURE = json['BLOOD_PRESSURE'] ?? '';
    hEARTBEATRATE = json['HEARTBEAT_RATE'] ?? '';
    bLOODOXYGENLEVEL = json['BLOOD_OXYGEN_LEVEL'] ?? '';
    rESPIRATORYRATE = json['RESPIRATORY_RATE'] ?? '';
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['BLOOD_PRESSURE'] = this.bLOODPRESSURE;
    data['HEARTBEAT_RATE'] = this.hEARTBEATRATE;
    data['BLOOD_OXYGEN_LEVEL'] = this.bLOODOXYGENLEVEL;
    data['RESPIRATORY_RATE'] = this.rESPIRATORYRATE;
    return data;
  }
}
