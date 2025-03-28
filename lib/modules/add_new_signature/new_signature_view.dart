import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import '../../core/app_singletons/app_singletons.dart';
import '../../core/constants/app_constants/App_Constants.dart';
import '../../core/constants/color/color.dart';
import 'new_signature_controller.dart';
import 'package:syncfusion_flutter_signaturepad/signaturepad.dart';

class NewSignatureView extends GetView<NewSignatureController> {
  const NewSignatureView({super.key});

  @override
  Widget build(BuildContext context) {

    bool checkIsMobileLayout = AppConstants.isMobileScreen.value;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: mainPurpleColor,
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: const Icon(
            Icons.arrow_back,
            color: sWhite,
            size: 20,
          ),
        ),
        title: Text(
          'add_new_signature'.tr,
          style: const TextStyle(
              fontFamily: 'Montserrat',
              color: sWhite,
              fontWeight: FontWeight.w600,
              fontSize: 16),
        ),
      ),
      body: Center(
        child: Container(
          decoration: checkIsMobileLayout
              ? const BoxDecoration()
              : const BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage('assets/images/signature_screen_back.jpg'),
                      fit: BoxFit.fill)),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                margin: const EdgeInsets.symmetric(vertical: 20),
                height: checkIsMobileLayout
                    ? 250
                    : MediaQuery.of(context).size.height * 0.5,
                width: checkIsMobileLayout
                    ? 300
                    : MediaQuery.of(context).size.width * 0.3,
                decoration: BoxDecoration(
                    color: sWhite,
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(color: shadowColor, width: 3)),
                child: SfSignaturePad(
                  key: controller.signaturePadStateKey,
                  strokeColor: blackColor,
                  minimumStrokeWidth: 2.0,
                  maximumStrokeWidth: 4.0,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [

                  const SizedBox(width: 15,),

                  Expanded(
                    child: ElevatedButton(
                        onPressed: () async {
                          controller.signaturePadStateKey.currentState!.clear();
                        },
                        child: Text('clear_signature'.tr,textAlign: TextAlign.center,)),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: ElevatedButton(
                        onPressed: () async {
                          if(Platform.isIOS || Platform.isAndroid){
                            controller.showAd();
                          }
                          controller.saveSignature();
                        },
                        child: Text('save_signature'.tr,textAlign: TextAlign.center,)),
                  ),
                  const SizedBox(width: 15,),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Visibility(
        visible: Platform.isAndroid || Platform.isIOS,
        child: Obx(() {
          return Visibility(
              visible: !AppSingletons.isSubscriptionEnabled.value,
              child: Visibility(
                visible: (Platform.isAndroid &&
                    AppSingletons.androidBannerAdsEnabled.value) ||
                    (Platform.isIOS &&
                        AppSingletons.iOSBannerAdsEnabled.value),
                child: controller.isBannerAdReady.value == true
                    ? Container(
                  padding: const EdgeInsets.symmetric(vertical: 5),
                  // width: controller.bannerAd.size.width.toDouble(),
                  // width: double.infinity,
                  height: 60,
                  child: AdWidget(ad: controller.bannerAd),
                )
                    : Container(
                  padding: const EdgeInsets.symmetric(vertical: 5),
                  // width: controller.bannerAd.size.width.toDouble(),
                  height: 50,
                  child: const Center(child: Text('Loading Ad')),
                ),
              ));
        }),
      ),
    );
  }
}
