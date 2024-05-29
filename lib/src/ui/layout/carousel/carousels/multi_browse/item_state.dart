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
        smallToMedium: (v) => v.mapToRangeFrom((0, 0.5), (0.7, 1.0)),
        medium: () => 0.5,
        mediumToLarge: (v) => v.mapToRange(0.5, 1.0),
        large: () => 1.0,
        largeToThin: (v) => v.mapToRangeFrom((1, 0), (0.1, 0.7)),
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
  }) =>
      switch (this) {
        MultiBrowseFutureThinItem(thinToSmall: 0) => futureThin(),
        MultiBrowseFutureThinItem(thinToSmall: 1) => small(),
        MultiBrowseFutureThinItem(thinToSmall: double v) => futureThinToSmall(v),
        MultiBrowseSmallItem(smallToMedium: 0) => small(),
        MultiBrowseSmallItem(smallToMedium: 1) => medium(),
        MultiBrowseSmallItem(smallToMedium: double v) => smallToMedium(v),
        MultiBrowseMediumItem(mediumToLarge: 0) => medium(),
        MultiBrowseMediumItem(mediumToLarge: 1) => large(),
        MultiBrowseMediumItem(mediumToLarge: double v) => mediumToLarge(v),
        MultiBrowseLargeItem(largeToThin: 0) => large(),
        MultiBrowseLargeItem(largeToThin: 1) => pastThin(),
        MultiBrowseLargeItem(largeToThin: double v) => largeToThin(v),
        MultiBrowsePastThinItem() => pastThin(),
      };

  bool before(MultiBrowseItemState other) {
    return ((!after(other)) && (!equal(other)));
  }

  bool after(MultiBrowseItemState other) {
    return switch (this) {
      MultiBrowseFutureThinItem(thinToSmall: double v) => switch (other) {
          MultiBrowseFutureThinItem(thinToSmall: double ov) => v > ov,
          _ => false,
        },
      MultiBrowseSmallItem(smallToMedium: double v) => switch (other) {
          MultiBrowseFutureThinItem(thinToSmall: double ov) => ov == 1 && v == 0 ? false : true,
          MultiBrowseSmallItem(smallToMedium: double ov) => v > ov,
          _ => false,
        },
      MultiBrowseMediumItem(mediumToLarge: double v) => switch (other) {
          MultiBrowseFutureThinItem() => true,
          MultiBrowseSmallItem(smallToMedium: double ov) => ov == 1 && v == 0 ? false : true,
          MultiBrowseMediumItem(mediumToLarge: double ov) => v > ov,
          _ => false,
        },
      MultiBrowseLargeItem(largeToThin: double v) => switch (other) {
          MultiBrowseFutureThinItem() => true,
          MultiBrowseSmallItem() => true,
          MultiBrowseMediumItem(mediumToLarge: double ov) => ov == 1 && v == 0 ? false : true,
          MultiBrowseLargeItem(largeToThin: double ov) => v > ov,
          _ => true,
        },
      MultiBrowsePastThinItem() => switch (other) {
          MultiBrowseLargeItem(largeToThin: 1) => false,
          MultiBrowsePastThinItem() => false,
          _ => true,
        },
    };
  }

  bool equal(MultiBrowseItemState other) {
    return switch (this) {
      MultiBrowseFutureThinItem(thinToSmall: double v) => switch (other) {
          MultiBrowseFutureThinItem(thinToSmall: double ov) => v == ov,
          MultiBrowseSmallItem(smallToMedium: 0) => v == 1,
          _ => false,
        },
      MultiBrowseSmallItem(smallToMedium: double v) => switch (other) {
          MultiBrowseFutureThinItem(thinToSmall: 1) => v == 0,
          MultiBrowseSmallItem(smallToMedium: double ov) => ov == v,
          MultiBrowseMediumItem(mediumToLarge: 0) => v == 1,
          _ => false,
        },
      MultiBrowseMediumItem(mediumToLarge: double v) => switch (other) {
          MultiBrowseSmallItem(smallToMedium: 1) => v == 0,
          MultiBrowseMediumItem(mediumToLarge: double ov) => ov == v,
          // MultiBrowseLargeItem(largeToThin: 0) => v == 1, nope, more than one large
          _ => false,
        },
      MultiBrowseLargeItem(largeToThin: double v) => switch (other) {
          // MultiBrowseMediumItem(mediumToLarge: 1) => v == 0, // nope, more than one large
          MultiBrowseLargeItem(largeToThin: double ov) => ov == v,
          _ => false,
        },
      MultiBrowsePastThinItem() => switch (other) {
          MultiBrowseLargeItem(largeToThin: 1) => true,
          MultiBrowsePastThinItem() => true,
          _ => false,
        },
    };
  }
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
