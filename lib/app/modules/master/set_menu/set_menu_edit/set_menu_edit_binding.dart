import 'package:get/get.dart';

import 'set_menu_edit_controller.dart';

class SetMenuEditBinding extends Binding {
  @override
  List<Bind> dependencies() {
    return [Bind.lazyPut<SetMenuEditController>(() => SetMenuEditController())];
  }
}
