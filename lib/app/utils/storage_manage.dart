import 'package:get_secure_storage/get_secure_storage.dart';

class StorageManage {
  static final StorageManage _instance = StorageManage._internal();
  static const String container = "RestAdmin";
  static const String password = "pericles";

  late final GetSecureStorage _box;

  StorageManage._internal() {
    _box = GetSecureStorage(container: container, password: password);
  }

  static Future<void> init() async {
    await GetSecureStorage.init(container: container, password: password);
  }

  factory StorageManage() => _instance;
  // 存储加密数据时，传入的值是一个 Map，包含原始类型信息
  Future<void> write(String key, dynamic value) async {
    return await _box.write(key, value);
  }

  dynamic read(String key) {
    return _box.read(key);
  }

  Future<void> remove(String key) async {
    await _box.remove(key);
  }

  Future<void> erase() async {
    await _box.erase();
  }

  bool hasData(String key) {
    return _box.hasData(key);
  }

  /// 获取全部数据
  Map<String, dynamic> getAllData() {
    final allData = <String, dynamic>{};
    final allKeys = _box.getKeys();
    for (var key in allKeys) {
      final value = _box.read(key);
      allData[key] = value;
    }
    return allData;
  }
}
