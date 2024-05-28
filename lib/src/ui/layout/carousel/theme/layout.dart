part of "../m3_carousel.dart";

extension AxisFold on Axis {
  T fold<T>({
    required T Function() ifVertifcal,
    required T Function() ifHorizontal,
  }) =>
      switch (this) {
        Axis.vertical => ifVertifcal(),
        Axis.horizontal => ifHorizontal(),
      };
}

abstract class M3CarouselLayouter<T extends CarouselItemState> {
  (Positioner, T)? position(
    int i,
    double x,
  );

  (int min, int max) visibleRange(double x);

  double get viewPortFraction;
  double get largeWidth;
}

typedef Positioner = Positioned Function(Widget child);
