import 'package:get/get.dart';
import 'item_screen_view.dart';

class ItemScreenBinding implements Bindings{
  @override
  void dependencies() {
    Get.lazyPut<ItemScreenView>(() => const ItemScreenView());
  }
}