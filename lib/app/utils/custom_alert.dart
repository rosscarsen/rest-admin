import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../translations/locale_keys.dart';

class CustomAlert {
  static Future<void> iosAlert(
    String message, {
    void Function()? onConfirm,
    void Function()? onCancel,
    bool showCancel = false,
    String? confirmText,
    String? cancelText,
  }) {
    return showCupertinoDialog(
      context: Get.context!,
      builder: (context) {
        return CupertinoAlertDialog(
          title: Text(LocaleKeys.systemMessage.tr),
          content: Text(message),
          actions: [
            if (showCancel)
              CupertinoDialogAction(
                child: Text(cancelText ?? LocaleKeys.cancel.tr),
                onPressed: () {
                  Navigator.pop(context); // 关闭对话框
                  if (onCancel != null) {
                    onCancel.call();
                  }
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
