import 'package:flutter/material.dart';

import 'package:get/get.dart';

import 'master_controller.dart';

class MasterView extends GetView<MasterController> {
  const MasterView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('MasterView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'MasterView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
