abstract interface class PersistenceProvider {
  bool get isCache;
  bool get isStable; // should be the opposite of is cache

  Future<bool> write(String objectKey, String encodedObject);

  Future<String?> readEncodedObject(String objectKey);

  Future<bool> remove(String objectKey);

  Future<Iterable<dynamic>> getKeys();
}
