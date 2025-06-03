import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../routes/app_pages.dart';
import '../../translations/locale_keys.dart';
import '../../widgets/custom_scaffold.dart';
import 'supplier_invoice_controller.dart';

class SupplierInvoiceView extends GetView<SupplierInvoiceController> {
  const SupplierInvoiceView({super.key});
  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      route: Routes.SUPPLIER_INVOICE,
      body: const Center(child: Text('SupplierInvoiceView is working', style: TextStyle(fontSize: 20))),
      title: LocaleKeys.supplierInvoice.tr,
    );
  }
}
