import 'dart:io';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import '../../core/app_singletons/app_singletons.dart';
import '../../database/database_helper.dart';
import '../../core/services/ads_controller.dart';
import '../../core/services/ads_helper.dart';

class BottomNavController extends GetxController with AdsControllerMixin {
 final RxInt currentIndex = 0.obs;

 DBHelper? bottomDbHelper;

 RxString appBarTitleText = 'INVOICE'.obs;

 Rx<bool> isBannerAdReady = false.obs;
 late BannerAd bannerAd;

  void changePage(int index){
    currentIndex.value = index;

    if(index == 0){
      appBarTitleText.value = 'INVOICE';
    } else if(index == 1){
      appBarTitleText.value = 'ESTIMATE';
    } else if(index == 2){
      appBarTitleText.value = 'CLIENT';
    } else if(index == 3){
      appBarTitleText.value = 'ITEM';
    } else if(index == 4){
      appBarTitleText.value = 'SETTINGS';
    }
  }

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
    bottomDbHelper = DBHelper();
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
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

}
