import 'package:get/get.dart';

import 'category_controller.dart';

class CategoryBinding extends Binding {
  @override
  List<Bind> dependencies() {
    return [Bind.lazyPut<CategoryController>(() => CategoryController())];
  }
}
