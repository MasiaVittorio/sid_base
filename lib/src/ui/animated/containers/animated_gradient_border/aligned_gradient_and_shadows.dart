import 'package:flutter/material.dart';

class AlignedGradientAndShadows extends StatelessWidget {
  const AlignedGradientAndShadows({
    super.key,
    required this.radius,
    required this.colorA,
    required this.colorB,
    required this.cornerA,
    required this.cornerB,
  });

  final Radius radius;
  final Color colorA;
  final Color colorB;
  final Alignment cornerA;
  final Alignment cornerB;

  @override
  Widget build(BuildContext context) {
    final borderRadius = BorderRadius.all(radius);

    return Stack(
      children: [
        Positioned.fill(
          child: Container(
            decoration: BoxDecoration(
              borderRadius: borderRadius,
              boxShadow: [
                BoxShadow(
                  color: colorA.withOpacity(0.3),
                  offset: Offset.zero,
                  blurRadius: 30,
                  spreadRadius: 1,
                ),
              ],
            ),
          ),
        ),
        Positioned.fill(
          child: Align(
            alignment: cornerB,
            child: FractionallySizedBox(
              widthFactor: 0.95,
              heightFactor: 0.95,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: borderRadius,
                  boxShadow: [
                    BoxShadow(
                      color: colorB.withOpacity(0.3),
                      offset: Offset.zero,
                      blurRadius: 30,
                      spreadRadius: 1,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        Positioned.fill(
          child: Container(
            decoration: BoxDecoration(
              borderRadius: borderRadius,
              gradient: LinearGradient(
                colors: [colorA, colorB],
                begin: cornerA,
                end: cornerB,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
