import 'package:flutter/material.dart';

import 'package:get/get.dart';

import 'product_edit_controller.dart';

class ProductEditView extends GetView<ProductEditController> {
  const ProductEditView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ProductEditView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'ProductEditView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
