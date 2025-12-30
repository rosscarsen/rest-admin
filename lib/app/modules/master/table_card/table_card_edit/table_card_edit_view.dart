import 'package:flutter/material.dart';

import 'package:get/get.dart';

import 'table_card_edit_controller.dart';

class TableCardEditView extends GetView<TableCardEditController> {
  const TableCardEditView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('TableCardEditView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'TableCardEditView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
