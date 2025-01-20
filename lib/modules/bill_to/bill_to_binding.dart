
import 'package:get/get.dart';
import 'bill_to_controller.dart';

class BillToBinding implements Bindings{
  @override
  void dependencies() {
  Get.lazyPut<BillToController>(() => BillToController());
  }

}