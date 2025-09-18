import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import '../../core/app_singletons/app_singletons.dart';
import '../../core/services/ads_helper.dart';
import '../../database/database_helper.dart';
import '../../model/company_model.dart';

class BusinessListController extends GetxController{

  DBHelper? dbBusinessListHelper;

  RxList<BusinessInfoModel> businessList = <BusinessInfoModel>[].obs;

  RxList<BusinessInfoModel> businessListDummyForDestop = <BusinessInfoModel>[].obs;

  RxBool isLoadingData = false.obs;

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

    dbBusinessListHelper = DBHelper();
    loadData();
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

  Future<void> loadData() async {
    isLoadingData.value = true;
    final list = await dbBusinessListHelper!.getBusinessList();
    businessList.assignAll(list);
    debugPrint("Business List length: ${businessList.length}");
    isLoadingData.value = false;
  }

  void deleteBusiness(int id) async {
    await dbBusinessListHelper!.deleteBusinessInfo(id);
    businessList.removeWhere((element) => element.id == id);
  }

  void deleteAllBusinessList() async {
    await dbBusinessListHelper!.deleteAllBusinessInfo();
    businessList.clear();
  }

}