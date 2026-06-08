part of "../../m3_carousel.dart";

sealed class HeroItemState extends CarouselItemState {
  const HeroItemState();

  @override
  bool get canBeOpened => switch (this) {
    HeroSmallItem(smallToHero: double v) => v > 0.95,
    HeroCenterItem(heroToPast: double v) => v <= 0.05,
    _ => false,
  };

  @override
  double get contentOpacity => fold(
    thin: () => 0.0,
    thinToSmall: (v) => 0.0,
    small: () => 0.0,
    smallToHero: (v) => v.rangeMap(from: (0.5, 0.95)),
    hero: () => 1.0,
    heroToPast: (v) => v.rangeMap(to: (1, 0), from: (0.05, 0.5)),
    past: () => 0.0,
  );

  T fold<T>({
    required T Function() thin,
    required T Function(double v) thinToSmall,
    required T Function() small,
    required T Function(double v) smallToHero,
    required T Function() hero,
    required T Function(double v) heroToPast,
    required T Function() past,
  }) => switch (this) {
    HeroThinItem(thinToSmall: 0) => thin(),
    HeroThinItem(thinToSmall: 1) => small(),
    HeroSmallItem(smallToHero: 0) => small(),
    HeroSmallItem(smallToHero: 1) => hero(),
    HeroCenterItem(heroToPast: 0) => hero(),
    HeroCenterItem(heroToPast: 1) => past(),
    HeroPastItem() => past(),
    HeroThinItem(thinToSmall: double v) => thinToSmall(v),
    HeroSmallItem(smallToHero: double v) => smallToHero(v),
    HeroCenterItem(heroToPast: double v) => heroToPast(v),
  };

  double get _v {
    return switch (this) {
      HeroThinItem(thinToSmall: double v) => v,
      HeroSmallItem(smallToHero: double v) => 1 + v,
      HeroCenterItem(heroToPast: double v) => 2 + v,
      HeroPastItem() => 3,
    };
  }

  bool after(HeroItemState other) => _v > other._v;
  bool equal(HeroItemState other) => _v == other._v;
  bool before(HeroItemState other) => _v < other._v;
}

class HeroThinItem extends HeroItemState {
  const HeroThinItem(this.thinToSmall);
  final double thinToSmall;
  @override
  String toString() => "fThin";
}

class HeroSmallItem extends HeroItemState {
  const HeroSmallItem(this.smallToHero);
  final double smallToHero;
  @override
  String toString() => "fSmall ${smallToHero.toStringAsFixed(2)}";
}

class HeroCenterItem extends HeroItemState {
  final double heroToPast;
  const HeroCenterItem(this.heroToPast);
  @override
  String toString() => "hero ${heroToPast.toStringAsFixed(2)}";
}

class HeroPastItem extends HeroItemState {
  const HeroPastItem();
  @override
  String toString() => "past";
}
