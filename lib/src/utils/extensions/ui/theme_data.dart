import 'package:flutter/material.dart';
import 'brightness.dart';

extension ElevatedSurface on ThemeData {
  
  Color elevatedSurface([double elevation = 2]) 
    => ElevationOverlay.applySurfaceTint(
      colorScheme.surface, 
      colorScheme.surfaceTint, 
      elevation * 2,
    );
}


extension ThemeDataSid on ThemeData {

  bool get isLight => brightness.isLight;
  bool get isDark => brightness.isDark;

}

