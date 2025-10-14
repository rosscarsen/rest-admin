import 'package:flutter/material.dart';

import 'package:get/get.dart';

import 'currency_controller.dart';

class CurrencyView extends GetView<CurrencyController> {
  const CurrencyView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('CurrencyView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'CurrencyView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
