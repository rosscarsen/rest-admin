import 'package:flutter/material.dart';

import 'package:get/get.dart';

import 'table_floor_plan_controller.dart';

class TableFloorPlanView extends GetView<TableFloorPlanController> {
  const TableFloorPlanView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('TableFloorPlanView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'TableFloorPlanView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
