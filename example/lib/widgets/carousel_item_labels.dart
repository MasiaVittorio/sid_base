// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:flutter/material.dart';
import 'package:sid_base/sid_base.dart';

class CarouselItemLabels extends StatelessWidget {
  const CarouselItemLabels({
    super.key,
    required this.title,
    required this.label,
  });

  final String? title;
  final String? label;

  @override
  Widget build(BuildContext context) {
    return Al.bottomCenter(
      child: Pad(
        bottom: 12,
        horizontal: 16,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            if (title case String title)
              Text(
                title,
                textAlign: TextAlign.center,
                style: context.theme.textTheme.titleLarge!.copyWith(color: Colors.white),
              ),
            if (label case String label)
              Text(
                label,
                textAlign: TextAlign.center,
                style: context.theme.textTheme.bodyMedium!.copyWith(color: Colors.white),
              ),
          ].separateWith(const Space.vertical(2)),
        ),
      ),
    );
  }
}
