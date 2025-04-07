import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/constants/app_constants/App_Constants.dart';
import '../../core/app_singletons/app_singletons.dart';
import '../../core/utils/utils.dart';
import '../../core/widgets/custom_container.dart';
import '../../core/widgets/dialogueToDelete.dart';
import '../../core/constants/color/color.dart';
import '../../core/widgets/common_text_field.dart';
import 'add_client_controller.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class AddClientView extends GetView<AddClientController> {
  const AddClientView({super.key});

  @override
  Widget build(BuildContext context) {

    bool checkIsMobileLayout = AppConstants.isMobileScreen.value;

    return  checkIsMobileLayout ? mainMobileLayout() : mainDesktopLayout(context);
  }

  Widget mainMobileLayout() {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: mainPurpleColor,
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: const Icon(
            Icons.arrow_back_rounded,
            color: sWhite,
          ),
        ),
        title: Text(
          AppSingletons().isEditingClientInfo
              // ? "user_name".trParams({'username': 'Hamza'})
              ? 'client_info'.tr
              : 'new_client'.tr,
          style: const TextStyle(
              fontFamily: 'SFProDisplay',
              color: sWhite,
              fontSize: 18,
              fontWeight: FontWeight.w600,
              letterSpacing: 1),
        ),
        actions: [
          Visibility(
            visible: AppSingletons().isEditingClientInfo,
            child: IconButton(
                onPressed: () {

                  CustomDialogues.showDialogueToDelete(
                      true,
                      'delete_client'.tr,
                      'are_you_sure_you_want_to_delete'.tr,
                          '${controller.clientNameController.text}?',
                          () => controller.clientListController.deleteClient(controller.indexId.value),
                          ()=> controller.clientListController.loadData()
                  );

                  // controller.clientListController.deleteClient(controller.indexId.value);

                },
                icon: const Icon(Icons.delete,size: 20,color: sWhite,)
            ),
          ),
          IconButton(
            onPressed: () async{
              if(controller.isTextEmpty.value){
                Utils().snackBarMsg(
                    'client_name'.tr,
                    'must_be_entered'.tr
                );
              } else{
                controller.showAd();
                if(AppSingletons().isEditingClientInfo){
                  await controller.editClientInfo(
                      controller.indexId.value,
                      controller.clientNameController.text,
                      controller.clientEmailController.text,
                      controller.clientPhoneController.text,
                      controller.billingAddressController.text,
                      controller.shippingAddressController.text,
                      controller.clientDetailController.text
                  );

                } else {
                  controller.saveClientData();
                }

              }
            },
            icon: Image.asset(
              'assets/icons/check.png',
              color: sWhite,
              height: 25,
              width: 25,
            ),
          ),
          const SizedBox(
            width: 10,
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(top: 10),
          child: Column(
            children: [
              CustomContainer(
                verticalPadding: 10,
                horizontalPadding: 10,
                childContainer: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20,),
                     Row(
                      children: [
                        Text('client_name'.tr, style: const TextStyle(
                            fontFamily: 'Montserrat',
                            fontWeight: FontWeight.w600, color: grey_1),),
                         const SizedBox(width: 5,),
                           const Text(
                          '*', style: TextStyle( fontFamily: 'Montserrat',color: starColor),),
                      ],
                    ),

                    const SizedBox(height: 5,),

                    CommonTextField(
                      textEditingController: controller.clientNameController,
                      hintText: 'enter_client_name'.tr,
                      maxLines: 1,
                      textInputType: TextInputType.text,
                      textInputAction: TextInputAction.next,
                      maxLength: 40,
                    ),

                    const SizedBox(height: 10,),
                     Text('email_address'.tr, style: const TextStyle(
                        fontFamily: 'Montserrat',
                        fontWeight: FontWeight.w600, color: grey_1),),
                    const SizedBox(height: 5,),

                    CommonTextField(
                      textEditingController: controller.clientEmailController,
                      hintText: 'enter_client_email_address'.tr,
                      textInputType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.next,
                      maxLines: 1,
                    ),

                    const SizedBox(height: 10,),
                     Text('phone'.tr, style: const TextStyle(
                        fontFamily: 'Montserrat',
                        fontWeight: FontWeight.w600, color: grey_1),),
                    const SizedBox(height: 5,),

                    CommonTextField(
                      textEditingController: controller.clientPhoneController,
                      hintText: 'enter_client_phone_number'.tr,
                      textInputType: TextInputType.phone,
                      textInputAction: TextInputAction.next,
                      maxLines: 1,
                    ),

                    const SizedBox(height: 10,),
                    Text('billing_address'.tr, style: const TextStyle(
                        fontFamily: 'Montserrat',
                        fontWeight: FontWeight.w600, color: grey_1),),
                    const SizedBox(width: 5,),

                    CommonTextField(
                      maxLines: 5,
                      textEditingController: controller.billingAddressController,
                      hintText: 'enter_address_line'.tr,
                      textInputType: TextInputType.multiline,
                      textInputAction: TextInputAction.next,
                    ),

                    const SizedBox(height: 10,),
                    Text('shipping_address'.tr, style: const TextStyle(
                        fontFamily: 'Montserrat',
                        fontWeight: FontWeight.w600, color: grey_1),),
                    const SizedBox(width: 5,),

                    CommonTextField(
                      maxLines: 5,
                      textEditingController: controller.shippingAddressController,
                      hintText: 'enter_address_line'.tr,
                      textInputType: TextInputType.multiline,
                      textInputAction: TextInputAction.next,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10,),
              CustomContainer(
                verticalPadding: 10,
                horizontalPadding: 10,
                childContainer: Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('client_detail_not_show_on_invoice'.tr, style: const TextStyle(
                          fontFamily: 'Montserrat',
                          fontWeight: FontWeight.w600, color: grey_1),),
                      const SizedBox(height: 5,),
                      Container(
                        constraints: const BoxConstraints(
                            minHeight: 80
                        ),

                        child: CommonTextField(
                          maxLines: 5,
                          textEditingController: controller.clientDetailController,
                          hintText: 'enter_client_detail'.tr,
                          textInputType: TextInputType.multiline,
                          textInputAction: TextInputAction.done,
                        ),

                      )

                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20,),
            ],
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
          icon: const Icon(
            Icons.arrow_back_rounded,
            color: sWhite,
          ),
        ),
        title: Text(
          AppSingletons().isEditingClientInfo
              ? 'Client Info'
              : 'New Client',
          style: const TextStyle(
              fontFamily: 'SFProDisplay',
              color: sWhite,
              fontSize: 18,
              fontWeight: FontWeight.w600,
              letterSpacing: 1),
        ),
        actions: [
          Visibility(
            visible: AppSingletons().isEditingClientInfo,
            child: IconButton(
                onPressed: () {

                  CustomDialogues.showDialogueToDelete(
                      true,
                      'Delete Client',
                      'Are you sure you want to delete ${controller.clientNameController.text}?',
                          '',
                          () => controller.clientListController.deleteClient(controller.indexId.value),
                          ()=> controller.clientListController.loadData()
                  );

                  // controller.clientListController.deleteClient(controller.indexId.value);

                },
                icon: const Icon(Icons.delete,size: 20,color: sWhite,)
            ),
          ),
          IconButton(
            onPressed: () async{
              if(controller.isTextEmpty.value){
                Utils().snackBarMsg('Client Name', 'Must be entered');
              } else{

                if(AppSingletons().isEditingClientInfo){
                  await controller.editClientInfo(
                      controller.indexId.value,
                      controller.clientNameController.text,
                      controller.clientEmailController.text,
                      controller.clientPhoneController.text,
                      controller.billingAddressController.text,
                      controller.shippingAddressController.text,
                      controller.clientDetailController.text
                  );
                } else {
                  controller.saveClientData();
                }
              }
            },
            icon: Image.asset(
              'assets/icons/check.png',
              color: sWhite,
              height: 25,
              width: 25,
            ),
          ),
          const SizedBox(
            width: 10,
          )
        ],
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage(
                  'assets/images/client_screen_desk.jpg',
                ),
                fit: BoxFit.fill)),
        child: Center(
          child: SizedBox(
            width: MediaQuery.of(context).size.width * 0.5,
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Column(
                  children: [
                    CustomContainer(
                      horizontalPadding: 10,
                      verticalPadding: 10,
                      childContainer: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 20,),
                          const Row(
                            children: [
                              Text('Client Name', style: TextStyle(
                                  fontFamily: 'Montserrat',
                                  fontWeight: FontWeight.w600, color: grey_1),),
                              SizedBox(width: 5,),
                              Text(
                                '*', style: TextStyle( fontFamily: 'Montserrat',color: starColor),),
                            ],
                          ),

                          const SizedBox(height: 5,),

                          CommonTextField(
                            textEditingController: controller.clientNameController,
                            hintText: 'Enter client name',
                            maxLines: 1,
                            textInputType: TextInputType.text,
                            textInputAction: TextInputAction.next,
                            maxLength: 40,
                          ),

                          const SizedBox(height: 10,),
                          const Text('Email Address', style: TextStyle(
                              fontFamily: 'Montserrat',
                              fontWeight: FontWeight.w600, color: grey_1),),
                          const SizedBox(height: 5,),

                          CommonTextField(
                            textEditingController: controller.clientEmailController,
                            hintText: 'Enter client email address',
                            textInputType: TextInputType.emailAddress,
                            textInputAction: TextInputAction.next,
                            maxLines: 1,
                          ),

                          const SizedBox(height: 10,),
                          const Text('Phone', style: TextStyle(
                              fontFamily: 'Montserrat',
                              fontWeight: FontWeight.w600, color: grey_1),),
                          const SizedBox(height: 5,),

                          CommonTextField(
                            textEditingController: controller.clientPhoneController,
                            hintText: 'Enter client phone number',
                            textInputType: TextInputType.phone,
                            textInputAction: TextInputAction.next,
                            maxLines: 1,
                          ),

                          const SizedBox(height: 10,),
                          const Text('Billing Address', style: TextStyle(
                              fontFamily: 'Montserrat',
                              fontWeight: FontWeight.w600, color: grey_1),),
                          const SizedBox(width: 5,),

                          CommonTextField(
                            maxLines: 5,
                            textEditingController: controller.billingAddressController,
                            hintText: 'Enter address line',
                            textInputType: TextInputType.multiline,
                            textInputAction: TextInputAction.next,
                          ),

                          const SizedBox(height: 10,),
                          const Text('Shipping Address', style: TextStyle(
                              fontFamily: 'Montserrat',
                              fontWeight: FontWeight.w600, color: grey_1),),
                          const SizedBox(width: 5,),

                          CommonTextField(
                            maxLines: 5,
                            textEditingController: controller.shippingAddressController,
                            hintText: 'Enter address line',
                            textInputType: TextInputType.multiline,
                            textInputAction: TextInputAction.next,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10,),
                    CustomContainer(
                      horizontalPadding: 10,
                      verticalPadding: 10,
                      childContainer: Padding(
                        padding: const EdgeInsets.only(top: 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Client Detail(Not show on invoice)', style: TextStyle(
                                fontFamily: 'Montserrat',
                                fontWeight: FontWeight.w600, color: grey_1),),
                            const SizedBox(height: 5,),
                            Container(
                              constraints: const BoxConstraints(
                                  minHeight: 80
                              ),

                              child: CommonTextField(
                                maxLines: 5,
                                textEditingController: controller.clientDetailController,
                                hintText: 'Enter client Detail',
                                textInputType: TextInputType.multiline,
                                textInputAction: TextInputAction.done,
                              ),

                            )

                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 20,),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
