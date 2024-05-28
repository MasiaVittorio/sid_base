part of "../../m3_carousel.dart";

sealed class CenteredHeroItemState extends CarouselItemState {
  const CenteredHeroItemState();

  T fold<T>({
    required T Function() futureThin,
    required T Function(double v) futureThinToSmall,
    required T Function() futureSmall,
    required T Function(double v) futureSmallToHero,
    required T Function() hero,
    required T Function(double v) heroToSmall,
    required T Function() pastSmall,
    required T Function(double v) pastSmallToThin,
    required T Function() pastThin,
  }) =>
      switch (this) {
        CenteredHeroFutureThinItem(thinToSmall: 0) => futureThin(),
        CenteredHeroFutureThinItem(thinToSmall: 1) => futureSmall(),
        CenteredHeroFutureThinItem(thinToSmall: double v) => futureThinToSmall(v),
        CenteredHeroFutureSmallItem(smallToHero: 1) => hero(),
        CenteredHeroFutureSmallItem(smallToHero: 0) => futureSmall(),
        CenteredHeroFutureSmallItem(smallToHero: double v) => futureSmallToHero(v),
        CenteredHeroCenterItem(heroToSmall: 1) => pastSmall(),
        CenteredHeroCenterItem(heroToSmall: 0) => hero(),
        CenteredHeroCenterItem(heroToSmall: double v) => heroToSmall(v),
        CenteredHeroPastSmallItem(smallToThin: 1) => pastThin(),
        CenteredHeroPastSmallItem(smallToThin: 0) => pastSmall(),
        CenteredHeroPastSmallItem(smallToThin: double v) => pastSmallToThin(v),
        CenteredHeroPastThinItem() => pastThin(),
      };

  bool before(CenteredHeroItemState other) {
    return ((!after(other)) && (!equal(other)));
  }

  bool after(CenteredHeroItemState other) {
    return switch (this) {
      CenteredHeroFutureThinItem(thinToSmall: double v) => switch (other) {
          CenteredHeroFutureThinItem(thinToSmall: double ov) => v > ov,
          _ => false,
        },
      CenteredHeroFutureSmallItem(smallToHero: double v) => switch (other) {
          CenteredHeroFutureThinItem() => true,
          CenteredHeroFutureSmallItem(smallToHero: double ov) => v > ov,
          _ => false,
        },
      CenteredHeroCenterItem(heroToSmall: double v) => switch (other) {
          CenteredHeroFutureThinItem() || CenteredHeroFutureSmallItem() => true,
          CenteredHeroCenterItem(heroToSmall: double ov) => v > ov,
          _ => false,
        },
      CenteredHeroPastSmallItem(smallToThin: double v) => switch (other) {
          CenteredHeroFutureThinItem() ||
          CenteredHeroFutureSmallItem() ||
          CenteredHeroCenterItem() =>
            true,
          CenteredHeroPastSmallItem(smallToThin: double ov) => v > ov,
          _ => false,
        },
      CenteredHeroPastThinItem() => switch (other) {
          CenteredHeroPastThinItem() => false,
          _ => true,
        },
    };
  }

  bool equal(CenteredHeroItemState other) {
    return switch (this) {
      CenteredHeroFutureThinItem(thinToSmall: double v) => switch (other) {
          CenteredHeroFutureThinItem(thinToSmall: double ov) => v == ov,
          CenteredHeroFutureSmallItem(smallToHero: 0) => v == 1,
          _ => false,
        },
      CenteredHeroFutureSmallItem(smallToHero: double v) => switch (other) {
          CenteredHeroFutureThinItem(thinToSmall: 1) => v == 0,
          CenteredHeroFutureSmallItem(smallToHero: double ov) => v == ov,
          CenteredHeroCenterItem(heroToSmall: 0) => v == 1,
          _ => false,
        },
      CenteredHeroCenterItem(heroToSmall: double v) => switch (other) {
          CenteredHeroFutureSmallItem(smallToHero: 1) => v == 0,
          CenteredHeroCenterItem(heroToSmall: double ov) => ov == v,
          CenteredHeroPastSmallItem(smallToThin: 0) => v == 1,
          _ => false,
        },
      CenteredHeroPastSmallItem(smallToThin: double v) => switch (other) {
          CenteredHeroCenterItem(heroToSmall: 1) => v == 0,
          CenteredHeroPastSmallItem(smallToThin: double ov) => v == ov,
          CenteredHeroPastThinItem() => v == 1,
          _ => false,
        },
      CenteredHeroPastThinItem() => switch (other) {
          CenteredHeroPastSmallItem(smallToThin: 1) => true,
          CenteredHeroPastThinItem() => true,
          _ => false,
        },
    };
  }
}

class CenteredHeroFutureThinItem extends CenteredHeroItemState {
  const CenteredHeroFutureThinItem(this.thinToSmall);
  final double thinToSmall;
  @override
  String toString() => "fThin";
}

class CenteredHeroFutureSmallItem extends CenteredHeroItemState {
  const CenteredHeroFutureSmallItem(this.smallToHero);
  final double smallToHero;
  @override
  String toString() => "fSmall ${smallToHero.toStringAsFixed(2)}";
}

class CenteredHeroCenterItem extends CenteredHeroItemState {
  final double heroToSmall;
  const CenteredHeroCenterItem(this.heroToSmall);
  @override
  String toString() => "hero ${heroToSmall.toStringAsFixed(2)}";
}

class CenteredHeroPastSmallItem extends CenteredHeroItemState {
  final double smallToThin;
  const CenteredHeroPastSmallItem(this.smallToThin);
  @override
  String toString() => "pSmall ${smallToThin.toStringAsFixed(2)}";
}

class CenteredHeroPastThinItem extends CenteredHeroItemState {
  const CenteredHeroPastThinItem();
  @override
  String toString() => "pThin";
}
