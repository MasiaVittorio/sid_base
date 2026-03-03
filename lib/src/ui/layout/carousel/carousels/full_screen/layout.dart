part of "../../m3_carousel.dart";

class FullScreenLayouter extends M3CarouselLayouter<FullScreenItemState> {
  FullScreenLayouter({required this.D, required this.b, required this.axis});

  final double D; // display size
  final double b; // padding in between items
  final Axis axis;

  @override
  double get viewPortFraction => 0.9;

  @override
  (int, int) visibleRange(double x) => (x.round() - 1, x.round() + 2);

  @override
  double get largeWidth => D;

  @override
  (Positioner, FullScreenItemState)? position(int i, double x) {
    return _steps(
      (min: 1, positioner: _future),
      [
        (max: 1, min: 0, positioner: _futureToCenter),
        (max: 0, min: -1, positioner: _centerToPast),
      ],
      _past,
      i - x,
    );
  }

  double get extSize => D * 0.8;
  double get futureEnd => D + b + extSize;
  (Positioner, FullScreenItemState)? _future() {
    return _position(
      start: D + b,
      end: futureEnd,
      state: const FullScreenFutureItem(0),
    );
  }

  (Positioner, FullScreenItemState) _futureToCenter(double value) {
    return _position(
      start: value.rangeMap(to: (D + b, 0)),
      end: value.rangeMap(to: (futureEnd, D)),
      state: FullScreenFutureItem(value),
    );
  }

  (Positioner, FullScreenItemState) _centerToPast(double value) {
    return _position(
      start: value.rangeMap(to: (0, -b - extSize)),
      end: value.rangeMap(to: (D, -b)),
      state: FullScreenCenterItem(value),
    );
  }

  (Positioner, FullScreenItemState)? _past() {
    return _position(
      start: -b - extSize,
      end: -b,
      state: const FullScreenPastItem(),
    );
  }

  (Positioner, FullScreenItemState)? _steps(
    ({num min, (Positioner, FullScreenItemState)? Function() positioner})
    onFuture,
    List<
      ({
        num min,
        num max,
        (Positioner, FullScreenItemState) Function(double value) positioner,
      })
    >
    steps,
    (Positioner, FullScreenItemState)? Function() onPast,
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

  (Positioner, FullScreenItemState) _position({
    required double start,
    required double end,
    required FullScreenItemState state,
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
