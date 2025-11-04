import 'package:get/get.dart';

import 'open_user_controller.dart';

class OpenUserBinding extends Binding {
  @override
  List<Bind> dependencies() {
    return [Bind.lazyPut<OpenUserController>(() => OpenUserController())];
  }
}
