import 'package:get/get.dart';

import 'copy_product_set_meal_controller.dart';

class CopyProductSetMealBinding extends Binding {
  @override
  List<Bind> dependencies() {
    return [Bind.lazyPut(() => CopyProductSetMealController())];
  }
}
