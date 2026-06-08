part of "../../m3_carousel.dart";

sealed class FullScreenItemState extends CarouselItemState {
  const FullScreenItemState();

  @override
  bool get canBeOpened => false;

  @override
  double get contentOpacity => fold(
    future: () => 0.0,
    futureToCenter: (v) => v.rangeMap(from: (0.45, 0.85)),
    center: () => 1.0,
    centerToPast: (v) => v.rangeMap(from: (0.15, 0.55), to: (1, 0)),
    past: () => 0.0,
  );

  T fold<T>({
    required T Function() future,
    required T Function(double v) futureToCenter,
    required T Function() center,
    required T Function(double v) centerToPast,
    required T Function() past,
  }) => switch (this) {
    FullScreenFutureItem(futureToCenter: 0) => future(),
    FullScreenFutureItem(futureToCenter: 1) => center(),
    FullScreenCenterItem(centerToPast: 0) => center(),
    FullScreenCenterItem(centerToPast: 1) => past(),
    FullScreenPastItem() => past(),
    FullScreenFutureItem(futureToCenter: double v) => futureToCenter(v),
    FullScreenCenterItem(centerToPast: double v) => centerToPast(v),
  };

  double get _v => switch (this) {
    FullScreenFutureItem(futureToCenter: double v) => v,
    FullScreenCenterItem(centerToPast: double v) => 1 + v,
    FullScreenPastItem() => 2,
  };

  bool before(FullScreenItemState other) => _v < other._v;

  bool after(FullScreenItemState other) => _v > other._v;

  bool equal(FullScreenItemState other) => _v == other._v;
}

class FullScreenFutureItem extends FullScreenItemState {
  const FullScreenFutureItem(this.futureToCenter);
  final double futureToCenter;
  @override
  String toString() => "future";
}

class FullScreenCenterItem extends FullScreenItemState {
  final double centerToPast;
  const FullScreenCenterItem(this.centerToPast);
  @override
  String toString() => "center ${centerToPast.toStringAsFixed(2)}";
}

class FullScreenPastItem extends FullScreenItemState {
  const FullScreenPastItem();
  @override
  String toString() => "past";
}
