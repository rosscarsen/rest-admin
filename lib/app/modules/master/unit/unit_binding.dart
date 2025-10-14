import 'package:get/get.dart';

import 'unit_controller.dart';

class UnitBinding extends Binding {
  @override
  List<Bind> dependencies() {
    return [Bind.lazyPut<UnitController>(() => UnitController())];
  }
}
