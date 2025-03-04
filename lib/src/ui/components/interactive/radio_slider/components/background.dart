part of '../radio_slider.dart';

class _Background extends StatelessWidget {
  const _Background(this.backgroundColor);

  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final RadioSliderThemeData? radioTheme = RadioSliderTheme.of(context);

    return Material(
      color:
          backgroundColor ??
          radioTheme?.backgroundColor ??
          theme.scaffoldBackgroundColor.withValues(
            alpha: 0.7,
          ), //like stage's subsections
      // ?? theme?.colorScheme?.onSurface?.withValues(alpha: 0.08),
      borderRadius: BorderRadius.circular(_RadioSliderState._radius),
    );
  }
}
