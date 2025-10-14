import 'package:get/get.dart';

import 'stock_controller.dart';

class StockBinding extends Binding {
  @override
  List<Bind> dependencies() {
    return [Bind.lazyPut<StockController>(() => StockController())];
  }
}
