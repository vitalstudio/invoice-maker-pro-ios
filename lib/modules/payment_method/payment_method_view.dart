import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import '../../core/constants/app_constants/App_Constants.dart';
import '../../core/app_singletons/app_singletons.dart';
import 'payment_method_controller.dart';
import '../../core/constants/color/color.dart';
import '../../core/utils/utils.dart';
import '../../core/widgets/common_text_field.dart';

class PaymentMethodView extends GetView<PaymentMethodController> {
  const PaymentMethodView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(PaymentMethodController());

    bool checkIsMobileLayout = AppConstants.isMobileScreen.value;

    return checkIsMobileLayout
        ? mainMobileLayout(context)
        : mainDesktopLayout(context);
  }

  Widget mainMobileLayout(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: mainPurpleColor,
        title: const Text('Payment Method',
          style: TextStyle(
              fontFamily: 'SFProDisplay',
              color: sWhite,
              fontWeight: FontWeight.w600,
              fontSize: 16
          ),
        ),
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: const Icon(Icons.arrow_back, color: sWhite, size: 20,),
        ),
      ),

      body: Obx(() =>
          Column(
            children: [
              Expanded(child: controller.isLoading.value
                  ? const Center(
                  child: CupertinoActivityIndicator(
                    color: mainPurpleColor,
                    radius: 20,
                    animating: true,
                  )) :
              controller.paymentList.isEmpty
                  ? const Center(
                child: Text('Tap + to add payment method',
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: grey_1
                  ),
                ),
              )
                  : ListView.builder(
                  itemCount: controller.paymentList.length,
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    int reverse = controller.paymentList.length - 1 - index;
                    final note = controller.paymentList[reverse];
                    return InkWell(
                      onTap: () {
                        if (!AppSingletons().isComingFromBottomBar) {
                          if (AppSingletons.isInvoiceDocument.value) {
                            AppSingletons.paymentMethodINV?.value = note.paymentMethod.toString();
                            AppSingletons.invDefaultPaymentMethodId?.value = note.id!;
                            Get.back();
                          } else {
                            AppSingletons.estPaymentMethodINV?.value = note.paymentMethod.toString();
                            AppSingletons.estDefaultPaymentMethodId?.value = note.id!;
                            Get.back();
                          }
                        }
                      },
                      child: Container(
                        constraints: const BoxConstraints(
                          minHeight: 50,
                        ),
                        margin: const EdgeInsets.symmetric(
                          horizontal: 15.0,
                          vertical: 5.0,
                        ),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                            color: sWhite,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: const [
                              BoxShadow(
                                  color: shadowColor,
                                  spreadRadius: 0.5,
                                  offset: Offset(1.5, 1.5)),
                              BoxShadow(
                                  color: shadowColor,
                                  spreadRadius: 0.3,
                                  offset: Offset(-0.25, -0.25)),
                            ]),

                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: SingleChildScrollView(
                                child: Text(
                                  note.paymentMethod!,
                                  textAlign: TextAlign.justify,
                                  style: const TextStyle(
                                      fontFamily: 'Montserrat',
                                      fontSize: 14,
                                      fontWeight: FontWeight.w400,
                                      color: blackColor
                                  ),
                                ),
                              ),
                            ),
                            Visibility(
                              visible: AppSingletons().isComingFromBottomBar,
                              child: IconButton(onPressed: () {
                                controller.deleteItem(note.id!);
                              },
                                  icon: const Icon(
                                    Icons.delete, color: starColor,)),
                            )
                          ],
                        ),

                      ),
                    );
                  }),
              ),
            ],
          ),),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          addNewPaymentMethod(context);
        },
        backgroundColor: mainPurpleColor,
        shape: const CircleBorder(),
        child: const Icon(Icons.add, color: sWhite,),
      ),
      bottomNavigationBar: Obx(() {
        return Visibility(
            visible: !AppSingletons.isSubscriptionEnabled.value,
            child: Visibility(
              visible: (Platform.isAndroid &&
                  AppSingletons.androidBannerAdsEnabled.value) ||
                  (Platform.isIOS &&
                      AppSingletons.iOSBannerAdsEnabled.value),
              child: controller.isBannerAdReady.value == true
                  ? Container(
                padding: const EdgeInsets.symmetric(vertical: 5),
                // width: controller.bannerAd.size.width.toDouble(),
                // width: double.infinity,
                height: 60,
                child: AdWidget(ad: controller.bannerAd),
              )
                  : Container(
                padding: const EdgeInsets.symmetric(vertical: 5),
                // width: controller.bannerAd.size.width.toDouble(),
                height: 50,
                child: const Center(child: Text('Loading Ad')),
              ),
            ));
      }),
    );
  }

  Widget mainDesktopLayout(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: mainPurpleColor,
        title: const Text('Payment Method',
          style: TextStyle(
              fontFamily: 'SFProDisplay',
              color: sWhite,
              fontWeight: FontWeight.w600,
              fontSize: 16
          ),
        ),
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: const Icon(Icons.arrow_back, color: sWhite, size: 20,),
        ),
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage('assets/images/payment_screen_back.jpg'),
                fit: BoxFit.fill
            )
        ),
        child: Column(
          children: [
            const SizedBox(height: 15,),
            Expanded(
              child: Container(
                width: MediaQuery
                    .of(context)
                    .size
                    .width * 0.5,
                decoration: BoxDecoration(
                    color: sWhite,
                    borderRadius: BorderRadius.circular(10)
                ),
                child: Column(
                  children: [
                    const SizedBox(height: 15,),
                    Obx(() {
                      return Expanded(child: controller.isLoading.value
                          ? const Center(
                          child: CupertinoActivityIndicator(
                            color: mainPurpleColor,
                            radius: 20,
                            animating: true,
                          )) :
                      controller.paymentList.isEmpty
                          ? const Center(
                        child: Text('Tap + to add signature',
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: grey_1
                          ),
                        ),
                      )
                          : ListView.builder(
                          itemCount: controller.paymentList.length,
                          shrinkWrap: true,
                          itemBuilder: (context, index) {
                            int reverse = controller.paymentList.length - 1 -
                                index;
                            final note = controller.paymentList[reverse];
                            return InkWell(
                              onTap: () {
                                if (!AppSingletons().isComingFromBottomBar) {
                                  if (AppSingletons.isInvoiceDocument.value) {
                                    AppSingletons.paymentMethodINV?.value = note.paymentMethod.toString();
                                    AppSingletons.invDefaultPaymentMethodId?.value = note.id!;
                                    Get.back();
                                  } else {
                                    AppSingletons.estPaymentMethodINV?.value = note.paymentMethod.toString();
                                    AppSingletons.estDefaultPaymentMethodId?.value = note.id!;
                                    Get.back();
                                  }
                                }
                              },
                              child: Container(
                                constraints: const BoxConstraints(
                                  minHeight: 50,
                                ),
                                margin: const EdgeInsets.symmetric(
                                  horizontal: 15.0,
                                  vertical: 5.0,
                                ),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 5),
                                decoration: BoxDecoration(
                                    color: sWhite,
                                    borderRadius: BorderRadius.circular(12),
                                    boxShadow: const [
                                      BoxShadow(
                                          color: shadowColor,
                                          spreadRadius: 0.5,
                                          offset: Offset(1.5, 1.5)),
                                      BoxShadow(
                                          color: shadowColor,
                                          spreadRadius: 0.3,
                                          offset: Offset(-0.25, -0.25)),
                                    ]),

                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment
                                      .spaceBetween,
                                  children: [
                                    Expanded(
                                      child: SingleChildScrollView(
                                        child: Text(
                                          note.paymentMethod!,
                                          textAlign: TextAlign.justify,
                                          style: const TextStyle(
                                              fontFamily: 'Montserrat',
                                              fontSize: 14,
                                              fontWeight: FontWeight.w400,
                                              color: blackColor
                                          ),
                                        ),
                                      ),
                                    ),
                                    Visibility(
                                      visible: AppSingletons()
                                          .isComingFromBottomBar,
                                      child: IconButton(onPressed: () {
                                        controller.deleteItem(note.id!);
                                      },
                                          icon: const Icon(
                                            Icons.delete, color: starColor,)),
                                    )
                                  ],
                                ),

                              ),
                            );
                          }),
                      );
                    }),
                    GestureDetector(
                      onTap: () {
                        addNewPaymentMethod(context);
                      },
                      child: Container(
                        width: double.infinity,
                        margin: const EdgeInsets.symmetric(horizontal: 20),
                        height: 50,
                        decoration: BoxDecoration(
                            color: mainPurpleColor,
                            borderRadius: BorderRadius.circular(10)
                        ),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              'Add New',
                              style: TextStyle(
                                  fontFamily: 'Montserrat',
                                  fontSize: 15,
                                  fontWeight: FontWeight.w700,
                                  color: sWhite
                              ),
                            ),
                            SizedBox(width: 5,),
                            Icon(Icons.add, color: sWhite,),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 15,),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 15,),
          ],
        ),
      ),
    );
  }

  Future addNewPaymentMethod(BuildContext context) async {
    return Get.dialog(
        AlertDialog(
          backgroundColor: offWhite,
          title: const Text('New payment method',
            style: TextStyle(
                fontFamily: 'Montserrat',
                color: grey_1,
                fontSize: 16,
                fontWeight: FontWeight.w600
            ),
          ),
          content: Container(
            margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            width: AppConstants.isMobileScreen.value
                ? MediaQuery
                .of(context)
                .size
                .width * 0.8
                : MediaQuery
                .of(context)
                .size
                .width * 0.3,
            child: CommonTextField(
              textEditingController: controller.paymentController,
              maxLength: 500,
              hintText: 'Enter payment method',
              maxLines: 15,
              textInputType: TextInputType.text,
              textInputAction: TextInputAction.done,
            ),
          ),

          actions: [
            TextButton(onPressed: () {
              Get.back();
            },
              child: const Text('Cancel',
                style: TextStyle(

                    color: grey_1,
                    fontSize: 15,
                    fontWeight: FontWeight.w600
                ),
              ),),

            TextButton(onPressed: () {
              if (controller.paymentController.text.isNotEmpty) {
                controller.saveData();
              } else {
                Utils().snackBarMsg(
                    'Error!!!', 'Please payment method to save');
              }
            },
              child: const Text('Save',
                style: TextStyle(
                    fontFamily: 'Montserrat',
                    color: grey_1,
                    fontSize: 15,
                    fontWeight: FontWeight.w600
                ),
              ),),

          ],

        )
    );
  }

}
