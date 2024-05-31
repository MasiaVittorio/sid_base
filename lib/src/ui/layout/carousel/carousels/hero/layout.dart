part of "../../m3_carousel.dart";

class HeroLayouter extends M3CarouselLayouter<HeroItemState> {
  HeroLayouter({
    required this.D,
    required this.A,
    required this.Z,
    required this.t,
    required this.b,
    required this.axis,
    required this.s,
  }) {
    l = D - A - Z - s - b;
  }

  final double D; // display size
  late final double l; // large hero item at the side
  final double A; // padding First
  final double Z; // padding Last
  final double b; // padding in between items
  final double t; // thin items
  final double s; // small items at the future side
  final Axis axis;

  @override
  double get viewPortFraction => (l * 0.8) / D;

  @override
  (int, int) visibleRange(double x) => (x.round() - 2, x.round() + 3);

  @override
  double get largeWidth => l;

  double get thinFrac => (b + t + b) / l;

  @override
  (Positioner, HeroItemState)? position(
    int i,
    double x,
  ) {
    return _steps(
      (min: 2, positioner: _future),
      [
        (
          max: 2,
          min: 1,
          positioner: _futureToSmall,
        ),
        (
          max: 1,
          min: 0,
          positioner: _smallToCenter,
        ),
        (
          max: 0,
          min: -1,
          positioner: _centerToPast,
        ),
      ],
      _past,
      i - x,
    );
  }

  (Positioner, HeroItemState)? _future() {
    return _position(
      start: D,
      end: D + t,
      state: const HeroThinItem(0),
    );
  }

  (Positioner, HeroItemState) _futureToSmall(double value) {
    final tF = thinFrac;
    final clippedStart = _smallToCenterEnd(value) + b;
    final lastThinStart = _smallToCenterEnd(tF) + b;
    final double start = value <= tF
        ? value.mapToRange(
            D,
            lastThinStart,
            fromMax: tF,
          )
        : clippedStart;
    final double end = value <= tF
        ? start + t
        : value.mapToRange(
            lastThinStart + t,
            D - Z,
            fromMin: tF,
          );
    return _position(
      start: start,
      end: end,
      state: HeroThinItem(
        value <= tF ? 0 : value.mapToRange(0, 1, fromMin: thinFrac),
      ),
    );
  }

  double get rightThinStart => D - b - t;

  double get futureSmallStart => D - Z - s;

  double get centerStart => A;
  double get centerEnd => D - Z - s - b;
  (Positioner, HeroItemState) _smallToCenter(double value) {
    return _position(
      start: _smallToCenterStart(value),
      end: _smallToCenterEnd(value),
      state: HeroSmallItem(value),
    );
  }

  double _smallToCenterStart(double value) => value.mapToRange(futureSmallStart, centerStart);

  double _smallToCenterEnd(double value) => value.mapToRange(D - Z, D - Z - s - b);

  (Positioner, HeroItemState) _centerToPast(double value) {
    return _position(
      start: value.mapToRange(A, -pastWidth),
      end: value.mapToRange(D - Z - s - b, 0),
      state: HeroCenterItem(value),
    );
  }

  double get pastWidth => l * 0.6;
  (Positioner, HeroItemState)? _past() {
    return _position(
      start: -pastWidth,
      end: 0,
      state: const HeroPastItem(),
    );
  }

  (Positioner, HeroItemState)? _steps(
    ({
      num min,
      (Positioner, HeroItemState)? Function() positioner,
    }) onFuture,
    List<
            ({
              num min,
              num max,
              (Positioner, HeroItemState) Function(double value) positioner,
            })>
        steps,
    (Positioner, HeroItemState)? Function() onPast,
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

  (Positioner, HeroItemState) _position({
    required double start,
    required double end,
    required HeroItemState state,
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
