class VitalSign {
  //String? sId;
  String? id;
  String? patientId;
  String? nurseName;
  String? modifyDate;
  String? category;
  String? readings;
  bool? isValid;
  String? createdAt;
  String? updatedAt;
  //int? iV;

  VitalSign({
    //this.sId,
    this.id,
    this.patientId,
    this.nurseName,
    this.modifyDate,
    this.category,
    this.readings,
    this.isValid,
    this.createdAt,
    this.updatedAt,
    //this.iV,
  });

  VitalSign.fromJson(Map<String, dynamic> json) {
    //sId = json['_id'];
    id = json['id'];
    patientId = json['patientId'];
    nurseName = json['nurseName'];
    modifyDate = json['modifyDate'];
    category = json['category'];
    readings = json['readings'];
    isValid = json['isValid'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    //iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};

    //data['_id'] = sId;
    data['id'] = id;
    data['patientId'] = patientId;
    data['nurseName'] = nurseName;
    data['modifyDate'] = modifyDate;
    data['category'] = category;
    data['readings'] = readings;
    data['isValid'] = isValid;

    return data;
  }
}
