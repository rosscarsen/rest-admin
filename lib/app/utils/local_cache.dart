import '../config.dart';
import '../model/login/login_model.dart';
import 'storage_manage.dart';

class LocalCache {
  static LoginResult? cacheInfo() {
    final StorageManage storageManage = StorageManage();
    final loginInfo = storageManage.read(Config.localStorageLoginInfo);
    bool isLogin = storageManage.read(Config.localStorageHasLogin) ?? false;

    if (!isLogin || loginInfo == null) return null;

    final LoginResult apiResult = LoginResult.fromJson(loginInfo);

    if ((apiResult.company?.isEmpty ?? true) || apiResult.dsn == null) {
      return null;
    }
    return apiResult;
  }
}
