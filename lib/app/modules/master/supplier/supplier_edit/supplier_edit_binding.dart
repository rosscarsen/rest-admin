import 'package:get/get.dart';

import 'supplier_edit_controller.dart';

class SupplierEditBinding extends Binding {
  @override
  List<Bind> dependencies() {
    return [Bind.lazyPut<SupplierEditController>(() => SupplierEditController())];
  }
}
