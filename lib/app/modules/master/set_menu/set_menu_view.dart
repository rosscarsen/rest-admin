import 'package:flutter/material.dart';

import 'package:get/get.dart';

import 'set_menu_controller.dart';

class SetMenuView extends GetView<SetMenuController> {
  const SetMenuView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('SetMenuView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'SetMenuView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
