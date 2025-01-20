import 'dart:io';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import '../../core/app_singletons/app_singletons.dart';
import '../../core/services/ads_helper.dart';
import '../../database/database_helper.dart';
import '../../model/signature_model.dart';

class SignatureListController extends GetxController{

  DBHelper? signatureDbHelper;
  RxList<SignatureModel> signatureList = <SignatureModel>[].obs;
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

    signatureDbHelper = DBHelper();
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
    final list = await signatureDbHelper!.getSignatureList();
    signatureList.assignAll(list);
    print("Signature list: ${signatureList.length}");
    isLoading.value = false;
  }

  void deleteSignature(int id) async {
    await signatureDbHelper!.deleteSignature(id);
    signatureList.removeWhere((element) => element.id == id);
  }

  void clearList() async {
    await signatureDbHelper!.deleteAllSignature();
    signatureList.clear();
  }

}