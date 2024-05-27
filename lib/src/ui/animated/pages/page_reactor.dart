import 'package:flutter/material.dart';

extension PageControllerSafe on PageController {
  bool get isSafe => hasClients && position.hasContentDimensions;
  double get safePage {
    if (isSafe) {
      if (page case final double page) {
        return page;
      }
    }
    return initialPage.toDouble();
  }
}

class SmoothPageReactor extends StatelessWidget {
  const SmoothPageReactor({
    super.key,
    required this.controller,
    this.child,
    required this.builder,
  });

  final PageController controller;
  final Widget? child;
  final Widget Function(
    BuildContext context,
    Widget? child,
    double page,
  ) builder;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      child: child,
      builder: (BuildContext context, Widget? child) {
        return builder(context, child, controller.safePage);
      },
    );
  }
}

class IntegerPageReactor extends StatefulWidget {
  const IntegerPageReactor({
    super.key,
    required this.controller,
    this.child,
    required this.builder,
  });

  final PageController controller;
  final Widget? child;
  final Widget Function(
    BuildContext context,
    Widget? child,
    int page,
  ) builder;

  @override
  State<IntegerPageReactor> createState() => _IntegerPageReactorState();
}

class _IntegerPageReactorState extends State<IntegerPageReactor> {
  late int page = widget.controller.safePage.round();

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(listener);
  }

  @override
  void dispose() {
    widget.controller.removeListener(listener);
    super.dispose();
  }

  void listener() {
    handleChange(widget.controller.safePage);
  }

  void handleChange(double newValue) {
    final int rounded = newValue.round();
    if (rounded != page) {
      setState(() {
        page = rounded;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return widget.builder(context, widget.child, page);
  }
}
