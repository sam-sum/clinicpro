enum FilterGender { male, female, both }

extension ParseToString on FilterGender {
  String toShortString() {
    return toString().split('.').last;
  }
}
