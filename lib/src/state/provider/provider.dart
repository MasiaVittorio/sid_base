import 'package:flutter/material.dart';


class CleanProvider<T> extends StatefulWidget {
  const CleanProvider({
    Key? key,
    required this.child,
    required this.data,
  }): super(key: key);

  final Widget child;
  final T data;

  @override
  State<CleanProvider<T>> createState() => _CleanProviderState<T>();

  static T? of<T>(BuildContext context){
    final _ProviderInherited<T>? provider = context
      .getElementForInheritedWidgetOfExactType<_ProviderInherited<T>>()
      ?.widget as _ProviderInherited<T>?;
    return provider?.data;
  }
}

class _CleanProviderState<T> extends State<CleanProvider<T>>{
  
  @override
  Widget build(BuildContext context){
    return _ProviderInherited<T>(
      data: widget.data,
      child: widget.child,
    );
  }
}

class _ProviderInherited<T> extends InheritedWidget {
  const _ProviderInherited({
    Key? key,
    required Widget child,
    required this.data,
  }) : super(key: key, child: child);

  final T data;

  @override
  bool updateShouldNotify(_ProviderInherited oldWidget) => false;
}