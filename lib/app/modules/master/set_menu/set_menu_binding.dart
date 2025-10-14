import 'package:get/get.dart';

import 'set_menu_controller.dart';

class SetMenuBinding extends Binding {
  @override
  List<Bind> dependencies() {
    return [Bind.lazyPut<SetMenuController>(() => SetMenuController())];
  }
}
