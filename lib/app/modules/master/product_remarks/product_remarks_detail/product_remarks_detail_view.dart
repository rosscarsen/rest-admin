import 'package:flutter/material.dart';

import 'package:get/get.dart';

import 'product_remarks_detail_controller.dart';

class ProductRemarksDetailView extends GetView<ProductRemarksDetailController> {
  const ProductRemarksDetailView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ProductRemarksDetailView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'ProductRemarksDetailView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
