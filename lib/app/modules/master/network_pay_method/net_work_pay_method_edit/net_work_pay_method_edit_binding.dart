import 'package:get/get.dart';

import 'net_work_pay_method_edit_controller.dart';

class NetWorkPayMethodEditBinding extends Binding {
  @override
  List<Bind> dependencies() {
    return [Bind.lazyPut<NetWorkPayMethodEditController>(() => NetWorkPayMethodEditController())];
  }
}
