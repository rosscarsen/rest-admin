import 'package:get/get.dart';

import 'table_card_controller.dart';

class TableCardBinding extends Binding {
  @override
  List<Bind> dependencies() => [Bind.lazyPut<TableCardController>(() => TableCardController())];
}
