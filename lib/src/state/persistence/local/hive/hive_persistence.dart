import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../../base/persitence.dart';

bool get _v => false;

class HivePersistence implements PersistenceProvider {
  const HivePersistence({
    this.boxName = "Hive Persistence Box",
  });

  static bool _initialized = false;
  Future<void> init() async {
    if (!_initialized) {
      if (_v) debugPrint("initializing Hive persistence");
      await Hive.initFlutter();
      if (_v) debugPrint("Hive persistence initialized");
      _initialized = true;
      return;
    } else {
      if (_v) debugPrint("Hive persistence already initialized");
    }
    return;
  }

  @override
  bool get isCache => false;
  @override
  bool get isStable => true;

  final String boxName;

  @override
  Future<String?> readEncodedObject(String objectKey) async {
    await init();
    final LazyBox<String> box = await Hive.openLazyBox<String>(boxName);
    final String? result = await box.get(objectKey);
    return result;
  }

  @override
  Future<bool> write(String objectKey, String encodedObject) async {
    await init();
    try {
      if (_v) debugPrint("hive writing key $objectKey value $encodedObject");
      final LazyBox<String> box = await Hive.openLazyBox<String>(boxName);
      box.put(objectKey, encodedObject);
      return true;
      // ignore: empty_catches
    } catch (e) {}
    return false;
  }

  @override
  Future<bool> remove(String objectKey) async {
    await init();
    try {
      if (_v) debugPrint("hive removing key $objectKey");
      final LazyBox<String> box = await Hive.openLazyBox<String>(boxName);
      box.delete(objectKey);
      return true;
      // ignore: empty_catches
    } catch (e) {}
    return false;
  }

  @override
  Future<Iterable<dynamic>> getKeys() async {
    await init();
    try {
      if (_v) debugPrint("hive getting keys");
      final LazyBox<String> box = await Hive.openLazyBox<String>(boxName);
      return box.keys;
      // ignore: empty_catches
    } catch (e) {}
    return [];
  }

  void dispose() async {
    await init();
    final box = await Hive.openLazyBox(boxName);
    box.compact();
    box.close();
  }
}
