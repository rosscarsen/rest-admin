import 'package:flutter/material.dart';

import 'package:get/get.dart';

import 'stock_controller.dart';

class StockView extends GetView<StockController> {
  const StockView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('StockView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'StockView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
