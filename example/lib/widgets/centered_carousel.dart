// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cached_network_image/cached_network_image.dart';
import 'package:example/logic/theme_logic.dart';
import 'package:flutter/material.dart';
import 'package:sid_base/sid_base.dart';

class CenteredCarouselHome extends StatelessWidget {
  const CenteredCarouselHome({super.key});

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
          child: M3Carousel<CenteredHeroItemState>(
            theme: CustomM3CarouselTheme(
              direction: direction,
            ),
            itemBuilder: (i, pi) => CarouselItem(
              background: CachedNetworkImageProvider('https://picsum.photos/1000?image=${i + 10}'),
              contentBuilder: (context, CenteredHeroItemState state, double largeWidth) =>
                  Container(
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
                            horizontal: 16,
                            child: Opacity(
                              opacity: keepText
                                  ? 1.0
                                  : state.fold(
                                      futureThin: () => 0.0,
                                      futureThinToSmall: (v) => 0.0,
                                      futureSmall: () => 0.0,
                                      futureSmallToHero: (v) =>
                                          v.mapToRangeFrom((0, 1), (0.5, 0.95)),
                                      hero: () => 1.0,
                                      heroToSmall: (v) => v.mapToRangeFrom((1, 0), (0.05, 0.5)),
                                      pastSmall: () => 0.0,
                                      pastSmallToThin: (v) => 0.0,
                                      pastThin: () => 0.0,
                                    ),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  Text(
                                    "$i",
                                    textAlign: TextAlign.start,
                                    style: context.theme.textTheme.titleLarge!
                                        .copyWith(color: Colors.white),
                                  ),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          // "Title $pi",
                                          state.toString(),
                                          textAlign: TextAlign.start,
                                          style: context.theme.textTheme.bodyMedium!
                                              .copyWith(color: Colors.white),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
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
      ],
    );
  }

  bool get keepText => false;
}

class CustomM3CarouselTheme extends CenteredHeroCarouselTheme {
  @override
  final Axis direction;
  CustomM3CarouselTheme({
    this.direction = Axis.horizontal,
  });
}
