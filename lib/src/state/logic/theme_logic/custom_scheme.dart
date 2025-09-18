import 'dart:convert';

import 'package:flutter/material.dart';

class CustomScheme {
  final DynamicSchemeVariant dynamicSchemeVariant;
  final double contrastLevel; // from -1 to 1 included
  final Color seedColor;

  CustomScheme({
    required this.dynamicSchemeVariant,
    required this.contrastLevel,
    required this.seedColor,
  });

  ColorScheme getScheme(Brightness brightness) => ColorScheme.fromSeed(
    brightness: brightness,
    seedColor: seedColor,
    contrastLevel: contrastLevel,
    dynamicSchemeVariant: dynamicSchemeVariant,
  );

  CustomScheme copyWith({
    DynamicSchemeVariant? dynamicSchemeVariant,
    double? contrastLevel,
    Color? seedColor,
  }) {
    return CustomScheme(
      dynamicSchemeVariant: dynamicSchemeVariant ?? this.dynamicSchemeVariant,
      contrastLevel: contrastLevel ?? this.contrastLevel,
      seedColor: seedColor ?? this.seedColor,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'dynamicSchemeVariant': dynamicSchemeVariant.index,
      'contrastLevel': contrastLevel,
      'seedColor': seedColor.toARGB32(),
    };
  }

  factory CustomScheme.fromMap(Map<String, dynamic> map) {
    return CustomScheme(
      dynamicSchemeVariant:
          DynamicSchemeVariant.values[map['dynamicSchemeVariant']],
      contrastLevel: map['contrastLevel'] as double,
      seedColor: Color(map['seedColor']),
    );
  }

  String toJson() => json.encode(toMap());

  factory CustomScheme.fromJson(String source) =>
      CustomScheme.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() =>
      'CustomScheme(dynamicSchemeVariant: $dynamicSchemeVariant, contrastLevel: $contrastLevel, seedColor: $seedColor)';

  @override
  bool operator ==(covariant CustomScheme other) {
    if (identical(this, other)) return true;

    return other.dynamicSchemeVariant == dynamicSchemeVariant &&
        other.contrastLevel == contrastLevel &&
        other.seedColor == seedColor;
  }

  @override
  int get hashCode =>
      dynamicSchemeVariant.hashCode ^
      contrastLevel.hashCode ^
      seedColor.hashCode;
}
