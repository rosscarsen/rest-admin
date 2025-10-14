import 'package:flutter/material.dart';

import 'package:get/get.dart';

import 'screen_mode_category_controller.dart';

class ScreenModeCategoryView extends GetView<ScreenModeCategoryController> {
  const ScreenModeCategoryView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ScreenModeCategoryView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'ScreenModeCategoryView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
