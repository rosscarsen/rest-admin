import 'package:get/get.dart';

import 'page_not_found_controller.dart';

class PageNotFoundBinding extends Binding {
  @override
  List<Bind> dependencies() {
    return [Bind.lazyPut<PageNotFoundController>(() => PageNotFoundController())];
  }
}
