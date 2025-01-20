import 'package:get/get.dart';
import 'business_info_controller.dart';

class BusinessInfoBinding implements Bindings{
  @override
  void dependencies() {
   Get.lazyPut<BusinessInfoController>(() => BusinessInfoController());
  }
}