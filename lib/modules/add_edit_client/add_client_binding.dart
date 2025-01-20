import 'package:get/get.dart';
import 'add_client_controller.dart';

class AddClientBinding implements Bindings{
  @override
  void dependencies() {
   Get.lazyPut<AddClientController>(() => AddClientController());
  }
}