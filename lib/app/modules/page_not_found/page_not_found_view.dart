import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../../config.dart';
import '../../routes/app_pages.dart';
import '../../translations/locale_keys.dart';
import '../../utils/storage_manage.dart';
import 'page_not_found_controller.dart';

class PageNotFoundView extends GetView<PageNotFoundController> {
  const PageNotFoundView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      extendBodyBehindAppBar: true,
      body: SafeArea(
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            spacing: 20.0,
            children: [
              Text(LocaleKeys.pageNotFound.tr, style: TextStyle(fontSize: 20)),
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.orange, foregroundColor: Colors.white),
                onPressed: () {
                  final StorageManage storageManage = StorageManage();
                  bool hasLogin =
                      (storageManage.read(Config.localStorageHasLogin) ?? false) &&
                      (storageManage.read(Config.localStorageLoginInfo) != null);
                  if (hasLogin) {
                    Get.offAllNamed(Routes.DASHBOARD);
                  } else {
                    Get.offAllNamed(Routes.SIGNIN);
                  }
                },
                child: Text(LocaleKeys.back.tr),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
