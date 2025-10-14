import 'package:flutter/material.dart';

import 'package:get/get.dart';

import 'supplier_controller.dart';

class SupplierView extends GetView<SupplierController> {
  const SupplierView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('SupplierView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'SupplierView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
