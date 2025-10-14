import 'package:get/get.dart';

import 'decca_controller.dart';

class DeccaBinding extends Binding {
  @override
  List<Bind> dependencies() {
    return [Bind.lazyPut<DeccaController>(() => DeccaController())];
  }
}
