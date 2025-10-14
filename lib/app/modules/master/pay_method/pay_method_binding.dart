import 'package:get/get.dart';

import 'pay_method_controller.dart';

class PayMethodBinding extends Binding {
  @override
  List<Bind> dependencies() {
    return [Bind.lazyPut<PayMethodController>(() => PayMethodController())];
  }
}
