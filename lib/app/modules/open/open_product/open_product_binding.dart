import 'package:get/get.dart';

import 'open_product_controller.dart';

class OpenProductBinding extends Binding {
  @override
  List<Bind> dependencies() => <Bind>[Bind.lazyPut<OpenProductController>(() => OpenProductController())];
}
