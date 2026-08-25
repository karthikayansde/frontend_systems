import 'package:get_storage/get_storage.dart';
import 'i_local_storage.dart';

class LocalStorageService implements ILocalStorage {
  late final GetStorage _box;

  @override
  Future<void> init() async {
    await GetStorage.init();
    _box = GetStorage();
  }

  @override
  Future<void> write<T>(String key, T value) async => await _box.write(key, value);

  @override
  T? read<T>(String key) => _box.read<T>(key);

  @override
  Future<void> delete(String key) async => await _box.remove(key);

  @override
  Future<void> deleteAll() async => await _box.erase();

  @override
  Future<bool> containsKey(String key) async => _box.hasData(key);
}
