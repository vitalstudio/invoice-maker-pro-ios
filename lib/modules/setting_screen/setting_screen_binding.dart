
import 'package:get/get.dart';
import 'setting_screen_controller.dart';

class SettingScreenBinding implements Bindings{
  @override
  void dependencies() {
    Get.lazyPut<SettingScreenController>(() => SettingScreenController());
  }
}
