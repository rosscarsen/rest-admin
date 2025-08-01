import 'package:get/get.dart';

import 'open_multiple_product_controller.dart';

class OpenMultipleProductBinding extends Binding {
  @override
  List<Bind> dependencies() => [Bind.lazyPut(() => OpenMultipleProductController())];
}
