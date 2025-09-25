import 'package:flutter/material.dart';

import 'package:get/get.dart';

import 'supplier_invoice_edit_controller.dart';

class SupplierInvoiceEditView extends GetView<SupplierInvoiceEditController> {
  const SupplierInvoiceEditView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('SupplierInvoiceEditView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'SupplierInvoiceEditView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
