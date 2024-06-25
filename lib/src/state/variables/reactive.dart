import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:sid_base/src/state/persistence/base/persitence.dart';
import 'package:sid_base/src/state/persistence/local/hive/hive_persistence.dart';

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

class PersistentReactive<T> extends Reactive<T> {
  PersistentReactive(
    super.value, {
    required this.key,
    this.fromJsonDecoded,
    this.toJsonEncodable,
    super.equality,
    void Function(T)? afterReading,
    this.persistenceProvider = const HivePersistence(),
    Reactive<Map<String, bool>>? readCount,
  }) : super() {
    if (afterReading != null) _afterReading.add(() => afterReading(value));

    if (readCount != null) {
      readCount.value[this.key] = false;
      readCount.refresh();
      _afterReading.add(() {
        readCount.value[this.key] = true;
        readCount.refresh();
      });
    }

    _read();
  }

  final String key;
  final T Function(dynamic jsonDecoded)? fromJsonDecoded;
  final dynamic Function(T)? toJsonEncodable;
  final List<VoidCallback> _afterReading = <VoidCallback>[];
  bool finishedReading = false;
  final PersistenceProvider persistenceProvider;

  @override
  bool update(T newValue, {bool distinct = true}) {
    if (_v) debugPrint("updating with $newValue");
    final bool result = super.update(newValue, distinct: distinct);
    _write();
    return result;
  }

  @override
  void refresh() {
    super.refresh();
    _write();
  }

  void accessAfterReading(void Function(T value) onValue) {
    void callback() {
      return onValue(value);
    }

    if (finishedReading) {
      callback.call();
    } else {
      _afterReading.add(callback);
    }
  }

  void _read() async {
    await __read();
    finishedReading = true;
    for (final callback in _afterReading) {
      callback.call();
    }
    _afterReading.clear();
  }

  Future<void> __read() async {
    try {
      final String? source = await persistenceProvider.readEncodedObject(key);
      if (_v) debugPrint('key $key, reading $source');
      if (source == null) return;
      final Object? jsonDecodedMap = jsonDecode(source);
      if (_v) debugPrint('key $key, decodedMap type ${jsonDecodedMap.runtimeType}');

      if (jsonDecodedMap case {'value': final Object? valueJsonDecoded}) {
        if (_v) debugPrint('key $key, valueJsonDecoded $valueJsonDecoded');

        T? value;

        if (valueJsonDecoded == null) {
          value = null;
        }
        final fromJsonDecoded = this.fromJsonDecoded;
        if (fromJsonDecoded == null) {
          if (valueJsonDecoded is T) {
            value = valueJsonDecoded;
          }
        } else {
          value = fromJsonDecoded(valueJsonDecoded);
        }

        if (value is T) {
          if (_v) debugPrint("after reading updating with value");
          this.update(value);
        } else {
          if (_v) debugPrint("after reading updating without value");
        }
      }

      // ignore: avoid_catches_without_on_clauses
    } catch (_) {}
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      "value": toJsonEncodable?.call(value) ?? value,
    };
  }

  void _write() async {
    try {
      final line = jsonEncode(toMap());
      if (_v) debugPrint('key $key, writing $line');
      persistenceProvider.write(key, line);
      // ignore: avoid_catches_without_on_clauses
    } catch (_) {}
  }
}

bool get _v => false;
