import 'package:flutter/material.dart';

import 'package:get/get.dart';

import 'table_card_controller.dart';

class TableCardView extends GetView<TableCardController> {
  const TableCardView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('TableCardView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'TableCardView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
