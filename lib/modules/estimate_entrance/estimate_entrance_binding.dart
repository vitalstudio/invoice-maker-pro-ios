import 'package:get/get.dart';
import 'estimate_entrance_controller.dart';

class EstimateEntranceBinding implements Bindings{
  @override
  void dependencies() {
    Get.lazyPut<EstimateEntranceController>(() => EstimateEntranceController());
  }
}