import 'package:get/get.dart';
import 'templates_controller.dart';

class TemplatesBinding implements Bindings{
  @override
  void dependencies() {
 Get.lazyPut<TemplatesController>(() => TemplatesController());
  }
}