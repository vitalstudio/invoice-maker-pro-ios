import 'package:get/get.dart';
import 'new_signature_controller.dart';

class NewSignatureBinding implements Bindings{
  @override
  void dependencies() {
   Get.lazyPut<NewSignatureController>(() => NewSignatureController());
  }
}