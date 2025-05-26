import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

import '../config.dart';
import '../routes/app_pages.dart';
import '../utils/stroage_manage.dart';

class AuthService extends GetxService {
  static AuthService get to => Get.find();
  final StorageManage storageManage = StorageManage();
  Timer? _authCheckTimer;

  var hasLogin = false.obs;

  @override
  void onReady() {
    _checkAuthStatus();
    _startAuthCheckTimer();
    super.onReady();
  }

  Future<void> _checkAuthStatus() async {
    hasLogin.value =
        (storageManage.read(Config.localStroagehasLogin) ?? false) &&
        (storageManage.read(Config.localStroageloginInfo) != null);

    if (!hasLogin.value && Get.currentRoute != Routes.SIGNIN) {
      Get.offAllNamed(Routes.SIGNIN);
    }
  }

  void _startAuthCheckTimer() {
    ever(hasLogin, (value) {
      _authCheckTimer?.cancel();
      if (!value && Get.currentRoute != Routes.SIGNIN) {
        Get.offAllNamed(Routes.SIGNIN);
      } else {
        _authCheckTimer = Timer.periodic(const Duration(seconds: 5), (timer) {
          debugPrint('auth check timer');
          _checkAuthStatus();
        });
      }
    });
  }

  @override
  void onClose() {
    _authCheckTimer?.cancel();
    super.onClose();
  }
}
