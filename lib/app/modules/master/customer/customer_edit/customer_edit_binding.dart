import 'package:get/get.dart';

import 'customer_edit_controller.dart';

class CustomerEditBinding extends Binding {
  @override
  List<Bind> dependencies() {
    return [Bind.lazyPut<CustomerEditController>(() => CustomerEditController())];
  }
}
