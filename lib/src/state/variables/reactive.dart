import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'persistent_reactive.dart';

typedef ValueBuilder<T> = Widget Function(
  BuildContext context,
  T val,
);
typedef ChildValueBuilder<T> = Widget Function(
  BuildContext context,
  T val,
  Widget? child,
);

extension QuickReactive<T> on T {
  Reactive<T> get createReactive => Reactive(this);

  PersistentReactive<T> createPersistentReactive({required String key}) =>
      PersistentReactive<T>(this, key: key);
}

// remember to call dispose after using this
class Reactive<T> extends ChangeNotifier {
  T value;

  bool get isDisposed => _isDisposed;
  bool _isDisposed = false;

  final List<VoidCallback> _beforeDisposing = [];
  final bool Function(T, T)? equality;

  Reactive(
    this.value, {
    this.equality,
  });

  void beforeDisposing(VoidCallback callback) => _beforeDisposing.add(callback);

  @override
  void dispose() {
    for (final f in _beforeDisposing) {
      f.call();
    }
    _beforeDisposing.clear();
    _isDisposed = true;
    super.dispose();
  }

  @mustCallSuper
  bool update(T newValue, {bool distinct = true}) {
    if (distinct) {
      if (equality?.call(newValue, value) ?? (newValue == value)) return false;
    }
    value = newValue;
    notifyListeners();
    return true;
  }

  void refresh() {
    notifyListeners();
  }

  void edit(void Function(T value) editor) {
    editor(value);
    refresh();
  }

  Future<void> updateWithFuture(Future<T> Function() getValue) async {
    try {
      final T v = await getValue();
      update(v);
    } on Object catch (_) {}
  }

  Widget build(Widget Function(BuildContext context, T value) builder) {
    return AnimatedBuilder(
      animation: this,
      builder: (BuildContext context, _) {
        return builder(context, this.value);
      },
    );
  }

  // So that the child is not rebuilt every time
  Widget buildWithStaticChild({
    required Widget Function(BuildContext context, T value, Widget child) builder,
    required Widget child,
  }) {
    return AnimatedBuilder(
      animation: this,
      child: child,
      builder: (BuildContext context, Widget? c) {
        return builder(context, this.value, c!);
      },
    );
  }

  static Widget build2<A, B>(
    Reactive<A> a,
    Reactive<B> b, {
    required Widget Function(BuildContext context, A a, B b) builder,
  }) {
    return a.build((context, aV) => b.build((context, bV) => builder(context, aV, bV)));
  }

  static Widget build3<A, B, C>(
    Reactive<A> a,
    Reactive<B> b,
    Reactive<C> c, {
    required Widget Function(BuildContext context, A aVal, B bVal, C cVal) builder,
  }) {
    return a.build((context, aV) {
      return b.build((context, bV) {
        return c.build((context, cV) {
          return builder(context, aV, bV, cV);
        });
      });
    });
  }

  static Widget build4<A, B, C, D>(
    Reactive<A> a,
    Reactive<B> b,
    Reactive<C> c,
    Reactive<D> d, {
    required Widget Function(BuildContext context, A aVal, B bVal, C cVal, D dVal) builder,
  }) {
    return a.build((context, aV) {
      return b.build((context, bV) {
        return c.build((context, cV) {
          return d.build((context, dV) {
            return builder(context, aV, bV, cV, dV);
          });
        });
      });
    });
  }

  static Reactive<T> modal<T>({
    required T initVal,
    String? key,
    T Function(dynamic)? fromJsonDecoded,
    dynamic Function(T)? toJsonEncodable,
    Reactive<Map<String, bool>>? readCount,
    void Function(T)? readCallback,
    bool Function(T, T)? equals,
    // T Function(T)? copier,
  }) =>
      key != null
          ? PersistentReactive<T>(
              initVal,
              key: key,
              fromJsonDecoded: fromJsonDecoded,
              toJsonEncodable: toJsonEncodable,
              afterReading: readCallback,
              readCount: readCount,
              // copier: copier,
              equality: equals,
            )
          : Reactive<T>(
              initVal,
              // copier: copier,
              equality: equals,
            );
}
