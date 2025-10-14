import 'package:get/get.dart';

import 'time_sales_controller.dart';

class TimeSalesBinding extends Binding {
  @override
  List<Bind> dependencies() {
    return [Bind.lazyPut<TimeSalesController>(() => TimeSalesController())];
  }
}
