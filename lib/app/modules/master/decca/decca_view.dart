import 'package:flutter/material.dart';

import 'package:get/get.dart';

import 'decca_controller.dart';

class DeccaView extends GetView<DeccaController> {
  const DeccaView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('DeccaView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'DeccaView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
