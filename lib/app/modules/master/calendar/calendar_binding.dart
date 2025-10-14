import 'package:get/get.dart';

import 'calendar_controller.dart';

class CalendarBinding extends Binding {
  @override
  List<Bind> dependencies() {
    return [Bind.lazyPut<CalendarController>(() => CalendarController())];
  }
}
