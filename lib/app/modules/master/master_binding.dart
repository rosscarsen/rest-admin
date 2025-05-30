import 'package:get/get.dart';

import 'master_controller.dart';

class MasterBinding extends Binding {
  @override
  List<Bind> dependencies() {
    return [Bind.lazyPut<MasterController>(() => MasterController())];
  }
}
