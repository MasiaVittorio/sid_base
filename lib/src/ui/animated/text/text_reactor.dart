import 'package:flutter/material.dart';

class TextReactor extends StatelessWidget {

  const TextReactor({
    Key? key,
    required this.controller,
    this.child,
    required this.builder,
  }) : super(key: key);

  final TextEditingController controller;
  final Widget? child;
  final Widget Function(BuildContext context, Widget? child, String text) builder;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: controller, 
      child: child,
      builder: (context, value, child) {
        return builder(context, child, value.text);
      },
    );
  }
}

