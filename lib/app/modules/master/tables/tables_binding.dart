import 'package:get/get.dart';

import 'tables_controller.dart';

class TablesBinding extends Binding {
  @override
  List<Bind> dependencies() {
    return [Bind.lazyPut<TablesController>(() => TablesController())];
  }
}
