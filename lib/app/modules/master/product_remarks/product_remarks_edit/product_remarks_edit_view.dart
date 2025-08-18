import 'package:flutter/material.dart';

import 'package:get/get.dart';

import 'product_remarks_edit_controller.dart';

class ProductRemarksEditView extends GetView<ProductRemarksEditController> {
  const ProductRemarksEditView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ProductRemarksEditView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'ProductRemarksEditView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
