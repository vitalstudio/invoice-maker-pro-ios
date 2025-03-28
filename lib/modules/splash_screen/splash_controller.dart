import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import '../../core/utils/dialogue_to_select_language.dart';
import '../../core/constants/app_constants/App_Constants.dart';
import '../../core/services/in_app_services_ios.dart';
import '../../core/preferenceManager/sharedPreferenceManager.dart';
import '../../core/services/firebase_controller.dart';
import '../../core/app_singletons/app_singletons.dart';
import '../../core/routes/routes.dart';
import '../../core/services/ads_controller.dart';
import 'package:in_app_purchase_android/in_app_purchase_android.dart'; // Android-specific addition

class SplashController extends GetxController  with AdsControllerMixin {

  @override
  void onInit() async{
    // adsControllerService.createInterstitialAd();
    try{
      if(Platform.isIOS || Platform.isMacOS){
        await checkPremiumStatusForIOS();
      } else if(Platform.isAndroid){
        await checkPreviousPurchase();
      }

      if(Platform.isIOS || Platform.isAndroid){
        await FirebaseController.getAdsPermissionData();
        debugPrint('isSubscriptionEnabled In Splash: ${AppSingletons.isSubscriptionEnabled.value}');
      }

      int checkNumberOfInvoicesMadeAlready = SharedPreferencesManager.getValue('noOfInvoicesMadeAlready') ?? 0;
      int checkNumberOfEstimatesMadeAlready = SharedPreferencesManager.getValue('noOfEstimatesMadeAlready') ?? 0;
      String storedAppLanguage = SharedPreferencesManager.getValue(AppConstants.keyStoredAppLanguage) ?? AppConstants.english;

      AppSingletons.noOfInvoicesMadeAlready.value = checkNumberOfInvoicesMadeAlready;
      AppSingletons.noOfEstimatesMadeAlready.value = checkNumberOfEstimatesMadeAlready;
      AppSingletons.storedAppLanguage.value = storedAppLanguage;
      debugPrint('noOfInvoicesMadeAlready: ${AppSingletons.noOfInvoicesMadeAlready.value}');
      debugPrint('noOfEstimatesMadeAlready: ${AppSingletons.noOfEstimatesMadeAlready.value}');
      debugPrint('storedAppLanguage: ${AppSingletons.storedAppLanguage.value}');

      // if(!AppSingletons.isSubscriptionEnabled.value) {
      //   if (Platform.isAndroid && AppSingletons.openAppAdsAndroidEnabled.value) {
      //     adsControllerService.loadOpenAppAd();
      //   }
      // }

      LanguageSelection.updateLocale(selectedLanguage: AppSingletons.storedAppLanguage.value);

    } catch(e){
      debugPrint('Error in subs: $e');
    }

    super.onInit();
  }

  Future<void> startTimerForSplash() async{
    Timer(const Duration(seconds: 5),(){
      // if(!AppSingletons.isSubscriptionEnabled.value) {
      //   if (Platform.isAndroid && AppSingletons.openAppAdsAndroidEnabled.value) {
      //     adsControllerService.showIOpenAppAd();
      //   }
      // }
      Get.offNamed(Routes.bottomNavBar);
    });
  }

  Future<void> checkPreviousPurchase()async{

    debugPrint('checkPreviousPurchase method called');

    late InAppPurchaseAndroidPlatformAddition androidAddition;

    androidAddition =
        InAppPurchase.instance.getPlatformAddition<InAppPurchaseAndroidPlatformAddition>();

    final QueryPurchaseDetailsResponse response = await androidAddition.queryPastPurchases();

    debugPrint('Previous purchase status: $response');

    if (response.pastPurchases.isNotEmpty) {
      if (Get.context!.mounted) {
        if (response.pastPurchases[0].productID == AppConstants.kMonthlyIdentifier ||
            response.pastPurchases[0].productID == AppConstants.kWeeklyIdentifier ||
            response.pastPurchases[0].productID == AppConstants.kYearlyIdentifier  ||
            response.pastPurchases[0].productID == AppConstants.kLifeTimeIdentifier
        ) {
          log(response.pastPurchases[0].productID);
          // return true;
          // proScreenVC.shouldShowAds = false;
          // proScreenVC.subscriptionStatus = true;
          // SharedPreferencesHelper.setBool(key, value)
          SharedPreferencesManager.setValue('isSubscriptionEnabled', true);
          AppSingletons.isSubscriptionEnabled.value = true;
        } else {
          // SharedPreferencesHelper.setBool(AppConsts.subscriptionStatusKey, false);
          // proScreenVC.shouldShowAds = true;
          // proScreenVC.subscriptionStatus = false;
          SharedPreferencesManager.setValue('isSubscriptionEnabled', false);
          AppSingletons.isSubscriptionEnabled.value = false;
        }
      }
    }
  }

  Future<void> checkPremiumStatusForIOS() async{
    try{
      bool purchaseStatus = await InAppServicesForIOS().checkSubscriptionStatus();

      AppSingletons.isSubscriptionEnabled.value = purchaseStatus;

    } catch(e){
      debugPrint('$e');
    }
  }

}