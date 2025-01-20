import 'package:get/get.dart';
import 'saved_pdf_controller.dart';

class SavedPdfBinding implements Bindings{
  @override
  void dependencies() {
    Get.lazyPut<SavedPdfController>(() => SavedPdfController());
  }
}