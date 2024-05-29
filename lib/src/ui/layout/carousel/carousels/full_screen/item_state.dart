part of "../../m3_carousel.dart";

sealed class FullScreenItemState extends CarouselItemState {
  const FullScreenItemState();

  @override
  bool get canBeOpened => switch (this) {
        FullScreenFutureItem(futureToCenter: double v) => v >= 0.95,
        FullScreenCenterItem(centerToPast: double v) => v <= 0.05,
        FullScreenPastItem() => false,
      };

  @override
  double get contentOpacity => fold(
        future: () => 0.0,
        futureToCenter: (v) => v.mapFromRangeTo((0.45, 0.85), (0, 1)),
        center: () => 1.0,
        centerToPast: (v) => v.mapFromRangeTo((0.15, 0.55), (1, 0)),
        past: () => 0.0,
      );

  T fold<T>({
    required T Function() future,
    required T Function(double v) futureToCenter,
    required T Function() center,
    required T Function(double v) centerToPast,
    required T Function() past,
  }) =>
      switch (this) {
        FullScreenFutureItem(futureToCenter: 0) => future(),
        FullScreenFutureItem(futureToCenter: 1) => center(),
        FullScreenFutureItem(futureToCenter: double v) => futureToCenter(v),
        FullScreenCenterItem(centerToPast: 1) => past(),
        FullScreenCenterItem(centerToPast: 0) => center(),
        FullScreenCenterItem(centerToPast: double v) => centerToPast(v),
        FullScreenPastItem() => past(),
      };

  bool before(FullScreenItemState other) {
    return ((!after(other)) && (!equal(other)));
  }

  bool after(FullScreenItemState other) {
    return switch (this) {
      FullScreenFutureItem(futureToCenter: double v) => switch (other) {
          FullScreenFutureItem(futureToCenter: double ov) => v > ov,
          _ => false,
        },
      FullScreenCenterItem(centerToPast: double v) => switch (other) {
          FullScreenFutureItem(futureToCenter: double ov) => ov == 1 && v == 0 ? false : true,
          FullScreenCenterItem(centerToPast: double ov) => v > ov,
          _ => false,
        },
      FullScreenPastItem() => switch (other) {
          FullScreenPastItem() => false,
          _ => true,
        },
    };
  }

  bool equal(FullScreenItemState other) {
    return switch (this) {
      FullScreenFutureItem(futureToCenter: double v) => switch (other) {
          FullScreenFutureItem(futureToCenter: double ov) => v == ov,
          _ => false,
        },
      FullScreenCenterItem(centerToPast: double v) => switch (other) {
          FullScreenFutureItem(futureToCenter: double ov) => ov == 1 && v == 0,
          FullScreenCenterItem(centerToPast: double ov) => ov == v,
          FullScreenPastItem() => v == 1,
        },
      FullScreenPastItem() => switch (other) {
          FullScreenCenterItem(centerToPast: double ov) => ov == 1,
          FullScreenPastItem() => true,
          _ => false,
        },
    };
  }
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
