import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import '../../core/constants/app_constants/App_Constants.dart';
import '../../core/app_singletons/app_singletons.dart';
import '../../core/constants/color/color.dart';
import '../../modules/business_info_list/business_list_controller.dart';
import '../../core/routes/routes.dart';
import '../../core/widgets/dialogueToDelete.dart';

class BusinessListView extends GetView<BusinessListController> {
  const BusinessListView({super.key});

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

        title: const Text(
          'All Businesses List',
          style: TextStyle(
              fontFamily: 'SFProDisplay',
              color: sWhite,
              fontSize: 18,
              fontWeight: FontWeight.w600,
              letterSpacing: 1.5),
        ),
      ),

      body: Obx(() =>
          Column(
            children: [
              Expanded(
                  child: controller.isLoadingData.value
                      ? const Center(
                      child: CupertinoActivityIndicator(
                        color: mainPurpleColor,
                        radius: 20,
                        animating: true,
                      ))
                      : controller.businessList.isEmpty
                      ? const Center(
                    child: Text('Tap + to add businesses',
                      style: TextStyle(
                          fontFamily: 'Montserrat', fontSize: 14,
                          color: grey_1,
                          fontWeight: FontWeight.w600
                      ),
                    ),
                  )
                      : ListView.builder(
                      itemCount: controller.businessList.length,
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        int reverse = controller.businessList.length - 1 - index;

                        final note = controller.businessList[reverse];

                        return Container(
                          margin: const EdgeInsets.symmetric(
                              horizontal: 15, vertical: 8),
                          alignment: Alignment.centerLeft,
                          decoration: BoxDecoration(
                              color: sWhite,
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: const [
                                BoxShadow(
                                    color: shadowColor,
                                    spreadRadius: 1,
                                    blurRadius: 5,
                                    offset: Offset(2, 2)),
                              ]),

                          child: ListTile(
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 10),
                            onTap: () {
                              if (AppSingletons().isComingFromBottomBar) {
                                Get.toNamed(Routes.businessInfo,
                                    arguments: {
                                      'indexId': note.id,
                                      'businessName': note.businessName.toString(),
                                      'businessEmail': note.businessEmail.toString(),
                                      'businessPhoneNo': note.businessPhoneNo.toString(),
                                      'businessBillAddress': note.businessBillingOne.toString(),
                                      'businessWebsite': note.businessWebsite,
                                      'businessLogoImg': note.businessLogoImg,
                                    }
                                );
                                AppSingletons().isEditingBusinessInfo = true;
                              }
                              else {
                                if (AppSingletons.isInvoiceDocument.value) {
                                  AppSingletons.businessNameINV?.value = note.businessName.toString();
                                  AppSingletons.businessPhoneNumberINV?.value = note.businessPhoneNo.toString();
                                  AppSingletons.businessEmailINV?.value = note.businessEmail.toString();
                                  AppSingletons.businessBillingAddressINV?.value = note.businessBillingOne.toString();
                                  AppSingletons.businessWebsiteINV?.value = note.businessWebsite.toString();
                                  AppSingletons.businessLogoImg.value = note.businessLogoImg ?? Uint8List(0);

                                  AppSingletons.invDefaultBusinessId?.value = note.id!;
                                  Get.back();
                                }
                                else {
                                  AppSingletons.estBusinessNameINV?.value = note.businessName.toString();
                                  AppSingletons.estBusinessPhoneNumberINV?.value = note.businessPhoneNo.toString();
                                  AppSingletons.estBusinessEmailINV?.value = note.businessEmail.toString();
                                  AppSingletons.estBusinessBillingAddressINV?.value = note.businessBillingOne.toString();
                                  AppSingletons.estBusinessWebsiteINV?.value = note.businessWebsite.toString();
                                  AppSingletons.estBusinessLogoImg.value = note.businessLogoImg ?? Uint8List(0);

                                  AppSingletons.estDefaultBusinessId?.value = note.id!;

                                  Get.back();
                                }
                              }
                            },
                            title: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text('${note.businessName}',
                                  style: const TextStyle(
                                    fontFamily: 'Montserrat', fontSize: 14,
                                    color: grey_1,
                                    fontWeight: FontWeight.w600,
                                  ),),
                                Text('${note.businessEmail}',
                                  style: const TextStyle(
                                    fontFamily: 'Montserrat',
                                    color: greyColor,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 14,
                                  ),),
                                Text('${note.businessPhoneNo}',
                                  style: const TextStyle(
                                    fontFamily: 'Montserrat',
                                    color: greyColor,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 14,
                                  ),),
                              ],
                            ),

                            trailing: Visibility(
                              visible: AppSingletons().isComingFromBottomBar,
                              child: PopupMenuButton(
                                  color: sWhite,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 5),
                                  shape: const Border.symmetric(),
                                  itemBuilder: (context) =>
                                  [
                                    PopupMenuItem(value: 0,
                                      onTap: () {
                                        CustomDialogues.showDialogueToDelete(
                                            false,
                                            'Delete Business',
                                            'Are you sure you want to delete ${note
                                                .businessName} from your business list?',
                                                () => controller.deleteBusiness(
                                                note.id!),
                                                () => controller.loadData());
                                      },
                                      child: const Row(
                                        mainAxisAlignment: MainAxisAlignment
                                            .spaceBetween,
                                        children: [
                                          Text('Delete',
                                            style: TextStyle(
                                                fontFamily: 'Montserrat',
                                                color: grey_1,
                                                fontWeight: FontWeight.w600,
                                                fontSize: 15
                                            ),
                                          ),
                                          Icon(Icons.delete, color: grey_1,
                                            size: 16,)
                                        ],
                                      ),),
                                    PopupMenuItem(value: 1,
                                      onTap: () {
                                        Get.toNamed(Routes.businessInfo,
                                            arguments: {
                                              'indexId': note.id,
                                              'businessName': note.businessName
                                                  .toString(),
                                              'businessEmail': note
                                                  .businessEmail.toString(),
                                              'businessPhoneNo': note
                                                  .businessPhoneNo.toString(),
                                              'businessBillAddress': note
                                                  .businessBillingOne
                                                  .toString(),
                                              'businessWebsite': note
                                                  .businessWebsite,
                                              'businessLogoImg': note
                                                  .businessLogoImg
                                            }
                                        );

                                        AppSingletons().isEditingBusinessInfo =
                                        true;
                                      },
                                      child: const Row(
                                        mainAxisAlignment: MainAxisAlignment
                                            .spaceBetween,
                                        children: [
                                          Text('Edit',
                                            style: TextStyle(
                                                fontFamily: 'Montserrat',
                                                color: grey_1,
                                                fontWeight: FontWeight.w600,
                                                fontSize: 16
                                            ),
                                          ),

                                          Icon(Icons.edit, color: grey_1,
                                            size: 16,)
                                        ],
                                      ),),
                                  ],
                                  child: Image.asset(
                                    'assets/icons/menu_vertical.png',
                                    height: 15, width: 30, color: grey_1,)),
                            ),

                          ),

                        );
                      })
              ),
            ],
          )),

      floatingActionButton: Visibility(
        // visible: AppSingletons().isComingFromBottomBar,
        child: FloatingActionButton(
          onPressed: () {
            AppSingletons().isEditingBusinessInfo = false;
            Get.toNamed(Routes.businessInfo);
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
      backgroundColor: lightShadePurple,
      appBar: AppBar(
        backgroundColor: mainPurpleColor,
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: const Icon(Icons.arrow_back, color: sWhite, size: 20,),
        ),
        title: const Text(
          'All Businesses List',
          style: TextStyle(
              fontFamily: 'SFProDisplay',
              color: sWhite,
              fontSize: 18,
              fontWeight: FontWeight.w600,
              letterSpacing: 1.5),
        ),
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
                width: MediaQuery
                    .of(context)
                    .size
                    .width * 0.6,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: sWhite,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20,),
                    Obx(() {
                      return Expanded(
                          child: controller.isLoadingData.value
                              ? const Center(
                              child: CupertinoActivityIndicator(
                                color: mainPurpleColor,
                                radius: 20,
                                animating: true,
                              ))
                              : controller.businessList.isEmpty
                              ? const Center(
                            child: Text('Tap + to add businesses',
                              style: TextStyle(
                                  fontFamily: 'Montserrat', fontSize: 14,
                                  color: grey_1,
                                  fontWeight: FontWeight.w600
                              ),
                            ),
                          )
                              : ListView.builder(
                              itemCount: controller.businessList.length,
                              shrinkWrap: true,
                              itemBuilder: (context, index) {
                                int reverse = controller.businessList.length -
                                    1 - index;

                                final note = controller.businessList[reverse];

                                return Container(
                                  margin: const EdgeInsets.symmetric(
                                      horizontal: 15, vertical: 8),
                                  alignment: Alignment.centerLeft,
                                  decoration: BoxDecoration(
                                      color: sWhite,
                                      borderRadius: BorderRadius.circular(12),
                                      boxShadow: const [
                                        BoxShadow(
                                            color: shadowColor,
                                            spreadRadius: 1,
                                            blurRadius: 5,
                                            offset: Offset(2, 2)),
                                      ]),

                                  child: ListTile(
                                    contentPadding: const EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 10),
                                    onTap: () {
                                      if (AppSingletons().isComingFromBottomBar) {
                                        Get.toNamed(Routes.businessInfo,
                                            arguments: {
                                              'indexId': note.id,
                                              'businessName': note.businessName.toString(),
                                              'businessEmail': note.businessEmail.toString(),
                                              'businessPhoneNo': note.businessPhoneNo.toString(),
                                              'businessBillAddress': note.businessBillingOne.toString(),
                                              'businessWebsite': note.businessWebsite,
                                              'businessLogoImg': note.businessLogoImg,
                                            }
                                        );
                                        AppSingletons().isEditingBusinessInfo = true;
                                      }
                                      else {
                                        if (AppSingletons.isInvoiceDocument.value) {
                                          AppSingletons.businessNameINV?.value = note.businessName.toString();
                                          AppSingletons.businessPhoneNumberINV?.value = note.businessPhoneNo.toString();
                                          AppSingletons.businessEmailINV?.value = note.businessEmail.toString();
                                          AppSingletons.businessBillingAddressINV?.value = note.businessBillingOne.toString();
                                          AppSingletons.businessWebsiteINV?.value = note.businessWebsite.toString();
                                          AppSingletons.businessLogoImg.value = note.businessLogoImg ?? Uint8List(0);

                                          AppSingletons.invDefaultBusinessId?.value = note.id!;
                                          Get.back();
                                        }
                                        else {
                                          AppSingletons.estBusinessNameINV?.value = note.businessName.toString();
                                          AppSingletons.estBusinessPhoneNumberINV?.value = note.businessPhoneNo.toString();
                                          AppSingletons.estBusinessEmailINV?.value = note.businessEmail.toString();
                                          AppSingletons.estBusinessBillingAddressINV?.value = note.businessBillingOne.toString();
                                          AppSingletons.estBusinessWebsiteINV?.value = note.businessWebsite.toString();
                                          AppSingletons.estBusinessLogoImg.value = note.businessLogoImg ?? Uint8List(0);

                                          AppSingletons.estDefaultBusinessId?.value = note.id!;

                                          Get.back();
                                        }
                                      }
                                    },
                                    title: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Text('${note.businessName}',
                                          style: const TextStyle(
                                            fontFamily: 'Montserrat',
                                            fontSize: 14,
                                            color: grey_1,
                                            fontWeight: FontWeight.w600,
                                          ),),
                                        Text('${note.businessEmail}',
                                          style: const TextStyle(
                                            fontFamily: 'Montserrat',
                                            color: greyColor,
                                            fontWeight: FontWeight.w500,
                                            fontSize: 14,
                                          ),),
                                        Text('${note.businessPhoneNo}',
                                          style: const TextStyle(
                                            fontFamily: 'Montserrat',
                                            color: greyColor,
                                            fontWeight: FontWeight.w500,
                                            fontSize: 14,
                                          ),),
                                      ],
                                    ),

                                    trailing: Visibility(
                                      visible: AppSingletons()
                                          .isComingFromBottomBar,
                                      child: PopupMenuButton(
                                          color: sWhite,
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 5),
                                          shape: const Border.symmetric(),
                                          itemBuilder: (context) =>
                                          [
                                            PopupMenuItem(value: 0,
                                              onTap: () {
                                                CustomDialogues
                                                    .showDialogueToDelete(
                                                    false,
                                                    'Delete Business',
                                                    'Are you sure you want to delete ${note
                                                        .businessName} from your business list?',
                                                        () => controller
                                                        .deleteBusiness(
                                                        note.id!),
                                                        () =>
                                                        controller.loadData());
                                              },
                                              child: const Row(
                                                mainAxisAlignment: MainAxisAlignment
                                                    .spaceBetween,
                                                children: [
                                                  Text('Delete',
                                                    style: TextStyle(
                                                        fontFamily: 'Montserrat',
                                                        color: grey_1,
                                                        fontWeight: FontWeight
                                                            .w600,
                                                        fontSize: 15
                                                    ),
                                                  ),
                                                  Icon(
                                                    Icons.delete, color: grey_1,
                                                    size: 16,)
                                                ],
                                              ),),
                                            PopupMenuItem(value: 1,
                                              onTap: () {
                                                Get.toNamed(Routes.businessInfo,
                                                    arguments: {
                                                      'indexId': note.id,
                                                      'businessName': note
                                                          .businessName
                                                          .toString(),
                                                      'businessEmail': note
                                                          .businessEmail
                                                          .toString(),
                                                      'businessPhoneNo': note
                                                          .businessPhoneNo
                                                          .toString(),
                                                      'businessBillAddress': note
                                                          .businessBillingOne
                                                          .toString(),
                                                      'businessWebsite': note
                                                          .businessWebsite,
                                                      'businessLogoImg': note
                                                          .businessLogoImg
                                                    }
                                                );

                                                AppSingletons()
                                                    .isEditingBusinessInfo =
                                                true;
                                              },
                                              child: const Row(
                                                mainAxisAlignment: MainAxisAlignment
                                                    .spaceBetween,
                                                children: [
                                                  Text('Edit',
                                                    style: TextStyle(
                                                        fontFamily: 'Montserrat',
                                                        color: grey_1,
                                                        fontWeight: FontWeight
                                                            .w600,
                                                        fontSize: 16
                                                    ),
                                                  ),

                                                  Icon(
                                                    Icons.edit, color: grey_1,
                                                    size: 16,)
                                                ],
                                              ),),
                                          ],
                                          child: Image.asset(
                                            'assets/icons/menu_vertical.png',
                                            height: 15,
                                            width: 30,
                                            color: grey_1,)),
                                    ),

                                  ),

                                );
                              })
                      );
                    }),
                    const SizedBox(width: 20,),
                    Visibility(
                      child: GestureDetector(
                        onTap: () {
                          Get.toNamed(Routes.businessInfo);
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 5),
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
                              SizedBox(width: 5,),
                              Icon(Icons.add, color: sWhite,),
                            ],
                          ),
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