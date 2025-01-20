import 'dart:io';
import 'package:get/get.dart';
import '../../../core/services/in_app_services_ios.dart';
import '../../services/ads_controller.dart';

class AppBindings extends Bindings {
  
  @override
  void dependencies() {

    if(Platform.isIOS || Platform.isMacOS){
      Get.put<InAppServicesForIOS>(InAppServicesForIOS());
    }

    if(Platform.isIOS || Platform.isAndroid){
      Get.put<AdsController>(AdsController());
    }
  }
}