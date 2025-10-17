import 'package:get/get.dart';

import 'unit_edit_controller.dart';

class UnitEditBinding extends Binding {
  @override
  List<Bind> dependencies() {
    return [Bind.lazyPut<UnitEditController>(() => UnitEditController())];
  }
}
