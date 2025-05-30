import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'refresh_temp_controller.dart';

class RefreshTempView extends GetView<RefreshTempController> {
  const RefreshTempView({super.key});
  @override
  Widget build(BuildContext context) {
    final preRoute = Get.arguments;

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Get.offNamed(preRoute.toString());
    });
    return Scaffold(body: SafeArea(child: SizedBox.shrink()));
  }
}
