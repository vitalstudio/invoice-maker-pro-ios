import 'package:get/get.dart';
import 'business_list_controller.dart';

class BusinessListBinding implements Bindings{
  @override
  void dependencies() {
    Get.lazyPut<BusinessListController>(() => BusinessListController());
  }
}