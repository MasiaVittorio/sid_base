extension DoubleSidMapToRange on num {
  double rangeMap({
    (double toMin, double toMax) to = (0, 1),
    (double fromMin, double fromMax) from = (0, 1),
  }) =>
      to.$1 +
      ((this - from.$1) / (from.$2 - from.$1)).clamp(0.0, 1.0) *
          (to.$2 - to.$1);
  double rangeMapLoose({
    (double toMin, double toMax) to = (0, 1),
    (double fromMin, double fromMax) from = (0, 1),
  }) =>
      to.$1 + ((this - from.$1) / (from.$2 - from.$1)) * (to.$2 - to.$1);
  double mapToRangeFrom(
    (double toMin, double toMax) to, [
    (double fromMin, double fromMax) from = (0, 1),
  ]) =>
      to.$1 +
      ((this - from.$1) / (from.$2 - from.$1)).clamp(0.0, 1.0) *
          (to.$2 - to.$1);
  double mapFromRangeTo(
    (double fromMin, double fromMax) from, [
    (double toMin, double toMax) to = (0, 1),
  ]) =>
      to.$1 +
      ((this - from.$1) / (from.$2 - from.$1)).clamp(0.0, 1.0) *
          (to.$2 - to.$1);
  double mapToRange(
    double toMin,
    double toMax, {
    num fromMin = 0.0,
    num fromMax = 1.0,
  }) =>
      toMin +
      ((this - fromMin) / (fromMax - fromMin)).clamp(0.0, 1.0) *
          (toMax - toMin);
  double mapFromRange(
    double fromMin,
    double fromMax, {
    num toMin = 0.0,
    num toMax = 1.0,
  }) =>
      toMin +
      ((this - fromMin) / (fromMax - fromMin)).clamp(0.0, 1.0) *
          (toMax - toMin);

  //Much much faster, but you can get numbers out of the range of [toMin,toMax];
  double mapToRangeLoose(
    double toMin,
    double toMax, {
    num fromMin = 0.0,
    num fromMax = 1.0,
  }) =>
      toMin + ((this - fromMin) / (fromMax - fromMin)) * (toMax - toMin);

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
