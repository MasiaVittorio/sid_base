import 'package:flutter/material.dart';

class CleanProvider<T> extends StatefulWidget {
  const CleanProvider({
    super.key,
    required this.child,
    required this.data,
  });

  final Widget child;
  final T data;

  @override
  State<CleanProvider<T>> createState() => _CleanProviderState<T>();

  static T? of<T>(BuildContext context) {
    final _ProviderInherited<T>? provider = context
        .getElementForInheritedWidgetOfExactType<_ProviderInherited<T>>()
        ?.widget as _ProviderInherited<T>?;
    return provider?.data;
  }
}

class _CleanProviderState<T> extends State<CleanProvider<T>> {
  @override
  Widget build(BuildContext context) {
    return _ProviderInherited<T>(
      data: widget.data,
      child: widget.child,
    );
  }
}

class _ProviderInherited<T> extends InheritedWidget {
  const _ProviderInherited({
    super.key,
    required super.child,
    required this.data,
  });

  final T data;

  @override
  bool updateShouldNotify(_ProviderInherited oldWidget) => false;
}

class ProviderBuilder<T> extends StatefulWidget {
  const ProviderBuilder({
    super.key,
    required this.child,
    required this.onCreate,
    required this.onDispose,
  });

  final Widget child;
  final T Function() onCreate;
  final void Function(T value) onDispose;

  @override
  State<ProviderBuilder<T>> createState() => _ProviderBuilderState<T>();

  static T? of<T>(BuildContext context) {
    final _ProviderInherited<T>? provider = context
        .getElementForInheritedWidgetOfExactType<_ProviderInherited<T>>()
        ?.widget as _ProviderInherited<T>?;
    return provider?.data;
  }
}

class _ProviderBuilderState<T> extends State<ProviderBuilder<T>> {
  late T value = widget.onCreate();

  @override
  void dispose() {
    widget.onDispose(value);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _ProviderInherited<T>(
      data: value,
      child: widget.child,
    );
  }
}
