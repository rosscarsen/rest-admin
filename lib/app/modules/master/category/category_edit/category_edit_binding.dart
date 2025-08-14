import 'package:get/get.dart';

import 'category_edit_controller.dart';

class CategoryEditBinding extends Binding {
  @override
  List<Bind> dependencies() {
    return [Bind.lazyPut<CategoryEditController>(() => CategoryEditController())];
  }
}
