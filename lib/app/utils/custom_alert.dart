import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../translations/locale_keys.dart';

class CustomAlert {
  static Future<void> iosAlert({
    required Object message,
    void Function()? onConfirm,
    void Function()? onCancel,
    bool showCancel = false,
    String? confirmText,
    String? cancelText,
    Widget? body,
    String? title,
  }) {
    return showCupertinoDialog(
      context: Get.context ?? WidgetsBinding.instance.rootElement!,
      builder: (context) {
        return CupertinoAlertDialog(
          title: Text(title ?? LocaleKeys.systemMessage.tr),
          content: message is Widget ? message : Text(message.toString()),
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
