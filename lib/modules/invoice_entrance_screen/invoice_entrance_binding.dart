
import 'package:get/get.dart';
import 'invoice_entrance_controller.dart';

class InvoiceEntranceBinding implements Bindings{
  @override
  void dependencies() {
    Get.lazyPut<InvoiceEntranceController>(() => InvoiceEntranceController());
  }
}
