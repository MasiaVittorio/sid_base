import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:sid_base/src/state/persistence/base/persitence.dart';
import 'package:sid_base/src/state/persistence/local/hive/hive_persistence.dart';
import 'package:sid_base/src/state/variables/reactive.dart';

class PersistentReactive<T> extends Reactive<T> {
  PersistentReactive(
    super.value, {
    required this.key,
    this.fromJsonDecoded,
    this.toJsonEncodable,
    super.equality,
    void Function(T)? afterReading,
    this.persistenceProvider = const HivePersistence(),
    this.verbose = false,
    Reactive<Map<String, bool>>? readCount,
  }) : super() {
    if (afterReading != null) _afterReading.add(() => afterReading(value));

    if (readCount != null) {
      readCount.value[key] = false;
      readCount.refresh();
      _afterReading.add(() {
        readCount.value[key] = true;
        readCount.refresh();
      });
    }

    _read();
  }

  final bool verbose;
  final String key;
  final T Function(dynamic jsonDecoded)? fromJsonDecoded;
  final dynamic Function(T value)? toJsonEncodable;
  final List<VoidCallback> _afterReading = <VoidCallback>[];
  bool finishedReading = false;
  final PersistenceProvider persistenceProvider;

  @override
  bool update(T newValue, {bool distinct = true}) {
    if (verbose) debugPrint("updating with $newValue");
    final bool result = super.update(newValue, distinct: distinct);
    _write();
    return result;
  }

  Future<bool> asyncUpdate(T newValue, {bool distinct = true}) async {
    if (verbose) debugPrint("updating with $newValue");
    final bool result = super.update(newValue, distinct: distinct);
    await _write();
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
      if (verbose) debugPrint('key $key, reading $source');
      if (source == null) return;
      final Object? jsonDecodedMap = jsonDecode(source);
      if (verbose) {
        debugPrint('key $key, decodedMap type ${jsonDecodedMap.runtimeType}');
      }

      if (jsonDecodedMap case {'value': final Object? valueJsonDecoded}) {
        if (verbose) debugPrint('key $key, valueJsonDecoded $valueJsonDecoded');

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
          if (verbose) debugPrint("after reading updating with value");
          update(value);
        } else {
          if (verbose) debugPrint("after reading updating without value");
        }
      }

      // ignore: avoid_catches_without_on_clauses
    } catch (error) {
      if (verbose) debugPrint("key $key error: $error");
    }
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{"value": toJsonEncodable?.call(value) ?? value};
  }

  Future<void> _write() async {
    if (verbose) debugPrint('writing $key');
    try {
      final line = jsonEncode(toMap());
      if (verbose) debugPrint('key $key, writing $line');
      persistenceProvider.write(key, line);
      // ignore: avoid_catches_without_on_clauses
    } catch (e) {
      if (verbose) debugPrint('error writing key $key, error: $e');
    }
  }
}
