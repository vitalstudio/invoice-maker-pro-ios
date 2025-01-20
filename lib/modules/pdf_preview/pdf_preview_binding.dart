import 'package:get/get.dart';
import 'pdf_preview_controller.dart';

class PdfPreviewBinding implements Bindings{
  @override
  void dependencies() {
    Get.lazyPut<PdfPreviewController>(() => PdfPreviewController());
  }
}