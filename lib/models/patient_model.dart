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
        data!.add(Patient.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['success'] = success;
    data['status'] = status;
    data['message'] = message;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Patient {
  LatestRecord? latestRecord;
  //String? sId;
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
  // int? iV;
  String? medicalNotes;
  String? doctor;
  String? email;

  Patient(
      {this.latestRecord,
      // this.sId,
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
      // this.iV,
      this.medicalNotes,
      this.doctor,
      this.email});

  Patient.fromJson(Map<String, dynamic> json) {
    latestRecord = json['latestRecord'] != null
        ? LatestRecord.fromJson(json['latestRecord'])
        : null;
    // sId = json['_id'];
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
    // iV = json['__v'];
    medicalNotes = json['medicalNotes'];
    doctor = json['doctor'];
    email = json['email'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (latestRecord != null) {
      data['latestRecord'] = latestRecord!.toJson();
    }
    //data['_id'] = this.sId;
    data['id'] = id;
    data['idCardNumber'] = idCardNumber;
    data['firstName'] = firstName;
    data['lastName'] = lastName;
    data['gender'] = gender;
    data['bedNumber'] = bedNumber;
    data['dateOfBirth'] = dateOfBirth;
    data['height'] = height;
    data['weight'] = weight;
    data['photoUrl'] = photoUrl;
    data['phoneNumber'] = phoneNumber;
    data['address'] = address;
    data['postalCode'] = postalCode;
    data['medicalAllergies'] = medicalAllergies;
    data['disabled'] = disabled;
    // data['createdAt'] = this.createdAt;
    // data['updatedAt'] = this.updatedAt;
    // data['__v'] = this.iV;
    data['medicalNotes'] = medicalNotes;
    data['doctor'] = doctor;
    data['email'] = email;
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
    final Map<String, dynamic> data = <String, dynamic>{};
    data['BLOOD_PRESSURE'] = bLOODPRESSURE;
    data['HEARTBEAT_RATE'] = hEARTBEATRATE;
    data['BLOOD_OXYGEN_LEVEL'] = bLOODOXYGENLEVEL;
    data['RESPIRATORY_RATE'] = rESPIRATORYRATE;
    return data;
  }
}
