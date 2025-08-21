import 'package:flutter/material.dart';

import 'package:get/get.dart';

import 'customer_controller.dart';

class CustomerView extends GetView<CustomerController> {
  const CustomerView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('CustomerView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'CustomerView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
