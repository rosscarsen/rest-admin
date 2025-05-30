import 'package:get/get.dart';

import 'supplier_invoice_controller.dart';

class SupplierInvoiceBinding extends Binding {
  @override
  List<Bind> dependencies() {
    return [
      Bind.lazyPut<SupplierInvoiceController>(
        () => SupplierInvoiceController(),
      ),
    ];
  }
}
