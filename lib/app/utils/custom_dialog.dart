import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';

class CustomDialog {
  static Future<void> successMessages(String msg) async {
    await SmartDialog.showNotify(
      msg: msg,
      notifyType: NotifyType.success,
      clickMaskDismiss: false,
      animationType: SmartAnimationType.fade,
    );
  }

  static Future<void> errorMessages(String msg) async {
    await SmartDialog.showNotify(
      msg: msg,
      notifyType: NotifyType.failure,
      clickMaskDismiss: false,
      animationType: SmartAnimationType.fade,
    );
  }

  static Future<void> warning(String msg) async {
    await SmartDialog.showNotify(
      msg: msg,
      notifyType: NotifyType.warning,
      clickMaskDismiss: false,
      animationType: SmartAnimationType.fade,
    );
  }

  static Future<void> showLoading(String msg) async {
    await SmartDialog.showLoading(msg: msg, clickMaskDismiss: false, animationType: SmartAnimationType.fade);
  }

  static Future<void> showToast(String msg, {int duration = 3}) async {
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
