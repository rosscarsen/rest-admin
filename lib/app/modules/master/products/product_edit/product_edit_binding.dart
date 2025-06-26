import 'package:get/get.dart';

import 'product_edit_controller.dart';

class ProductEditBinding extends Binding {
  @override
  List<Bind> dependencies() {
    return [Bind.lazyPut<ProductEditController>(() => ProductEditController())];
  }
}
