import 'package:get/get.dart';

import 'supplier_invoice_edit_controller.dart';

class SupplierInvoiceEditBinding extends Binding {
  @override
  List<Bind> dependencies() {
    return [Bind.lazyPut<SupplierInvoiceEditController>(() => SupplierInvoiceEditController())];
  }
}
