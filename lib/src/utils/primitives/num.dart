extension DoubleSidMapToRange on num {
  double rangeMap({
    (num toMin, num toMax) to = (0, 1),
    (num fromMin, num fromMax) from = (0, 1),
  }) =>
      to.$1 +
      ((this - from.$1) / (from.$2 - from.$1)).clamp(0.0, 1.0) *
          (to.$2 - to.$1);
  double rangeMapLoose({
    (num toMin, num toMax) to = (0, 1),
    (num fromMin, num fromMax) from = (0, 1),
  }) => to.$1 + ((this - from.$1) / (from.$2 - from.$1)) * (to.$2 - to.$1);

  double mod(double n) {
    double v = this + 0;
    while (v > n) {
      v -= n;
    }
    return v;
  }
}

extension ModN on int {
  int modLessThan(int n) {
    int v = this + 0;
    while (v >= n) {
      v -= n;
    }
    return v;
  }
}
