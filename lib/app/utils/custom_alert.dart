import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../translations/locale_keys.dart';

class CustomAlert {
  static iosAlert(String message, {void Function()? onConfirm, bool showCancel = false, String? confirmText}) {
    showCupertinoDialog(
      context: Get.context!,
      builder: (context) {
        return CupertinoAlertDialog(
          title: Text(LocaleKeys.systemMessage.tr),
          content: Text(message),
          actions: [
            if (showCancel)
              CupertinoDialogAction(
                child: Text(LocaleKeys.cancel.tr),
                onPressed: () {
                  Navigator.pop(context); // 关闭对话框
                },
              ),
            CupertinoDialogAction(
              onPressed: () {
                Navigator.pop(context);
                if (onConfirm != null) {
                  onConfirm.call();
                }
              },
              child: Text(confirmText ?? LocaleKeys.confirm.tr),
            ),
          ],
        );
      },
    );
  }
}
