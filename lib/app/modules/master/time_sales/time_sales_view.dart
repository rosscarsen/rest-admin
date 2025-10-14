import 'package:flutter/material.dart';

import 'package:get/get.dart';

import 'time_sales_controller.dart';

class TimeSalesView extends GetView<TimeSalesController> {
  const TimeSalesView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('TimeSalesView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'TimeSalesView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
