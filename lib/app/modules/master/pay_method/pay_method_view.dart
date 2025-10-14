import 'package:flutter/material.dart';

import 'package:get/get.dart';

import 'pay_method_controller.dart';

class PayMethodView extends GetView<PayMethodController> {
  const PayMethodView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('PayMethodView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'PayMethodView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
