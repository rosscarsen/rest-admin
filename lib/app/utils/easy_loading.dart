import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

void successMessages(String msg) {
  EasyLoading.instance
    ..indicatorType = EasyLoadingIndicatorType.fadingCircle
    ..loadingStyle = EasyLoadingStyle.custom
    ..indicatorSize = 45.0
    ..radius = 10.0
    ..progressColor = Colors.green
    ..backgroundColor = Colors.black
    ..indicatorColor = Colors.green
    ..textColor = Colors.green
    ..maskColor = Colors.transparent
    ..userInteractions = true
    ..dismissOnTap = false
    ..displayDuration = const Duration(seconds: 3)
    ..animationStyle = EasyLoadingAnimationStyle.scale
    ..maskType = EasyLoadingMaskType.black
    ..customAnimation = CustomAnimation();
  EasyLoading.showSuccess(msg, maskType: EasyLoadingMaskType.custom);
}

void errorMessages(String msg) {
  EasyLoading.instance
    ..indicatorType = EasyLoadingIndicatorType.fadingCircle
    ..loadingStyle = EasyLoadingStyle.custom
    ..indicatorSize = 45.0
    ..radius = 10.0
    ..progressColor = Colors.red
    ..backgroundColor = Colors.black
    ..indicatorColor = Colors.red
    ..textColor = Colors.red
    ..maskColor = Colors.transparent
    ..userInteractions = true
    ..dismissOnTap = false
    ..displayDuration = const Duration(seconds: 3)
    ..animationStyle = EasyLoadingAnimationStyle.scale
    ..maskType = EasyLoadingMaskType.black
    ..customAnimation = CustomAnimation();
  EasyLoading.showError(msg, maskType: EasyLoadingMaskType.custom);
}

void showLoading(String msg) {
  EasyLoading.instance
    ..indicatorType = EasyLoadingIndicatorType.fadingCircle
    ..loadingStyle = EasyLoadingStyle.custom
    ..indicatorSize = 45.0
    ..radius = 10.0
    ..progressColor = Colors.white
    ..backgroundColor = Colors.black
    ..indicatorColor = Colors.white
    ..textColor = Colors.white
    ..maskColor = Colors.black.withValues(alpha: 0.5)
    ..userInteractions = true
    ..dismissOnTap = false
    ..animationStyle = EasyLoadingAnimationStyle.scale
    ..maskType = EasyLoadingMaskType.black
    ..customAnimation = CustomAnimation();
  EasyLoading.show(status: msg, maskType: EasyLoadingMaskType.custom);
}

void showToast(String msg, {int duration = 3}) {
  EasyLoading.instance
    ..indicatorType = EasyLoadingIndicatorType.fadingCircle
    ..loadingStyle = EasyLoadingStyle.custom
    ..indicatorSize = 45.0
    ..radius = 10.0
    ..progressColor = Colors.white
    ..backgroundColor = Colors.black
    ..indicatorColor = Colors.white
    ..textColor = Colors.white
    ..maskColor = Colors.black.withValues(alpha: .3)
    ..displayDuration = Duration(seconds: duration)
    ..userInteractions = true
    ..dismissOnTap = false
    ..animationStyle = EasyLoadingAnimationStyle.scale
    ..maskType = EasyLoadingMaskType.black
    ..customAnimation = CustomAnimation();
  EasyLoading.showToast(msg, maskType: EasyLoadingMaskType.custom);
}

void dismissLoading() {
  if (EasyLoading.isShow) {
    EasyLoading.dismiss();
  }
}

class CustomAnimation extends EasyLoadingAnimation {
  @override
  // 修复方法签名以正确覆盖 EasyLoadingAnimation 的 buildWidget 方法
  Widget buildWidget(Widget child, AnimationController controller, AlignmentGeometry alignment) {
    return FadeTransition(
      // 'animation' 未定义，使用 controller 的 value 来创建动画
      opacity: controller.drive(Tween<double>(begin: 0.0, end: 1.0)),
      child: ScaleTransition(
        // 'animation' 未定义，使用 controller 的 value 来创建缩放动画
        scale: controller.drive(Tween<double>(begin: 0.8, end: 1.0)),
        child: Container(
          constraints: const BoxConstraints(minWidth: 200), // 最小宽度设置在这里
          child: child,
        ),
      ),
    );
  }
}
