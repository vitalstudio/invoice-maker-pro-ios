import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import '../../core/constants/app_constants/App_Constants.dart';
import '../../modules/signature_for_invoice/signature_list_controller.dart';
import '../../core/app_singletons/app_singletons.dart';
import '../../core/constants/color/color.dart';
import '../../core/routes/routes.dart';

class SignatureListView extends GetView<SignatureListController> {
  const SignatureListView({super.key});

  @override
  Widget build(BuildContext context) {

    bool checkIsMobileLayout = AppConstants.isMobileScreen.value;

    return checkIsMobileLayout
        ? mainMobileLayout()
        : mainDesktopLayout(context);
  }

  Widget mainMobileLayout() {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: mainPurpleColor,
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: const Icon(Icons.arrow_back, color: sWhite, size: 20,),
        ),
        title: const Text('Signature Info', style: TextStyle(
            fontFamily: 'Montserrat',
            color: sWhite,
            fontWeight: FontWeight.w600,
            fontSize: 16),),
      ),

      body: Obx(() =>
          Column(
            children: [
              Expanded(
                child: controller.isLoading.value
                    ? const Center(
                    child: CupertinoActivityIndicator(
                      color: mainPurpleColor,
                      radius: 20,
                      animating: true,
                    ))
                    : controller.signatureList.isEmpty
                    ? const Center(
                  child: Text('Tap + to add signature',
                    style: TextStyle(
                        fontFamily: 'Montserrat',
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: grey_1),
                  ),
                ) : ListView.builder(
                    itemCount: controller.signatureList.length,
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      int reverse =
                          controller.signatureList.length - 1 - index;
                      final note = controller.signatureList[reverse];

                      return InkWell(
                        onTap: () {
                          if (!AppSingletons().isComingFromBottomBar) {
                            if (AppSingletons.isInvoiceDocument.value) {
                              AppSingletons.signatureImgINV?.value =
                              note.pngBytes!;

                              AppSingletons.invDefaultSignatureId?.value = note.id!;

                              Get.back();
                            } else {
                              AppSingletons.estSignatureImgINV?.value = note.pngBytes!;
                              AppSingletons.estDefaultSignatureId?.value = note.id!;
                              Get.back();
                            }
                          }
                        },
                        child: Container(
                          height: 100,
                          margin: const EdgeInsets.symmetric(
                            horizontal: 15.0,
                            vertical: 5.0,
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 10),
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
                              Image.memory(note.pngBytes!),
                              Visibility(
                                visible: AppSingletons().isComingFromBottomBar,
                                child: IconButton(onPressed: () {
                                  controller.deleteSignature(note.id!);
                                },
                                    icon: const Icon(
                                      Icons.delete, color: starColor,)),
                              ),
                            ],
                          ),
                        ),
                      );
                    }),
              ),
            ],
          ),
      ),

      floatingActionButton: Visibility(
        // visible: AppSingletons().isComingFromBottomBar,
        child: FloatingActionButton(
          onPressed: () {
            Get.toNamed(Routes.addNewSignatureView);
          },
          backgroundColor: mainPurpleColor,
          shape: const CircleBorder(),
          child: const Icon(Icons.add, color: sWhite,),
        ),
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
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: const Icon(Icons.arrow_back, color: sWhite, size: 20,),
        ),
        title: const Text('Signature Info', style: TextStyle(
            fontFamily: 'Montserrat',
            color: sWhite,
            fontWeight: FontWeight.w600,
            fontSize: 16),),
      ),
      body: Container(
        alignment: Alignment.center,
        decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage('assets/images/signature_screen_back.jpg'),
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
                    .width * 0.6,
                decoration: BoxDecoration(
                    color: sWhite,
                    borderRadius: BorderRadius.circular(10)
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20,),
                    Obx(() {
                      return Expanded(
                        child: controller.isLoading.value
                            ? const Center(
                            child: CupertinoActivityIndicator(
                              color: mainPurpleColor,
                              radius: 20,
                              animating: true,
                            ))
                            : controller.signatureList.isEmpty
                            ? const Center(
                          child: Text('Tap + to add signature',
                            style: TextStyle(
                                fontFamily: 'Montserrat',
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: grey_1),
                          ),
                        ) : ListView.builder(
                            itemCount: controller.signatureList.length,
                            shrinkWrap: true,
                            itemBuilder: (context, index) {
                              int reverse =
                                  controller.signatureList.length - 1 - index;
                              final note = controller.signatureList[reverse];

                              return InkWell(
                                onTap: () {
                                  if (!AppSingletons().isComingFromBottomBar) {
                                    if (AppSingletons.isInvoiceDocument.value) {
                                      AppSingletons.signatureImgINV?.value =
                                      note.pngBytes!;

                                      AppSingletons.invDefaultSignatureId?.value = note.id!;

                                      Get.back();
                                    } else {
                                      AppSingletons.estSignatureImgINV?.value = note.pngBytes!;
                                      AppSingletons.estDefaultSignatureId?.value = note.id!;
                                      Get.back();
                                    }
                                  }
                                },
                                child: Container(
                                  height: 100,
                                  margin: const EdgeInsets.symmetric(
                                    horizontal: 15.0,
                                    vertical: 5.0,
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10),
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
                                      Image.memory(note.pngBytes!),
                                      Visibility(
                                        visible: AppSingletons()
                                            .isComingFromBottomBar,
                                        child: IconButton(onPressed: () {
                                          controller.deleteSignature(note.id!);
                                        },
                                            icon: const Icon(
                                              Icons.delete, color: starColor,)),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            }),
                      );
                    }),
                    GestureDetector(
                      onTap: () {
                        Get.toNamed(Routes.addNewSignatureView);
                      },
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 20),
                        width: double.infinity,
                        height: 50,
                        decoration: BoxDecoration(
                          color: mainPurpleColor,
                          borderRadius: BorderRadius.circular(10),
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
                            SizedBox(
                              width: 10,
                            ),
                            Icon(Icons.add, color: sWhite, size: 20,),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 20,),
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
}