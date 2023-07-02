import 'package:flutter/material.dart';

class Al extends StatelessWidget {

  const Al({
    super.key,
    required this.alignment,
    required this.child,
  });
  const Al.center({
    required this.child,
    super.key,
  }): alignment = Alignment.center;
  const Al.centerLeft({
    required this.child,
    super.key,
  }): alignment = Alignment.centerLeft;
  const Al.centerRight({
    required this.child,
    super.key,
  }): alignment = Alignment.centerRight;
  const Al.topCenter({
    required this.child,
    super.key,
  }): alignment = Alignment.topCenter;
  const Al.bottomCenter({
    required this.child,
    super.key,
  }): alignment = Alignment.bottomCenter;
  const Al.topLeft({
    required this.child,
    super.key,
  }): alignment = Alignment.topLeft;
  const Al.bottomLeft({
    required this.child,
    super.key,
  }): alignment = Alignment.bottomLeft;
  const Al.topRight({
    required this.child,
    super.key,
  }): alignment = Alignment.topRight;
  const Al.bottomRight({
    required this.child,
    super.key,
  }): alignment = Alignment.bottomRight;

  final Alignment alignment;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: alignment,
      child: child,
    );
  }
}