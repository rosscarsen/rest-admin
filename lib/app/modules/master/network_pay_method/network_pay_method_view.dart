import 'package:flutter/material.dart';

import 'package:get/get.dart';

import 'network_pay_method_controller.dart';

class NetworkPayMethodView extends GetView<NetworkPayMethodController> {
  const NetworkPayMethodView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('NetworkPayMethodView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'NetworkPayMethodView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
