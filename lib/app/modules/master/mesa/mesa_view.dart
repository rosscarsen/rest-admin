import 'package:flutter/material.dart';

import 'package:get/get.dart';

import 'mesa_controller.dart';

class MesaView extends GetView<MesaController> {
  const MesaView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('MesaView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'MesaView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
