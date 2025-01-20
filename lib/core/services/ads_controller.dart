import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import '../../core/app_singletons/app_singletons.dart';
import 'ads_helper.dart';

class AdsController extends GetxController {

  InterstitialAd? interstitialAd;
  Rx<bool> isInterstitialAdLoaded = false.obs;

  RewardedAd? rewardedAd;
  Rx<bool> isRewardedAdLoaded = false.obs;
  bool isRewardEarned = false;

  AppOpenAd? appOpenAd;
  Rx<bool> isOpenAppAdLoaded = false.obs;


  @override
  void onInit() {
    createInterstitialAd();
    // loadRewardedAd();
    super.onInit();
  }

  void createInterstitialAd() {

    if(!AppSingletons.isSubscriptionEnabled.value){
      if(Platform.isAndroid && AppSingletons.androidInterstitialAdsEnabled.value){
        InterstitialAd.load(
            adUnitId: AdHelper.interstitialAdUnitId,
            request: const AdRequest(),
            adLoadCallback: InterstitialAdLoadCallback(
              onAdLoaded: (InterstitialAd ad) {
                debugPrint('$ad loaded');
                interstitialAd = ad;
                // _numInterstitialLoadAttempts = 0;
                interstitialAd!.setImmersiveMode(true);
                isInterstitialAdLoaded.value = true;
                // showInterstitialAd();
              },
              onAdFailedToLoad: (LoadAdError error) {
                debugPrint('InterstitialAd failed to load: $error.');
                // _numInterstitialLoadAttempts += 1;
                interstitialAd = null;
                // if (_numInterstitialLoadAttempts < maxFailedLoadAttempts) {
                //   _createInterstitialAd();
                // }
              },
            ));
      }

      if(Platform.isIOS && AppSingletons.iOSInterstitialAdsEnabled.value){
        InterstitialAd.load(
            adUnitId: AdHelper.interstitialAdUnitId,
            request: const AdRequest(),
            adLoadCallback: InterstitialAdLoadCallback(
              onAdLoaded: (InterstitialAd ad) {
                debugPrint('$ad loaded');
                interstitialAd = ad;
                // _numInterstitialLoadAttempts = 0;
                interstitialAd!.setImmersiveMode(true);
                isInterstitialAdLoaded.value = true;
                // showInterstitialAd();
              },
              onAdFailedToLoad: (LoadAdError error) {
                debugPrint('InterstitialAd failed to load: $error.');
                // _numInterstitialLoadAttempts += 1;
                interstitialAd = null;
                // if (_numInterstitialLoadAttempts < maxFailedLoadAttempts) {
                //   _createInterstitialAd();
                // }
              },
            ));
      }
    } else{
      debugPrint('Subscription enabled so interstitial add stopped...');
    }

  }

  void showInterstitialAd() {
    if (!AppSingletons.isSubscriptionEnabled.value) {
      if (Platform.isAndroid &&
          AppSingletons.androidInterstitialAdsEnabled.value) {
        if (interstitialAd == null) {
          debugPrint('Warning: attempt to show interstitial before loaded.');
          return;
        }
        interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
          onAdShowedFullScreenContent: (InterstitialAd ad) =>
              debugPrint('ad onAdShowedFullScreenContent.'),
          onAdDismissedFullScreenContent: (InterstitialAd ad) {
            debugPrint('$ad onAdDismissedFullScreenContent.');
            // Get.toNamed(Routes.water);
            ad.dispose();
            isInterstitialAdLoaded.value = false;
            createInterstitialAd();
          },
          onAdFailedToShowFullScreenContent: (InterstitialAd ad,
              AdError error) {
            debugPrint('$ad onAdFailedToShowFullScreenContent: $error');
            ad.dispose();
            isInterstitialAdLoaded.value = false;
            createInterstitialAd();
          },
        );
        interstitialAd!.show();
        interstitialAd = null;
      }
    }
    if(Platform.isIOS && AppSingletons.iOSInterstitialAdsEnabled.value) {
      if (interstitialAd == null) {
        debugPrint('Warning: attempt to show interstitial before loaded.');
        return;
      }
      interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
        onAdShowedFullScreenContent: (InterstitialAd ad) =>
            debugPrint('ad onAdShowedFullScreenContent.'),
        onAdDismissedFullScreenContent: (InterstitialAd ad) {
          debugPrint('$ad onAdDismissedFullScreenContent.');
          // Get.toNamed(Routes.water);
          ad.dispose();
          isInterstitialAdLoaded.value = false;
          createInterstitialAd();
        },
        onAdFailedToShowFullScreenContent: (InterstitialAd ad,
            AdError error) {
          debugPrint('$ad onAdFailedToShowFullScreenContent: $error');
          ad.dispose();
          isInterstitialAdLoaded.value = false;
          createInterstitialAd();
        },
      );
      interstitialAd!.show();
      interstitialAd = null;
    }
  }

  // void loadRewardedAd() {
  //   RewardedAd.load(
  //       adUnitId: AdHelper.rewardedAdUnitId,
  //       request: const AdRequest(),
  //       rewardedAdLoadCallback: RewardedAdLoadCallback(
  //         // Called when an ad is successfully received.
  //         onAdLoaded: (ad) {
  //           debugPrint('$ad loaded.');
  //           ad.fullScreenContentCallback = FullScreenContentCallback(
  //             onAdFailedToShowFullScreenContent: (ad, err) {
  //               // Dispose the ad here to free resources.
  //               ad.dispose();
  //             },
  //             // Called when the ad dismissed full screen content.
  //             onAdDismissedFullScreenContent: (ad) {
  //               // Dispose the ad here to free resources.
  //               ad.dispose();
  //             },
  //           );
  //           // Keep a reference to the ad so you can show it later.
  //           rewardedAd = ad;
  //           isRewardedAdLoaded.value = true;
  //         },
  //
  //         // Called when an ad request failed.
  //         onAdFailedToLoad: (LoadAdError error) {
  //           debugPrint('RewardedAd failed to load: $error');
  //         },
  //       ));
  // }
  //
  // Future<void> showRewardedAd({required Function onRewardGranted}) async {
  //   if(rewardedAd == null) {
  //     debugPrint('Warning: attempt to show rewarded before loaded.');
  //     return;
  //   }
  //
  //   rewardedAd?.fullScreenContentCallback = FullScreenContentCallback(
  //     onAdShowedFullScreenContent: (ad) =>
  //         debugPrint('ad onAdShowedFullScreenContent.'),
  //     onAdFailedToShowFullScreenContent: (ad, err) {
  //       // Dispose the ad here to free resources.
  //       isRewardedAdLoaded.value = false;
  //       ad.dispose();
  //       loadRewardedAd();
  //     },
  //     // Called when the ad dismissed full screen content.
  //     onAdDismissedFullScreenContent: (ad) {
  //       // Dispose the ad here to free resources.
  //       isRewardedAdLoaded.value = false;
  //       ad.dispose();
  //       loadRewardedAd();
  //       if(isRewardEarned) {
  //         debugPrint("Rewarded");
  //         onRewardGranted();
  //         isRewardEarned = false;
  //         // WebViewBillController().downloadImage();
  //       }
  //     },
  //   );
  //   await rewardedAd?.show(
  //       onUserEarnedReward: (AdWithoutView ad, RewardItem reward) {
  //         debugPrint("He He");
  //         isRewardEarned = true;
  //       });
  //   rewardedAd = null;
  // }

  // void loadOpenAppAd() {
  //   AppOpenAd.load(
  //     adUnitId: AdHelper.openAppAdUnitId,
  //     request: const AdRequest(),
  //     adLoadCallback: AppOpenAdLoadCallback(
  //       onAdLoaded: (ad) {
  //         appOpenAd = ad;
  //         isOpenAppAdLoaded.value = true;
  //       },
  //       onAdFailedToLoad: (error) {
  //         debugPrint('AppOpenAd failed to load: $error');
  //         // Handle the error.
  //       },
  //     ), orientation: 1,
  //   );
  // }
  //
  // void showIOpenAppAd() {
  //   if (appOpenAd == null) {
  //     debugPrint('Warning: attempt to show open app before loaded.');
  //     return;
  //   }
  //
  //   // Set the fullScreenContentCallback and show the ad.
  //   appOpenAd!.fullScreenContentCallback = FullScreenContentCallback(
  //     onAdShowedFullScreenContent: (ad) {
  //       // _isShowingAd = true;
  //       debugPrint('$ad onAdShowedFullScreenContent');
  //     },
  //     onAdFailedToShowFullScreenContent: (ad, error) {
  //       debugPrint('$ad onAdFailedToShowFullScreenContent: $error');
  //       isOpenAppAdLoaded.value = false;
  //       ad.dispose();
  //       loadOpenAppAd();
  //     },
  //     onAdDismissedFullScreenContent: (ad) {
  //       debugPrint('$ad onAdDismissedFullScreenContent');
  //       isOpenAppAdLoaded.value = false;
  //       ad.dispose();
  //       loadOpenAppAd();
  //     },
  //   );
  //   appOpenAd!.show();
  //   appOpenAd = null;
  // }

}

mixin AdsControllerMixin {
  AdsController get adsControllerService => Get.find<AdsController>();
}