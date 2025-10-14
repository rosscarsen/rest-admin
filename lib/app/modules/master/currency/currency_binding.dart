import 'package:get/get.dart';

import 'currency_controller.dart';

class CurrencyBinding extends Binding {
  @override
  List<Bind> dependencies() {
    return [Bind.lazyPut<CurrencyController>(() => CurrencyController())];
  }
}
