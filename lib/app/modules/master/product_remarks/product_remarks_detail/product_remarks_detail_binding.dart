import 'package:get/get.dart';

import 'product_remarks_detail_controller.dart';

class ProductRemarksDetailBinding extends Binding {
  @override
  List<Bind<dynamic>> dependencies() {
    return [Bind.lazyPut<ProductRemarksDetailController>(() => ProductRemarksDetailController())];
  }
}
