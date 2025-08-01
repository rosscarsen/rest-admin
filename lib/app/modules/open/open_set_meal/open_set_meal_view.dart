import 'package:flutter/material.dart';

import 'package:get/get.dart';

import 'open_set_meal_controller.dart';

class OpenSetMealView extends GetView<OpenSetMealController> {
  const OpenSetMealView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('OpenSetMealView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'OpenSetMealView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
