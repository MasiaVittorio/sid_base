part of "../../m3_carousel.dart";

class MultiBrowseLayouter extends M3CarouselLayouter<MultiBrowseItemState> {
  MultiBrowseLayouter({
    required this.D,
    required double targetLarge,
    required this.A,
    required this.Z,
    required this.t,
    required this.b,
    required this.axis,
    required final double sMin,
    required final double sMax,
  }) {
    (double nm, double ns, double nL)? tryLarge(double tL) {
      final double tLb = tL + b;
      final double mMaxS = (D - A - Z - sMax - tLb).mod(tLb) - b;
      if (mMaxS > sMax) {
        return (mMaxS, sMax, tL);
      } else {
        final double mMinS = (D - A - Z - sMin - tLb).mod(tLb) - b;
        // assert(m > s);
        if (mMinS > sMin) {
          return (mMinS, sMin, tL);
        }
      }
      return null;
    }

    final (double tm, double ts, double tLok)? withTarget = tryLarge(
      targetLarge,
    );

    if (withTarget != null) {
      m = withTarget.$1;
      s = withTarget.$2;
      l = withTarget.$3;
      lb = l + b;
      mb = m + b;
      n = ((D - A - Z - s) / lb).floor();
    } else {
      const mLfrac = 2 / 10;
      final int newN = ((D - A - Z - sMax) / (targetLarge + b)).floor();
      final newTarget =
          (D - A - Z - sMax - b * (newN + 1) - (sMax * (1 - mLfrac))) /
          (newN + mLfrac);
      final (double tm, double ts, double tLok)? withNewTarget = tryLarge(
        newTarget,
      );
      if (withNewTarget != null) {
        m = withNewTarget.$1;
        s = withNewTarget.$2;
        l = withNewTarget.$3;
        lb = l + b;
        mb = m + b;
        n = ((D - A - Z - s) / lb).floor();
      } else {
        final (double tm, double ts, double tLok) withAutoTarget =
            tryLarge(D - A - Z - sMax - sMax * 1.5 - 2 * b)!;
        m = withAutoTarget.$1;
        s = withAutoTarget.$2;
        l = withAutoTarget.$3;
        lb = l + b;
        mb = m + b;
        n = ((D - A - Z - s) / lb).floor();
      }
    }
  }

  final double D; // display size
  late final double l; // large items
  final double A; // padding First
  final double Z; // padding Last
  final double b; // padding in between items
  final double t; // thin items
  late final double s; // small items
  late final double m; // medium items
  late final int n; // number of larges
  // ignore: non_constant_identifier_names
  late final double lb; // large + in between
  late final double mb; // medium + in between
  final Axis axis;

  @override
  int get pagesInFocus => n;

  @override
  double get viewPortFraction => ((m * 0.8 + 0.2 * l)) / D;

  @override
  (int, int) visibleRange(double x) => (x.round() - 2, x.round() + n + 2 + 2);

  @override
  double get largeWidth => l;

  double get thinFrac => (b + t + b) / l;
  double get pastThinFrac =>
      (b + t + b - A) /
      (D * viewPortFraction); // (b + t + b - A) / (D * viewportFrac) = tF / 1

  bool get newThinStrat => true;
  @override
  (Positioner, MultiBrowseItemState)? position(int i, double x) {
    final int v = n + 2;
    final double tF = thinFrac;
    final double ptF = pastThinFrac;
    return _steps(
      (min: v, positioner: _future),
      [
        if (newThinStrat)
          (max: v, min: v - 1, positioner: _futureToSmall)
        else ...[
          (max: v, min: v - tF, positioner: _futureToThin),
          (max: v - tF, min: v - 1, positioner: _thinToSmall),
        ],
        (max: (v - 1), min: n, positioner: _smallToMedium),
        (max: n, min: n - 1, positioner: _mediumToLarge),
        (max: n - 1, min: 0, positioner: _largeToFirst),
        if (newThinStrat)
          (max: 0, min: -1, positioner: _firstToPast)
        else ...[
          (max: 0, min: -1 + ptF, positioner: _firstToThin),
          (max: -1 + ptF, min: -1, positioner: _thinToPast),
        ],
      ],
      _past,
      i - x,
    );
  }

  (Positioner, MultiBrowseItemState)? _future() {
    return _position(
      start: D,
      end: D + t,
      state: const MultiBrowseFutureThinItem(0),
    );
  }

  (Positioner, MultiBrowseItemState) _futureToSmall(double value) {
    final tF = thinFrac;
    final clippedStart = _smallToMediumEnd(value) + b;
    final lastThinStart = _smallToMediumEnd(tF) + b;
    final double start =
        value <= tF
            ? value.rangeMap(to: (D, lastThinStart), from: (0, tF))
            : clippedStart;
    final double end =
        value <= thinFrac
            ? start + t
            : value.rangeMap(
              to: (lastThinStart + t, D - Z),
              from: (thinFrac, 1),
            );
    return _position(
      start: start,
      end: end,
      state: MultiBrowseFutureThinItem(
        value <= thinFrac ? 0 : value.rangeMap(from: (thinFrac, 1)),
      ),
    );
  }

  double get rightThinStart => D - b - t;
  (Positioner, MultiBrowseItemState) _futureToThin(double value) {
    final start = value.rangeMap(to: (D, rightThinStart));
    return _position(
      start: start,
      end: start + t,
      state: const MultiBrowseFutureThinItem(0),
    );
  }

  double get smallStart => D - Z - s;
  (Positioner, MultiBrowseItemState) _thinToSmall(double value) {
    return _position(
      start: value.rangeMap(to: (rightThinStart, smallStart)),
      end: value.rangeMap(to: (rightThinStart + t, smallStart + s)),
      state: MultiBrowseFutureThinItem(value),
    );
  }

  double get mediumStart => D - Z - s - b - m;
  (Positioner, MultiBrowseItemState) _smallToMedium(double value) {
    return _position(
      start: value.rangeMap(to: (smallStart, mediumStart)),
      end: _smallToMediumEnd(value),
      state: MultiBrowseSmallItem(value),
    );
  }

  double _smallToMediumEnd(double value) =>
      value.rangeMap(to: (smallStart + s, mediumStart + m));

  double get firstTimeLargeStart => A + (lb * (n - 1));
  (Positioner, MultiBrowseItemState) _mediumToLarge(double value) {
    return _position(
      start: value.rangeMap(to: (mediumStart, firstTimeLargeStart)),
      end: value.rangeMap(to: (mediumStart + m, firstTimeLargeStart + l)),
      state: MultiBrowseMediumItem(value),
    );
  }

  (Positioner, MultiBrowseItemState) _largeToFirst(double value) {
    return _position(
      start: value.rangeMap(to: (firstTimeLargeStart, A)),
      end: value.rangeMap(to: (firstTimeLargeStart + l, A + l)),
      state: const MultiBrowseLargeItem(0),
    );
  }

  (Positioner, MultiBrowseItemState) _firstToPast(double value) {
    final double straightEnd = value.rangeMap(to: (A + l, A - b));
    // final double tF = thinFrac;
    final double tF = pastThinFrac;
    final double lastStraightEnd = (1 - tF).rangeMap(to: (A + l, A - b));
    final double end =
        value <= 1 - tF
            ? straightEnd
            : value.rangeMap(to: (lastStraightEnd, 0), from: (1 - tF, 1));
    // final double start = value <= 1 - tF ? value.mapToRange(A, b, fromMax: 1 - tF) : end - t;
    final double start =
        end <= b + t ? end - t : value.rangeMap(to: (A, b), from: (0, 1 - tF));
    return _position(
      start: start,
      end: end,
      state: MultiBrowseLargeItem(
        value >= 1 - tF ? 1 : value.rangeMap(from: (0, 1 - tF)),
      ),
    );
  }

  (Positioner, MultiBrowseItemState) _firstToThin(double value) {
    return _position(
      start: value.rangeMap(to: (A, b)),
      end: value.rangeMap(to: (A + l, b + t)),
      state: MultiBrowseLargeItem(value),
    );
  }

  (Positioner, MultiBrowseItemState) _thinToPast(double value) {
    return _position(
      start: value.rangeMap(to: (b, -t)),
      end: value.rangeMap(to: (b + t, 0)),
      state: const MultiBrowsePastThinItem(),
    );
  }

  (Positioner, MultiBrowseItemState)? _past() {
    return _position(start: -t, end: 0, state: const MultiBrowsePastThinItem());
  }

  (Positioner, MultiBrowseItemState)? _steps(
    ({num min, (Positioner, MultiBrowseItemState)? Function() positioner})
    onFuture,
    List<
      ({
        num min,
        num max,
        (Positioner, MultiBrowseItemState) Function(double value) positioner,
      })
    >
    steps,
    (Positioner, MultiBrowseItemState)? Function() onPast,
    double future,
  ) {
    if (future >= onFuture.min) {
      return onFuture.positioner();
    }
    for (final step in steps) {
      if (future >= step.min && future < step.max) {
        return step.positioner(future.rangeMap(from: (step.max, step.min)));
      }
    }
    return onPast();
  }

  (Positioner, MultiBrowseItemState) _position({
    required double start,
    required double end,
    required MultiBrowseItemState state,
  }) {
    return (
      axis.fold(
        ifHorizontal:
            () =>
                (Widget child) => Positioned(
                  top: 0,
                  bottom: 0,
                  left: start,
                  right: D - end,
                  child: child,
                ),
        ifVertifcal:
            () =>
                (Widget child) => Positioned(
                  top: start,
                  bottom: D - end,
                  left: 0,
                  right: 0,
                  child: child,
                ),
      ),
      state,
    );
  }
}
