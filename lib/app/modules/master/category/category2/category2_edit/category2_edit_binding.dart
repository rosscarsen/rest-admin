import 'package:get/get.dart';

import 'category2_edit_controller.dart';

class Category2EditBinding extends Binding {
  @override
  List<Bind> dependencies() => [Bind.lazyPut<Category2EditController>(() => Category2EditController())];
}
