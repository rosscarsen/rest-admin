import 'package:get/get.dart';

import 'table_edit_controller.dart';

class TableEditBinding extends Binding {
  @override
  List<Bind> dependencies() {
    return [Bind.lazyPut<TableEditController>(() => TableEditController())];
  }
}
