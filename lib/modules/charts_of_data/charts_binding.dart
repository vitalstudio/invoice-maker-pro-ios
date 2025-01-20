import 'package:get/get.dart';
import 'charts_controller.dart';

class ChartsBinding implements Bindings{
  @override
  void dependencies() {
    Get.lazyPut<ChartsController>(() => ChartsController());
  }
}