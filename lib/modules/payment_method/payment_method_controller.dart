import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import '../../core/app_singletons/app_singletons.dart';
import '../../core/services/ads_helper.dart';
import '../../database/database_helper.dart';
import '../../model/payment_model.dart';

class PaymentMethodController extends GetxController{
  DBHelper? paymentDbHelper;
  RxList<PaymentModel> paymentList = <PaymentModel>[].obs;

  TextEditingController paymentController = TextEditingController();

  RxBool isLoading = false.obs;

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

    paymentDbHelper = DBHelper();
    loadData();
    super.onInit();
  }

  void _loadBannerAd() {
    bannerAd = BannerAd(
      adUnitId: AdHelper.bannerAdUnitId,
      request: AdRequest(),
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

  Future<void> loadData() async {
    isLoading.value = true;
    final list = await paymentDbHelper!.getPaymentList();
    paymentList.assignAll(list);

    print('Payment list: ${paymentList.length}');
    isLoading.value = false;
  }

  void deleteItem(int id) async {
    await paymentDbHelper!.deletePayment(id);
    paymentList.removeWhere((element) => element.id == id);
  }

  void clearList() async {
    await paymentDbHelper!.deleteAllPayment();
  }

  @override
  void onClose() {
    paymentController.clear();
    super.onClose();
  }

  void saveData() async {
    final paymentModel = PaymentModel(
      paymentMethod: paymentController.text,
    );

    await paymentDbHelper!.insertPayment(paymentModel);
    loadData();
    Get.back();

    paymentController.clear();
  }



}