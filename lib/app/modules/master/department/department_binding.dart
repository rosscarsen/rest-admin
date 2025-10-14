import 'package:get/get.dart';

import 'department_controller.dart';

class DepartmentBinding extends Binding {
  @override
  List<Bind> dependencies() {
    return [Bind.lazyPut<DepartmentController>(() => DepartmentController())];
  }
}
