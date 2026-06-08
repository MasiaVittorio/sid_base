import 'package:flutter/material.dart';
import 'package:sid_base/sid_base.dart';

extension ColorToHex on Color {
  static String _pad(int val) => val.toRadixString(16).padLeft(2, '0');
  String get hexString =>
      "${_pad(red8Bit)}${_pad(green8Bit)}${_pad(blue8Bit)}".toUpperCase();
  String get alphaHexString => "${_pad(alpha8Bit)}$hexString".toUpperCase();
}
