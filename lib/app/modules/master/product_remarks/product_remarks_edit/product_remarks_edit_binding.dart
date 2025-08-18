import 'package:get/get.dart';

import 'product_remarks_edit_controller.dart';

class ProductRemarksEditBinding extends Binding {
  @override
  List<Bind> dependencies() => [Bind.lazyPut<ProductRemarksEditController>(() => ProductRemarksEditController())];
}
