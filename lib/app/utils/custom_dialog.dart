import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';

class CustomDialog {
  static Future<void> successMessages(String msg, {int displayTime = 3}) async {
    await dismissDialog();
    await SmartDialog.showNotify(
      msg: msg,
      notifyType: NotifyType.success,
      clickMaskDismiss: false,
      animationType: SmartAnimationType.fade,
      displayTime: Duration(seconds: displayTime),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(12), color: Colors.black),
          child: Column(
            spacing: 8.0,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.check_circle, color: Colors.green, size: 30),
              Text(
                msg,
                style: const TextStyle(color: Colors.green, fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        );
      },
    );
  }

  static Future<void> errorMessages(String msg, {int duration = 3}) async {
    await dismissDialog();
    await SmartDialog.showNotify(
      msg: msg,
      notifyType: NotifyType.error,
      clickMaskDismiss: false,
      animationType: SmartAnimationType.centerScale_otherSlide,
      displayTime: const Duration(seconds: 3),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(12), color: Colors.black),
          child: Column(
            spacing: 8.0,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.error_outline, color: Colors.redAccent, size: 30),
              Text(
                msg,
                style: const TextStyle(color: Colors.redAccent, fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        );
      },
    );
  }

  static Future<void> warning(String msg) async {
    await dismissDialog();
    await SmartDialog.showNotify(
      msg: msg,
      notifyType: NotifyType.warning,
      clickMaskDismiss: false,
      animationType: SmartAnimationType.fade,
    );
  }

  static Future<void> showLoading(String msg) async {
    await dismissDialog();
    await SmartDialog.showLoading(msg: msg, clickMaskDismiss: false, animationType: SmartAnimationType.fade);
  }

  static Future<void> showToast(String msg, {int duration = 3}) async {
    await dismissDialog();
    await SmartDialog.showToast(
      msg,
      displayTime: Duration(seconds: duration),
      displayType: SmartToastType.last,
      clickMaskDismiss: false,
      animationType: SmartAnimationType.fade,
      alignment: Alignment.center,
    );
  }

  static Future<void> dismissDialog() async {
    if (SmartDialog.checkExist()) {
      await SmartDialog.dismiss();
    }
  }
}
