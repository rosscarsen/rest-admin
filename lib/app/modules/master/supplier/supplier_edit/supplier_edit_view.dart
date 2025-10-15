import 'package:flutter/material.dart';

import 'package:get/get.dart';

import 'supplier_edit_controller.dart';

class SupplierEditView extends GetView<SupplierEditController> {
  const SupplierEditView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('SupplierEditView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'SupplierEditView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
