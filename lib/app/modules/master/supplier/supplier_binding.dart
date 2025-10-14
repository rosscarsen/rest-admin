import 'package:get/get.dart';

import 'supplier_controller.dart';

class SupplierBinding extends Binding {
  @override
  List<Bind> dependencies() {
    return [Bind.lazyPut<SupplierController>(() => SupplierController())];
  }
}
