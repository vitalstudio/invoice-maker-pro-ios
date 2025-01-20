
import 'package:get/get.dart';
import 'client_list_controller.dart';

class ClientBinding implements Bindings{
  @override
  void dependencies() {
    Get.lazyPut<ClientListController>(() => ClientListController());
  }
}
