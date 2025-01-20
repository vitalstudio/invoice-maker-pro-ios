
class AdsPermissionHandlerModel {
  String? id;
  bool? bannerAndroidEnable;
  bool? bannerIOSEnable;
  bool? interstitialAndroidEnable;
  bool? interstitialIOSEnable;
  bool? openAppAdsAndroidEnable;

  AdsPermissionHandlerModel({
    this.id,
    this.bannerAndroidEnable,
    this.bannerIOSEnable,
    this.interstitialAndroidEnable,
    this.interstitialIOSEnable,
    this.openAppAdsAndroidEnable
  });


  AdsPermissionHandlerModel.fromMap(Map<String,dynamic> adsPH):
  id = adsPH['id'],
  bannerAndroidEnable = adsPH['banner_android_enable'],
  bannerIOSEnable = adsPH['banner_ios_enable'],
  interstitialAndroidEnable = adsPH['interstitial_android_enable'],
  interstitialIOSEnable = adsPH['interstitial_ios_enable'],
  openAppAdsAndroidEnable = adsPH['openApp_android_enable'];

  Map<String, Object?> toMap(){
    return {
      'id' : id,
      'banner_android_enable' : bannerAndroidEnable,
      'banner_ios_enable' : bannerIOSEnable.hashCode,
      'interstitial_android_enable' : interstitialAndroidEnable,
      'interstitial_ios_enable' : interstitialIOSEnable,
      'openApp_android_enable' : openAppAdsAndroidEnable
    };
  }
}