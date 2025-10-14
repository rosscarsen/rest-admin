import 'package:flutter/material.dart';

import 'package:get/get.dart';

import 'department_controller.dart';

class DepartmentView extends GetView<DepartmentController> {
  const DepartmentView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('DepartmentView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'DepartmentView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
