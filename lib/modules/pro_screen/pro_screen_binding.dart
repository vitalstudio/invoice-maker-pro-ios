import 'package:get/get.dart';
import 'pro_screen_controller.dart';

class ProScreenBinding implements Bindings{
  @override
  void dependencies() {
    Get.lazyPut<ProScreenController>(() => ProScreenController());
  }
}