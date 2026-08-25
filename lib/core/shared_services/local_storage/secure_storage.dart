import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'i_local_storage.dart';

class SecureStorageService implements ILocalStorage {
  final FlutterSecureStorage _secureStorage;
  final Map<String, String> _cache = {};

  SecureStorageService({required FlutterSecureStorage secureStorage})
      : _secureStorage = secureStorage;

  @override
  Future<void> init() async {
    try {
      final allValues = await _secureStorage.readAll();
      _cache.addAll(allValues);
    } catch (_) {
      // Fallback if secure storage read fails during startup
    }
  }

  @override
  Future<void> write<T>(String key, T value) async {
    if (value is String) {
      _cache[key] = value;
      await _secureStorage.write(key: key, value: value);
    } else {
      throw ArgumentError('SecureStorageService only supports String values.');
    }
  }

  @override
  T? read<T>(String key) {
    final value = _cache[key];
    if (value == null) return null;
    if (value is T) {
      return value as T;
    }
    return null;
  }

  @override
  Future<void> delete(String key) async {
    _cache.remove(key);
    await _secureStorage.delete(key: key);
  }

  @override
  Future<void> deleteAll() async {
    _cache.clear();
    await _secureStorage.deleteAll();
  }

  @override
  Future<bool> containsKey(String key) async {
    return _cache.containsKey(key);
  }
}
