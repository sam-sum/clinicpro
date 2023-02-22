class VitalSignLatest {
  String? bloodPressure;
  String? heartBeatRate;
  String? bloodOxygenLevel;
  String? respiratoryRate;

  VitalSignLatest({
    this.bloodPressure,
    this.heartBeatRate,
    this.bloodOxygenLevel,
    this.respiratoryRate,
  });

  void setBloodPressure(String? bloodPressureReading) {
    bloodPressure = bloodPressureReading;
  }

  void setHeartBeatRate(String? heartBeatRateReading) {
    heartBeatRate = heartBeatRateReading;
  }

  void setBloodOxygenLevel(String? bloodOxygenLevelReading) {
    bloodOxygenLevel = bloodOxygenLevelReading;
  }

  void setRespiratoryRate(String? respiratoryRateReading) {
    respiratoryRate = respiratoryRateReading;
  }
}
