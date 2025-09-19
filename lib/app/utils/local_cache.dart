import 'dart:convert';

import '../config.dart';
import '../model/login_model.dart';
import 'storage_manage.dart';

class LocalCache {
  static Map<String, dynamic> cacheInfo() {
    final StorageManage storageManage = StorageManage();
    Map<String, dynamic> loginInfo = storageManage.read(Config.localStorageLoginInfo) ?? {};
    bool isLogin = storageManage.read(Config.localStorageHasLogin) ?? false;

    if (!isLogin || loginInfo.isEmpty) return {};

    LoginResult apiResult = LoginResult.fromJson(loginInfo);
    if ((apiResult.company ?? "").isEmpty || apiResult.dsn == null) {
      return {};
    }
    return {"Auth": base64.encode(utf8.encode(json.encode(loginInfo)))};
  }
}
