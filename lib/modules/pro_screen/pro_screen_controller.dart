import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:invoice/core/services/in_app_services_ios.dart';
import '../../core/app_singletons/app_singletons.dart';
import '../../core/constants/app_constants/App_Constants.dart';
import '../../core/preferenceManager/sharedPreferenceManager.dart';
import '../../core/services/in_app_services.dart';
import 'package:purchases_flutter/models/package_wrapper.dart';

abstract class PurchaseCallback {
  void onPurchaseSuccessCallback();

  void onPurchaseFailureCallback();

  void onPurchasedRestored();

  void onPurchaseExpired();
}

class ProScreenController extends GetxController implements PurchaseCallback{
  // List<ProductDetails> productsDetails = [];

  RxList<ProductDetails> productsDetailsAndroid = <ProductDetails>[].obs;
  Rx<List<Package>> productsDetailsIOS = Rx<List<Package>>([]);

  RxBool isUserPro = false.obs;

  RxString lifeTimeValue = ''.obs;
  RxString yearlyPurchaseValue = ''.obs;
  RxString monthlyPurchaseValue = ''.obs;
  RxString weeklyPurchaseValue = ''.obs;

  List imagesList = [
    'assets/images/slide1.jpg',
    'assets/images/slide2.jpg',
    'assets/images/slide3.jpg',
    'assets/images/slide4.jpg',
    'assets/images/slide5.jpg',
  ];

  void nowGetProductsForAndroid() async {
    List<ProductDetails> items = await InAppServices().getStoreProducts();
    productsDetailsAndroid.assignAll(items);

    yearlyPurchaseValue.value = productsDetailsAndroid[3].rawPrice.toString();
    monthlyPurchaseValue.value = productsDetailsAndroid[1].rawPrice.toString();
    weeklyPurchaseValue.value = productsDetailsAndroid[2].rawPrice.toString();
    lifeTimeValue.value = productsDetailsAndroid[0].rawPrice.toString();

    debugPrint("InApp Products:: $productsDetailsAndroid");
  }

  void nowGetProductsIOS() async {
    List<Package> items = await InAppServicesForIOS().getProducts();
    productsDetailsIOS.value.assignAll(items);


    yearlyPurchaseValue.value = setCurrencyCodeAndPriceString(
        productsDetailsIOS.value[2].storeProduct.price,
        productsDetailsIOS.value[2].storeProduct.currencyCode);
    monthlyPurchaseValue.value = setCurrencyCodeAndPriceString(
        productsDetailsIOS.value[1].storeProduct.price,
        productsDetailsIOS.value[1].storeProduct.currencyCode);
    weeklyPurchaseValue.value = setCurrencyCodeAndPriceString(
        productsDetailsIOS.value[0].storeProduct.price,
        productsDetailsIOS.value[0].storeProduct.currencyCode);
    lifeTimeValue.value = setCurrencyCodeAndPriceString(
        productsDetailsIOS.value[3].storeProduct.price,
        productsDetailsIOS.value[3].storeProduct.currencyCode);

  }

  String setCurrencyCodeAndPriceString(double price, String currencyCode){
    String returnString = '$currencyCode ${price.toStringAsFixed(2)}';
    return returnString;
  }

  @override
  void onInit() {
    // if (Platform.isAndroid) {
    //   InAppServices().initializedPurchase(this);
    //   // WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
    //   //
    //   // });
    // }
    super.onInit();
  }

  @override
  void onReady() {
    if(Platform.isAndroid) {
      nowGetProductsForAndroid();
    } else if(Platform.isIOS || Platform.isMacOS){
      nowGetProductsIOS();
    }
    super.onReady();
  }

  void buyProduct(ProductDetails productDetails) {
    try {

      // Utils().snackBarMsg('Buy Product Dialogue Open', 'From Pro Screen Controller');

      debugPrint(productDetails.id);

      InAppServices().buyProduct(productDetails);
    } catch (e) {
      debugPrint('$e');
    }
  }

  void buyProductIOS(Package package) {
    try {
      InAppServicesForIOS().buyProduct(package, this);
    } catch (e) {
      debugPrint('$e');
    }
  }

  void getRestoreProduct(){
    try {
      InAppServicesForIOS().restorePurchase(this);
    } catch (e) {
      debugPrint('$e');
    }
  }

  @override
  void onPurchaseFailureCallback() {
    // TODO: implement onPurchaseFailureCallback
    // isUserPro.value =
    //     SharedPreferencesManager.getValue(AppConstants.userStatusKey)??false;
  }

  @override
  void onPurchaseSuccessCallback() {
    // TODO: implement onPurchaseSuccessCallback

    // Utils().snackBarMsg('onPurchaseSuccessCallback', 'CALLED');

    isUserPro.value = true;
    AppSingletons.isSubscriptionEnabled.value = true;
    // Utils().snackBarMsg('onPurchaseSuccessCallback', 'Value Assigned');
    SharedPreferencesManager.setValue(AppConstants.userStatusKey, true);
    Get.back();
  }

  @override
  void onPurchasedRestored() {
    isUserPro.value = true;
    AppSingletons.isSubscriptionEnabled.value = true;
    SharedPreferencesManager.setValue(AppConstants.userStatusKey, true);

    // TODO: implement onPurchasedRestored
  }

  @override
  void onPurchaseExpired() {
    // TODO: implement onPurchaseExpired
    isUserPro.value = false;
    AppSingletons.isSubscriptionEnabled.value = false;
    SharedPreferencesManager.setValue(AppConstants.userStatusKey, false);
  }

}
