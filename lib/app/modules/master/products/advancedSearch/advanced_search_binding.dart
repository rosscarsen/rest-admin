import 'package:get/get.dart';

import 'advanced_search_controller.dart';

class AdvancedSearchBinding extends Binding {
  @override
  List<Bind> dependencies() => [Bind.lazyPut<AdvancedSearchController>(() => AdvancedSearchController())];
}
