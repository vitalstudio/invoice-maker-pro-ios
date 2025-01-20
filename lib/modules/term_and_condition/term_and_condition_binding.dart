import 'package:get/get.dart';
import 'term_and_condition_controller.dart';

class TermAndConditionBinding implements Bindings{
  @override
  void dependencies() {
    Get.lazyPut<TermAndConditionController>(() => TermAndConditionController());
  }
}