import 'package:get/get.dart';

import 'open_set_meal_controller.dart';

class OpenSetMealBinding extends Binding {
  @override
  List<Bind> dependencies() {
    return [Bind.lazyPut(() => OpenSetMealController())];
  }
}
