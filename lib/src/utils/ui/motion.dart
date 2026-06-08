import 'package:flutter/material.dart';

/// taken from https://m3.material.io/styles/motion/easing-and-duration/tokens-specs#ed7ab8eb-9b9a-40a3-806f-a4485558f3df

class Easings {
  const Easings._();

  static final a = Durations.medium1;

  // begin and end on screen: 500ms (long2)
  static const Curve emphasized = Curves.easeInOutCubicEmphasized;

  // enter the screen: 400ms (medium4)
  static const Curve emphasizedDecelerate = Easing.emphasizedDecelerate;

  // exit the screen: 200ms (short4)
  static const Curve emphasizedAccelerate = Easing.emphasizedAccelerate;

  // begin and end on screen: 300ms (medium2)
  static const Curve standard = Easing.standard;

  // enter the screen: 250ms (medium1)
  static const Curve standardDecelerate = Easing.standardDecelerate;

  // exit the screen: 200ms (short4)
  static const Curve standardAccelerate = Easing.standardAccelerate;
}

typedef CurveDurationPair = ({Curve curve, Duration duration});

class Motion {
  static const beginAndEndOnScreenEmphasized = (
    curve: Easings.emphasized,
    duration: Durations.long2,
  );

  static const enterScreenEmphasized = (
    curve: Easings.emphasizedDecelerate,
    duration: Durations.medium4,
  );

  static const exitScreenEmphasized = (
    curve: Easings.emphasizedAccelerate,
    duration: Durations.short4,
  );

  static const beginAndEndOnScreenStandard = (
    curve: Easings.standard,
    duration: Durations.medium2,
  );

  static const enterScreenStandard = (
    curve: Easings.standardDecelerate,
    duration: Durations.medium1,
  );

  static const exitScreenStandard = (
    curve: Easings.standardAccelerate,
    duration: Durations.short4,
  );
}
