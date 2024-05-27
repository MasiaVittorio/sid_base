// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:sid_base/sid_base.dart';
import 'package:sid_base/src/ui/layout/carousel/theme/decoration.dart';
import 'package:sid_base/src/ui/layout/flist/theme.dart';

export 'theme/layout.dart';

class CarouselItem {
  final ImageProvider background;
  final Widget Function(BuildContext context, CarouselItemState state, double largeWidth)
      contentBuilder;
  CarouselItem({
    required this.background,
    required this.contentBuilder,
  });
}

class M3Carousel extends StatelessWidget {
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
  final CarouselItem Function(int i) itemBuilder;
  final int? itemCount;
  final bool loop;

  @override
  Widget build(BuildContext context) {
    final M3CarouselTheme theme =
        this.theme ?? CleanProvider.of<M3CarouselTheme>(context) ?? const M3CarouselTheme();
    return CleanProvider(
      data: theme,
      child: LayoutBuilder(builder: (context, constraints) {
        return ConstrainedBox(
          constraints: constraints,
          child: _M3CarouselBody(
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

class _M3CarouselBody extends StatefulWidget {
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
  final CarouselItem Function(int i) itemBuilder;
  final int? itemCount;
  final bool loop;
  final M3CarouselTheme theme;
  final BoxConstraints constraints;
  final CarouselLayouter layouter;
  final CarouselItemDecorator decorator;

  @override
  State<_M3CarouselBody> createState() => _M3CarouselBodyState();
}

class _M3CarouselBodyState extends State<_M3CarouselBody> {
  late PageController controller;

  @override
  void initState() {
    super.initState();
    // final mq = MediaQuery.of(context);
    // final mq = context.getInheritedWidgetOfExactType<MediaQuery>()?.data;
    controller = PageController(
      initialPage: widget.initialIndex,
      viewportFraction: widget.layouter.viewPortFraction,
      keepPage: true,
    );
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
                          if (widget.itemBuilder(itemIndex) case CarouselItem item)
                            if (widget.layouter.position(pi, page)
                                case (Positioner, CarouselItemState) result)
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

/// This widget is invisible for its parent to hit testing, but still
/// allows its subtree to receive pointer events.
///
/// {@tool snippet}
///
/// In this example, a drag can be started anywhere in the widget, including on
/// top of the text button, even though the button is visually in front of the
/// background gesture detector. At the same time, the button is tappable.
///
/// ```dart
/// class MyWidget extends StatelessWidget {
///   @override
///   Widget build(BuildContext context) {
///     return Stack(
///       children: [
///         GestureDetector(
///           behavior: HitTestBehavior.opaque,
///           onVerticalDragStart: (_) => print("Background drag started"),
///         ),
///         Positioned(
///           top: 60,
///           left: 60,
///           height: 60,
///           width: 60,
///           child: TransparentPointer(
///             child: TextButton(
///               child: Text("Tap me"),
///               onPressed: () => print("You tapped me"),
///             ),
///           ),
///         ),
///       ],
///     );
///   }
/// }
/// ```
/// {@end-tool}
///
/// See also:
///
///  * [IgnorePointer], which is also invisible for its parent during hit testing, but
///    does not allow its subtree to receive pointer events.
///  * [AbsorbPointer], which is visible during hit testing, but prevents its subtree
///    from receiving pointer event. The opposite of this widget.
class TransparentPointer extends SingleChildRenderObjectWidget {
  /// Creates a widget that is invisible for its parent to hit testing, but still
  /// allows its subtree to receive pointer events.
  const TransparentPointer({
    required super.child,
    this.transparent = true,
    super.key,
  });

  /// Whether this widget is invisible to its parent during hit testing.
  final bool transparent;

  @override
  RenderTransparentPointer createRenderObject(BuildContext context) {
    return RenderTransparentPointer(
      transparent: transparent,
    );
  }

  @override
  void updateRenderObject(BuildContext context, RenderTransparentPointer renderObject) {
    renderObject.transparent = transparent;
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<bool>('transparent', transparent));
  }
}

class RenderTransparentPointer extends RenderProxyBox {
  RenderTransparentPointer({
    RenderBox? child,
    bool transparent = true,
  })  : _transparent = transparent,
        super(child);

  bool get transparent => _transparent;
  bool _transparent;

  set transparent(bool value) {
    if (value == _transparent) return;
    _transparent = value;
  }

  @override
  bool hitTest(BoxHitTestResult result, {required Offset position}) {
    final hit = super.hitTest(result, position: position);
    return !transparent && hit;
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<bool>('transparent', transparent));
  }
}
