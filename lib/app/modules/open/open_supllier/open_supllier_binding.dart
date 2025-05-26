import 'package:get/get.dart';

import 'open_supllier_controller.dart';

class OpenSupllierBinding extends Binding {
  @override
  List<Bind> dependencies() => <Bind>[Bind.lazyPut<OpenSupllierController>(() => OpenSupllierController())];
}
