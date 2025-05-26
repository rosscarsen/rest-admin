import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

successMessages(String msg) {
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
    ..customAnimation = CustomAnimation();
  EasyLoading.showSuccess(msg, maskType: EasyLoadingMaskType.custom);
}

errorMessages(String msg) {
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
    ..customAnimation = CustomAnimation();
  EasyLoading.showError(msg, maskType: EasyLoadingMaskType.custom);
}

showLoding(String msg) {
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
    ..customAnimation = CustomAnimation();
  EasyLoading.show(status: msg, maskType: EasyLoadingMaskType.custom);
}

showToast(String msg, {int duration = 2}) {
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
    ..customAnimation = CustomAnimation();
  EasyLoading.showToast(msg, maskType: EasyLoadingMaskType.custom);
}

dismissLoding() {
  if (EasyLoading.isShow) {
    EasyLoading.dismiss();
  }
}

class CustomAnimation extends EasyLoadingAnimation {
  CustomAnimation();

  @override
  Widget buildWidget(Widget child, AnimationController controller, AlignmentGeometry alignment) {
    return Opacity(opacity: controller.value, child: RotationTransition(turns: controller, child: child));
  }
}
