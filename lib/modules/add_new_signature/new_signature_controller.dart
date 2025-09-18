import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import '../../core/app_singletons/app_singletons.dart';
import '../../core/services/ads_controller.dart';
import '../../core/services/ads_helper.dart';
import '../../modules/signature_for_invoice/signature_list_controller.dart';
import 'package:syncfusion_flutter_signaturepad/signaturepad.dart';
import '../../database/database_helper.dart';
import '../../model/signature_model.dart';


class NewSignatureController extends GetxController with AdsControllerMixin {

  final GlobalKey<SfSignaturePadState> signaturePadStateKey = GlobalKey();
  DBHelper? signatureDbHelper;
  RxList<SignatureModel> signatureList = <SignatureModel>[].obs;

  final signatureListController = Get.put(SignatureListController());

  Rx<bool> isBannerAdReady = false.obs;
  late BannerAd bannerAd;

  @override
  void onInit() {
    // if(Platform.isAndroid || Platform.isIOS){
    //   _loadBannerAd();
    // }
    if(!AppSingletons.isSubscriptionEnabled.value){
      if(Platform.isAndroid && AppSingletons.androidBannerAdsEnabled.value){
        _loadBannerAd();
      }

      if(Platform.isIOS && AppSingletons.iOSBannerAdsEnabled.value){
        _loadBannerAd();
      }
    }
    signatureDbHelper = DBHelper();
    super.onInit();
  }

  void _loadBannerAd() {
    bannerAd = BannerAd(
      adUnitId: AdHelper.bannerAdUnitId,
      request: const AdRequest(),
      size: AdSize.banner,
      listener: BannerAdListener(
        onAdLoaded: (_) {
          isBannerAdReady.value = true;
        },
        onAdFailedToLoad: (ad, err) {
          isBannerAdReady.value = false;
          ad.dispose();
        },
      ),
    );

    bannerAd.load();
  }

  void saveSignature() async {
    final renderedImage = await signaturePadStateKey.currentState!.toImage();
    ByteData? byteData =
    await renderedImage.toByteData(format: ImageByteFormat.png);
    Uint8List pngBytes = byteData!.buffer.asUint8List();

    final signatureModel = SignatureModel(
      pngBytes: pngBytes,
    );
    signatureDbHelper!.insertSignature(signatureModel);
    signatureListController.loadData();
    Get.back();
  }

  void showAd() {
    adsControllerService.showInterstitialAd();
  }

}