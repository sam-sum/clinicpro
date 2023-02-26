enum FilterOp { nop, equal, less, greater }

extension ParseToString on FilterOp {
  String toShortString() {
    return toString().split('.').last;
  }
}
