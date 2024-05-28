library m3_carousel;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:sid_base/sid_base.dart';
import 'package:sid_base/src/all.dart';
import 'package:sid_base/src/ui/layout/flist/theme.dart';

import 'transparent_pointer.dart';

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
  });

  final int initialIndex;
  final M3CarouselTheme? theme;

  // if loop = true and itemCount finite, page index can be more than item index
  final CarouselItem<T> Function(int itemIndex, int pageIndex) itemBuilder;

  final int? itemCount;
  final bool loop;

  @override
  Widget build(BuildContext context) {
    final M3CarouselTheme theme = this.theme ??
        CleanProvider.of<M3CarouselTheme>(context) ??
        const MultiBrowseCarouselTheme();
    return CleanProvider(
      data: theme,
      child: LayoutBuilder(builder: (context, constraints) {
        return ConstrainedBox(
          constraints: constraints,
          child: _M3CarouselBody<T>(
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
  });

  final int initialIndex;
  final CarouselItem Function(int itemIndex, int pageIndex) itemBuilder;
  final int? itemCount;
  final bool loop;
  final M3CarouselTheme theme;
  final BoxConstraints constraints;
  final M3CarouselLayouter layouter;
  final M3CarouselItemDecorator decorator;

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

    return CleanProvider(
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
                        if (getIndex(pi) case int itemIndex)
                          if (widget.itemBuilder(itemIndex, pi) case CarouselItem<T> item)
                            if (widget.layouter.position(pi, page) case (Positioner, T) result)
                              if (widget.decorator.build(
                                context,
                                (pi - page),
                                item.contentBuilder(context, result.$2, widget.layouter.largeWidth),
                                item.background,
                              )
                                  case Widget child)
                                result.$1(child),
                    ],
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
