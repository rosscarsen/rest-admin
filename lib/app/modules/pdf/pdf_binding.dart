import 'package:get/get.dart';

import 'pdf_controller.dart';

class PdfBinding extends Binding {
  @override
  List<Bind> dependencies() {
    return [Bind.lazyPut<PdfController>(() => PdfController())];
  }
}
