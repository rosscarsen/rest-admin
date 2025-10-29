import 'package:flutter/material.dart';

import 'package:get/get.dart';

import 'department_edit_controller.dart';

class DepartmentEditView extends GetView<DepartmentEditController> {
  const DepartmentEditView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('DepartmentEditView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'DepartmentEditView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
