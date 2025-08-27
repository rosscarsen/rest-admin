import 'package:flutter/material.dart';

import 'package:get/get.dart';

import 'customer_edit_controller.dart';

class CustomerEditView extends GetView<CustomerEditController> {
  const CustomerEditView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('CustomerEditView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'CustomerEditView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
