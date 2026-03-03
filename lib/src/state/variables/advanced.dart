import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:sid_base/src/state/persistence/base/persitence.dart';
import 'package:sid_base/src/state/persistence/local/hive/hive_persistence.dart';

extension QuickAdvanced<T> on T? {
  AdvancedReactive<T> get createAdvancedReactive {
    final T? v = this;
    return v == null ? AdvancedReactive.empty() : AdvancedReactive.initial(v);
  }

  PersistentAdvancedReactive<T> createPersistentAdvancedReactive({
    required String key,
  }) {
    final T? v = this;
    return v == null
        ? PersistentAdvancedReactive<T>.empty(key: key)
        : PersistentAdvancedReactive<T>.initial(v, key: key);
  }
}

// remember to call dispose after using this
class AdvancedReactive<T> extends ChangeNotifier {
  T? _value;
  // must be updated every time because T might be nullable anyway and that has to be seen as a value
  bool _hasValue;
  String? _error;

  bool get hasError {
    final String? e = _error;
    return e != null && e.isNotEmpty;
  }

  bool get hasValidValue => (!hasError) && _hasValue;
  bool get isEmpty => (!_hasValue) && (!hasError);

  AdvancedReactive.initial(T value) : _hasValue = true, _value = value;

  AdvancedReactive.empty() : _hasValue = false, _value = null;

  AdvancedReactive.error(String error) : _hasValue = false, _error = error;

  @mustCallSuper
  void updateWithValue(T newValue, {bool distinct = true, bool notify = true}) {
    if (newValue == _value) {}
    if (distinct && newValue == _value && _hasValue && _error == null) return;
    if (newValue == _value) {}
    _hasValue = true;
    _error = null;
    _value = newValue;
    if (notify) notifyListeners();
  }

  @mustCallSuper
  void updateWithError(String newError, {bool notify = true}) {
    _error = newError;
    _hasValue = false;
    // _value = null; // leave the previous value be
    if (notify) notifyListeners();
  }

  // useful for reading storage
  @mustCallSuper
  void updateWithErrorAndValue(
    String newError,
    T? alsoValue, {
    bool notify = true,
  }) {
    _error = newError;
    _value = alsoValue;
    _hasValue = false;
    if (notify) notifyListeners();
  }

  @mustCallSuper
  void updateWithEmpty({bool notify = true}) {
    _hasValue = false;
    _value = null;
    _error = null;
    if (notify) notifyListeners();
  }

  Future<T?> updateWithFuture(
    Future<T> Function() getValue, {
    bool notify = true,
    bool distinct = true,
  }) async {
    try {
      final T v = await getValue();
      updateWithValue(v, notify: notify, distinct: distinct);
      return v;
    } on Object catch (e) {
      if (e is String) {
        updateWithError(e, notify: notify);
        return null;
      } else if (e is Error) {
        updateWithError(e.toString(), notify: notify);
        return null;
      } else {
        updateWithError("Unknown error", notify: notify);
        return null;
      }
    }
  }

  A access<A>({
    required A Function() onEmpty,
    required A Function(T value) onValue,
    required A Function(String error) onError,
  }) {
    if (hasValidValue) {
      final T? v = _value;
      if (null is T) {
        return onValue(v as T);
      } else {
        if (v != null) {
          return onValue(v);
        }
      }
    }
    final String? e = _error;
    if (e != null && e.isEmpty) {
      onError(e);
    }
    return onEmpty();
  }

  T? accessSimple() {
    return _value;
  }

  Widget build({
    required Widget Function() onEmpty,
    required Widget Function(String error) onError,
    required Widget Function(T value) onValue,
  }) {
    return AnimatedBuilder(
      animation: this,
      builder: (_, Widget? c) {
        return access<Widget>(
          onEmpty: () => onEmpty(),
          onValue: (T value) => onValue(value),
          onError: (String error) => onError(error),
        );
      },
    );
  }

  // So that the child is not rebuilt every time
  Widget buildWithStaticChild({
    required Widget Function(Widget child) onEmpty,
    required Widget Function(T value, Widget child) onValue,
    required Widget Function(String error, Widget child) onError,
    required Widget child,
  }) {
    return AnimatedBuilder(
      animation: this,
      child: child,
      builder: (_, Widget? c) {
        return access<Widget>(
          onEmpty: () => onEmpty(c!),
          onValue: (T value) => onValue(value, c!),
          onError: (String error) => onError(error, c!),
        );
      },
    );
  }

  Widget buildSimple(Widget Function(T? valueOrNull) builder) {
    return AnimatedBuilder(
      animation: this,
      builder: (_, _) => builder(accessSimple()),
    );
  }

  Widget buildSimpleWithStaticChild({
    required Widget child,
    required Widget Function(T? valueOrNull, Widget child) builder,
  }) {
    return AnimatedBuilder(
      animation: this,
      child: child,
      builder: (_, Widget? c) => builder(accessSimple(), c!),
    );
  }
}

bool get _v => false; // verbose

class PersistentAdvancedReactive<T> extends AdvancedReactive<T> {
  PersistentAdvancedReactive.initial(
    super.value, {
    required this.key,
    this.fromJsonDecoded,
    this.toJsonEncodable,
    this.persistenceProvider = const HivePersistence(),
  }) : super.initial() {
    _read();
  }

  PersistentAdvancedReactive.error(
    super.error, {
    required this.key,
    this.fromJsonDecoded,
    this.toJsonEncodable,
    this.persistenceProvider = const HivePersistence(),
  }) : super.error() {
    _read();
  }

  PersistentAdvancedReactive.empty({
    required this.key,
    this.fromJsonDecoded,
    this.toJsonEncodable,
    this.persistenceProvider = const HivePersistence(),
  }) : super.empty() {
    _read();
  }

  final String key;
  final T Function(dynamic jsonDecoded)? fromJsonDecoded;
  final dynamic Function(T)? toJsonEncodable;
  final List<VoidCallback> _afterReading = <VoidCallback>[];
  bool finishedReading = false;
  final PersistenceProvider persistenceProvider;

  @override
  void updateWithEmpty({bool write = true, bool notify = true}) {
    super.updateWithEmpty(notify: notify);
    if (write) _write();
  }

  @override
  void updateWithError(
    String newError, {
    bool write = true,
    bool notify = true,
  }) {
    super.updateWithError(newError, notify: notify);
    if (write) _write();
  }

  @override
  void updateWithValue(
    T newValue, {
    bool distinct = true,
    bool write = true,
    bool notify = true,
  }) {
    final bool same = newValue == _value;
    super.updateWithValue(newValue, distinct: distinct, notify: notify);
    if (same && distinct) return;
    if (write) _write();
  }

  @override
  Future<T?> updateWithFuture(
    Future<T> Function() getValue, {
    bool notify = true,
    bool distinct = true,
    bool write = true,
  }) async {
    final result = await super.updateWithFuture(
      getValue,
      notify: notify,
      distinct: distinct,
    );
    if (write) _write();
    return result;
  }

  @override
  void updateWithErrorAndValue(
    String newError,
    T? alsoValue, {
    bool notify = true,
    bool write = true,
  }) {
    super.updateWithErrorAndValue(newError, alsoValue, notify: notify);
    if (write) _write();
  }

  void accessAfterReading({
    required void Function() onEmpty,
    required void Function(T value) onValue,
    required void Function(String error) onError,
  }) {
    callback() {
      if (hasValidValue) {
        final T? v = _value;
        if (v != null) {
          return onValue(v);
        }
      }
      if (hasError) {
        final String? e = _error;
        if (e != null && e.isEmpty) {
          onError(e);
        }
      }
      return onEmpty();
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
      if (_v) {
        debugPrint('key $key, decodedMap type ${jsonDecodedMap.runtimeType}');
      }

      if (jsonDecodedMap case {
        'value': final Object? valueJsonDecoded,
        'hasValue': final bool hasValue,
        'error': final String? error,
      }) {
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

        if (error != null && error.isNotEmpty) {
          updateWithErrorAndValue(error, value, write: false);
        } else {
          if (value is T && (hasValue)) {
            if (_v) debugPrint("after reading updating with value");
            updateWithValue(value, write: false);
          } else {
            if (_v) debugPrint("after reading updating with empty");
            updateWithEmpty(write: false);
          }
        }
      }

      // ignore: avoid_catches_without_on_clauses
    } catch (_) {
      updateWithError("Erorr reading from storage", write: false);
      return;
    }
  }

  Map<String, dynamic> toMap() {
    final bool hasValue = _hasValue;
    final T? value = _value;
    final String? error = _error;
    return <String, dynamic>{
      "value": value == null ? null : toJsonEncodable?.call(value) ?? value,
      "error": error,
      "hasValue": hasValue,
    };
  }

  void _write() async {
    try {
      final line = jsonEncode(toMap());
      if (_v) debugPrint('key $key, writing $line');
      persistenceProvider.write(key, line);
      // ignore: avoid_catches_without_on_clauses
    } catch (_) {
      updateWithError("Erorr writing on storage", write: true);
      return;
    }
  }
}
