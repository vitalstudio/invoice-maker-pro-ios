import 'package:get/get.dart';
import 'estimate_list_controller.dart';

class EstimateListBinding implements Bindings{
  @override
  void dependencies() {
   Get.lazyPut<EstimateListController>(() => EstimateListController());
  }

}