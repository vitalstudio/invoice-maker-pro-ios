import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import '../../core/constants/app_constants/App_Constants.dart';
import '../../core/app_singletons/app_singletons.dart';
import '../../core/utils/utils.dart';
import '../../core/widgets/common_text_field.dart';
import '../../core/widgets/custom_container.dart';
import '../../core/constants/color/color.dart';
import '../../core/widgets/dialogueToDelete.dart';
import 'business_info_controller.dart';

class BusinessInfoView extends GetView<BusinessInfoController> {
  const BusinessInfoView({super.key});

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
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: const Icon(Icons.arrow_back_rounded, color: sWhite,),
        ),
        title: Text(
          AppSingletons().isEditingBusinessInfo
              ? 'business_info'.tr
              : 'new_business'.tr,
          style: const TextStyle(
              fontFamily: 'SFProDisplay',
              color: sWhite,
              fontSize: 18,
              fontWeight: FontWeight.w600,
              letterSpacing: 1.5),
        ),

        actions: [
          Visibility(
            visible: AppSingletons().isEditingBusinessInfo,
            child: IconButton(
                onPressed: () {
                  CustomDialogues.showDialogueToDelete(
                      true,
                      'delete_business'.tr,
                      'are_you_sure_you_want_to_delete'.tr,
                          // 'are_you_sure_you_want_to_delete ${controller
                      //                           .businessNameController
                      //                           .text} from your business list?'
                          '?',
                          () =>
                          controller.businessListController.deleteBusiness(
                              controller.indexId.value),
                          () => controller.businessListController.loadData());
                },
                icon: const Icon(Icons.delete, size: 20, color: sWhite,)),
          ),

          IconButton(
              onPressed: () {
                if (controller.isTextEmpty.value) {
                  Utils().snackBarMsg(
                      'business_name'.tr, 'must_be_entered'.tr);
                } else {
                  controller.showAd();
                  if (AppSingletons().isEditingBusinessInfo) {
                    controller.editBusinessInfo();
                  } else {
                    controller.saveData();
                    Get.back();
                  }
                }
              },
              icon: const Icon(Icons.check, size: 20, color: sWhite,)
          )
        ],

      ),

      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(top: 10),
          child: CustomContainer(
            verticalPadding: 10,
            horizontalPadding: 10,
            childContainer: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20,),

                Align(
                  alignment: Alignment.center,
                  child: GestureDetector(
                    onTap: () {
                      controller.pickGalleryImage(context);
                    },
                    child: Obx(() {
                      return Container(
                        width: 100,
                        height: 100,
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          border: Border.all(
                            color: shadowColor,
                          ),
                        ),
                        child: controller.businessLogoImg.value.isEmpty
                            ? const Icon(
                          Icons.add, size: 35, color: shadowColor,)
                            : Image.memory(controller.businessLogoImg.value,
                            fit: BoxFit.fill),
                      );
                    }),
                  ),
                ),

                const SizedBox(height: 20,),

                Row(
                  children: [
                    Text('business_name'.tr,
                      style: const TextStyle(
                          fontFamily: 'Montserrat',
                          fontWeight: FontWeight.w600, color: grey_1,fontSize: 14),),
                    const SizedBox(width: 5,),
                    const Text(
                      '*', style: TextStyle(fontFamily: 'Montserrat',color: starColor),),
                  ],
                ),
                const SizedBox(height: 5,),

                CommonTextField(
                  hintText: 'enter_business_name'.tr,
                  maxLines: 1,
                  textInputType: TextInputType.name,
                  textEditingController: controller.businessNameController,
                  maxLength: 40,
                ),
                const SizedBox(height: 10,),

                Text('email_address'.tr,
                  style: const TextStyle(
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w600, color: grey_1,fontSize: 14),
                ),
                const SizedBox(height: 5,),
                CommonTextField(
                  hintText: 'enter_email_address'.tr,
                  maxLines: 1,
                  textInputType: TextInputType.emailAddress,
                  textEditingController: controller.emailAddressController,
                ),

                const SizedBox(height: 10,),

                 Text('phone'.tr, style: const TextStyle(
                    fontFamily: 'Montserrat',fontSize: 14,
                    fontWeight: FontWeight.w600, color: grey_1),),
                const SizedBox(height: 5,),
                CommonTextField(
                  hintText: 'enter_phone_number'.tr,
                  maxLines: 1,
                  textInputType: TextInputType.phone,
                  textEditingController: controller.phoneController,
                ),

                const SizedBox(height: 10,),

                 Text('billing_address'.tr, style: const TextStyle(
                    fontFamily: 'Montserrat',fontSize: 14,
                    fontWeight: FontWeight.w600, color: grey_1),),
                const SizedBox(height: 5,),
                CommonTextField(
                  hintText: 'enter_billing_address'.tr,
                  maxLines: 1,
                  textInputType: TextInputType.text,
                  textEditingController: controller.billAddressONEController,
                ),
                const SizedBox(height: 10,),

                Text('business_website'.tr, style: const TextStyle(
                    fontFamily: 'Montserrat',fontSize: 14,
                    fontWeight: FontWeight.w600, color: grey_1),),
                const SizedBox(height: 5,),
                CommonTextField(
                  hintText: 'enter_business_website'.tr,
                  maxLines: 1,
                  textInputType: TextInputType.text,
                  textEditingController: controller.businessWebsiteController,
                ),

                const SizedBox(height: 10,),
              ],
            ),
          ),
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
          icon: const Icon(Icons.arrow_back_rounded, color: sWhite,),
        ),
        title: Text(
          AppSingletons().isEditingBusinessInfo
              ? 'Business Info'
              : 'New Business',
          style: const TextStyle(
              fontFamily: 'SFProDisplay',
              color: sWhite,
              fontSize: 18,
              fontWeight: FontWeight.w600,
              letterSpacing: 1.5),
        ),

        actions: [
          Visibility(
            visible: AppSingletons().isEditingBusinessInfo,
            child: IconButton(
                onPressed: () {
                  CustomDialogues.showDialogueToDelete(
                      true,
                      'Delete Business',
                      'Are you sure you want to delete ${controller
                          .businessNameController
                          .text} from your business list?',
                          '',
                          () =>
                          controller.businessListController.deleteBusiness(
                              controller.indexId.value),
                          () => controller.businessListController.loadData());
                },
                icon: const Icon(Icons.delete, size: 20, color: sWhite,)),
          ),

          IconButton(
              onPressed: () {
                if (controller.isTextEmpty.value) {
                  Utils().snackBarMsg(
                      'Business Name', 'Cannot be empty');
                } else {
                  if (AppSingletons().isEditingBusinessInfo) {
                    controller.editBusinessInfo();
                  } else {
                    controller.saveData();
                    Get.back();
                  }
                }
              },
              icon: const Icon(Icons.check, size: 20, color: sWhite,)
          )
        ],

      ),

      body: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage('assets/images/client_screen_desk.jpg'),
                fit: BoxFit.fill
            )
        ),
        child: Column(
          children: [
            const SizedBox(height: 15,),
            Expanded(
              child: Container(
                width: MediaQuery.of(context).size.width * 0.5,
                padding: const EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: sWhite,
                ),
                child: SingleChildScrollView(
                  child: CustomContainer(
                    horizontalPadding: 10,
                    verticalPadding: 10,
                    childContainer: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 20,),
                        Align(
                          alignment: Alignment.center,
                          child: GestureDetector(
                            onTap: () {
                              controller.pickGalleryImage(context);
                            },
                            child: Obx(() {
                              return Container(
                                width: 100,
                                height: 100,
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15),
                                  border: Border.all(
                                    color: shadowColor,
                                  ),
                                ),
                                child: controller.businessLogoImg.value.isEmpty
                                    ? const Icon(
                                  Icons.add, size: 35, color: shadowColor,)
                                    : Image.memory(controller.businessLogoImg.value,
                                    fit: BoxFit.fill),
                              );
                            }),
                          ),
                        ),
                  
                        const SizedBox(height: 20,),
                  
                        const Row(
                          children: [
                            Text('Business Name',
                              style:TextStyle(
                                  fontFamily: 'Montserrat',
                                  fontWeight: FontWeight.w600, color: grey_1,fontSize: 14),),
                            SizedBox(width: 5,),
                            Text(
                              '*', style: TextStyle(fontFamily: 'Montserrat',color: starColor),),
                          ],
                        ),
                        const SizedBox(height: 5,),
                  
                        CommonTextField(
                          hintText: 'Enter business name',
                          maxLines: 1,
                          textInputType: TextInputType.name,
                          textEditingController: controller.businessNameController,
                          maxLength: 40,
                        ),
                        const SizedBox(height: 10,),
                  
                        const Text('Email Address',
                          style: TextStyle(
                              fontFamily: 'Montserrat',
                              fontWeight: FontWeight.w600, color: grey_1,fontSize: 14),
                        ),
                        const SizedBox(height: 5,),
                        CommonTextField(
                          hintText: 'Enter email address',
                          maxLines: 1,
                          textInputType: TextInputType.emailAddress,
                          textEditingController: controller.emailAddressController,
                        ),
                  
                        const SizedBox(height: 10,),
                  
                        const Text('Phone', style: TextStyle(
                            fontFamily: 'Montserrat',fontSize: 14,
                            fontWeight: FontWeight.w600, color: grey_1),),
                        const SizedBox(height: 5,),
                        CommonTextField(
                          hintText: 'Enter phone number',
                          maxLines: 1,
                          textInputType: TextInputType.phone,
                          textEditingController: controller.phoneController,
                        ),
                  
                        const SizedBox(height: 10,),
                  
                        const Text('Billing Address', style: TextStyle(
                            fontFamily: 'Montserrat',fontSize: 14,
                            fontWeight: FontWeight.w600, color: grey_1),),
                        const SizedBox(height: 5,),
                        CommonTextField(
                          hintText: 'Enter billing address',
                          maxLines: 1,
                          textInputType: TextInputType.text,
                          textEditingController: controller.billAddressONEController,
                        ),
                        const SizedBox(height: 10,),
                  
                        const Text('Business Website', style: TextStyle(
                            fontFamily: 'Montserrat',fontSize: 14,
                            fontWeight: FontWeight.w600, color: grey_1),),
                        const SizedBox(height: 5,),
                        CommonTextField(
                          hintText: 'Enter business website',
                          maxLines: 1,
                          textInputType: TextInputType.text,
                          textEditingController: controller.businessWebsiteController,
                        ),
                  
                        const SizedBox(height: 10,),
                      ],
                    ),
                  ),
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