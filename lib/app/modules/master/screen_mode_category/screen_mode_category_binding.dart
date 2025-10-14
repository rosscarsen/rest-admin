import 'package:get/get.dart';

import 'screen_mode_category_controller.dart';

class ScreenModeCategoryBinding extends Binding {
  @override
  List<Bind> dependencies() {
    return [Bind.lazyPut<ScreenModeCategoryController>(() => ScreenModeCategoryController())];
  }
}
