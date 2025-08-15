import 'package:flutter/material.dart';

import 'package:get/get.dart';

import 'category2_edit_controller.dart';

class Category2EditView extends GetView<Category2EditController> {
  const Category2EditView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Category2EditView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'Category2EditView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
