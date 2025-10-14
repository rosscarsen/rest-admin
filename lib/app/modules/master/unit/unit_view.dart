import 'package:flutter/material.dart';

import 'package:get/get.dart';

import 'unit_controller.dart';

class UnitView extends GetView<UnitController> {
  const UnitView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('UnitView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'UnitView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
