import 'package:get/get.dart';

import 'department_edit_controller.dart';

class DepartmentEditBinding extends Binding {
  @override
  List<Bind<dynamic>> dependencies() {
    return [Bind.lazyPut(() => DepartmentEditController())];
  }
}
