import 'package:get/get.dart';

import 'open_product_barcode_controller.dart';

class OpenProductBarcodeBinding extends Binding {
  @override
  List<Bind> dependencies() => <Bind>[Bind.lazyPut<OpenProductBarcodeController>(() => OpenProductBarcodeController())];
}
