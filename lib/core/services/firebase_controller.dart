import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import '../../core/app_singletons/app_singletons.dart';
import '../../core/preferenceManager/sharedPreferenceManager.dart';
import '../../model/ads_permission_handler_model.dart';

class FirebaseController{

 static  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

 static var adsPermissionHandler = AdsPermissionHandlerModel().obs;

 static String collectionName = 'ads-permission-handler';
 static String docId = 'AVl24x85FyCxZP9c0kYL';

 static Future<void> getAdsPermissionData() async {

   try{
     DocumentSnapshot snapshot = await firebaseFirestore
         .collection(collectionName)
         .doc(docId)
         .get();

     if(snapshot.exists){

       adsPermissionHandler.value = AdsPermissionHandlerModel.fromMap(snapshot.data() as Map<String,dynamic>);

       debugPrint('Data coming : ${adsPermissionHandler.value}');

       SharedPreferencesManager.setValue('bannerAndroidEnable', adsPermissionHandler.value.bannerAndroidEnable);
       SharedPreferencesManager.setValue('bannerIOSEnable', adsPermissionHandler.value.bannerIOSEnable);
       SharedPreferencesManager.setValue('interstitialAndroidEnable', adsPermissionHandler.value.interstitialAndroidEnable);
       SharedPreferencesManager.setValue('interstitialIOSEnable', adsPermissionHandler.value.interstitialIOSEnable);
       SharedPreferencesManager.setValue('openAppAndroidEnable', adsPermissionHandler.value.openAppAdsAndroidEnable);

       setAdsValuesInVariables();

     } else{
       debugPrint('Document does not exist in firebase');
     }

   } catch(e){
     debugPrint('Error in fetching data: $e');
   }
  }

  static Future<void> setAdsValuesInVariables() async {
     AppSingletons.androidBannerAdsEnabled.value = SharedPreferencesManager.getValue('bannerAndroidEnable') ?? true;
     AppSingletons.iOSBannerAdsEnabled.value = SharedPreferencesManager.getValue('bannerIOSEnable') ?? true;
     AppSingletons.androidInterstitialAdsEnabled.value = SharedPreferencesManager.getValue('interstitialAndroidEnable') ?? true;
     AppSingletons.iOSInterstitialAdsEnabled.value = SharedPreferencesManager.getValue('interstitialIOSEnable') ?? true;
     AppSingletons.openAppAdsAndroidEnabled.value = SharedPreferencesManager.getValue('openAppAndroidEnable') ?? true;

     debugPrint('Android Banner: ${AppSingletons.androidBannerAdsEnabled.value}');
     debugPrint('IOS Banner: ${AppSingletons.iOSBannerAdsEnabled.value}');
     debugPrint('Android Interstitial: ${AppSingletons.androidInterstitialAdsEnabled.value}');
     debugPrint('IOS Interstitial: ${AppSingletons.iOSInterstitialAdsEnabled.value}');
     debugPrint('Android OpenApp: ${AppSingletons.openAppAdsAndroidEnabled.value}');

 }

}