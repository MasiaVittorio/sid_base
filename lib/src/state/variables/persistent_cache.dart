import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:sid_base/src/state/persistence/base/persitence.dart';
import 'package:sid_base/src/state/persistence/local/hive/hive_persistence.dart';

class PersistentCache<T> {
  PersistentCache({
    required this.baseKey,
    required this.getFunction,
    this.fromJsonDecoded,
    this.toJsonEncodable,
    this.persistenceProvider = const HivePersistence(),
  });

  final String baseKey;
  final T Function(dynamic jsonDecoded)? fromJsonDecoded;
  final dynamic Function(T)? toJsonEncodable;
  bool finishedReading = false;
  final PersistenceProvider persistenceProvider;
  final Future<T?> Function(String objectKey) getFunction;

  Future<T?> readOrGet(
    String objectKey,
  ) async {
    final T? cached = await read(objectKey);
    if (cached case T value) return value;
    final T? object = await getFunction(objectKey);
    if (object case T object) {
      write(objectKey, object);
    }
    return object;
  }

  Future<T?> read(String objectKey) async {
    try {
      final String key = k(objectKey);
      final String? source = await persistenceProvider.readEncodedObject(key);
      if (_v) debugPrint('key $key, reading $source');
      if (source == null) return null;
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
          return value;
        } else {
          if (_v) debugPrint("after reading updating without value");
        }
      }
    } catch (_) {}
    return null;
  }

  Map<String, dynamic> toMap(T object) {
    return <String, dynamic>{
      "value": toJsonEncodable?.call(object) ?? object,
    };
  }

  void write(String objectKey, T object) async {
    try {
      final String key = k(objectKey);
      final line = jsonEncode(toMap(object));
      if (_v) debugPrint('key $key, writing $line');
      persistenceProvider.write(key, line);
    } catch (_) {}
  }

  String k(String objectKey) => baseKey + objectKey;
  static bool get _v => false;
}
