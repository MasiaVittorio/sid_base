part of "../../m3_carousel.dart";

class CenteredHeroLayouter extends M3CarouselLayouter<CenteredHeroItemState> {
  CenteredHeroLayouter({
    required this.D,
    required this.A,
    required this.Z,
    required this.t,
    required this.b,
    required this.axis,
    required this.s,
  }) {
    l = D - A - Z - s - s - b - b;
  }

  final double D; // display size
  late final double l; // large item at the center
  final double A; // padding First
  final double Z; // padding Last
  final double b; // padding in between items
  final double t; // thin items
  late final double s; // small items at the sides
  final Axis axis;

  @override
  double get viewPortFraction => (l * 0.8) / D;

  @override
  (int, int) visibleRange(double x) => (x.round() - 2, x.round() + 3);

  @override
  double get largeWidth => l;

  double get thinFrac => (b + t + b) / l;

  @override
  (Positioner, CenteredHeroItemState)? position(int i, double x) {
    return _steps(
      (min: 2, positioner: _future),
      [
        (max: 2, min: 1, positioner: _futureToSmall),
        (max: 1, min: 0, positioner: _smallToCenter),
        (max: 0, min: -1, positioner: _centerToSmall),
        (max: -1, min: -2, positioner: _smallToPast),
      ],
      _past,
      i - x,
    );
  }

  (Positioner, CenteredHeroItemState)? _future() {
    return _position(
      start: D,
      end: D + t,
      state: const CenteredHeroFutureThinItem(0),
    );
  }

  (Positioner, CenteredHeroItemState) _futureToSmall(double value) {
    final tF = thinFrac;
    final clippedStart = _smallToCenterEnd(value) + b;
    final lastThinStart = _smallToCenterEnd(tF) + b;
    final double start =
        value <= tF
            ? value.rangeMap(to: (D, lastThinStart), from: (0, tF))
            : clippedStart;
    final double end =
        value <= tF
            ? start + t
            : value.rangeMap(to: (lastThinStart + t, D - Z), from: (tF, 1));
    return _position(
      start: start,
      end: end,
      state: CenteredHeroFutureThinItem(
        value <= tF ? 0 : value.rangeMap(to: (0, 1), from: (thinFrac, 1)),
      ),
    );
  }

  double get rightThinStart => D - b - t;

  double get futureSmallStart => D - Z - s;

  double get centerStart => A + s + b;
  double get centerEnd => D - Z - s - b;
  (Positioner, CenteredHeroItemState) _smallToCenter(double value) {
    return _position(
      start: _smallToCenterStart(value),
      end: _smallToCenterEnd(value),
      state: CenteredHeroFutureSmallItem(value),
    );
  }

  double _smallToCenterStart(double value) =>
      value.rangeMap(to: (futureSmallStart, centerStart));

  double _smallToCenterEnd(double value) =>
      value.rangeMap(to: (D - Z, D - Z - s - b));

  double get pastSmallStart => A;
  double get pastSmallEnd => A + s;
  (Positioner, CenteredHeroItemState) _centerToSmall(double value) {
    return _position(
      start: _centerToSmallStart(value),
      end: _centerToSmallEnd(value),
      state: CenteredHeroCenterItem(value),
    );
  }

  double _centerToSmallStart(double value) =>
      value.rangeMap(to: (centerStart, pastSmallStart));

  double _centerToSmallEnd(double value) =>
      value.rangeMap(to: (centerEnd, pastSmallEnd));

  (Positioner, CenteredHeroItemState) _smallToPast(double value) {
    final tF = thinFrac;
    final clippedEnd = _centerToSmallStart(value) - b;
    final lastThinEnd = _centerToSmallStart(1 - tF) - b;
    final double end =
        value <= 1 - tF
            ? clippedEnd
            : value.rangeMap(to: (lastThinEnd, 0), from: (1 - tF, 1));
    final double start =
        value >= 1 - tF
            ? end - t
            : value.rangeMap(to: (A, lastThinEnd - t), from: (0, 1 - tF));
    return _position(
      start: start,
      end: end,
      state:
          value <= 1 - tF
              ? CenteredHeroPastSmallItem(value.rangeMap(from: (0, 1 - tF)))
              : const CenteredHeroPastThinItem(),
    );
  }

  (Positioner, CenteredHeroItemState)? _past() {
    return _position(
      start: -t,
      end: 0,
      state: const CenteredHeroPastThinItem(),
    );
  }

  (Positioner, CenteredHeroItemState)? _steps(
    ({num min, (Positioner, CenteredHeroItemState)? Function() positioner})
    onFuture,
    List<
      ({
        num min,
        num max,
        (Positioner, CenteredHeroItemState) Function(double value) positioner,
      })
    >
    steps,
    (Positioner, CenteredHeroItemState)? Function() onPast,
    double future,
  ) {
    if (future >= onFuture.min) {
      return onFuture.positioner();
    }
    for (final step in steps) {
      if (future >= step.min && future < step.max) {
        return step.positioner(
          future.rangeMap(to: (0, 1), from: (step.max, step.min)),
        );
      }
    }
    return onPast();
  }

  (Positioner, CenteredHeroItemState) _position({
    required double start,
    required double end,
    required CenteredHeroItemState state,
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
