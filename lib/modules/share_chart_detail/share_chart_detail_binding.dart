import 'package:get/get.dart';
import 'share_chart_detail_controller.dart';

class ShareChartDetailBinding implements Bindings{
  @override
  void dependencies() {
   Get.lazyPut<ShareChartDetailController>(() => ShareChartDetailController());
  }
}