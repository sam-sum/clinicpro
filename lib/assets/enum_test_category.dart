enum TestCategory {
  // ignore: constant_identifier_names
  BLOOD_PRESSURE,
  // ignore: constant_identifier_names
  HEARTBEAT_RATE,
  // ignore: constant_identifier_names
  RESPIRATORY_RATE,
  // ignore: constant_identifier_names
  BLOOD_OXYGEN_LEVEL
}

extension ParseToString on TestCategory {
  String toShortString() {
    return toString().split('.').last;
  }
}
