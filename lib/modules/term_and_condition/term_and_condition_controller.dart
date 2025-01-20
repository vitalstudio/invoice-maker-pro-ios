import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import '../../core/app_singletons/app_singletons.dart';
import '../../core/services/ads_helper.dart';
import '../../database/database_helper.dart';
import '../../model/termAndCondition_model.dart';

class TermAndConditionController extends GetxController{

  DBHelper? termDbHelper;
  RxList<TermModel> termList = <TermModel>[].obs;

  TextEditingController termAndCondController = TextEditingController();

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

    termDbHelper = DBHelper();
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
    final list = await termDbHelper!.getTermList();
    termList.assignAll(list);
    print("Term list: ${termList.length}");
    isLoading.value = false;
  }
  void deleteTerm(int id) async {
    await termDbHelper!.deleteTAC(id);
    termList.removeWhere((element) => element.id == id);
  }

  void clearList() async {
    await termDbHelper!.deleteAllTAC();
    termList.clear();
  }

  @override
  void onClose() {
    termAndCondController.dispose();
    super.onClose();
  }


  void saveData() async {
    final termModel = TermModel(
      tcDetail: termAndCondController.text,
    );
    await termDbHelper!.insertTAC(termModel);
    loadData();
    Get.back();
  }

}