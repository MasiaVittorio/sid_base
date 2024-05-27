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

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SizedBox(
          height: 200,
          child: M3Carousel(
            theme: CustomM3CarouselTheme(targetLarge: targetLarge),
            itemBuilder: (i) => CarouselItem(
              background: CachedNetworkImageProvider('https://picsum.photos/250?image=${i + 10}'),
              content: (context, state) => Center(child: Text("$i\n$state")),
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
  CustomM3CarouselTheme({
    required this.targetLarge,
  });

  @override
  double get widthLarge => targetLarge;
}
