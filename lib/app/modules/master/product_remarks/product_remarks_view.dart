import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../routes/app_pages.dart';
import '../../../translations/locale_keys.dart';
import '../../../widgets/custom_scaffold.dart';
import 'product_remarks_controller.dart';

class ProductRemarksView extends GetView<ProductRemarksController> {
  const ProductRemarksView({super.key});
  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      route: Routes.PRODUCT_REMARKS,
      body: const Center(child: Text('ProductRemarksView is working', style: TextStyle(fontSize: 20))),
      title: LocaleKeys.productRemarks.tr,
    );
  }
}
