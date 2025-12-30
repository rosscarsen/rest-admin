import 'package:get/get.dart';

import 'table_card_edit_controller.dart';

class TableCardEditBinding extends Binding {
  @override
  List<Bind> dependencies() {
    return [Bind.lazyPut<TableCardEditController>(() => TableCardEditController())];
  }
}
