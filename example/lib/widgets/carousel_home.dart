// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cached_network_image/cached_network_image.dart';
import 'package:example/logic/theme_logic.dart';
import 'package:flutter/material.dart';
import 'package:sid_base/sid_base.dart';

class CarouselHome extends StatelessWidget {
  const CarouselHome({super.key});

  @override
  Widget build(BuildContext context) {
    var themeLogic = context.provide<ThemeLogic>();
    return Scaffold(
      appBar: AppBar(title: const Text("Carousel example")),
      body: Column(
        children: [
          const SlidableCarousel(),
          const Space.vertical(8),
          Expanded(
            child: ListView(
              children: [
                const Space.vertical(8),
                themeLogic.dark.build(
                  (context, value) => SwitchListTile(
                    value: value,
                    onChanged: (_) => themeLogic.toggleBrightness(),
                    title: const Text("Dark mode:"),
                    secondary: Icon(MdiIcons.weatherNight),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class SlidableCarousel extends StatefulWidget {
  const SlidableCarousel({
    super.key,
  });

  @override
  State<SlidableCarousel> createState() => _SlidableCarouselState();
}

class _SlidableCarouselState extends State<SlidableCarousel> {
  double targetLarge = 180;

  void onChanged(double v) {
    setState(() {
      targetLarge = v;
    });
  }

  Axis direction = Axis.horizontal;

  void onChangedDirection(Axis d) {
    setState(() {
      direction = d;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        RadioSlider(
          items: const [
            RadioSliderItem(title: Text("Vertical"), icon: Icon(Icons.vertical_distribute_sharp)),
            RadioSliderItem(title: Text("Horizontal"), icon: Icon(Icons.horizontal_distribute))
          ],
          selectedIndex: direction == Axis.vertical ? 0 : 1,
          onTap: (int index) {
            onChangedDirection(index == 0 ? Axis.vertical : Axis.horizontal);
          },
        ),
        const Space.vertical(8),
        SizedBox(
          height: direction.fold(
            ifVertifcal: () => 400,
            ifHorizontal: () => 250,
          ),
          child: M3Carousel(
            theme: CustomM3CarouselTheme(
              targetLarge: targetLarge,
              direction: direction,
            ),
            itemBuilder: (i) => CarouselItem(
              background: CachedNetworkImageProvider('https://picsum.photos/1000?image=${i + 10}'),
              contentBuilder: (context, CarouselItemState state, double largeWidth) => Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.black.withOpacity(0.4),
                      Colors.black.withOpacity(0.1),
                      Colors.black.withOpacity(0.0),
                    ],
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                  ),
                ),
                child: Material(
                  type: MaterialType.transparency,
                  child: InkWell(
                    onTap: () {},
                    child: Stack(
                      children: [
                        Positioned(
                          bottom: 0,
                          left: 0,
                          width: direction.fold(
                            ifVertifcal: () => null,
                            ifHorizontal: () => largeWidth,
                          ),
                          right: direction.fold(
                            ifVertifcal: () => 0,
                            ifHorizontal: () => null,
                          ),
                          child: Pad(
                            bottom: 12,
                            horizontal: 12,
                            child: Opacity(
                              opacity: switch (state) {
                                ThinItem(thinToSmall: double _) => 0.0,
                                SmallItem(smallToMedium: double v) =>
                                  v.mapToRange(0, 0.5, fromMin: 0.7),
                                MediumItem(mediumToLarge: double v) => v.mapToRange(0.5, 1),
                                LargeItem(largeToThin: double v) =>
                                  v.mapToRange(1, 0, fromMin: 0.1, fromMax: 0.7),
                              },
                              child: Text.rich(
                                TextSpan(children: [
                                  TextSpan(text: "$i\n"),
                                  TextSpan(
                                    text: "Titolo",
                                    style: context.theme.textTheme.bodyMedium!
                                        .copyWith(color: Colors.white),
                                  ),
                                ]),
                                style: context.theme.textTheme.titleLarge!
                                    .copyWith(color: Colors.white),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            itemCount: 5,
            loop: true,
          ),
        ),
        const Space.vertical(12),
        Pad(
          horizontal: 24,
          child: Text(
            "Target large size: ${targetLarge.toStringAsFixed(1)}",
            style: context.theme.textTheme.titleSmall,
          ),
        ),
        Slider(
          value: targetLarge,
          onChanged: onChanged,
          min: 80,
          max: 500,
        ),
      ],
    );
  }
}

class CustomM3CarouselTheme extends M3CarouselTheme {
  final double targetLarge;
  @override
  final Axis direction;
  CustomM3CarouselTheme({
    required this.targetLarge,
    this.direction = Axis.horizontal,
  });

  @override
  double get widthLarge => targetLarge;
}
