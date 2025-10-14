import 'package:get/get.dart';

import 'mesa_controller.dart';

class MesaBinding extends Binding {
  @override
  List<Bind> dependencies() {
    return [Bind.lazyPut<MesaController>(() => MesaController())];
  }
}
