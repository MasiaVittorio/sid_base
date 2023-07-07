import 'package:flutter/material.dart';
import 'package:sid_base/sid_base.dart';

class ExpandableAppBar extends StatelessWidget {

  const ExpandableAppBar({
    Key? key,
    required this.expanded,
    required this.title,
    this.close,
    this.automaticallyImplyLeading = true,
    this.useCloseButton = false,
    this.leading,
    this.actions = const [],
    this.centered = true,
    this.duration = const Duration(milliseconds: 300),
    this.curve = Curves.ease,
    this.expandedHeight = expandedHeightLarge,
    this.expandedColor,
    this.collapsedColor,
    this.expandedBottomRadius,
    this.expandedBackgroundWidget,
  }) : super(key: key);

  bool get scrolled => !expanded;
  final bool expanded;
  final String title;
  final VoidCallback? close;
  final bool automaticallyImplyLeading;
  final bool useCloseButton;
  final Widget? leading;
  final List<Widget> actions;
  final bool centered;
  final Duration duration;
  final Curve curve;
  final double expandedHeight;
  final Color? expandedColor;
  final Color? collapsedColor;
  final double? expandedBottomRadius;
  final Widget? expandedBackgroundWidget;
  
  static const double expandedHeightMedium = 112;
  static const double expandedHeightLarge = 152;
  static const collapsedHeight = 64.0;


  @override
  Widget build(BuildContext context) {
    final topSafe = context.safe.top;
    final theme = Theme.of(context);

    final Widget? maybeLeading = getMaybeLeading(context);
    late final double extraBottom;
    final Widget? bkg = expandedBackgroundWidget;
    if(bkg != null){
      extraBottom = 0;
    } else {
      extraBottom = 0;
    }
    final Widget content = backColor(
      theme: theme,
      child: Padding(
        padding: EdgeInsets.only(bottom: extraBottom),
        child: buildContent(topSafe, theme, maybeLeading),
      ),
    );


    return sizeAndClip(
      topSafe: topSafe, 
      child: Stack(children: [
        if(bkg != null)
          Positioned.fill(child: bkg),
        Positioned.fill(
          bottom: - extraBottom,
          child: content,
        ),
      ],),
    );
  }

  Widget sizeAndClip({required double topSafe, required Widget child}) {
    return AnimatedContainer(
      duration: duration,
      curve: curve,
      width: double.infinity,
      height: scrolled
        ? topSafe + collapsedHeight
        : topSafe + expandedHeight,
      decoration: BoxDecoration(
        borderRadius: expandedBottomRadius != null
          ? BorderRadius.vertical(bottom: Radius.circular(
            expanded ? expandedBottomRadius! : 0,
          ))
          : null,
      ),
      clipBehavior: Clip.antiAlias,
      child: child,
    );
  }

  Widget backColor({required Widget child, required ThemeData theme}){
    return AnimatedContainer(
      duration: duration,
      curve: curve,
      width: double.infinity,
      height: double.infinity,
      color: scrolled 
        ? collapsedColor ?? theme.elevatedSurface(2)
        : expandedColor ?? theme.colorScheme.background,
      child: child,
    );
  }

  Widget buildContent(double topSafe, ThemeData theme, Widget? maybeLeading) {
    return Material(
      type: MaterialType.transparency,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Space.vertical(topSafe),
          collapsed(theme, maybeLeading),
          Expanded(child: largeTitle(theme)),
        ],
      ),
    );
  }

  Widget? getMaybeLeading(BuildContext context){
    Widget? lead = leading;
    if (lead == null && automaticallyImplyLeading) {
      final ModalRoute<dynamic>? parentRoute = ModalRoute.of(context);
      final bool canPop = parentRoute?.canPop ?? false;
      final ScaffoldState? scaffold = Scaffold.maybeOf(context);
      final bool hasDrawer = scaffold?.hasDrawer ?? false;
      final bool hasEndDrawer = scaffold?.hasEndDrawer ?? false;
      if (hasDrawer) {
        void handleDrawerButton() {
          Scaffold.of(context).openDrawer();
        }
        lead = IconButton(
          icon: const Icon(Icons.menu),
          iconSize: 24,
          onPressed: handleDrawerButton,
          tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
        );
      } else {
        if (!hasEndDrawer && canPop) {
          lead = useCloseButton 
            ? CloseButton(onPressed: close) 
            : BackButton(onPressed: close);
        }
      }
    }
    return lead;
  }

  
  Widget largeTitle(ThemeData theme) {
    return Stack(
      clipBehavior: Clip.hardEdge,
      children: [
        Positioned(
          bottom: 20, left: 16, right: 16,
          child: AnimatedOpacity(
            opacity: scrolled ? 0.0 : 1.0,
            duration: duration,
            curve: curve,
            child: SizedBox(
              width: double.infinity,
              child: DefaultTextStyle.merge(
                style: theme.textTheme.headlineMedium,
                child: Text(
                  title, 
                  maxLines: 1, 
                  overflow: TextOverflow.ellipsis,
                ),
              )
            ),
          ),
        ),
      ],
    );
  }

  Widget collapsed(ThemeData theme, Widget? maybeLeading) 
    => SizedBox(
      height: collapsedHeight,
      child: Stack(children: [
        Positioned.fill(
          child: icons(theme, maybeLeading),
        ),
        Positioned.fill(
          left: collapsedHeight,
          right: collapsedHeight,
          child: Align(
            alignment: centered ? Alignment.center : Alignment.centerLeft,
            child: collapsedTitle(theme),
          ),
        ),
      ],),
    );

  Widget icons(ThemeData theme, Widget? maybeLeading) {
    return Row(children: [
      if(maybeLeading != null)
        square(maybeLeading),
      const Spacer(),
      for(final child in actions)
        square(child),
    ],);
  }

  Widget collapsedTitle(ThemeData theme) 
    => DefaultTextStyle.merge(
      style: theme.textTheme.titleLarge,
      child: AnimatedOpacity(
        duration: duration,
        opacity: scrolled ? 1.0 : 0.0,
        child: Text(title, maxLines: 1, overflow: TextOverflow.ellipsis,),
      ),
    );


  Widget square(Widget child) => SizedBox.square(
    dimension: collapsedHeight,
    child: Center(child: child),
  );


}
