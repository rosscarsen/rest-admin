import 'package:get/get.dart';

import 'table_floor_plan_controller.dart';

class TableFloorPlanBinding extends Binding {
  @override
  List<Bind> dependencies() => [Bind.lazyPut<TableFloorPlanController>(() => TableFloorPlanController())];
}
