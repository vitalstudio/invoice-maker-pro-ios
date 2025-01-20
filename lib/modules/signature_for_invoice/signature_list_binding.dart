
import 'package:get/get.dart';
import 'signature_list_controller.dart';

class SignatureListBinding implements Bindings{
  @override
  void dependencies() {
    Get.lazyPut<SignatureListController>(() => SignatureListController());
  }
}