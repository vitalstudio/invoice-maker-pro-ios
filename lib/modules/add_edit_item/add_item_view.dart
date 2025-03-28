import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import '../../core/constants/app_constants/App_Constants.dart';
import '../../core/utils/utils.dart';
import '../../core/widgets/custom_container.dart';
import '../../core/app_singletons/app_singletons.dart';
import '../../core/widgets/dialogueToDelete.dart';
import 'add_item_controller.dart';
import '../../core/constants/color/color.dart';
import '../../core/widgets/common_text_field.dart';

class AddItemView extends GetView<AddItemController> {
  const AddItemView({super.key});

  @override
  Widget build(BuildContext context) {

    final controller = Get.put<AddItemController>(AddItemController());

    bool checkIsMobileLayout = AppConstants.isMobileScreen.value;

    return  checkIsMobileLayout ? mainMobileLayout() : mainDesktopLayout(context);
  }

  Widget mainMobileLayout() {
    return Scaffold(
      backgroundColor: orangeLight_1,
      appBar: AppBar(
        backgroundColor: mainPurpleColor,
        leading: IconButton(
          onPressed: () {
            Get.back();
            AppSingletons.isEditingItemDataFromInvoice.value = false;
          },
          icon: const Icon(
            Icons.arrow_back_rounded,
            color: sWhite,
          ),
        ),
        title:  Text(
          AppSingletons().isEditingItemInfo
              ? 'item_info'.tr
              : 'new_item'.tr,
          style: const TextStyle(
              fontFamily: 'SFProDisplay',
              color: sWhite,
              fontSize: 18,
              fontWeight: FontWeight.w600,
              letterSpacing: 1),
        ),
        actions: [
          Visibility(
            visible: AppSingletons().isComingFromBottomBar && AppSingletons().isEditingItemInfo,
            child: IconButton(
                onPressed: () {
                  CustomDialogues.showDialogueToDelete(
                      true,
                      'delete_item'.tr,
                      'are_you_sure_you_want_to_delete'.tr,
                          '${controller.itemNameController.text}?',
                          () => controller.itemScreenListController.deleteItem(controller.indexId.value),
                          ()=> controller.itemScreenListController.loadData()
                  );
                },
                icon: const Icon(Icons.delete, size: 20, color: sWhite,)
            ),
          ),

          Visibility(
            visible: AppSingletons.isEditingItemDataFromInvoice.value,
            child: IconButton(
                onPressed: () {
                  controller.deleteItemFromInvoiceItemList(controller.itemIdToEditInvoice.value);
                },
                icon: const Icon(Icons.delete, size: 20, color: sWhite,)
            ),
          ),

          IconButton(
              onPressed: () async {

                if(controller.isTextEmpty.value){
                  Utils().snackBarMsg(
                      'item_name'.tr, 'must_be_entered'.tr);
                } else{

                  if(AppSingletons.isEditingItemDataFromInvoice.value){
                    controller.editItemFromInvoiceItemList(controller.itemIdToEditInvoice.value);

                    debugPrint('Item EDITED inside invoice');

                  } else if(AppSingletons().isComingFromBottomBar){
                    if(AppSingletons().isEditingItemInfo){
                      await controller.editItemInfo(
                        controller.indexId.value,
                        controller.itemNameController.text,
                        controller.itemPriceController.text,
                        controller.itemUnitToMeasureController.text,
                        // controller.itemDiscountController.text,
                        // controller.itemQuantityController.text,
                        // controller.itemTextRateController.text,
                        // controller.totalPrice.toString(),
                        controller.itemDescriptionController.text,
                      );

                      debugPrint('Item ADDED inside invoice or est');

                      Get.back();
                    }
                    else {
                      controller.saveItemData();
                      Get.back();
                    }
                  } else {

                    if(AppSingletons.isAddNewItemInINVEST){
                      controller.addingItemsInInvoice(
                          controller.itemNameController.text,
                          controller.totalPrice.value.toString(),
                          controller.itemDiscountController.text,
                          controller.itemPriceController.text,
                          controller.itemQuantityController.text,
                          controller.itemTextRateController.text,
                          controller.itemUnitToMeasureController.text,
                          controller.itemDescriptionController.text
                      );

                      controller.saveItemData();

                      debugPrint('NEW Item ADDED inside invoice or EST');
                      Get.back();
                      Get.back();

                    } else {
                      controller.addingItemsInInvoice(
                          controller.itemNameController.text,
                          controller.totalPrice.value.toString(),
                          controller.itemDiscountController.text,
                          controller.itemPriceController.text,
                          controller.itemQuantityController.text,
                          controller.itemTextRateController.text,
                          controller.itemUnitToMeasureController.text,
                          controller.itemDescriptionController.text
                      );

                      debugPrint('Item ADDED inside invoice or EST');
                      Get.back();
                      Get.back();
                    }
                  }
                }
              },
              icon: const Icon(Icons.check, size: 20, color: sWhite,)
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: WillPopScope(
          onWillPop: ()async{
            if(AppSingletons().isComingFromBottomBar){
              Get.back();
            } else if(AppSingletons.isEditingItemDataFromInvoice.value){
              AppSingletons.isEditingItemDataFromInvoice.value = false;
              Get.back();
            } else{
              Get.back();
            }
            return true;
          },
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
                          Text('item_name'.tr, style: const TextStyle(
                              fontFamily: 'Montserrat',
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                              color: grey_1),),
                          const SizedBox(width: 5,),
                          const Text(
                            '*',
                            style: TextStyle( fontFamily: 'Montserrat',color: starColor),),
                        ],
                      ),

                      const SizedBox(height: 5,),

                      CommonTextField(
                        textEditingController: controller.itemNameController,
                        hintText: 'enter_item_name'.tr,
                        maxLines: 1,
                        textInputType: TextInputType.text,
                        textInputAction: TextInputAction.next,
                        maxLength: 40,
                      ),
                      const SizedBox(height: 10,),
                       Text('item_price'.tr, style: const TextStyle(
                          fontFamily: 'Montserrat',
                          fontWeight: FontWeight.w600, color: grey_1,fontSize: 14),),
                      const SizedBox(height: 5,),

                      CommonTextField(
                        textEditingController: controller.itemPriceController,
                        hintText: 'enter_item_price'.tr,
                        maxLines: 1,
                        inputFormatter: [AmountInputFormatter()],
                        textInputType: TextInputType.number,
                        textInputAction: TextInputAction.next,
                      ),

                      const SizedBox(height: 10,),
                       Text('unit_to_measure'.tr, style: const TextStyle(
                          fontFamily: 'Montserrat',
                          fontWeight: FontWeight.w600,fontSize: 14, color: grey_1),),
                      const SizedBox(height: 5,),

                      CommonTextField(
                        textEditingController: controller.itemUnitToMeasureController,
                        hintText: 'none'.tr,
                        maxLines: 1,
                        textInputType: TextInputType.text,
                        textInputAction: TextInputAction.next,
                      ),
                      const SizedBox(height: 5,),

                      Visibility(
                          visible: AppSingletons().isComingFromBottomBar == false,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                      const SizedBox(height: 5,),

                       Text('item_quantity'.tr, style: const TextStyle(
                          fontFamily: 'Montserrat',
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                          color: grey_1),),
                      const SizedBox(height: 5,),
                      CommonTextField(
                        textEditingController: controller.itemQuantityController,
                        hintText: '0',
                        maxLines: 1,
                        inputFormatter: [AmountInputFormatter()],
                        textInputType: TextInputType.number,
                        textInputAction: TextInputAction.next,
                      ),
                      const SizedBox(height: 10,),
                              Text('discount'.tr, style: const TextStyle(
                          fontFamily: 'Montserrat',
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                          color: grey_1),),
                      const SizedBox(height: 5,),
                      CommonTextField(
                        textEditingController: controller.itemDiscountController,
                        hintText: '0%',
                        maxLines: 1,
                        textInputType: TextInputType.number,
                        textInputAction: TextInputAction.next,
                        inputFormatter: [
                          FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
                          PercentageInputFormatter(),
                        ],
                      ),
                      const SizedBox(height: 10,),
                       Text('tax_rate'.tr, style: const TextStyle(
                          fontFamily: 'Montserrat',
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                          color: grey_1),),
                      const SizedBox(height: 5,),
                      CommonTextField(
                        textEditingController: controller.itemTextRateController,
                        hintText: '0%',
                        maxLines: 1,
                        textInputType: TextInputType.number,
                        textInputAction: TextInputAction.next,
                        inputFormatter: [
                          FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
                          PercentageInputFormatter(),
                        ],
                      ),
                      const SizedBox(height: 10,),
                       Text(
                        '* ${'this_discount_and_tax_is_valid_on_this_item_only'.tr}',
                        style: const TextStyle(
                          fontFamily: 'Montserrat',
                          color: greyColor,
                          fontSize: 13,
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                      const SizedBox(height: 10,),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration:  BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: mainPurpleColor,
                        ),

                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                             Text('total'.tr,
                              style: const TextStyle(
                                fontFamily: 'Montserrat',
                                color: sWhite,
                                fontWeight: FontWeight.w600,
                                fontSize: 16,
                              ),
                            ),

                            Obx(() {
                              return
                                Text(controller.totalPrice.value.toString(),
                                  style: const TextStyle(
                                    fontFamily: 'Montserrat',
                                    color: sWhite,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 16,
                                  ),
                                );
                            })
                          ],
                        ),
                      ),
                            ],
                          ),
                      ),
                    ],
                  ),
                ),
                // Visibility(
                //   visible: AppSingletons().isComingFromBottomBar == false,
                //   child: InkWell(
                //     onTap: () {
                //       controller.calculateResult();
                //     },
                //     child: Container(
                //       margin: const EdgeInsets.symmetric(horizontal: 10),
                //       padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 5),
                //       decoration: BoxDecoration(
                //         borderRadius: BorderRadius.circular(8),
                //         color: grey_1,
                //       ),
                //
                //       child: Row(
                //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //         children: [
                //           Text('Total',
                //             style: GoogleFonts.montserrat(
                //               color: sWhite,
                //               fontWeight: FontWeight.w600,
                //               fontSize: 16,
                //             ),
                //           ),
                //
                //           Obx(() {
                //             return
                //               Text(controller.totalPrice.value.toString(),
                //               style: GoogleFonts.montserrat(
                //                 color: sWhite,
                //                 fontWeight: FontWeight.w600,
                //                 fontSize: 16,
                //               ),
                //             );
                //           })
                //         ],
                //       ),
                //     ),
                //   ),
                // ),
                const SizedBox(height: 10,),
                CustomContainer(
                  verticalPadding: 10,
                  horizontalPadding: 10,
                  childContainer: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text('item_description'.tr, style: const TextStyle(
                          fontFamily: 'Montserrat',
                          fontWeight: FontWeight.w600,fontSize: 14, color: grey_1),),
                      const SizedBox(height: 5,),

                      Container(
                        constraints: const BoxConstraints(
                            minHeight: 100
                        ),

                        child: CommonTextField(
                          textEditingController: controller.itemDescriptionController,
                          textInputAction: TextInputAction.done,
                          textInputType: TextInputType.text,
                          maxLength: 500,
                          maxLines: 8,
                          hintText: 'enter_description_here'.tr,
                        ),
                      ),
                    ],
                  ),
                )
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
      backgroundColor: orangeLight_1,
      appBar: AppBar(
        backgroundColor: mainPurpleColor,
        leading: IconButton(
          onPressed: () {
            Get.back();
            AppSingletons.isEditingItemDataFromInvoice.value = false;
          },
          icon: const Icon(
            Icons.arrow_back_rounded,
            color: sWhite,
          ),
        ),
        title:  Text(
          AppSingletons().isEditingItemInfo
              ? 'Item Info'
              : 'New Item',
          style: const TextStyle(
              fontFamily: 'SFProDisplay',
              color: sWhite,
              fontSize: 18,
              fontWeight: FontWeight.w600,
              letterSpacing: 1),
        ),
        actions: [
          Visibility(
            visible: AppSingletons().isComingFromBottomBar && AppSingletons().isEditingItemInfo,
            child: IconButton(
                onPressed: () {
                  CustomDialogues.showDialogueToDelete(
                      true,
                      'Delete Item',
                      'Are you sure you want to delete ${controller.itemNameController.text}?',
                          '',
                          () => controller.itemScreenListController.deleteItem(controller.indexId.value),
                          ()=> controller.itemScreenListController.loadData()
                  );
                },
                icon: const Icon(Icons.delete, size: 20, color: sWhite,)
            ),
          ),

          Visibility(
            visible: AppSingletons.isEditingItemDataFromInvoice.value,
            child: IconButton(
                onPressed: () {
                  controller.deleteItemFromInvoiceItemList(controller.itemIdToEditInvoice.value);
                },
                icon: const Icon(Icons.delete, size: 20, color: sWhite,)
            ),
          ),

          IconButton(
              // onPressed: () async {
              //
              //   if(controller.isTextEmpty.value){
              //     Utils().snackBarMsg('Item Name', 'Must be entered');
              //   } else{
              //
              //     if(AppSingletons.isEditingItemDataFromInvoice.value){
              //       controller.editItemFromInvoiceItemList(controller.itemIdToEditInvoice.value);
              //
              //       debugPrint('Item EDITED inside invoice');
              //
              //     }
              //     else if(AppSingletons().isEditingItemInfo){
              //       await controller.editItemInfo(
              //         controller.indexId.value,
              //         controller.itemNameController.text,
              //         controller.itemPriceController.text,
              //         controller.itemUnitToMeasureController.text,
              //         // controller.itemDiscountController.text,
              //         // controller.itemQuantityController.text,
              //         // controller.itemTextRateController.text,
              //         // controller.totalPrice.toString(),
              //         controller.itemDescriptionController.text,
              //
              //       );
              //
              //       debugPrint('Item ADDED inside invoice');
              //       debugPrint('Item ADDED inside invoice');
              //
              //       Get.back();
              //     }
              //     else {
              //       controller.saveItemData();
              //
              //       Get.back();
              //     }
              //   }
              // },
              onPressed: () async {

                if(controller.isTextEmpty.value){
                  Utils().snackBarMsg('Item Name', 'Must be entered');
                } else{

                  if(AppSingletons.isEditingItemDataFromInvoice.value){
                    controller.editItemFromInvoiceItemList(controller.itemIdToEditInvoice.value);

                    debugPrint('Item EDITED inside invoice');

                  } else if(AppSingletons().isComingFromBottomBar){
                    if(AppSingletons().isEditingItemInfo){
                      await controller.editItemInfo(
                        controller.indexId.value,
                        controller.itemNameController.text,
                        controller.itemPriceController.text,
                        controller.itemUnitToMeasureController.text,
                        // controller.itemDiscountController.text,
                        // controller.itemQuantityController.text,
                        // controller.itemTextRateController.text,
                        // controller.totalPrice.toString(),
                        controller.itemDescriptionController.text,
                      );

                      debugPrint('Item ADDED inside invoice or est');

                      Get.back();
                    }
                    else {
                      controller.saveItemData();
                      Get.back();
                    }
                  } else {

                    if(AppSingletons.isAddNewItemInINVEST){
                      controller.addingItemsInInvoice(
                          controller.itemNameController.text,
                          controller.totalPrice.value.toString(),
                          controller.itemDiscountController.text,
                          controller.itemPriceController.text,
                          controller.itemQuantityController.text,
                          controller.itemTextRateController.text,
                          controller.itemUnitToMeasureController.text,
                          controller.itemDescriptionController.text
                      );

                      controller.saveItemData();

                      debugPrint('NEW Item ADDED inside invoice or EST');
                      Get.back();
                      Get.back();

                    } else {
                      controller.addingItemsInInvoice(
                          controller.itemNameController.text,
                          controller.totalPrice.value.toString(),
                          controller.itemDiscountController.text,
                          controller.itemPriceController.text,
                          controller.itemQuantityController.text,
                          controller.itemTextRateController.text,
                          controller.itemUnitToMeasureController.text,
                          controller.itemDescriptionController.text
                      );

                      debugPrint('Item ADDED inside invoice or EST');
                      Get.back();
                      Get.back();
                    }
                  }
                }
              },
              icon: const Icon(Icons.check, size: 20, color: sWhite,)
          ),
        ],
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage('assets/images/item_screen_back.jpg'),
                fit: BoxFit.fill)),
        child: Center(
          child: SizedBox(
            width: MediaQuery.of(context).size.width * 0.5,
            child: SingleChildScrollView(
              child: WillPopScope(
                onWillPop: ()async{
                  if(AppSingletons().isComingFromBottomBar){
                    Get.back();
                  } else if(AppSingletons.isEditingItemDataFromInvoice.value){
                    AppSingletons.isEditingItemDataFromInvoice.value = false;
                    Get.back();
                  } else{
                    Get.back();
                  }
                  return true;
                },
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
                            const Row(
                              children: [
                                Text('Item Name', style: TextStyle(
                                    fontFamily: 'Montserrat',
                                    fontWeight: FontWeight.w600,
                                    fontSize: 14,
                                    color: grey_1),),
                                SizedBox(width: 5,),
                                Text(
                                  '*',
                                  style: TextStyle( fontFamily: 'Montserrat',color: starColor),),
                              ],
                            ),
                            const SizedBox(height: 5,),
                            CommonTextField(
                              textEditingController: controller.itemNameController,
                              hintText: 'Enter Item name',
                              maxLines: 1,
                              textInputType: TextInputType.text,
                              textInputAction: TextInputAction.next,
                              maxLength: 40,
                            ),
                            const SizedBox(height: 10,),
                            const Text('Item Price', style: TextStyle(
                                fontFamily: 'Montserrat',
                                fontWeight: FontWeight.w600, color: grey_1,fontSize: 14),),
                            const SizedBox(height: 5,),
                            CommonTextField(
                              textEditingController: controller.itemPriceController,
                              hintText: 'Enter Item price',
                              maxLines: 1,
                              inputFormatter: [AmountInputFormatter()],
                              textInputType: TextInputType.number,
                              textInputAction: TextInputAction.next,
                            ),
                            const SizedBox(height: 10,),
                            const Text('Unit to measure', style: TextStyle(
                                fontFamily: 'Montserrat',
                                fontWeight: FontWeight.w600,fontSize: 14, color: grey_1),),
                            const SizedBox(height: 5,),
                            CommonTextField(
                              textEditingController: controller.itemUnitToMeasureController,
                              hintText: 'None',
                              maxLines: 1,
                              textInputType: TextInputType.text,
                              textInputAction: TextInputAction.next,
                            ),
                            const SizedBox(height: 10,),
                            Visibility(
                                visible: !AppSingletons().isComingFromBottomBar,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text('Item Quantity', style: TextStyle(
                                        fontFamily: 'Montserrat',
                                        fontWeight: FontWeight.w600,
                                        fontSize: 14,
                                        color: grey_1),),
                                    const SizedBox(height: 5,),
                                    CommonTextField(
                                      textEditingController: controller.itemQuantityController,
                                      hintText: '0',
                                      maxLines: 1,
                                      inputFormatter: [AmountInputFormatter()],
                                      textInputType: TextInputType.number,
                                      textInputAction: TextInputAction.next,
                                    ),
                                    const SizedBox(height: 10,),
                                    const Text('Discount', style: TextStyle(
                                        fontFamily: 'Montserrat',
                                        fontWeight: FontWeight.w600,
                                        fontSize: 14,
                                        color: grey_1),),
                                    const SizedBox(height: 5,),
                                    CommonTextField(
                                      textEditingController: controller.itemDiscountController,
                                      hintText: '0%',
                                      maxLines: 1,
                                      textInputType: TextInputType.number,
                                      textInputAction: TextInputAction.next,
                                      inputFormatter: [
                                        FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
                                        PercentageInputFormatter(),
                                      ],
                                    ),
                                    const SizedBox(height: 10,),
                                    const Text('Tax Rate', style: TextStyle(
                                        fontFamily: 'Montserrat',
                                        fontWeight: FontWeight.w600,
                                        fontSize: 14,
                                        color: grey_1),),
                                    const SizedBox(height: 5,),
                                    CommonTextField(
                                      textEditingController: controller.itemTextRateController,
                                      hintText: '0%',
                                      maxLines: 1,
                                      textInputType: TextInputType.number,
                                      textInputAction: TextInputAction.next,
                                      inputFormatter: [
                                        FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
                                        PercentageInputFormatter(),
                                      ],
                                    ),
                                    const SizedBox(height: 10,),
                                    const Text(
                                      '* This discount and tax is valid on this item only',
                                      style: TextStyle(
                                        fontFamily: 'Montserrat',
                                        color: greyColor,
                                        fontSize: 13,
                                        fontWeight: FontWeight.w300,
                                      ),
                                    ),
                                    const SizedBox(height: 10,),
                                    Container(
                                      padding: const EdgeInsets.all(12),
                                      decoration:  BoxDecoration(
                                        borderRadius: BorderRadius.circular(8),
                                        color: mainPurpleColor,
                                      ),

                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          const Text('Total',
                                            style: TextStyle(
                                              fontFamily: 'Montserrat',
                                              color: sWhite,
                                              fontWeight: FontWeight.w600,
                                              fontSize: 16,
                                            ),
                                          ),

                                          Obx(() {
                                            return
                                              Text(controller.totalPrice.value.toString(),
                                                style: const TextStyle(
                                                  fontFamily: 'Montserrat',
                                                  color: sWhite,
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 16,
                                                ),
                                              );
                                          })
                                        ],
                                      ),
                                    ),
                                  ],
                                )),
                          ],
                        ),
                      ),
                      // Visibility(
                      //   visible: AppSingletons().isComingFromBottomBar == false,
                      //   child: InkWell(
                      //     onTap: () {
                      //       controller.calculateResult();
                      //     },
                      //     child: Container(
                      //       margin: const EdgeInsets.symmetric(horizontal: 10),
                      //       padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 5),
                      //       decoration: BoxDecoration(
                      //         borderRadius: BorderRadius.circular(8),
                      //         color: grey_1,
                      //       ),
                      //
                      //       child: Row(
                      //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      //         children: [
                      //           Text('Total',
                      //             style: GoogleFonts.montserrat(
                      //               color: sWhite,
                      //               fontWeight: FontWeight.w600,
                      //               fontSize: 16,
                      //             ),
                      //           ),
                      //
                      //           Obx(() {
                      //             return
                      //               Text(controller.totalPrice.value.toString(),
                      //               style: GoogleFonts.montserrat(
                      //                 color: sWhite,
                      //                 fontWeight: FontWeight.w600,
                      //                 fontSize: 16,
                      //               ),
                      //             );
                      //           })
                      //         ],
                      //       ),
                      //     ),
                      //   ),
                      // ),
                      const SizedBox(height: 10,),
                      CustomContainer(
                        verticalPadding: 10,
                        horizontalPadding: 10,
                        childContainer: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            const Text('Item Description', style: TextStyle(
                                fontFamily: 'Montserrat',
                                fontWeight: FontWeight.w600,fontSize: 14, color: grey_1),),
                            const SizedBox(height: 5,),

                            Container(
                              constraints: const BoxConstraints(
                                  minHeight: 100
                              ),

                              child: CommonTextField(
                                textEditingController: controller.itemDescriptionController,
                                textInputAction: TextInputAction.done,
                                textInputType: TextInputType.text,
                                maxLength: 500,
                                maxLines: 8,
                                hintText: 'Enter description here',
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 10,),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}