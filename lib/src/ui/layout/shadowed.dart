import 'package:flutter/material.dart';

extension ShadowedWidget on Widget {
  Widget shadowed({Color? materialBodyColor}) => Shadowed(
        materyalBodyColor: materialBodyColor,
        child: this,
      );
}

class Shadowed extends StatelessWidget {
  final Widget child;
  final Color? materyalBodyColor;
  const Shadowed({
    super.key,
    required this.child,
    this.materyalBodyColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(boxShadow: <BoxShadow>[
        BoxShadow(
          color: Color(0x6F000000),
          spreadRadius: 0.0,
          blurRadius: 5.8,
          offset: Offset(0, 2),
        )
      ]),
      child: Material(
        color: materyalBodyColor,
        child: child,
      ),
    );
  }
}
