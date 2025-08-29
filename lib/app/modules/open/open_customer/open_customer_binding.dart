import 'package:get/get.dart';

import 'open_customer_controller.dart';

class OpenCustomerBinding extends Binding {
  @override
  List<Bind> dependencies() {
    return [Bind.lazyPut<OpenCustomerController>(() => OpenCustomerController())];
  }
}
