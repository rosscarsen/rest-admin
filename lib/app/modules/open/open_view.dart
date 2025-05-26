import 'package:flutter/material.dart';

import 'package:get/get.dart';

import 'open_controller.dart';

class OpenView extends GetView<OpenController> {
  const OpenView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('OpenView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'OpenView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
