import 'package:flutter/material.dart';
import 'package:sid_base/sid_base.dart';

abstract class VarDetail<T> extends ValueDetail<T> {

  const VarDetail({
    super.key,
    required this.blocVar,
  });

  final Reactive<T> blocVar;
  
  @override
  void onSave(T newVal) => blocVar.update(newVal);
  
  @override
  Widget updater(Widget Function(BuildContext p1, T p2) builder) {
    return blocVar.build(builder);
  }
}

