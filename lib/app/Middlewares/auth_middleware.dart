import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../routes/app_pages.dart';
import '../utils/local_cache.dart';

/* class AuthMiddleware extends GetMiddleware {
  @override
  Future<RouteDecoder?> redirectDelegate(RouteDecoder route) async {
    final localInfo = LocalCache.cacheInfo();
    if (localInfo.isEmpty && route.pageSettings?.name != Routes.SIGNIN) {
      showToast(LocaleKeys.logginInvalid.tr);
      /* if (kIsWeb) {
        return RouteDecoder.fromRoute(Routes.SIGNIN);
      } else { */
      await Future.delayed(Duration(seconds: 3), () => Get.offAllNamed(Routes.SIGNIN));
      return null;
      //}
    }
    return await super.redirectDelegate(route);
  }
}
 */
class AuthMiddleware extends GetMiddleware {
  @override
  RouteSettings? redirect(String? route) {
    final localInfo = LocalCache.cacheInfo();
    if (localInfo.isEmpty && route != Routes.SIGNIN) {
      return const RouteSettings(name: Routes.SIGNIN);
    }
    return null; // 正常放行
  }
}
