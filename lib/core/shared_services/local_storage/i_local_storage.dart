abstract class ILocalStorage {
  Future<void> init();
  Future<void> write<T>(String key, T value);
  T? read<T>(String key);
  Future<void> delete(String key);
  Future<void> deleteAll();
  Future<bool> containsKey(String key);
}
