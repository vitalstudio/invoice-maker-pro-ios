class AdHelper {

  // test app Id: ca-app-pub-3940256099942544~3347511713

  static bool productionMode = false;

  static String get bannerAdUnitId {
    if(productionMode) {
      return "ca-app-pub-9676410697154134/8455517275";
    }
    else {
      return "ca-app-pub-3940256099942544/9214589741";
    }
  }

  // static String get nativeAdUnitId {
  //   if(productionMode) {
  //     return "ca-app-pub-5727425438286982/3132675549";
  //   }
  //   else {
  //     return "ca-app-pub-3940256099942544/2247696110";
  //   }
  // }
  //
  // static String get nativeAdUnitId02 {
  //   if(productionMode) {
  //     return "ca-app-pub-5727425438286982/6479799046";
  //   }
  //   else {
  //     return "ca-app-pub-3940256099942544/2247696110";
  //   }
  // }

  static String get interstitialAdUnitId {
    if(productionMode) {
      return "ca-app-pub-9676410697154134/7183594362";
    }
    else {
      return "ca-app-pub-3940256099942544/1033173712";
    }
  }

  static String get rewardedAdUnitId {
    if(productionMode) {
      return "ca-app-pub-9676410697154134/7183594362";
    }
    else {
      return "ca-app-pub-3940256099942544/5224354917";
    }
  }

  static String get openAppAdUnitId {
    if(productionMode) {
      return "ca-app-pub-9676410697154134/9577027254";
    }
    else {
      return "ca-app-pub-3940256099942544/9257395921";
    }
  }

}