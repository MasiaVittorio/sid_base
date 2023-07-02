import 'package:flutter/foundation.dart';

import '../../base/persitence.dart';
import 'package:hive_flutter/hive_flutter.dart';

bool get _v => false;

class HivePersistence implements PersistenceProvider {
  const HivePersistence();

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

  static const String boxName = "Hive Persistence Box";

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

  void dispose() async {
    await init();
    final box = await Hive.openLazyBox(boxName);
    box.compact();
    box.close();
  }
}
