// ignore_for_file: public_member_api_docs, sort_constructors_first
library m3_carousel;

import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:sid_base/sid_base.dart';
import 'package:sid_base/src/all.dart';

import 'transparent_pointer.dart';

part 'carousels/centered_hero/carousel.dart';
part 'carousels/centered_hero/decorator.dart';
part 'carousels/centered_hero/item_state.dart';
part 'carousels/centered_hero/layout.dart';
part 'carousels/centered_hero/theme.dart';
part 'carousels/full_screen/carousel.dart';
part 'carousels/full_screen/decorator.dart';
part 'carousels/full_screen/item_state.dart';
part 'carousels/full_screen/layout.dart';
part 'carousels/full_screen/theme.dart';
part 'carousels/multi_browse/carousel.dart';
part 'carousels/multi_browse/decorator.dart';
part 'carousels/multi_browse/item_state.dart';
part 'carousels/multi_browse/layout.dart';
part 'carousels/multi_browse/theme.dart';
part 'item.dart';
part 'item_state.dart';
part 'theme/decoration.dart';
part 'theme/layout.dart';
part 'theme/theme.dart';

class M3Carousel<T extends CarouselItemState> extends StatelessWidget {
  const M3Carousel({
    super.key,
    this.initialIndex = 0,
    this.theme,
    required this.itemBuilder,
    this.itemCount,
    this.loop = false,
    this.autoFocusOnTap = true,
    this.openBuilder,
    required this.defaultTheme,
  });

  final int initialIndex;
  final M3CarouselTheme<T>? theme;

  final CarouselItem<T> Function(int itemIndex) itemBuilder;

  final int? itemCount;
  final bool loop;

  final Widget Function(
      BuildContext context, VoidCallback close, int itemIndex, CarouselItem<T> item)? openBuilder;
  final bool autoFocusOnTap;

  final M3CarouselTheme<T> defaultTheme;
  @override
  Widget build(BuildContext context) {
    final M3CarouselTheme<T> theme =
        this.theme ?? CleanProvider.of<M3CarouselTheme<T>>(context) ?? defaultTheme;
    return CleanProvider(
      data: theme,
      child: LayoutBuilder(builder: (context, constraints) {
        return ConstrainedBox(
          constraints: constraints,
          child: _M3CarouselBody<T>(
            autoFocusOnTap: autoFocusOnTap,
            openBuilder: openBuilder,
            constraints: constraints,
            itemBuilder: itemBuilder,
            itemCount: itemCount,
            loop: loop,
            initialIndex: initialIndex,
            theme: theme,
            layouter: theme.getLayouter(theme.direction.fold(
              ifVertifcal: () => constraints.maxHeight,
              ifHorizontal: () => constraints.maxWidth,
            )),
            decorator: theme.getDecorator(),
          ),
        );
      }),
    );
  }
}

class _M3CarouselBody<T extends CarouselItemState> extends StatefulWidget {
  const _M3CarouselBody({
    required this.initialIndex,
    required this.itemBuilder,
    required this.itemCount,
    required this.loop,
    required this.theme,
    required this.constraints,
    required this.layouter,
    required this.decorator,
    required this.openBuilder,
    required this.autoFocusOnTap,
  });

  final int initialIndex;
  final CarouselItem<T> Function(int itemIndex) itemBuilder;
  final int? itemCount;
  final bool loop;
  final M3CarouselTheme<T> theme;
  final BoxConstraints constraints;
  final M3CarouselLayouter<T> layouter;
  final M3CarouselItemDecorator decorator;
  final Widget Function(
      BuildContext context, VoidCallback close, int itemIndex, CarouselItem<T> item)? openBuilder;
  final bool autoFocusOnTap;

  @override
  State<_M3CarouselBody<T>> createState() => _M3CarouselBodyState<T>();
}

class _M3CarouselBodyState<T extends CarouselItemState> extends State<_M3CarouselBody<T>> {
  late PageController controller;

  @override
  void initState() {
    super.initState();
    initController(widget.initialIndex, widget.layouter.viewPortFraction);
  }

  double? lastViewPortFraction;
  void initController(int initialPage, double viewPortFraction) {
    lastViewPortFraction = viewPortFraction;
    controller = PageController(
      initialPage: initialPage,
      viewportFraction: viewPortFraction,
      keepPage: true,
    );
  }

  @override
  void didUpdateWidget(covariant _M3CarouselBody<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    final newViewPortFraction = widget.layouter.viewPortFraction;
    if (lastViewPortFraction != newViewPortFraction) {
      final int page = controller.safePage.round();
      controller.dispose();
      initController(page, newViewPortFraction);
    }
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  int? getIndex(int pageIndex) {
    if (pageIndex < 0) return null;
    final int? n = widget.itemCount;
    if (n == null) return pageIndex;
    if (n > pageIndex) return pageIndex;
    if (widget.loop) return pageIndex.modLessThan(n);
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final theme = widget.theme;

    return CleanProvider<M3CarouselTheme<T>>(
      data: theme,
      child: Stack(
        children: [
          PageView.builder(
            itemBuilder: (context, index) => const SizedBox(),
            itemCount: widget.loop ? null : widget.itemCount,
            controller: controller,
            scrollDirection: widget.theme.direction,
            physics: const PageScrollPhysics(),
          ),
          Positioned.fill(
            child: TransparentPointer(
              child: SmoothPageReactor(
                controller: controller,
                builder: (context, child, page) {
                  final range = widget.layouter.visibleRange(page);
                  return Stack(
                    fit: StackFit.expand,
                    children: [
                      for (int pi = range.$1; pi < range.$2; pi++)
                        if (widget.layouter.position(pi, page) case (Positioner, T) result)
                          if (getIndex(pi) case int itemIndex)
                            ((() {
                              final item = widget.itemBuilder(itemIndex);
                              final state = result.$2;
                              final positioner = result.$1;
                              final double future = (pi - page).toDouble();
                              final openBuilder = widget.openBuilder;
                              return positioner(
                                _GesturesDecider<T>(
                                  carouselTheme: widget.theme,
                                  borderRadius: theme.borderRadius,
                                  pageIndex: pi,
                                  openBuilder: openBuilder == null
                                      ? null
                                      : (context, close) => openBuilder(
                                            context,
                                            close,
                                            itemIndex,
                                            item,
                                          ),
                                  autoFocus: widget.autoFocusOnTap,
                                  canBeOpened: state.canBeOpened,
                                  overrideOnTap: item.overrideOnTap,
                                  controller: controller,
                                  builder: (context, round, onTap) {
                                    return widget.decorator.build(
                                      context,
                                      future,
                                      _LayoutContent(
                                        content: item.contentBuilder?.call(context, state, pi),
                                        gradient: item.gradient,
                                        direction: theme.direction,
                                        largeWidth: widget.layouter.largeWidth,
                                        contentOpacity: result.$2.contentOpacity,
                                        onTap: onTap,
                                      ),
                                      item.background,
                                      round,
                                    );
                                  },
                                ),
                              );
                            })())
                    ],
                  );
                },
              ),
            ),
          ),
          // Positioned(
          //   right: 0,
          //   top: 0,
          //   bottom: 0,
          //   width: theme.inBetweenPadding,
          //   child: Container(color: context.theme.colorScheme.surface),
          // ),
          // Positioned(
          //   left: 0,
          //   top: 0,
          //   bottom: 0,
          //   width: theme.inBetweenPadding,
          //   child: Container(color: context.theme.colorScheme.surface),
          // ),
        ],
      ),
    );
  }
}

class _LayoutContent<T extends CarouselItemState> extends StatelessWidget {
  const _LayoutContent({
    super.key,
    required this.content,
    required this.gradient,
    required this.direction,
    required this.largeWidth,
    required this.contentOpacity,
    required this.onTap,
  });

  final Widget? content;
  final Gradient? gradient;
  final Axis direction;
  final double largeWidth;
  final double contentOpacity;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child: Container(
        decoration: BoxDecoration(
          gradient: content == null ? null : gradient,
        ),
        child: InkWell(
          onTap: onTap,
          child: content == null
              ? const SizedBox.expand()
              : Stack(
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
                      child: Opacity(
                        opacity: contentOpacity,
                        child: content,
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}

class _GesturesDecider<T extends CarouselItemState> extends StatelessWidget {
  const _GesturesDecider({
    required this.borderRadius,
    required this.pageIndex,
    required this.autoFocus,
    required this.canBeOpened,
    required this.overrideOnTap,
    required this.builder,
    required this.controller,
    required this.carouselTheme,
    required this.openBuilder,
  });

  final M3CarouselTheme<T> carouselTheme;
  final BorderRadius borderRadius;
  final int pageIndex;
  final bool autoFocus;
  final bool canBeOpened;
  bool get canBeFocused => !canBeOpened;
  final VoidCallback? overrideOnTap;
  final Widget Function(BuildContext context, bool round, VoidCallback? onTap) builder;

  final PageController controller;
  final Widget Function(BuildContext context, VoidCallback close)? openBuilder;

  void focus() => controller.animateToPage(
        pageIndex,
        duration: Durations.medium3,
        curve: Easing.emphasizedDecelerate,
      );

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    return switch ((overrideOnTap, openBuilder)) {
      (VoidCallback onTap, _) => builder(context, true, onTap),
      (_, null) => builder(
          context,
          true,
          canBeFocused && autoFocus ? focus : null,
        ),
      (_, Widget Function(BuildContext, VoidCallback) openBuilder) => OpenContainer(
          openShape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
          closedShape: RoundedRectangleBorder(borderRadius: borderRadius),
          tappable: false,
          clipBehavior: Clip.antiAlias,
          closedColor: theme.colorScheme.secondaryContainer,
          middleColor: theme.colorScheme.secondaryContainer,
          openColor: theme.colorScheme.secondaryContainer,
          closedBuilder: (context, open) {
            return CleanProvider<M3CarouselTheme<T>>(
              data: carouselTheme,
              child: builder(
                context,
                false,
                switch (canBeOpened) {
                  true => open,
                  false => autoFocus ? focus : null,
                },
              ),
            );
          },
          openBuilder: openBuilder,
        ),
    };
  }
}
