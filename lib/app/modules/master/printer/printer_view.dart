import 'package:flutter/material.dart';

import 'package:get/get.dart';

import 'printer_controller.dart';

class PrinterView extends GetView<PrinterController> {
  const PrinterView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('PrinterView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'PrinterView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
