part of "../../m3_carousel.dart";

sealed class MultiBrowseItemState extends CarouselItemState {
  const MultiBrowseItemState();

  @override
  bool get canBeOpened => switch (this) {
    MultiBrowseMediumItem(mediumToLarge: double v) => v >= 0.95,
    MultiBrowseLargeItem(largeToThin: double v) => v < 0.05,
    _ => false,
  };

  @override
  double get contentOpacity => fold(
    futureThin: () => 0.0,
    futureThinToSmall: (v) => 0.0,
    small: () => 0.0,
    smallToMedium: (v) => v.rangeMap(to: (0, 0.5), from: (0.7, 1.0)),
    medium: () => 0.5,
    mediumToLarge: (v) => v.rangeMap(to: (0.5, 1.0)),
    large: () => 1.0,
    largeToThin: (v) => v.rangeMap(to: (1, 0), from: (0.1, 0.7)),
    pastThin: () => 0.0,
  );

  T fold<T>({
    required T Function() futureThin,
    required T Function(double v) futureThinToSmall,
    required T Function() small,
    required T Function(double v) smallToMedium,
    required T Function() medium,
    required T Function(double v) mediumToLarge,
    required T Function() large,
    required T Function(double v) largeToThin,
    required T Function() pastThin,
  }) => switch (this) {
    MultiBrowseFutureThinItem(thinToSmall: 0) => futureThin(),
    MultiBrowseFutureThinItem(thinToSmall: 1) => small(),
    MultiBrowseSmallItem(smallToMedium: 0) => small(),
    MultiBrowseSmallItem(smallToMedium: 1) => medium(),
    MultiBrowseMediumItem(mediumToLarge: 0) => medium(),
    MultiBrowseMediumItem(mediumToLarge: 1) => large(),
    MultiBrowseLargeItem(largeToThin: 0) => large(),
    MultiBrowseLargeItem(largeToThin: 1) => pastThin(),
    MultiBrowsePastThinItem() => pastThin(),
    MultiBrowseFutureThinItem(thinToSmall: double v) => futureThinToSmall(v),
    MultiBrowseSmallItem(smallToMedium: double v) => smallToMedium(v),
    MultiBrowseMediumItem(mediumToLarge: double v) => mediumToLarge(v),
    MultiBrowseLargeItem(largeToThin: double v) => largeToThin(v),
  };

  double get _v {
    return switch (this) {
      MultiBrowseFutureThinItem(thinToSmall: double v) => 0 + v,
      MultiBrowseSmallItem(smallToMedium: double v) => 1 + v,
      MultiBrowseMediumItem(mediumToLarge: double v) => 2 + v,
      MultiBrowseLargeItem(largeToThin: double v) => 3 + v,
      MultiBrowsePastThinItem() => 4,
    };
  }

  bool before(MultiBrowseItemState other) => _v < other._v;

  bool after(MultiBrowseItemState other) => _v > other._v;

  bool equal(MultiBrowseItemState other) => _v == other._v;
}

class MultiBrowseFutureThinItem extends MultiBrowseItemState {
  const MultiBrowseFutureThinItem(this.thinToSmall);
  final double thinToSmall;
  @override
  String toString() => "Future Thin";
}

class MultiBrowseSmallItem extends MultiBrowseItemState {
  MultiBrowseSmallItem(this.smallToMedium);
  final double smallToMedium;
  @override
  String toString() => "Small (to medium ${smallToMedium.toStringAsFixed(3)})";
}

class MultiBrowseMediumItem extends MultiBrowseItemState {
  final double mediumToLarge;
  const MultiBrowseMediumItem(this.mediumToLarge);
  @override
  String toString() => "Medium (to large ${mediumToLarge.toStringAsFixed(3)})";
}

class MultiBrowseLargeItem extends MultiBrowseItemState {
  final double largeToThin;
  const MultiBrowseLargeItem(this.largeToThin);

  @override
  String toString() => "Large (to thin ${largeToThin.toStringAsFixed(3)})";
}

class MultiBrowsePastThinItem extends MultiBrowseItemState {
  const MultiBrowsePastThinItem();
  @override
  String toString() => "Past Thin";
}
