import 'package:get/get.dart';

import 'currency_edit_controller.dart';

class CurrencyEditBinding extends Binding {
  @override
  List<Bind> dependencies() {
    return [Bind.lazyPut<CurrencyEditController>(() => CurrencyEditController())];
  }
}
