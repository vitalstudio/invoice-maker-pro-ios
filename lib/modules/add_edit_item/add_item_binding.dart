import 'package:get/get.dart';
import 'add_item_controller.dart';

class AddItemBinding implements Bindings{
  @override
  void dependencies() {
    Get.lazyPut<AddItemController>(() => AddItemController());
  }
}