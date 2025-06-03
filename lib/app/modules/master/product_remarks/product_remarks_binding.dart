import 'package:get/get.dart';

import 'product_remarks_controller.dart';

class ProductRemarksBinding extends Binding {
  @override
  List<Bind> dependencies() {
    return [Bind.lazyPut<ProductRemarksController>(() => ProductRemarksController())];
  }
}
