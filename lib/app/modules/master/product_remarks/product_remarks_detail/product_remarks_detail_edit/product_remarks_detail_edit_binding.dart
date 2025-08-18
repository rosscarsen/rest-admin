import 'package:get/get.dart';

import 'product_remarks_detail_edit_controller.dart';

class ProductRemarksDetailEditBinding extends Binding {
  @override
  List<Bind<dynamic>> dependencies() {
    return [Bind.lazyPut<ProductRemarksDetailEditController>(() => ProductRemarksDetailEditController())];
  }
}
