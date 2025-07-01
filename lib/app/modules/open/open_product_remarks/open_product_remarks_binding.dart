import 'package:get/get.dart';

import 'open_product_remarks_controller.dart';

class OpenProductRemarksBinding extends Binding {
  @override
  List<Bind> dependencies() {
    return [Bind.lazyPut(() => OpenProductRemarksController())];
  }
}
