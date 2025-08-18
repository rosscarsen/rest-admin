import 'package:flutter/material.dart';

import 'package:get/get.dart';

import 'product_remarks_detail_edit_controller.dart';

class ProductRemarksDetailEditView
    extends GetView<ProductRemarksDetailEditController> {
  const ProductRemarksDetailEditView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ProductRemarksDetailEditView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'ProductRemarksDetailEditView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
