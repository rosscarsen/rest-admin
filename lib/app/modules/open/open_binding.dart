import 'package:get/get.dart';

import 'open_controller.dart';

class OpenBinding extends Binding {
  @override
  List<Bind> dependencies() => <Bind>[Bind.lazyPut<OpenController>(() => OpenController())];
}
