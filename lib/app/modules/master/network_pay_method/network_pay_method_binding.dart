import 'package:get/get.dart';

import 'network_pay_method_controller.dart';

class NetworkPayMethodBinding extends Binding {
  @override
  List<Bind> dependencies() {
    return [Bind.lazyPut<NetworkPayMethodController>(() => NetworkPayMethodController())];
  }
}
