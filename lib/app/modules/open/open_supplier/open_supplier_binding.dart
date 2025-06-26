import 'package:get/get.dart';

import 'open_supplier_controller.dart';

class OpenSupplierBinding extends Binding {
  @override
  List<Bind> dependencies() => <Bind>[Bind.lazyPut<OpenSupplierController>(() => OpenSupplierController())];
}
