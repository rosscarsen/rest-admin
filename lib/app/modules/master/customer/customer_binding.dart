import 'package:get/get.dart';

import 'customer_controller.dart';

class CustomerBinding extends Binding {
  @override
  List<Bind> dependencies() {
    return [Bind.lazyPut<CustomerController>(() => CustomerController())];
  }
}
