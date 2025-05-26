import 'package:get/get.dart';

import 'signin_controller.dart';

class SigninBinding extends Binding {
  @override
  List<Bind> dependencies() {
    return [
      Bind.lazyPut<SigninController>(
        () => SigninController(),
      )
    ];
  }
}
