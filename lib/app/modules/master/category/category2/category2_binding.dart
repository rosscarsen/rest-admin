import 'package:get/get.dart';

import 'category2_controller.dart';

class Category2Binding extends Binding {
  @override
  List<Bind> dependencies() {
    return [Bind.lazyPut<Category2Controller>(() => Category2Controller())];
  }
}
