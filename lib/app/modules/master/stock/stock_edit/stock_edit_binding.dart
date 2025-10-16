import 'package:get/get.dart';

import 'stock_edit_controller.dart';

class StockEditBinding extends Binding {
  @override
  List<Bind> dependencies() {
    return [Bind.lazyPut<StockEditController>(() => StockEditController())];
  }
}
