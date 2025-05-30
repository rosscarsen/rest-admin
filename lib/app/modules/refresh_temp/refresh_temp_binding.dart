import 'package:get/get.dart';

import 'refresh_temp_controller.dart';

class RefreshTempBinding extends Binding {
  @override
  List<Bind> dependencies() {
    return [Bind.lazyPut<RefreshTempController>(() => RefreshTempController())];
  }
}
