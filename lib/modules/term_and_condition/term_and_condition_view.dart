import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import '../../core/constants/app_constants/App_Constants.dart';
import '../../core/constants/color/color.dart';
import '../../core/utils/utils.dart';
import '../../core/widgets/common_text_field.dart';
import '../../core/app_singletons/app_singletons.dart';
import 'term_and_condition_controller.dart';

class TermAndConditionView extends GetView<TermAndConditionController> {
  const TermAndConditionView({super.key});

  @override
  Widget build(BuildContext context) {

    bool checkIsMobileLayout = AppConstants.isMobileScreen.value;

    return checkIsMobileLayout
        ? mainMobileLayout(context)
        : mainDesktopLayout(context);
  }

  Widget mainMobileLayout(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: mainPurpleColor,
        title:  Text('term_and_conditions'.tr,
          style: const TextStyle(
              fontFamily: 'Montserrat',
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
              Expanded(
                  child: controller.isLoading.value
                      ? const Center(
                      child: CupertinoActivityIndicator(
                        color: mainPurpleColor,
                        radius: 20,
                        animating: true,
                      ))
                      : controller.termList.isEmpty
                      ?  Center(
                    child: Text('tap_plus_to_add_term_and_condition'.tr,
                      style: const TextStyle(
                          fontFamily: 'Montserrat',
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: grey_1
                      ),
                    ),
                  )
                      : ListView.builder(
                      itemCount: controller.termList.length,
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        int reverse = controller.termList.length - 1 - index;
                        final note = controller.termList[reverse];
                        return InkWell(
                          onTap: () {
                            if (!AppSingletons().isComingFromBottomBar) {
                              if (AppSingletons.isInvoiceDocument.value) {
                                AppSingletons.termAndConditionINV?.value = note.tcDetail.toString();
                                AppSingletons.invDefaultTermAndCId?.value = note.id!;
                                Get.back();
                              } else {
                                AppSingletons.estTermAndConditionINV?.value = note.tcDetail.toString();
                                AppSingletons.estDefaultTermAndCId?.value = note.id!;
                                Get.back();
                              }
                            }
                          },
                          child: Container(
                            constraints: const BoxConstraints(minHeight: 50,),
                            margin: const EdgeInsets.symmetric(
                              horizontal: 15.0, vertical: 5.0,),
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
                                      note.tcDetail!,
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
                                  child: IconButton(
                                      onPressed: () {
                                        controller.deleteTerm(note.id!);
                                      },
                                      icon: const Icon(
                                        Icons.delete,
                                        color: starColor,
                                      )),
                                )
                              ],
                            ),
                          ),
                        );
                      })),
            ],
          ),),
      floatingActionButton: Visibility(
        // visible: AppSingletons().isComingFromBottomBar,
        child: FloatingActionButton(
          onPressed: () {
            addNewTermAndCondition(context);
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
        title: const Text('Term and conditions',
          style: TextStyle(
              fontFamily: 'Montserrat',
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
                image: AssetImage('assets/images/term_condition_back.jpg'),
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
                      return Expanded(
                          child: controller.isLoading.value
                              ? const Center(
                              child: CupertinoActivityIndicator(
                                color: mainPurpleColor,
                                radius: 20,
                                animating: true,
                              ))
                              : controller.termList.isEmpty
                              ? const Center(
                            child: Text('Tap + to add term and condition',
                              style: TextStyle(
                                  fontFamily: 'Montserrat',
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: grey_1
                              ),
                            ),
                          )
                              : ListView.builder(
                              itemCount: controller.termList.length,
                              shrinkWrap: true,
                              itemBuilder: (context, index) {
                                int reverse = controller.termList.length - 1 -
                                    index;
                                final note = controller.termList[reverse];
                                return InkWell(
                                  onTap: () {
                                    if (!AppSingletons().isComingFromBottomBar) {
                                      if (AppSingletons.isInvoiceDocument.value) {
                                        AppSingletons.termAndConditionINV?.value = note.tcDetail.toString();
                                        AppSingletons.invDefaultTermAndCId?.value = note.id!;
                                        Get.back();
                                      } else {
                                        AppSingletons.estTermAndConditionINV?.value = note.tcDetail.toString();
                                        AppSingletons.estDefaultTermAndCId?.value = note.id!;
                                        Get.back();
                                      }
                                    }
                                  },
                                  child: Container(
                                    constraints: const BoxConstraints(
                                      minHeight: 50,),
                                    margin: const EdgeInsets.symmetric(
                                      horizontal: 15.0, vertical: 5.0,),
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
                                              note.tcDetail!,
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
                                          child: IconButton(
                                              onPressed: () {
                                                controller.deleteTerm(note.id!);
                                              },
                                              icon: const Icon(
                                                Icons.delete,
                                                color: starColor,
                                              )),
                                        )
                                      ],
                                    ),
                                  ),
                                );
                              }));
                    }),
                    GestureDetector(
                      onTap: () {
                        addNewTermAndCondition(context);
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

  Future addNewTermAndCondition(BuildContext context) async {
    return Get.dialog(
        AlertDialog(
          backgroundColor: offWhite,
          title:  Text('new_term_and_condition'.tr,
            style: const TextStyle(
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
              textEditingController: controller.termAndCondController,
              maxLength: 500,
              hintText: 'enter_term_and_conditions'.tr,
              maxLines: 15,
              textInputType: TextInputType.text,
              textInputAction: TextInputAction.done,
            ),
          ),

          actions: [
            TextButton(onPressed: () {
              controller.termAndCondController.text = '';
              Get.back();
            },
              child:  Text('cancel'.tr,
                style: const TextStyle(
                    fontFamily: 'Montserrat',
                    color: grey_1,
                    fontSize: 15,
                    fontWeight: FontWeight.w600
                ),
              ),),

            TextButton(onPressed: () {
              if (controller.termAndCondController.text.isNotEmpty) {
                controller.saveData();
                controller.termAndCondController.text = '';
              } else {
                Utils().snackBarMsg(
                    '${'error'.tr}!!!', 'please_enter_terms_conditions'.tr);
              }
            },
              child: Text('save'.tr,
                style: const TextStyle(
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