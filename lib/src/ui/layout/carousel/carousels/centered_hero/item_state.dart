part of "../../m3_carousel.dart";

sealed class CenteredHeroItemState extends CarouselItemState {
  const CenteredHeroItemState();

  @override
  bool get canBeOpened => switch (this) {
    CenteredHeroFutureSmallItem(smallToHero: double v) => v > 0.95,
    CenteredHeroCenterItem(heroToSmall: double v) => v <= 0.05,
    _ => false,
  };

  @override
  double get contentOpacity => fold(
    futureThin: () => 0.0,
    futureThinToSmall: (v) => 0.0,
    futureSmall: () => 0.0,
    futureSmallToHero: (v) => v.rangeMap(to: (0, 1), from: (0.5, 0.95)),
    hero: () => 1.0,
    heroToSmall: (v) => v.rangeMap(to: (1, 0), from: (0.05, 0.5)),
    pastSmall: () => 0.0,
    pastSmallToThin: (v) => 0.0,
    pastThin: () => 0.0,
  );

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
  }) => switch (this) {
    CenteredHeroFutureThinItem(thinToSmall: 0) => futureThin(),
    CenteredHeroFutureThinItem(thinToSmall: 1) => futureSmall(),
    CenteredHeroFutureSmallItem(smallToHero: 0) => futureSmall(),
    CenteredHeroFutureSmallItem(smallToHero: 1) => hero(),
    CenteredHeroCenterItem(heroToSmall: 0) => hero(),
    CenteredHeroCenterItem(heroToSmall: 1) => pastSmall(),
    CenteredHeroPastSmallItem(smallToThin: 0) => pastSmall(),
    CenteredHeroPastSmallItem(smallToThin: 1) => pastThin(),
    CenteredHeroPastThinItem() => pastThin(),
    CenteredHeroFutureThinItem(thinToSmall: double v) => futureThinToSmall(v),
    CenteredHeroFutureSmallItem(smallToHero: double v) => futureSmallToHero(v),
    CenteredHeroCenterItem(heroToSmall: double v) => heroToSmall(v),
    CenteredHeroPastSmallItem(smallToThin: double v) => pastSmallToThin(v),
  };

  double get _v {
    return switch (this) {
      CenteredHeroFutureThinItem(thinToSmall: double v) => v,
      CenteredHeroFutureSmallItem(smallToHero: double v) => 1 + v,
      CenteredHeroCenterItem(heroToSmall: double v) => 2 + v,
      CenteredHeroPastSmallItem(smallToThin: double v) => 3 + v,
      CenteredHeroPastThinItem() => 4,
    };
  }

  bool before(CenteredHeroItemState other) => _v < other._v;

  bool after(CenteredHeroItemState other) => _v > other._v;

  bool equal(CenteredHeroItemState other) => _v == other._v;
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
