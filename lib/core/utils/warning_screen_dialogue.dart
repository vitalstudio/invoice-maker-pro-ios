import 'dart:io';

import 'package:currency_code_to_currency_symbol/currency_code_to_currency_symbol.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import '../../core/constants/color/color.dart';
import '../../core/routes/routes.dart';
import 'package:purchases_flutter/models/package_wrapper.dart';
import '../../modules/pro_screen/pro_screen_controller.dart';
import '../app_singletons/app_singletons.dart';
import '../constants/app_constants/App_Constants.dart';
import '../preferenceManager/sharedPreferenceManager.dart';
import '../services/in_app_services.dart';
import '../services/in_app_services_ios.dart';

class WarningScreenDialogue extends GetxController implements PurchaseCallback {

  RxList<ProductDetails> productsDetailsAndroid = <ProductDetails>[].obs;
  Rx<List<Package>> productsDetailsIOS = Rx<List<Package>>([]);

  RxString monthlyPurchaseValue = ''.obs;
  RxString perWeekMonthlyValue = ''.obs;

  RxString discPercInMonthlyAmount = ''.obs;

  Future showWarningDialogue({required BuildContext context,
    required bool isInvoiceWarningBox
  }) async {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            child: Container(
              height: 550,
              decoration: BoxDecoration(
                  color: sWhite,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: const [
                    BoxShadow(
                        color: mainPurpleColor,
                        blurRadius: 10,
                        spreadRadius: 5,
                        offset: Offset(1, 1)
                    )
                  ]
              ),
              child: Column(
                children: [
                  const SizedBox(height: 10,),

                  Container(
                    margin: const EdgeInsets.only(
                        right: 10
                    ),
                    alignment: Alignment.centerRight,
                    child: GestureDetector(
                        onTap: () {
                          Get.back();
                        },
                        child: const Icon(
                          Icons.cancel_outlined,
                          color: mainPurpleColor,
                          size: 30,
                        )
                    ),
                  ),

                  const Icon(Icons.warning, color: redTemplate, size: 50,),

                  const SizedBox(height: 10,),

                  Text(
                    isInvoiceWarningBox
                        ? 'invoice_limit_reached'.tr
                        : 'estimate_limit_reached'.tr,
                    style: const TextStyle(
                        fontFamily: 'Montserrat',
                        color: blackColor,
                        fontSize: 20,
                        fontWeight: FontWeight.bold
                    ),
                  ),

                  const SizedBox(height: 10,),

                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 10),
                    alignment: Alignment.center,
                    child: Text(
                      'free_invoice_limit_message'.tr,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                          fontFamily: 'Montserrat',
                          color: blackColor,
                          fontSize: 15,
                          fontWeight: FontWeight.w600
                      ),
                    ),
                  ),

                  const Spacer(),

                  Stack(
                    children: [
                      Align(
                        alignment: Alignment.center,
                        child: Container(
                          width: 170,
                          height: 135,
                          margin: const EdgeInsets.only(top: 20),
                          decoration: BoxDecoration(
                            color: mainPurpleColor,
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const SizedBox(
                                height: 22,
                              ),
                              Center(
                                child: Obx(() {
                                  return Text(
                                    '${'save'.tr} ${discPercInMonthlyAmount
                                        .value}%',
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                        fontFamily: 'Montserrat',
                                        color: sWhite,
                                        fontSize: 22,
                                        fontWeight: FontWeight.w600
                                    ),
                                  );
                                }),
                              ),
                              const SizedBox(
                                height: 5,
                              ),

                              Center(
                                child: Obx(() {
                                  return Text(
                                    monthlyPurchaseValue.value.isNotEmpty
                                        || monthlyPurchaseValue.value != ''
                                        ? monthlyPurchaseValue.value
                                        : '\$00.00',
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                        fontFamily: 'Montserrat',
                                        color: sWhite,
                                        fontSize: 27,
                                        fontWeight: FontWeight.w600
                                    ),
                                  );
                                }),
                              ),

                              const SizedBox(
                                height: 3,
                              ),

                              Center(
                                child: Obx(() {
                                  return Text(
                                    perWeekMonthlyValue.value.isNotEmpty
                                        || perWeekMonthlyValue.value != ''
                                        ? '${perWeekMonthlyValue
                                        .value} ${'per_week'.tr}'
                                        : '00.00 ${'per_week'.tr}',
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                        fontFamily: 'Montserrat',
                                        color: sWhite,
                                        fontSize: 17,
                                        fontWeight: FontWeight.w600
                                    ),
                                  );
                                }),
                              ),

                            ],
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.center,
                        child: Container(
                          width: 140,
                          decoration: BoxDecoration(
                              color: sWhite,
                              border: Border.all(
                                  color: mainPurpleColor,
                                  width: 1.5
                              ),
                              borderRadius: BorderRadius.circular(5)
                          ),
                          padding: const EdgeInsets.all(3),
                          child: Text(
                            'monthly_plan'.tr,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                                fontFamily: 'Montserrat',
                                color: blackColor,
                                fontSize: 20,
                                fontWeight: FontWeight.w600
                            ),
                          ),
                        ),
                      )
                    ],
                  ),

                  const Spacer(),

                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 10),
                    alignment: Alignment.center,
                    child: Text(
                      'no_commitment'.tr,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                          fontFamily: 'Montserrat',
                          color: blackColor,
                          fontSize: 15,
                          fontWeight: FontWeight.w600
                      ),
                    ),
                  ),

                  const SizedBox(height: 5,),

                  GestureDetector(
                    onTap: () {
                      buyProductIOS(
                          productsDetailsIOS.value[1]);
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: redTemplate,
                        borderRadius: BorderRadius.circular(5),
                      ),
                      padding: const EdgeInsets.symmetric(
                          vertical: 2,
                          horizontal: 20
                      ),
                      child: Text(
                        'continue'.tr,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                            fontFamily: 'Montserrat',
                            color: sWhite,
                            fontSize: 36,
                            fontWeight: FontWeight.w600
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 15,),

                  GestureDetector(
                    onTap: () {
                      Get.toNamed(Routes.proScreenView);
                    },
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 10),
                      alignment: Alignment.center,
                      child: Text(
                        'see_other_plan'.tr,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                            fontFamily: 'Montserrat',
                            color: blackColor,
                            fontSize: 20,
                            fontWeight: FontWeight.w700
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 5,),
                ],
              ),
            ),
          );
        }
    );
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

  void getRestoreProduct() {
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

    // isUserPro.value = true;
    AppSingletons.isSubscriptionEnabled.value = true;
    // Utils().snackBarMsg('onPurchaseSuccessCallback', 'Value Assigned');
    SharedPreferencesManager.setValue(AppConstants.userStatusKey, true);
    Get.back();
  }

  @override
  void onPurchasedRestored() {
    // isUserPro.value = true;
    AppSingletons.isSubscriptionEnabled.value = true;
    SharedPreferencesManager.setValue(AppConstants.userStatusKey, true);
  }

  @override
  void onPurchaseExpired() {
    // isUserPro.value = false;
    AppSingletons.isSubscriptionEnabled.value = false;
    SharedPreferencesManager.setValue(AppConstants.userStatusKey, false);
  }

  void nowGetProductsIOS() async {
    debugPrint('nowGetProductsIOS CALLED');
    List<Package> items = await InAppServicesForIOS().getProducts();
    productsDetailsIOS.value.assignAll(items);

    monthlyPurchaseValue.value = setCurrencyCodeAndPriceString(
        productsDetailsIOS.value[1].storeProduct.price,
        getCurrencySymbol(
            productsDetailsIOS.value[1].storeProduct.currencyCode));

    double monthlyValue = productsDetailsIOS.value[1].storeProduct.price;
    double convertToPerWeek = monthlyValue / 4.325;

    perWeekMonthlyValue.value = convertToPerWeek.toStringAsFixed(2);

    discPercInMonthlyAmount.value = calculateMonthlyPercentage(
        monthlyVal: productsDetailsIOS.value[1].storeProduct.price,
        weeklyVal: productsDetailsIOS.value[0].storeProduct.price
    );
  }

  void nowGetProductsForAndroid() async {
    List<ProductDetails> items = await InAppServices().getStoreProducts();
    productsDetailsAndroid.assignAll(items);

    monthlyPurchaseValue.value = setCurrencyCodeAndPriceString(
        productsDetailsAndroid[1].rawPrice,
        getCurrencySymbol(productsDetailsAndroid[1].currencyCode));

    String currencyCode = productsDetailsAndroid[1].currencyCode;
    debugPrint('CurrencyCode: $currencyCode');

    String symbolFromCode = getCurrencySymbol(currencyCode);

    debugPrint('CurrencySymbol: $symbolFromCode');

    debugPrint("InApp Products:: $productsDetailsAndroid");

    double monthlyAmount = productsDetailsAndroid[1].rawPrice;
    double convertToPerWeek = monthlyAmount / 4.325;

    perWeekMonthlyValue.value = convertToPerWeek.toStringAsFixed(2);

    discPercInMonthlyAmount.value = calculateMonthlyPercentage(
        monthlyVal: productsDetailsAndroid[1].rawPrice,
        weeklyVal: productsDetailsAndroid[2].rawPrice
    );
  }

  String setCurrencyCodeAndPriceString(double price, String currencyCode) {
    String returnString = '$currencyCode ${price.toStringAsFixed(2)}';
    return returnString;
  }

  @override
  void onReady() {
    super.onReady();
    debugPrint('OnReady Start');
    if(Platform.isAndroid) {
      nowGetProductsForAndroid();
    } else{
      nowGetProductsIOS();
    }

  }

  String calculateMonthlyPercentage({
    required double monthlyVal,
    required double weeklyVal,
  }) {
    double originalValWeek = weeklyVal * 4.33;

    double minusVal = originalValWeek - monthlyVal;
    double divVal = minusVal / originalValWeek;

    double percentageVal = divVal * 100;

    debugPrint('Per Month: ${percentageVal.toStringAsFixed(0)}');

    return percentageVal.toStringAsFixed(0);
  }

}