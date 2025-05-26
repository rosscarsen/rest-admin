import 'dart:convert';

import '../config.dart';
import '../model/login_model.dart';
import 'stroage_manage.dart';

class LocalCache {
  static Map<String, dynamic> cacheInfo() {
    final StorageManage storageManage = StorageManage();
    Map<String, dynamic> loginInfo = storageManage.read(Config.localStroageloginInfo) ?? {};
    bool isLogin = storageManage.read(Config.localStroagehasLogin) ?? false;

    if (!isLogin || loginInfo.isEmpty) return {};

    UserData userData = UserData.fromJson(loginInfo);
    if ((userData.company ?? "").isEmpty || userData.dsn == null) {
      return {};
    }
    return {"Auth": base64.encode(utf8.encode(json.encode(loginInfo)))};
  }
}
