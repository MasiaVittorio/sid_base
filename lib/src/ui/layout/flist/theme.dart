import 'package:flutter/material.dart';
import 'package:sid_base/sid_base.dart';

class FlistTheme {
  const FlistTheme();
  double get firstPadding => 16;
  double get lastPadding => 16;
  double get inBetweenPadding => 8;

  BorderRadius get borderRadius => BorderRadius.circular(24);
  double get thin => 8;
  double get large => 224;
  double get smallMin => 48;
  double get smallMax => 48;

  double howManyLarges(double mainAxisSize) {
    final double available = mainAxisSize - firstPadding - lastPadding - small(mainAxisSize);
    return (available / (large + inBetweenPadding)).floorToDouble();
  }

  // first + large + inb + --- + inb + small + last
  double small(double mainAxisSize) {
    final double available = mainAxisSize -
        firstPadding -
        large -
        inBetweenPadding -
        inBetweenPadding -
        smallMax -
        lastPadding;
    if (available.mod((large + inBetweenPadding)) > smallMax) {
      return smallMax;
    }
    return smallMin;
  }

  // double opening(int index, double position, double mainAxisSize) {
  //   // sono aperto se tutti i larghi prima di me sono stati scorsi fino a farmi entrare nella zona full larga
  //   final double fullLargeZone =
  //       firstPadding + (large + inBetweenPadding) * howManyLarges(mainAxisSize);

  //   final double spaceTakenByLargesBeforeMe = index * (large + inBetweenPadding) + firstPadding;
  //   final double spaceTakenUpToMeAsLarge = spaceTakenByLargesBeforeMe + large + inBetweenPadding;

  //   if (spaceTakenUpToMeAsLarge - position < fullLargeZone) return 1;

  //   final flexZone = mainAxisSize - fullLargeZone;
  //   final double spaceTakenByLargesBeforeBefore =
  //       spaceTakenByLargesBeforeMe - large - inBetweenPadding;
  //   // if(spaceTakenByLargesBeforeBefore - position)

  //   // return (fullLargeZone + position).mapToRange(
  //   //   0,
  //   //   1,
  //   //   fromMax: spaceTakenByLargesBeforeMe
  //   // );
  // }
}
