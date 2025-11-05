import 'package:get/get.dart';

import 'open_department_controller.dart';

class OpenDepartmentBinding extends Binding {
  @override
  List<Bind> dependencies() {
    return [Bind.lazyPut<OpenDepartmentController>(() => OpenDepartmentController())];
  }
}
