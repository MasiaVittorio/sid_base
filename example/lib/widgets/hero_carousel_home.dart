// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cached_network_image/cached_network_image.dart';
import 'package:example/logic/theme_logic.dart';
import 'package:example/widgets/carousel_item_labels.dart';
import 'package:flutter/material.dart';
import 'package:sid_base/sid_base.dart';

class HeroCarouselHome extends StatelessWidget {
  const HeroCarouselHome({super.key});

  @override
  Widget build(BuildContext context) {
    var themeLogic = context.provide<ThemeLogic>();
    return Scaffold(
      appBar: AppBar(title: const Text("Carousel example"), scrolledUnderElevation: 0),
      body: Column(
        children: [
          const Expanded(child: SlidableCarousel()),
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
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(
          child: Center(
            child: SizedBox(
              height: direction.fold(
                ifVertifcal: () => null,
                ifHorizontal: () => 250,
              ),
              child: HeroCarousel(
                theme: HeroCarouselTheme(direction: direction),
                itemBuilder: itemBuilder<HeroItemState>,
                openBuilder: (context, close, itemIndex, item) => Scaffold(
                  body: FullScreenCarousel(
                    initialIndex: itemIndex,
                    itemBuilder: itemBuilder<FullScreenItemState>,
                  ),
                ),
              ),
            ),
          ),
        ),
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
        const Space.vertical(12),
      ],
    );
  }

  CarouselItem<T> itemBuilder<T extends CarouselItemState>(int i) => CarouselItem(
        background: CachedNetworkImageProvider('https://picsum.photos/1000?image=${i + 10}'),
        contentBuilder: (context, state, pi) => CarouselItemLabels(
          title: "$i",
          label: "Title $pi",
        ),
      );
}
