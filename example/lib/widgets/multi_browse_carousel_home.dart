// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cached_network_image/cached_network_image.dart';
import 'package:example/logic/theme_logic.dart';
import 'package:flutter/material.dart';
import 'package:sid_base/sid_base.dart';

class MultiBrowseCarouselHome extends StatelessWidget {
  const MultiBrowseCarouselHome({super.key});

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
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(
          child: Center(
            child: SizedBox(
              height: direction.fold(
                ifVertifcal: () => null,
                ifHorizontal: () => 250,
              ),
              child: carousel(),
            ),
          ),
        ),
        const Space.vertical(12),
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

  static const ratios = [
    "/1000/2000",
    "/2000/1000",
    "/1000/1000",
    "/800/3000",
    "/3000/800",
    "/1000/1000",
    "/1000/1200",
    "/1200/1000",
  ];
  String ratio(int i) => ratios[i % ratios.length];
  Widget carousel() {
    return MultiBrowseCarousel(
      theme: CustomM3CarouselTheme(targetLarge: targetLarge, direction: direction),
      itemBuilder: (int i) => CarouselItem(
        background: CachedNetworkImageProvider('https://picsum.photos${ratio(i)}?image=${i + 10}'),
        contentBuilder: (context, state, pi) => CarouselItemLabels(
          title: "$i",
          label: "Title $pi",
        ),
      ),
      openBuilder: (context, close, itemIndex, item) => fullScreenCarousel(itemIndex),
    );
  }

  static const fsRatios = [
    "/2000/4000",
    "/4000/2000",
    "/3000/3000",
    "/1000/5000",
    "/5000/1000",
    "/3000/3000",
    "/2000/2400",
    "/2400/2000",
  ];
  String fsRatio(int i) => fsRatios[i % ratios.length];

  Scaffold fullScreenCarousel(int itemIndex) {
    return Scaffold(
      body: FullScreenCarousel(
        initialIndex: itemIndex,
        itemBuilder: (int i) => CarouselItem(
          background:
              CachedNetworkImageProvider('https://picsum.photos${fsRatio(i)}?image=${i + 10}'),
          contentBuilder: (context, state, pi) => CarouselItemLabels(
            title: "$i",
            label: "Title $pi",
          ),
        ),
      ),
    );
  }
}

class CustomM3CarouselTheme extends MultiBrowseCarouselTheme {
  final double targetLarge;
  CustomM3CarouselTheme({
    required this.targetLarge,
    super.direction = Axis.horizontal,
  });

  @override
  double get widthLarge => targetLarge;
}
