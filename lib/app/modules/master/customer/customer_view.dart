import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../../../routes/app_pages.dart';
import '../../../translations/locale_keys.dart';
import '../../../widgets/custom_scaffold.dart';
import 'customer_controller.dart';

class CustomerView extends GetView<CustomerController> {
  const CustomerView({super.key});
  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      body: const Center(child: Text('CustomerView is working', style: TextStyle(fontSize: 20))),
      route: Routes.CUSTOMER,
      title: LocaleKeys.customer.tr,
    );
  }
}
