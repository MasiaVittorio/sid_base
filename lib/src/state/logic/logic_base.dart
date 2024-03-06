import 'package:flutter/material.dart';

abstract class LogicBase {
  @mustCallSuper
  void dispose() {
    _mounted = false;
  }

  bool get mounted => _mounted;
  bool _mounted = true;
}
