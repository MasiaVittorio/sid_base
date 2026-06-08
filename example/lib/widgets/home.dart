import 'package:example/logic/theme_logic.dart';
import 'package:example/widgets/multi_browse_carousel_home.dart';
import 'package:flutter/material.dart';
import 'package:sid_base/sid_base.dart';

class HomeExample extends StatelessWidget {
  const HomeExample({super.key});

  @override
  Widget build(BuildContext context) {
    final themeLogic = CleanProvider.of<ThemeLogic>(context)!;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Settings"),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              children: [
                themeLogic.dark.build(
                  (context, value) => SwitchListTile(
                    value: value,
                    onChanged: (_) => themeLogic.toggleBrightness(),
                    title: const Text("Dark mode:"),
                    secondary: Icon(MdiIcons.weatherNight),
                  ),
                ),
                ListTile(
                  title: const Text("Carousel example"),
                  onTap: () => context.pushPage(const MultiBrowseCarouselHome()),
                ),
              ],
            ),
          ),
          const TryCard(),
        ],
      ),
    );
  }
}

class TryCard extends StatefulWidget {
  const TryCard({
    super.key,
  });

  @override
  State<TryCard> createState() => _TryCardState();
}

class _TryCardState extends State<TryCard> {
  bool expanded = true;
  void onChanged(bool value) => setState(() {
        expanded = value;
      });
  @override
  Widget build(BuildContext context) {
    final Color one = context.theme.colorScheme.surface;
    final Color two = context.theme.colorScheme.inverseSurface;
    final Color surface = one.isDark ? one : two;
    final Color opposite = one.isLight ? one : two;
    return ExpandableCircleCard(
      expanded: expanded,
      onExpandedChanged: onChanged,
      collapsedCircleChild: const Icon(Icons.person_outline),
      expandedChild: const Text(
          "Ciao ciao ciao Ciao ciao ciao Ciao ciao ciao Ciao ciao ciao Ciao ciao ciao Ciao ciao ciao Ciao ciao ciao Ciao ciao ciao Ciao ciao ciao Ciao ciao ciao Ciao ciao ciao Ciao ciao ciao Ciao ciao ciao "),
      expandedCircleChild: const Icon(Icons.person),
      titleChild: const Text("Shield formation"),

      surfaceColor: surface,
      oppositeColor: opposite,

      // surfaceColor: const Color(0xff001521),
      // oppositeColor: const Color(0xfff7e9dc),
    );
  }
}
