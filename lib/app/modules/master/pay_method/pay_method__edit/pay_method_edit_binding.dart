import 'package:get/get.dart';

import 'pay_method_edit_controller.dart';

class PayMethodEditBinding extends Binding {
  @override
  List<Bind> dependencies() => [Bind.lazyPut<PayMethodEditController>(() => PayMethodEditController())];
}
