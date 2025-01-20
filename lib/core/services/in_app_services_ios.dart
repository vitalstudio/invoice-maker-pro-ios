// import 'dart:async';
// import 'package:flutter/services.dart';
// import '../../core/constants/app_constants/App_Constants.dart';
// import '../../core/preferenceManager/sharedPreferenceManager.dart';
// import '../../modules/pro_screen/pro_screen_controller.dart';
// import 'package:purchases_flutter/purchases_flutter.dart';
//
// import '../app_singletons/app_singletons.dart';
//
// class InAppServicesForIOS {
//   StreamSubscription<dynamic>? _subscription;
//
//   static const Set<String> _kIds = <String>{
//     'weekly_invoice_pro',
//     'monthly_invoice_pro',
//     'yearly_invoice_pro'
//   };
//
// // Call this method in the main.dart file
//   Future<void> initPlatformState() async {
//     await Purchases.setDebugLogsEnabled(true);
//
//     PurchasesConfiguration configuration;
//     print("initPlatformState");
//
//     configuration = PurchasesConfiguration("appl_eQscdnEIAawXjsITtfNidCoISSo");
//
//     await Purchases.configure(configuration);
//   }
//
// //TODO: call this method in the init state of pro screen
//   Future<List<Package>> getProducts() async {
//     List<Package> allPackages = [];
//     try {
//       Offerings offerings = await Purchases.getOfferings();
//       if (offerings.current != null &&
//           offerings.current!.availablePackages.isNotEmpty) {
//         print("Flutter Offerings:: ${offerings.current!.availablePackages}");
//         allPackages = offerings.current!.availablePackages;
//
//         // Display packages for sale
//       }
//     } on PlatformException catch (e) {
//       allPackages = [];
//       // optional error handling
//     }
//     return allPackages;
//   }
//
// //Call this method on buy now button
//   void buyProduct(Package package, PurchaseCallback callback) async {
//     // Using Offerings/Packages
//     try {
//       CustomerInfo customerInfo = await Purchases.purchasePackage(package);
//       if (customerInfo.entitlements.all["premium"]!.isActive) {
//         callback.onPurchaseSuccessCallback();
//       }
//     } on PlatformException catch (e) {
//       callback.onPurchaseFailureCallback();
//       var errorCode = PurchasesErrorHelper.getErrorCode(e);
//       if (errorCode != PurchasesErrorCode.purchaseCancelledError) {}
//     }
//   }
//
//   Future<bool> checkSubscriptionStatus() async {
//     bool isActive = false;
//     try {
//       CustomerInfo customerInfo = await Purchases.getCustomerInfo();
//       if (customerInfo.entitlements.all.isNotEmpty) {
//         isActive = customerInfo.entitlements.all['premium']!.isActive;
//       }
//
//       // access latest customerInfo
//     } on PlatformException catch (e) {
//       isActive = SharedPreferencesManager.getValue(AppConstants.userStatusKey) ??
//               false;
//       // Error fetching customer info
//     }
//     return isActive;
//   }
//
//   //Call on the Restore purchase button....
//
//   Future restorePurchase(PurchaseCallback purchaseCallback) async {
//     try {
//       CustomerInfo customerInfo = await Purchases.restorePurchases();
//       // ... check restored purchaserInfo to see if entitlement is now active
//       if (customerInfo.entitlements.all.isNotEmpty) {
//         if (customerInfo.entitlements.all['premium']!.isActive) {
//           purchaseCallback.onPurchasedRestored();
//           AppSingletons.isSubscriptionEnabled.value = true;
//           SharedPreferencesManager.setValue(AppConstants.userStatusKey, true);
//         } else {
//           purchaseCallback.onPurchaseExpired();
//           AppSingletons.isSubscriptionEnabled.value = false;
//           SharedPreferencesManager.setValue(AppConstants.userStatusKey, false);
//         }
//       } else {
//         purchaseCallback.onPurchaseExpired();
//         AppSingletons.isSubscriptionEnabled.value = false;
//         SharedPreferencesManager.setValue(AppConstants.userStatusKey, false);
//       }
//     } on PlatformException catch (e) {
//       // Error restoring purchases
//     }
//   }
//
//   void buyTestProduct(PurchaseCallback purchaseCallback) {
//     purchaseCallback.onPurchaseSuccessCallback();
//   }
// }

import 'dart:async';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../../core/constants/app_constants/App_Constants.dart';
import '../../core/preferenceManager/sharedPreferenceManager.dart';
import '../../modules/pro_screen/pro_screen_controller.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

import '../app_singletons/app_singletons.dart';

class InAppServicesForIOS extends GetxController {

  StreamSubscription<dynamic>? _subscription;

  static const Set<String> _kIds = <String>{
    'weekly_invoice_pro',
    'monthly_invoice_pro',
    'yearly_invoice_pro'
  };

// Call this method in the main.dart file
  Future<void> initPlatformState() async {
    // await Purchases.setDebugLogsEnabled(true);

    PurchasesConfiguration configuration;
    print("initPlatformState");

    configuration = PurchasesConfiguration("appl_eQscdnEIAawXjsITtfNidCoISSo");

    await Purchases.configure(configuration);
  }

//TODO: call this method in the init state of pro screen
  Future<List<Package>> getProducts() async {
    List<Package> allPackages = [];
    try {
      Offerings offerings = await Purchases.getOfferings();
      if (offerings.current != null &&
          offerings.current!.availablePackages.isNotEmpty) {
        print("Flutter Offerings:: ${offerings.current!.availablePackages}");
        allPackages = offerings.current!.availablePackages;

        // Display packages for sale
      }
    } on PlatformException catch (e) {
      allPackages = [];
      // optional error handling
    }
    return allPackages;
  }

//Call this method on buy now button
  void buyProduct(Package package, PurchaseCallback callback) async {
    // Using Offerings/Packages
    try {
      CustomerInfo customerInfo = await Purchases.purchasePackage(package);
      if (customerInfo.entitlements.all["premium"]!.isActive) {
        callback.onPurchaseSuccessCallback();
      }
    } on PlatformException catch (e) {
      callback.onPurchaseFailureCallback();
      var errorCode = PurchasesErrorHelper.getErrorCode(e);
      if (errorCode != PurchasesErrorCode.purchaseCancelledError) {}
    }
  }

  Future<bool> checkSubscriptionStatus() async {
    bool isActive = false;
    try {
      CustomerInfo customerInfo = await Purchases.getCustomerInfo();
      if (customerInfo.entitlements.all.isNotEmpty) {
        isActive = customerInfo.entitlements.all['premium']!.isActive;
      }

      // access latest customerInfo
    } on PlatformException catch (e) {
      isActive = SharedPreferencesManager.getValue(AppConstants.userStatusKey) ??
          false;
      // Error fetching customer info
    }
    return isActive;
  }

  //Call on the Restore purchase button....

  Future restorePurchase(PurchaseCallback purchaseCallback) async {
    try {
      CustomerInfo customerInfo = await Purchases.restorePurchases();
      // ... check restored purchaserInfo to see if entitlement is now active
      if (customerInfo.entitlements.all.isNotEmpty) {
        if (customerInfo.entitlements.all['premium']!.isActive) {
          purchaseCallback.onPurchasedRestored();
          AppSingletons.isSubscriptionEnabled.value = true;
          SharedPreferencesManager.setValue(AppConstants.userStatusKey, true);

          Get.back();

        } else {
          purchaseCallback.onPurchaseExpired();
          AppSingletons.isSubscriptionEnabled.value = false;
          SharedPreferencesManager.setValue(AppConstants.userStatusKey, false);
        }
      } else {
        purchaseCallback.onPurchaseExpired();
        AppSingletons.isSubscriptionEnabled.value = false;
        SharedPreferencesManager.setValue(AppConstants.userStatusKey, false);
      }
    } on PlatformException catch (e) {
      // Error restoring purchases
    }
  }

  void buyTestProduct(PurchaseCallback purchaseCallback) {
    purchaseCallback.onPurchaseSuccessCallback();
  }

  @override
  void onInit() {
    if(Platform.isIOS || Platform.isMacOS) {
      initPlatformState();
    }
    super.onInit();
  }

}
