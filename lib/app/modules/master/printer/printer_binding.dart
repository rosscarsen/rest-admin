import 'package:get/get.dart';

import 'printer_controller.dart';

class PrinterBinding extends Binding {
  @override
  List<Bind> dependencies() {
    return [Bind.lazyPut<PrinterController>(() => PrinterController())];
  }
}
