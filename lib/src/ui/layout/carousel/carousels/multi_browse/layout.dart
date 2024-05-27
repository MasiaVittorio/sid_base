part of "../../m3_carousel.dart";

class MultiBrowseLayouter extends M3CarouselLayouter {
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

    final (double tm, double ts, double tLok)? withTarget = tryLarge(targetLarge);

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
          (D - A - Z - sMax - b * (newN + 1) - (sMax * (1 - mLfrac))) / (newN + mLfrac);
      final (double tm, double ts, double tLok)? withNewTarget = tryLarge(newTarget);
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
  double get viewPortFraction => ((m * 0.8 + 0.2 * l)) / D;

  @override
  (int, int) visibleRange(double x) => (x.round() - 2, x.round() + n + 2 + 2);

  @override
  double get largeWidth => l;

  double get thinFrac => (b + t + b) / l;

  bool get newThinStrat => true;
  @override
  (Positioner, CarouselItemState)? position(
    int i,
    double x,
  ) {
    final int v = n + 2;
    final double thinFrac = (b + t + b) / l;
    return _steps(
      (min: v, positioner: _future),
      [
        if (newThinStrat)
          (
            max: v,
            min: v - 1,
            positioner: _futureToSmall,
          )
        else ...[
          (
            max: v,
            min: v - thinFrac,
            positioner: _futureToThin,
          ),
          (
            max: v - thinFrac,
            min: v - 1,
            positioner: _thinToSmall,
          ),
        ],
        (
          max: (v - 1),
          min: n,
          positioner: _smallToMedium,
        ),
        (
          max: n,
          min: n - 1,
          positioner: _mediumToLarge,
        ),
        (
          max: n - 1,
          min: 0,
          positioner: _largeToFirst,
        ),
        if (newThinStrat)
          (
            max: 0,
            min: -1,
            positioner: _firstToPast,
          )
        else ...[
          (
            max: 0,
            min: -1 + thinFrac,
            positioner: _firstToThin,
          ),
          (
            max: -1 + thinFrac,
            min: -1,
            positioner: _thinToPast,
          ),
        ],
      ],
      _past,
      i - x,
    );
  }

  (Positioner, CarouselItemState)? _future() {
    return _position(
      start: D,
      end: D + t,
      state: const ThinItem(0),
    );
  }

  (Positioner, CarouselItemState) _futureToSmall(double value) {
    final tF = thinFrac;
    final clippedStart = _smallToMediumEnd(value) + b;
    final lastThinStart = _smallToMediumEnd(tF) + b;
    final double start = value <= tF
        ? value.mapToRange(
            D,
            lastThinStart,
            fromMax: tF,
          )
        : clippedStart;
    final double end = value <= thinFrac
        ? start + t
        : value.mapToRange(
            lastThinStart + t,
            D - Z,
            fromMin: thinFrac,
          );
    return _position(
      start: start,
      end: end,
      state: ThinItem(value <= thinFrac ? 0 : value.mapToRange(0, 1, fromMin: thinFrac)),
    );
  }

  double get rightThinStart => D - b - t;
  (Positioner, CarouselItemState) _futureToThin(double value) {
    final start = value.mapToRange(D, rightThinStart);
    return _position(
      start: start,
      end: start + t,
      state: const ThinItem(0),
    );
  }

  double get smallStart => D - Z - s;
  (Positioner, CarouselItemState) _thinToSmall(double value) {
    return _position(
      start: value.mapToRange(
        rightThinStart,
        smallStart,
      ),
      end: value.mapToRange(
        rightThinStart + t,
        smallStart + s,
      ),
      state: ThinItem(value),
    );
  }

  double get mediumStart => D - Z - s - b - m;
  (Positioner, CarouselItemState) _smallToMedium(double value) {
    return _position(
      start: value.mapToRange(smallStart, mediumStart),
      end: _smallToMediumEnd(value),
      state: SmallItem(value),
    );
  }

  double _smallToMediumEnd(double value) => value.mapToRange(smallStart + s, mediumStart + m);

  double get firstTimeLargeStart => A + (lb * (n - 1));
  (Positioner, CarouselItemState) _mediumToLarge(double value) {
    return _position(
      start: value.mapToRange(mediumStart, firstTimeLargeStart),
      end: value.mapToRange(mediumStart + m, firstTimeLargeStart + l),
      state: MediumItem(value),
    );
  }

  (Positioner, CarouselItemState) _largeToFirst(double value) {
    return _position(
      start: value.mapToRange(firstTimeLargeStart, A),
      end: value.mapToRange(firstTimeLargeStart + l, A + l),
      state: LargeItem(0),
    );
  }

  (Positioner, CarouselItemState) _firstToPast(double value) {
    final double straightEnd = value.mapToRange(A + l, A - b);
    final double tF = thinFrac;
    final double lastStraightEnd = (1 - tF).mapToRange(A + l, A - b);
    final double end =
        value <= 1 - tF ? straightEnd : value.mapToRange(lastStraightEnd, 0, fromMin: 1 - tF);
    // final double start = value <= 1 - tF ? value.mapToRange(A, b, fromMax: 1 - tF) : end - t;
    final double start = end <= b + t ? end - t : value.mapToRange(A, b, fromMax: 1 - tF);
    return _position(
      start: start,
      end: end,
      state: LargeItem(
        value >= 1 - tF
            ? 1
            : value.mapToRange(
                0,
                1,
                fromMin: 0,
                fromMax: 1 - tF,
              ),
      ),
    );
  }

  (Positioner, CarouselItemState) _firstToThin(double value) {
    return _position(
      start: value.mapToRange(A, b),
      end: value.mapToRange(A + l, b + t),
      state: LargeItem(value),
    );
  }

  (Positioner, CarouselItemState) _thinToPast(double value) {
    return _position(
      start: value.mapToRange(b, -t),
      end: value.mapToRange(b + t, 0),
      state: const ThinItem(0),
    );
  }

  (Positioner, CarouselItemState)? _past() {
    return _position(
      start: -t,
      end: 0,
      state: const ThinItem(0),
    );
  }

  (Positioner, CarouselItemState)? _steps(
    ({
      num min,
      (Positioner, CarouselItemState)? Function() positioner,
    }) onFuture,
    List<
            ({
              num min,
              num max,
              (Positioner, CarouselItemState) Function(double value) positioner,
            })>
        steps,
    (Positioner, CarouselItemState)? Function() onPast,
    double future,
  ) {
    if (future >= onFuture.min) {
      return onFuture.positioner();
    }
    for (final step in steps) {
      if (future >= step.min && future < step.max) {
        return step.positioner(
          future.mapToRange(0, 1, fromMin: step.max, fromMax: step.min),
        );
      }
    }
    return onPast();
  }

  (Positioner, CarouselItemState) _position({
    required double start,
    required double end,
    required CarouselItemState state,
  }) {
    return (
      axis.fold(
        ifHorizontal: () => (Widget child) => Positioned(
              top: 0,
              bottom: 0,
              left: start,
              right: D - end,
              child: child,
            ),
        ifVertifcal: () => (Widget child) => Positioned(
              top: start,
              bottom: D - end,
              left: 0,
              right: 0,
              child: child,
            ),
      ),
      state
    );
  }
}

sealed class CarouselItemState {
  const CarouselItemState();
}

class ThinItem extends CarouselItemState {
  const ThinItem(this.thinToSmall);
  final double thinToSmall;
  @override
  String toString() => "Thin";
}

class SmallItem extends CarouselItemState {
  SmallItem(this.smallToMedium);
  final double smallToMedium;
  @override
  String toString() => "Small (to medium ${smallToMedium.toStringAsFixed(3)})";
}

class MediumItem extends CarouselItemState {
  final double mediumToLarge;
  MediumItem(this.mediumToLarge);
  @override
  String toString() => "Medium (to large ${mediumToLarge.toStringAsFixed(3)})";
}

class LargeItem extends CarouselItemState {
  final double largeToThin;
  LargeItem(this.largeToThin);

  @override
  String toString() => "Large (to thin ${largeToThin.toStringAsFixed(3)})";
}
