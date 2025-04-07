import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:intl/intl.dart';
import 'package:currency_picker/currency_picker.dart';
import 'package:invoice/core/utils/dialogue_to_select_language.dart';
import '../../core/constants/app_constants/App_Constants.dart';
import '../../core/utils/utils.dart';
import '../../core/routes/routes.dart';
import '../../../core/widgets/custom_container.dart';
import '../../core/app_singletons/app_singletons.dart';
import '../../core/widgets/common_text_field.dart';
import 'invoice_entrance_controller.dart';
import '../../../core/constants/color/color.dart';

class InvoiceEntranceView extends GetView<InvoiceEntranceController> {
  InvoiceEntranceView({super.key});

  @override
  final controller = Get.put<InvoiceEntranceController>(InvoiceEntranceController());

  @override
  Widget build(BuildContext context) {

    bool checkIsMobileLayout = AppConstants.isMobileScreen.value;

    return checkIsMobileLayout
        ? mainMobileLayout(context,checkIsMobileLayout) : mainDesktopLayout(context,checkIsMobileLayout);
  }

  Widget mainMobileLayout(BuildContext context,bool isMobileScreen) {
    return Scaffold(
      backgroundColor: orangeLight_1,
      appBar: AppBar(
        backgroundColor: mainPurpleColor,
        leading: IconButton(
          onPressed: () {
            leaveInvoiceAlert();
          },
          icon: const Icon(
            Icons.arrow_back_rounded,
            color: sWhite,
          ),
        ),
        title: Text(
          AppSingletons.isEditInvoice.value == false
              ? 'enter_invoice'.tr
              : 'edit_invoice'.tr,
          style: const TextStyle(
              fontFamily: 'SFProDisplay',
              color: sWhite,
              fontSize: 18,
              fontWeight: FontWeight.w600,
              letterSpacing: 1),
        ),
      ),
      body: Obx(() {
        return controller.isLoadingDefaultValues.value
            ? const Center(child: CupertinoActivityIndicator(
          color: mainPurpleColor, radius: 15,),)
            : PopScope(
          canPop: false,
          onPopInvoked: (_) {
            leaveInvoiceAlert();
          },
          // onWillPop: () async {
          //   leaveInvoiceAlert();
          //   return true;
          // },
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(
                  height: 20,
                ),
                InkWell(
                  onTap: () {
                    editDataAndInvoiceNumber(context,isMobileScreen);
                  },
                  child: CustomContainer(
                    horizontalPadding: 10,
                    verticalPadding: 10,
                    childContainer: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Obx(() {
                          return
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  AppSingletons.invoiceNumberId?.value ?? '',
                                  style: const TextStyle(
                                      fontFamily: 'SFProDisplay',
                                      letterSpacing: 1.5,
                                      color: grey_1,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w900),
                                ),

                                Text(
                                  '${'created_on'.tr} ${DateFormat('dd-MM-yyyy')
                                      .format(AppSingletons.creationDate.value)
                                      .toString()}',
                                  style: const TextStyle(
                                      fontFamily: 'Montserrat',
                                      color: grey_1,
                                      fontWeight: FontWeight.w500
                                  ),
                                ),
                                Text(
                                  '${'due_on'.tr} ${DateFormat('dd-MM-yyyy').format(
                                      AppSingletons.dueDate.value).toString()}',
                                  style: const TextStyle(
                                      fontFamily: 'Montserrat',
                                      color: grey_1,
                                      fontWeight: FontWeight.w500),
                                ),
                              ],
                            );
                        }),
                        const Icon(
                          Icons.keyboard_arrow_right_outlined,
                          color: grey_1,
                        )
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                GestureDetector(
                  onTap: () {
                    // selectInvoiceLanguage(isMobileScreen);
                    LanguageSelection.selectALanguage(
                        context: context,
                        titleHeading: 'invoice_language'.tr,
                        onChange: (){
                          AppSingletons.languageName?.value = AppSingletons.selectedNewLanguage.value;
                          AppSingletons.invDefaultLanguageName?.value = AppSingletons.selectedNewLanguage.value;
                          Get.back();
                        }
                    );
                  },
                  child: CustomContainer(
                    childContainer: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Container(
                              height: 60,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10),
                              decoration: const BoxDecoration(
                                  borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(8),
                                      bottomLeft: Radius.circular(8)),
                                  color: mainPurpleColor
                              ),
                              child: const Icon(
                                Icons.language,
                                color: sWhite,
                              ),
                            ),
                            const SizedBox(width: 17,),
                             Text(
                              'invoice_language'.tr,
                              style: const TextStyle(
                                  fontFamily: 'Montserrat',
                                  fontWeight: FontWeight.w600,
                                  color: grey_1,
                                  fontSize: 14
                              ),
                            ),
                          ],
                        ),

                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Obx(() {
                              return Text(
                                AppSingletons.languageName?.value ?? 'English',
                                style: const TextStyle(
                                  color: grey_1,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                ),
                              );
                            }),
                            Container(
                              padding: const EdgeInsets.only(right: 10),
                              child: const Icon(
                                Icons.keyboard_arrow_right_outlined,
                                color: grey_1,
                              ),
                            )
                          ],
                        ),

                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                GestureDetector(
                  onTap: () {
                    Get.toNamed(Routes.pdfTemplateSelect);
                  },
                  child: CustomContainer(
                    childContainer: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          children: [
                            Container(
                              height: 60,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10),
                              decoration: const BoxDecoration(
                                  borderRadius: BorderRadius.only(
                                      bottomLeft: Radius.circular(8),
                                      topLeft: Radius.circular(8)),
                                  color: mainPurpleColor
                              ),
                              child: const Icon(
                                Icons.account_balance_wallet,
                                color: sWhite,
                              ),
                            ),
                            const SizedBox(width: 17),
                             Text(
                              'template'.tr,
                              style: const TextStyle(
                                  fontFamily: 'Montserrat',
                                  fontWeight: FontWeight.w600,
                                  color: grey_1,
                                  fontSize: 14),
                            ),
                          ],
                        ),
                        Container(
                          padding: const EdgeInsets.only(right: 10),
                          child: const Icon(
                            Icons.keyboard_arrow_right_outlined,
                            color: grey_1,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                GestureDetector(
                  onTap: () {
                    Get.toNamed(Routes.businessListView);
                    AppSingletons().isComingFromBottomBar = false;
                  },
                  child: CustomContainer(
                    childContainer: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Obx(() {
                              return Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10),
                                height: AppSingletons.businessNameINV!.value
                                    .isNotEmpty
                                    ? 80
                                    : 60,
                                decoration: const BoxDecoration(
                                    borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(8),
                                        bottomLeft: Radius.circular(8)),
                                    color: mainPurpleColor
                                ),
                                child: const Icon(
                                  Icons.perm_contact_cal_outlined,
                                  color: sWhite,
                                ),
                              );
                            }),
                            const SizedBox(width: 17,),
                            Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(height: 10,),
                                 Text(
                                  'from'.tr,
                                  style: const TextStyle(
                                      fontFamily: 'Montserrat',
                                      fontWeight: FontWeight.w600,
                                      color: grey_1,
                                      fontSize: 14),
                                ),
                                Obx(() {
                                  return Visibility(
                                    visible: AppSingletons.businessNameINV
                                        ?.value
                                        .isNotEmpty ??
                                        false,
                                    child: Text(
                                      AppSingletons.businessNameINV?.value ??
                                          '',
                                      style: const TextStyle(
                                          fontWeight: FontWeight.w500,
                                          fontFamily: 'Montserrat',
                                          color: grey_4,
                                          fontSize: 14),
                                    ),
                                  );
                                }),
                                Obx(() {
                                  return Visibility(
                                    visible:
                                    AppSingletons.businessEmailINV?.value
                                        .isNotEmpty ?? false,
                                    child: Text(
                                      AppSingletons.businessEmailINV?.value ??
                                          '',
                                      style: const TextStyle(
                                          fontWeight: FontWeight.w500,
                                          fontFamily: 'Montserrat',
                                          color: grey_4,
                                          fontSize: 14),
                                    ),
                                  );
                                }),
                                const SizedBox(height: 10,),
                              ],
                            ),
                          ],
                        ),
                        Container(
                          padding: const EdgeInsets.only(right: 10),
                          child: const Icon(
                            Icons.keyboard_arrow_right_outlined,
                            color: grey_1,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 10,),
                GestureDetector(
                  onTap: () {
                    Get.toNamed(Routes.clientDataView);
                    AppSingletons().isComingFromBottomBar = false;
                  },
                  child: CustomContainer(
                    childContainer: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Obx(() {
                              return Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10),
                                height: AppSingletons.clientNameINV!.value
                                    .isNotEmpty
                                    ? 80
                                    : 60,
                                decoration: const BoxDecoration(
                                    borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(8),
                                        bottomLeft: Radius.circular(8)),
                                    color: mainPurpleColor
                                ),
                                child: const Icon(
                                  Icons.arrow_circle_right_outlined,
                                  color: sWhite,
                                ),
                              );
                            }),
                            const SizedBox(width: 17,),
                            Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(height: 10,),
                                 Text(
                                  'bill_to'.tr,
                                  style: const TextStyle(
                                      fontFamily: 'Montserrat',
                                      fontWeight: FontWeight.w600,
                                      color: grey_1,
                                      fontSize: 14),
                                ),
                                Obx(() {
                                  return Visibility(
                                    visible: AppSingletons.clientNameINV!.value
                                        .isNotEmpty,
                                    child: Text(
                                      AppSingletons.clientNameINV?.value ?? '',
                                      style: const TextStyle(
                                          fontWeight: FontWeight.w500,
                                          color: greyColor,
                                          fontSize: 14),
                                    ),
                                  );
                                }),
                                Obx(() {
                                  return Visibility(
                                    visible: AppSingletons.clientEmailINV!.value
                                        .isNotEmpty,
                                    child: Text(
                                      AppSingletons.clientEmailINV?.value ?? '',
                                      style: const TextStyle(
                                          fontWeight: FontWeight.w500,
                                          color: greyColor,
                                          fontSize: 14),
                                    ),
                                  );
                                }),
                                const SizedBox(height: 10,),
                              ],
                            ),
                          ],
                        ),
                        Container(
                          padding: const EdgeInsets.only(right: 10),
                          child: const Icon(
                            Icons.keyboard_arrow_right_outlined,
                            color: grey_1,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 10,),
                Container(
                  width: double.infinity,
                  margin: const EdgeInsets.symmetric(horizontal: 10),
                  decoration: BoxDecoration(
                    color: offWhite,
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: const [
                      BoxShadow(
                          color: shadowColor,
                          blurRadius: 5,
                          offset: Offset(3, 3)),
                    ],
                  ),
                  child: Column(
                    children: [
                      // Container(
                      //   decoration: const BoxDecoration(
                      //     borderRadius: BorderRadius.only(
                      //       topLeft: Radius.circular(8),
                      //       topRight: Radius.circular(8)
                      //     ),
                      //     color: mainPurpleColor
                      //   ),
                      //   child: ListTile(
                      //     contentPadding: const EdgeInsets.symmetric(
                      //         horizontal: 10, vertical: 0),
                      //     leading: const Icon(
                      //       Icons.account_tree_outlined,
                      //       color: sWhite,
                      //     ),
                      //     title: GestureDetector(
                      //       child: const Text(
                      //         'Items',
                      //         style: TextStyle(
                      //             fontFamily: 'Montserrat',
                      //             fontWeight: FontWeight.w600,
                      //             color: sWhite,
                      //             fontSize: 14),
                      //       ),
                      //     ),
                      //   ),
                      // ),

                      GestureDetector(
                        onTap: () {
                          Get.toNamed(Routes.itemsView);
                          AppSingletons().isComingFromBottomBar = false;
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: offWhite,
                            borderRadius: BorderRadius.circular(8),
                            boxShadow: const [
                              BoxShadow(
                                  color: shadowColor,
                                  blurRadius: 5,
                                  offset: Offset(3, 3)
                              ),
                            ],
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10),
                                    height: 60,
                                    decoration: const BoxDecoration(
                                        borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(8),
                                            bottomLeft: Radius.circular(8)),
                                        color: mainPurpleColor
                                    ),
                                    child: const Icon(
                                      Icons.account_tree_outlined,
                                      color: sWhite,
                                    ),
                                  ),
                                  const SizedBox(width: 17,),
                                   Text(
                                    'add_items'.tr,
                                    style: const TextStyle(
                                        fontFamily: 'Montserrat',
                                        fontWeight: FontWeight.w600,
                                        color: grey_1,
                                        fontSize: 14),
                                  ),
                                ],
                              ),
                              Container(
                                padding: const EdgeInsets.only(right: 10),
                                child: const Icon(
                                  Icons.keyboard_arrow_right_outlined,
                                  color: grey_1,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(height: 5,),

                      Obx(() =>
                      controller.isLoading.value
                          ? const Center(
                        child: CupertinoActivityIndicator(
                          color: orangeDark_3,
                          radius: 10,
                        ),
                      )
                          : ListView.builder(
                        itemCount: controller.selectedItemNames.length,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) {
                          final itemName = controller.selectedItemNames[index];
                          final itemPrice = controller.selectedItemPrice[index];
                          final itemUnit = controller.selectedItemUnitName[index];
                          final itemQuantity = controller.selectedItemQuantity[index];
                          final itemDiscount = controller.selectedItemDiscount[index];
                          final itemTaxRate = controller.selectedItemTaxRate[index];
                          final itemDescription = controller.selectedItemDescription[index];
                          final itemAmount = controller.selectedItemAmount[index];

                          return GestureDetector(
                            onTap: () {
                              AppSingletons().isComingFromBottomBar = false;
                              Get.toNamed(Routes.addEditItemView, arguments: {
                                'indexId': index,
                                'itemName': itemName.toString(),
                                'itemPrice': itemPrice.toString(),
                                'itemUnit': itemUnit.toString(),
                                'itemQuantity': itemQuantity.toString(),
                                'itemDiscount': itemDiscount.toString(),
                                'itemTaxRate': itemTaxRate.toString(),
                                'itemDescription': itemDescription.toString(),
                              });

                              AppSingletons.isEditingItemDataFromInvoice.value =
                              true;

                              debugPrint('ABC ${AppSingletons
                                  .isEditingItemDataFromInvoice.value}');

                              debugPrint('IndexId: $index');
                              debugPrint('ItemUnit: $itemUnit');
                              debugPrint('itemQuantity: $itemQuantity');
                              debugPrint('itemDiscount: $itemDiscount');
                              debugPrint('itemTaxRate: $itemTaxRate');
                              debugPrint('itemDescription: $itemDescription');
                            },
                            child: Container(
                              margin: const EdgeInsets.symmetric(
                                  horizontal: 9, vertical: 5),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 15, vertical: 5),
                              decoration: BoxDecoration(color: lightShadePurple,
                                  borderRadius: BorderRadius.circular(5)
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment
                                    .spaceBetween,
                                children: [
                                  Column(
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment
                                        .start,
                                    children: [
                                      Text(itemName,
                                        style: const TextStyle(
                                            fontSize: 14,
                                            fontFamily: 'Montserrat',
                                            fontWeight: FontWeight.w700,
                                            color: grey_1
                                        ),
                                      ),
                                      Obx(() {
                                        return Text(
                                          '(${AppSingletons.currencyNameINV
                                              ?.value ??
                                              'Rs'}$itemPrice X $itemQuantity)',
                                          style: const TextStyle(
                                              fontSize: 14,
                                              fontFamily: 'Montserrat',
                                              fontWeight: FontWeight.w500,
                                              color: grey_1
                                          ),
                                        );
                                      }),

                                      Visibility(
                                        visible: itemDiscount != null,
                                        child: Text(
                                          '${'discount'.tr} (- $itemDiscount%)',
                                          style: const TextStyle(
                                              fontSize: 14,
                                              fontFamily: 'Montserrat',
                                              fontWeight: FontWeight.w500,
                                              color: grey_1
                                          ),
                                        ),
                                      ),

                                      Visibility(
                                        visible: itemTaxRate != null,
                                        child: Text('${'tax'.tr} (+ $itemTaxRate%)',
                                          style: const TextStyle(
                                              fontSize: 14,
                                              fontFamily: 'Montserrat',
                                              fontWeight: FontWeight.w500,
                                              color: grey_1
                                          ),
                                        ),
                                      ),

                                    ],
                                  ),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Row(
                                        children: [
                                          Obx(() {
                                            return Text(
                                              AppSingletons.currencyNameINV
                                                  ?.value ?? 'Rs',
                                              style: const TextStyle(
                                                  fontSize: 15,
                                                  fontFamily: 'Montserrat',
                                                  fontWeight: FontWeight.w700,
                                                  color: grey_2
                                              ),
                                            );
                                          }),
                                          const SizedBox(width: 2,),
                                          Text(itemAmount.toString(),
                                            style: const TextStyle(
                                                fontSize: 15,
                                                fontFamily: 'Montserrat',
                                                fontWeight: FontWeight.w700,
                                                color: grey_2
                                            ),
                                          ),
                                        ],
                                      ),

                                      const SizedBox(height: 8,),

                                      Row(
                                        children: [
                                          GestureDetector(onTap: () {
                                            controller.subtractItemQuantity(
                                                index);
                                          },
                                              child: Container(
                                                  decoration: BoxDecoration(
                                                      color: mainPurpleColor,
                                                      borderRadius: BorderRadius
                                                          .circular(3)
                                                  ),
                                                  padding: const EdgeInsets
                                                      .symmetric(vertical: 3,
                                                      horizontal: 12),
                                                  child: const Text(
                                                    '-', style: TextStyle(
                                                      fontSize: 18,
                                                      fontFamily: 'Montserrat',
                                                      fontWeight: FontWeight
                                                          .w700,
                                                      color: sWhite
                                                  ),)
                                              )),

                                          const SizedBox(width: 8,),

                                          Text(itemQuantity.toString(),
                                            style: const TextStyle(
                                              fontSize: 17,
                                              fontFamily: 'Montserrat',
                                              fontWeight: FontWeight.w700,
                                              color: grey_2,
                                            ),
                                          ),

                                          const SizedBox(width: 8,),

                                          GestureDetector(
                                            onTap: () {
                                              controller.addItemQuantity(index);
                                            },
                                            child: Container(
                                                decoration: BoxDecoration(
                                                    color: mainPurpleColor,
                                                    borderRadius: BorderRadius
                                                        .circular(3)
                                                ),
                                                padding: const EdgeInsets
                                                    .symmetric(
                                                    vertical: 3,
                                                    horizontal: 10),
                                                child: const Text(
                                                  '+', style: TextStyle(
                                                    fontSize: 18,
                                                    fontFamily: 'Montserrat',
                                                    fontWeight: FontWeight.w600,
                                                    color: sWhite
                                                ),)),)
                                        ],
                                      )
                                    ],
                                  ),
                                ],
                              ),
                              // ListTile(
                              //   onTap: () {
                              //     AppSingletons().isComingFromBottomBar = false;
                              //     Get.toNamed(Routes.addEditItemView, arguments: {
                              //       'indexId': index,
                              //       'itemName': itemName.toString(),
                              //       'itemPrice': itemPrice.toString(),
                              //       'itemUnit': itemUnit.toString(),
                              //       'itemQuantity': itemQuantity.toString(),
                              //       'itemDiscount': itemDiscount.toString(),
                              //       'itemTaxRate': itemTaxRate.toString(),
                              //       'itemDescription': itemDescription.toString(),
                              //     });
                              //
                              //     AppSingletons.isEditingItemDataFromInvoice
                              //         .value = true;
                              //
                              //     debugPrint('${AppSingletons
                              //         .isEditingItemDataFromInvoice.value}');
                              //
                              //     debugPrint('IndexId: $index');
                              //     debugPrint('ItemUnit: $itemUnit');
                              //     debugPrint('itemQuantity: $itemQuantity');
                              //     debugPrint('itemDiscount: $itemDiscount');
                              //     debugPrint('itemTaxRate: $itemTaxRate');
                              //     debugPrint('itemDescription: $itemDescription');
                              //   },
                              //   leading: Column(
                              //     mainAxisSize: MainAxisSize.min,
                              //     mainAxisAlignment: MainAxisAlignment.start,
                              //     crossAxisAlignment: CrossAxisAlignment.start,
                              //     children: [
                              //       Text(itemName,
                              //         style: const TextStyle(
                              //             fontSize: 14,
                              //             fontFamily: 'Montserrat',
                              //             fontWeight: FontWeight.w700,
                              //             color: grey_1
                              //         ),
                              //       ),
                              //       Text('($itemPrice X $itemQuantity)',
                              //         style: const TextStyle(
                              //             fontSize: 14,
                              //             fontFamily: 'Montserrat',
                              //             fontWeight: FontWeight.w500,
                              //             color: grey_1
                              //         ),
                              //       ),
                              //
                              //       Visibility(
                              //         visible: itemDiscount != null,
                              //         child: Text('Discount (- $itemDiscount%)',
                              //           style: const TextStyle(
                              //               fontSize: 14,
                              //               fontFamily: 'Montserrat',
                              //               fontWeight: FontWeight.w500,
                              //               color: grey_1
                              //           ),
                              //         ),
                              //       ),
                              //
                              //       Visibility(
                              //         visible: itemTaxRate != null,
                              //         child: Text('Tax (+ $itemTaxRate%)',
                              //           style: const TextStyle(
                              //               fontSize: 14,
                              //               fontFamily: 'Montserrat',
                              //               fontWeight: FontWeight.w500,
                              //               color: grey_1
                              //           ),
                              //         ),
                              //       ),
                              //
                              //     ],
                              //   ),
                              //   // title: Text(itemName,
                              //   //   style: const TextStyle(
                              //   //       fontSize: 14,
                              //   //       fontFamily: 'Montserrat',
                              //   //       fontWeight: FontWeight.w600,
                              //   //       color: grey_1
                              //   //   ),
                              //   // ),
                              //   trailing: Text(itemAmount.toString(),
                              //     style: const TextStyle(
                              //         fontSize: 12,
                              //         fontFamily: 'Montserrat',
                              //         fontWeight: FontWeight.w500,
                              //         color: grey_2
                              //     ),
                              //   ),
                              // ),
                            ),
                          );
                        },
                      )),
                      const SizedBox(height: 10,),
                      InkWell(
                        onTap: () {
                          // Get.offAndToNamed(Routes.itemsView);
                          Get.toNamed(Routes.itemsView);

                          AppSingletons().isComingFromBottomBar = false;
                        },
                        child: Container(
                          margin: const EdgeInsets.symmetric(horizontal: 9),
                          width: double.infinity,
                          decoration: BoxDecoration(
                              color: lightShadePurple,
                              borderRadius: BorderRadius.circular(5)),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                margin: const EdgeInsets.all(8),
                                height: 20,
                                width: 20,
                                alignment: Alignment.center,
                                decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: mainPurpleColor),
                                child: const Icon(
                                  Icons.add,
                                  color: sWhite,
                                  size: 13,
                                ),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                               Text(
                                'add_items'.tr,
                                style: const TextStyle(
                                  fontFamily: 'Montserrat',
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 9),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 10),
                        width: double.infinity,
                        decoration: BoxDecoration(
                            color: lightShadePurple,
                            borderRadius: BorderRadius.circular(5)),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                             Text(
                              'subtotal'.tr,
                              style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: grey_1,
                                  fontFamily: 'Montserrat',
                                  fontSize: 13
                              ),
                            ),
                            Obx(() {
                              return Row(
                                children: [
                                  Text(
                                    '${ AppSingletons.currencyNameINV?.value}',
                                    style: const TextStyle(
                                      color: grey_1,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  Text(
                                    '${ AppSingletons.subTotal?.value
                                        .toStringAsFixed(
                                        0)}',
                                    style: const TextStyle(
                                      color: grey_1,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              );
                            })
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      ListTile(
                        onTap: () {
                          addDiscountInTotal();
                        },
                        leading: const Icon(
                          Icons.percent,
                          color: grey_1,
                        ),
                        title: Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                             Text(
                              'discount'.tr,
                              style: const TextStyle(
                                  fontFamily: 'Montserrat',
                                  fontWeight: FontWeight.w600,
                                  color: grey_1,
                                  fontSize: 14),
                            ),
                            Obx(() {
                              return Visibility(
                                visible: AppSingletons.discountPercentage!
                                    .value !=
                                    '',
                                child: Text(
                                  '(${AppSingletons.discountPercentage?.value ??
                                      'N/A'}%)',
                                  style: const TextStyle(),
                                ),
                              );
                            })
                          ],
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Obx(() {
                              return Visibility(
                                visible: AppSingletons.discountAmount.value
                                    .isNotEmpty ||
                                    AppSingletons.discountAmount.value != '0',
                                child: Text(
                                  '-${AppSingletons.discountAmount.value}',
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 16,
                                      color: grey_1),
                                ),
                              );
                            }),
                            const SizedBox(
                              width: 5,
                            ),
                            const Icon(
                              Icons.keyboard_arrow_right_outlined,
                              color: grey_1,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      ListTile(
                        onTap: () {
                          addTaxInTotal();
                        },
                        leading: const Icon(
                          Icons.cut,
                          color: grey_1,
                        ),
                        title: Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                             Text(
                              'tax'.tr,
                              style: const TextStyle(
                                  fontFamily: 'Montserrat',
                                  fontWeight: FontWeight.w600,
                                  color: grey_1,
                                  fontSize: 14),
                            ),
                            Obx(() {
                              return Visibility(
                                visible: AppSingletons.taxPercentage!.value !=
                                    '',
                                child: Text(
                                  '(${AppSingletons.taxPercentage?.value ??
                                      'N/A'}%)',
                                  style: const TextStyle(),
                                ),
                              );
                            })
                          ],
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Obx(() {
                              return Visibility(
                                visible: AppSingletons.taxAmount.value
                                    .isNotEmpty ||
                                    AppSingletons.taxAmount.value != '0',
                                child: Text(
                                  '+${AppSingletons.taxAmount.value}',
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 16,
                                      color: grey_1),
                                ),
                              );
                            }),
                            const SizedBox(
                              width: 5,
                            ),
                            const Icon(
                              Icons.keyboard_arrow_right_outlined,
                              color: grey_1,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      ListTile(
                        onTap: () {
                          addShippingCostinTotal();
                        },
                        leading: const Icon(
                          Icons.local_shipping_outlined,
                          color: grey_1,
                        ),
                        title: Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'shipping'.tr,
                              style: const TextStyle(
                                  fontFamily: 'Montserrat',
                                  fontWeight: FontWeight.w600,
                                  color: grey_1,
                                  fontSize: 14),
                            ),
                          ],
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Obx(() {
                              return Text(
                                '+${AppSingletons.shippingCost.value}',
                                style: const TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 16,
                                    color: grey_1),
                              );
                            }),
                            const SizedBox(
                              width: 5,
                            ),
                            const Icon(
                              Icons.keyboard_arrow_right_outlined,
                              color: grey_1,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Container(
                        width: double.infinity,
                        decoration: const BoxDecoration(
                            color: mainPurpleColor,
                            borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(5),
                                bottomRight: Radius.circular(5))),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 10),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                             Text(
                              'total'.tr,
                              style: const TextStyle(
                                  fontFamily: 'Montserrat',
                                  color: sWhite,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 13
                              ),
                            ),
                            Obx(() {
                              return Row(
                                children: [
                                  Text(
                                    '${AppSingletons.currencyNameINV?.value}',
                                    style: const TextStyle(
                                      color: sWhite,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  Text(
                                    '${AppSingletons.finalPriceTotal?.value
                                        .toStringAsFixed(0)}',
                                    style: const TextStyle(
                                      color: sWhite,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              );
                            })
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                GestureDetector(
                  onTap: () {
                    showCurrencyPicker(
                      context: context,
                      showFlag: false,
                      showCurrencyName: true,
                      showCurrencyCode: true,
                      onSelect: (Currency currency) {
                        controller.selectCurrency(currency);
                        debugPrint('Selected currency: ${currency.name}');
                      },
                    );
                  },

                  child: CustomContainer(
                    childContainer: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Container(
                              height: 60,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10),
                              decoration: const BoxDecoration(
                                  color: mainPurpleColor,
                                  borderRadius: BorderRadius.only(
                                    bottomLeft: Radius.circular(8),
                                    topLeft: Radius.circular(8),
                                  )
                              ),
                              child: const Icon(
                                Icons.money,
                                color: sWhite,
                              ),
                            ),
                            const SizedBox(width: 17,),
                             Text(
                              'currency'.tr,
                              style: const TextStyle(
                                  fontFamily: 'Montserrat',
                                  fontWeight: FontWeight.w600,
                                  color: grey_1,
                                  fontSize: 14),
                            ),
                          ],
                        ),

                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Obx(() {
                              return Text(
                                AppSingletons.currencyNameINV?.value ?? '',
                                style: const TextStyle(
                                  color: grey_1,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                ),
                              );
                            }),
                            const Icon(
                              Icons.keyboard_arrow_right_outlined,
                              color: grey_1,
                            ),
                            const SizedBox(width: 10,),
                          ],
                        ),
                      ],
                    ),
                  ),

                ),
                const SizedBox(
                  height: 10,
                ),
                GestureDetector(
                  onTap: () {
                    Get.toNamed(Routes.signatureView);
                    AppSingletons().isComingFromBottomBar = false;
                  },

                  child: CustomContainer(
                    childContainer: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              height: 60,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10),
                              decoration: const BoxDecoration(
                                  borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(8),
                                      bottomLeft: Radius.circular(8)
                                  ),
                                  color: mainPurpleColor
                              ),
                              child: const Icon(
                                Icons.mode_edit_outline_outlined,
                                color: sWhite,
                              ),
                            ),
                            const SizedBox(width: 17,),
                             Text(
                              'signature'.tr,
                              style: const TextStyle(
                                  fontFamily: 'Montserrat',
                                  fontWeight: FontWeight.w600,
                                  color: grey_1,
                                  fontSize: 14),
                            ),
                          ],
                        ),

                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Obx(() =>
                            AppSingletons.signatureImgINV!.value.isEmpty
                                ? const SizedBox.shrink()
                                : Image.memory(
                              AppSingletons.signatureImgINV?.value ??
                                  Uint8List(0),
                              width: 30,
                              height: 30,
                              color: orangeDark_3,
                              fit: BoxFit.fill,
                            )),
                            const Icon(
                              Icons.keyboard_arrow_right_outlined,
                              color: grey_1,
                            ),

                            const SizedBox(width: 10,)

                          ],
                        ),

                      ],
                    ),
                  ),

                ),
                const SizedBox(
                  height: 10,
                ),
                GestureDetector(
                  onTap: () {
                    Get.toNamed(Routes.termsAndConditionView);
                    AppSingletons().isComingFromBottomBar = false;
                  },
                  child: CustomContainer(
                    childContainer: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Expanded(
                          child: Row(
                            children: [
                              Obx(() {
                                return Container(
                                  height: AppSingletons.termAndConditionINV!
                                      .value.isNotEmpty ? 80 : 60,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10),
                                  decoration: const BoxDecoration(
                                      color: mainPurpleColor,
                                      borderRadius: BorderRadius.only(
                                          bottomLeft: Radius.circular(8),
                                          topLeft: Radius.circular(8)
                                      )
                                  ),
                                  child: const Icon(
                                    Icons.event_note_sharp,
                                    color: sWhite,
                                  ),
                                );
                              }),
                              const SizedBox(width: 17,),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                     Text(
                                      'term_and_condition'.tr,
                                      style: const TextStyle(
                                          fontFamily: 'Montserrat',
                                          fontWeight: FontWeight.w600,
                                          color: grey_1,
                                          fontSize: 14),
                                    ),
                                    Obx(() {
                                      return Visibility(
                                        visible: AppSingletons
                                            .termAndConditionINV!.value
                                            .isNotEmpty,
                                        child: Text(
                                          AppSingletons.termAndConditionINV
                                              ?.value ?? '',
                                          maxLines: 2,
                                          style: const TextStyle(
                                              fontWeight: FontWeight.w500,
                                              color: grey_4,
                                              fontSize: 13),
                                        ),
                                      );
                                    }),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: const Icon(
                            Icons.keyboard_arrow_right_outlined,
                            color: grey_1,
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                GestureDetector(
                  onTap: () {
                    Get.toNamed(Routes.paymentView);
                    AppSingletons().isComingFromBottomBar = false;
                  },
                  child: CustomContainer(
                    childContainer: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Expanded(
                          child: Row(
                            children: [
                              Obx(() {
                                return Container(
                                  height: AppSingletons.paymentMethodINV!.value
                                      .isNotEmpty ? 80 : 60,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10),
                                  decoration: const BoxDecoration(
                                      color: mainPurpleColor,
                                      borderRadius: BorderRadius.only(
                                          bottomLeft: Radius.circular(8),
                                          topLeft: Radius.circular(8)
                                      )
                                  ),
                                  child: const Icon(
                                    Icons.payment_outlined,
                                    color: sWhite,
                                  ),
                                );
                              }),
                              const SizedBox(width: 17,),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                     Text(
                                      'payment_method'.tr,
                                      style: const TextStyle(
                                          fontFamily: 'Montserrat',
                                          fontWeight: FontWeight.w600,
                                          color: grey_1,
                                          fontSize: 14),
                                    ),
                                    Obx(() {
                                      return Visibility(
                                        visible: AppSingletons.paymentMethodINV!
                                            .value.isNotEmpty,
                                        child: Text(
                                          AppSingletons.paymentMethodINV
                                              ?.value ?? '',
                                          maxLines: 2,
                                          style: const TextStyle(
                                              fontWeight: FontWeight.w500,
                                              color: grey_4,
                                              fontSize: 13),
                                        ),
                                      );
                                    }),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: const Icon(
                            Icons.keyboard_arrow_right_outlined,
                            color: grey_1,
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
              ],
            ),
          ),
        );
      }),
      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(20),
                  topLeft: Radius.circular(10),
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                      flex: 1,
                      child: GestureDetector(
                        onTap: () async {
                          controller.showAd();
                          int templateId = 0;

                          debugPrint('Singleton temp ID: ${AppSingletons
                              .invoiceTemplateIdINV.value}');

                          if (AppSingletons.invoiceTemplateIdINV.value.isNotEmpty) {
                            templateId =
                                int.parse(AppSingletons.invoiceTemplateIdINV.value);
                          }

                          AppSingletons.isPreviewingPdfBeforeSave.value = true;

                          AppSingletons.isPreviewEstimateDoc.value = false;

                          debugPrint('isItPreviewBeforeSaving: ${AppSingletons
                              .isPreviewingPdfBeforeSave.value}');
                          debugPrint('Temp ID: $templateId');

                          Get.toNamed(Routes.pdfPreviewPages);
                        },
                        child: Container(
                          height: 50,
                          alignment: Alignment.center,
                          margin: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 10),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: blackColor, width: 1)),
                          child: Text(
                            'preview'.tr,
                            style: TextStyle(
                                color: Colors.grey.shade400,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      )),
                  Expanded(
                    flex: 2,
                    child: InkWell(
                      onTap: () async {
                        controller.showAd();

                        if(!AppSingletons.isSubscriptionEnabled.value){

                          if(AppSingletons.isEditInvoice.value){
                            await controller.editInvoiceData();
                          } else{
                            if(AppSingletons.noOfInvoicesMadeAlready.value >= 1){
                              Get.toNamed(Routes.proScreenView);
                            } else{
                              await controller.saveDataInInvoice();
                            }
                          }

                          // if(
                          // AppSingletons.selectedTempIndexToCheck.value == 0
                          // || AppSingletons.selectedTempIndexToCheck.value == 1
                          // ) {
                          //
                          //
                          // } else{
                          //   Get.toNamed(Routes.proScreenView);
                          // }
                        }
                        else{
                          if (AppSingletons.isEditInvoice.value) {
                            await controller.editInvoiceData();
                          } else {
                            await controller.saveDataInInvoice();
                          }
                        }


                      },
                      child: Container(
                        height: 50,
                        alignment: Alignment.center,
                        margin: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 10),
                        constraints: const BoxConstraints(minHeight: 50),
                        decoration: BoxDecoration(
                            color: mainPurpleColor,
                            borderRadius: BorderRadius.circular(10)),
                        child: Text(
                          'save'.tr,
                          style: const TextStyle(
                              color: sWhite, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  )
                ],
              )),
          Obx(() {
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
        ],
      ),
    );
  }

  Widget mainDesktopLayout(BuildContext context,bool isMobileScreen) {
    return Scaffold(
      backgroundColor: orangeLight_1,
      appBar: AppBar(
        backgroundColor: mainPurpleColor,
        leading: IconButton(
          onPressed: () {
            leaveInvoiceAlert();
          },
          icon: const Icon(
            Icons.arrow_back_rounded,
            color: sWhite,
          ),
        ),
        title: Text(
          AppSingletons.isEditInvoice.value == false
              ? 'Enter Invoice'
              : 'Edit Invoice',
          style: const TextStyle(
              fontFamily: 'SFProDisplay',
              color: sWhite,
              fontSize: 18,
              fontWeight: FontWeight.w600,
              letterSpacing: 1),
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage(
                    'assets/images/invoice_entrance_back.jpg'
                ),
                fit: BoxFit.fill
            )
        ),
        alignment: Alignment.center,
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 30),
          width: MediaQuery.of(context).size.width * 0.5,
          decoration: BoxDecoration(
              color: sWhite,
              borderRadius: BorderRadius.circular(10)
          ),
          child: PopScope(
            canPop: false,
            onPopInvoked: (_) {
              leaveInvoiceAlert();
            },
            // onWillPop: () async {
            //   leaveInvoiceAlert();
            //   return true;
            // },
            child: Stack(
              children: [
                Obx(() {
                  return controller.isLoadingDefaultValues.value
                      ? const Center(child: CupertinoActivityIndicator(
                    color: mainPurpleColor, radius: 15,),)
                      : SingleChildScrollView(
                    child: Column(
                      children: [
                        const SizedBox(
                          height: 20,
                        ),
                        InkWell(
                          onTap: () {
                            editDataAndInvoiceNumber(context,isMobileScreen);
                          },
                          child: CustomContainer(
                            horizontalPadding: 10,
                            verticalPadding: 10,
                            childContainer: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Obx(() {
                                  return
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(
                                          AppSingletons.invoiceNumberId?.value ?? '',
                                          style: const TextStyle(
                                              fontFamily: 'SFProDisplay',
                                              letterSpacing: 1.5,
                                              color: grey_1,
                                              fontSize: 16,
                                              fontWeight: FontWeight.w900),
                                        ),

                                        Text(
                                          'Created on ${DateFormat('dd-MM-yyyy')
                                              .format(
                                              AppSingletons.creationDate.value)
                                              .toString()}',
                                          style: const TextStyle(
                                              fontFamily: 'Montserrat',
                                              color: grey_1,
                                              fontWeight: FontWeight.w500
                                          ),
                                        ),
                                        Text(
                                          'Due on ${DateFormat('dd-MM-yyyy')
                                              .format(
                                              AppSingletons.dueDate.value)
                                              .toString()}',
                                          style: const TextStyle(
                                              fontFamily: 'Montserrat',
                                              color: grey_1,
                                              fontWeight: FontWeight.w500),
                                        ),
                                      ],
                                    );
                                }),
                                const Icon(
                                  Icons.keyboard_arrow_right_outlined,
                                  color: grey_1,
                                )
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        GestureDetector(
                          onTap: () {
                            selectInvoiceLanguage(isMobileScreen);
                          },
                          child: CustomContainer(
                            childContainer: Row(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      height: 60,
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10),
                                      decoration: const BoxDecoration(
                                          borderRadius: BorderRadius.only(
                                              topLeft: Radius.circular(8),
                                              bottomLeft: Radius.circular(8)),
                                          color: mainPurpleColor
                                      ),
                                      child: const Icon(
                                        Icons.language,
                                        color: sWhite,
                                      ),
                                    ),
                                    const SizedBox(width: 17,),
                                    const Text(
                                      'Invoice Language',
                                      style: TextStyle(
                                          fontFamily: 'Montserrat',
                                          fontWeight: FontWeight.w600,
                                          color: grey_1,
                                          fontSize: 14
                                      ),
                                    ),
                                  ],
                                ),

                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Obx(() {
                                      return Text(
                                        AppSingletons.languageName?.value ??
                                            'English',
                                        style: const TextStyle(
                                          color: grey_1,
                                          fontSize: 12,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      );
                                    }),
                                    Container(
                                      padding: const EdgeInsets.only(right: 10),
                                      child: const Icon(
                                        Icons.keyboard_arrow_right_outlined,
                                        color: grey_1,
                                      ),
                                    )
                                  ],
                                ),

                              ],
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        GestureDetector(
                          onTap: () {
                            Get.toNamed(Routes.pdfTemplateSelect);
                          },
                          child: CustomContainer(
                            childContainer: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      height: 60,
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10),
                                      decoration: const BoxDecoration(
                                          borderRadius: BorderRadius.only(
                                              bottomLeft: Radius.circular(8),
                                              topLeft: Radius.circular(8)),
                                          color: mainPurpleColor
                                      ),
                                      child: const Icon(
                                        Icons.account_balance_wallet,
                                        color: sWhite,
                                      ),
                                    ),
                                    const SizedBox(width: 17),
                                    const Text(
                                      'Templates',
                                      style: TextStyle(
                                          fontFamily: 'Montserrat',
                                          fontWeight: FontWeight.w600,
                                          color: grey_1,
                                          fontSize: 14),
                                    ),
                                  ],
                                ),
                                Container(
                                  padding: const EdgeInsets.only(right: 10),
                                  child: const Icon(
                                    Icons.keyboard_arrow_right_outlined,
                                    color: grey_1,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        GestureDetector(
                          onTap: () {
                            Get.toNamed(Routes.businessListView);
                            AppSingletons().isComingFromBottomBar = false;
                          },
                          child: CustomContainer(
                            childContainer: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Obx(() {
                                      return Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 10),
                                        height: AppSingletons.businessNameINV!
                                            .value
                                            .isNotEmpty
                                            ? 80
                                            : 60,
                                        decoration: const BoxDecoration(
                                            borderRadius: BorderRadius.only(
                                                topLeft: Radius.circular(8),
                                                bottomLeft: Radius.circular(8)),
                                            color: mainPurpleColor
                                        ),
                                        child: const Icon(
                                          Icons.perm_contact_cal_outlined,
                                          color: sWhite,
                                        ),
                                      );
                                    }),
                                    const SizedBox(width: 17,),
                                    Column(
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment: CrossAxisAlignment
                                          .start,
                                      children: [
                                        const SizedBox(height: 10,),
                                        const Text(
                                          'From',
                                          style: TextStyle(
                                              fontFamily: 'Montserrat',
                                              fontWeight: FontWeight.w600,
                                              color: grey_1,
                                              fontSize: 14),
                                        ),
                                        Obx(() {
                                          return Visibility(
                                            visible: AppSingletons
                                                .businessNameINV
                                                ?.value
                                                .isNotEmpty ??
                                                false,
                                            child: Text(
                                              AppSingletons.businessNameINV
                                                  ?.value ??
                                                  '',
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.w500,
                                                  fontFamily: 'Montserrat',
                                                  color: grey_4,
                                                  fontSize: 14),
                                            ),
                                          );
                                        }),
                                        Obx(() {
                                          return Visibility(
                                            visible:
                                            AppSingletons.businessEmailINV
                                                ?.value
                                                .isNotEmpty ?? false,
                                            child: Text(
                                              AppSingletons.businessEmailINV
                                                  ?.value ??
                                                  '',
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.w500,
                                                  fontFamily: 'Montserrat',
                                                  color: grey_4,
                                                  fontSize: 14),
                                            ),
                                          );
                                        }),
                                        const SizedBox(height: 10,),
                                      ],
                                    ),
                                  ],
                                ),
                                Container(
                                  padding: const EdgeInsets.only(right: 10),
                                  child: const Icon(
                                    Icons.keyboard_arrow_right_outlined,
                                    color: grey_1,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 10,),
                        GestureDetector(
                          onTap: () {
                            Get.toNamed(Routes.clientDataView);
                            AppSingletons().isComingFromBottomBar = false;
                          },
                          child: CustomContainer(
                            childContainer: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Obx(() {
                                      return Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 10),
                                        height: AppSingletons.clientNameINV!
                                            .value
                                            .isNotEmpty
                                            ? 80
                                            : 60,
                                        decoration: const BoxDecoration(
                                            borderRadius: BorderRadius.only(
                                                topLeft: Radius.circular(8),
                                                bottomLeft: Radius.circular(8)),
                                            color: mainPurpleColor
                                        ),
                                        child: const Icon(
                                          Icons.arrow_circle_right_outlined,
                                          color: sWhite,
                                        ),
                                      );
                                    }),
                                    const SizedBox(width: 17,),
                                    Column(
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment: CrossAxisAlignment
                                          .start,
                                      children: [
                                        const SizedBox(height: 10,),
                                        const Text(
                                          'Bill To',
                                          style: TextStyle(
                                              fontFamily: 'Montserrat',
                                              fontWeight: FontWeight.w600,
                                              color: grey_1,
                                              fontSize: 14),
                                        ),
                                        Obx(() {
                                          return Visibility(
                                            visible: AppSingletons
                                                .clientNameINV!
                                                .value
                                                .isNotEmpty,
                                            child: Text(
                                              AppSingletons.clientNameINV
                                                  ?.value ?? '',
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.w500,
                                                  color: greyColor,
                                                  fontSize: 14),
                                            ),
                                          );
                                        }),
                                        Obx(() {
                                          return Visibility(
                                            visible: AppSingletons
                                                .clientEmailINV!
                                                .value
                                                .isNotEmpty,
                                            child: Text(
                                              AppSingletons.clientEmailINV
                                                  ?.value ?? '',
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.w500,
                                                  color: greyColor,
                                                  fontSize: 14),
                                            ),
                                          );
                                        }),
                                        const SizedBox(height: 10,),
                                      ],
                                    ),
                                  ],
                                ),
                                Container(
                                  padding: const EdgeInsets.only(right: 10),
                                  child: const Icon(
                                    Icons.keyboard_arrow_right_outlined,
                                    color: grey_1,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 10,),
                        Container(
                          width: double.infinity,
                          margin: const EdgeInsets.symmetric(horizontal: 10),
                          decoration: BoxDecoration(
                            color: offWhite,
                            borderRadius: BorderRadius.circular(8),
                            boxShadow: const [
                              BoxShadow(
                                  color: shadowColor,
                                  blurRadius: 5,
                                  offset: Offset(3, 3)),
                            ],
                          ),
                          child: Column(
                            children: [
                              // Container(
                              //   decoration: const BoxDecoration(
                              //     borderRadius: BorderRadius.only(
                              //       topLeft: Radius.circular(8),
                              //       topRight: Radius.circular(8)
                              //     ),
                              //     color: mainPurpleColor
                              //   ),
                              //   child: ListTile(
                              //     contentPadding: const EdgeInsets.symmetric(
                              //         horizontal: 10, vertical: 0),
                              //     leading: const Icon(
                              //       Icons.account_tree_outlined,
                              //       color: sWhite,
                              //     ),
                              //     title: GestureDetector(
                              //       child: const Text(
                              //         'Items',
                              //         style: TextStyle(
                              //             fontFamily: 'Montserrat',
                              //             fontWeight: FontWeight.w600,
                              //             color: sWhite,
                              //             fontSize: 14),
                              //       ),
                              //     ),
                              //   ),
                              // ),

                              GestureDetector(
                                onTap: () {
                                  Get.toNamed(Routes.itemsView);
                                  AppSingletons().isComingFromBottomBar = false;
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: offWhite,
                                    borderRadius: BorderRadius.circular(8),
                                    boxShadow: const [
                                      BoxShadow(
                                          color: shadowColor,
                                          blurRadius: 5,
                                          offset: Offset(3, 3)
                                      ),
                                    ],
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment
                                        .spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          Container(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 10),
                                            height: 60,
                                            decoration: const BoxDecoration(
                                                borderRadius: BorderRadius.only(
                                                    topLeft: Radius.circular(8),
                                                    bottomLeft: Radius.circular(
                                                        8)),
                                                color: mainPurpleColor
                                            ),
                                            child: const Icon(
                                              Icons.account_tree_outlined,
                                              color: sWhite,
                                            ),
                                          ),
                                          const SizedBox(width: 17,),
                                          const Text(
                                            'Add Items',
                                            style: TextStyle(
                                                fontFamily: 'Montserrat',
                                                fontWeight: FontWeight.w600,
                                                color: grey_1,
                                                fontSize: 14),
                                          ),
                                        ],
                                      ),
                                      Container(
                                        padding: const EdgeInsets.only(
                                            right: 10),
                                        child: const Icon(
                                          Icons.keyboard_arrow_right_outlined,
                                          color: grey_1,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),

                              const SizedBox(height: 5,),

                              Obx(() =>
                              controller.isLoading.value
                                  ? const Center(
                                child: CupertinoActivityIndicator(
                                  color: orangeDark_3,
                                  radius: 10,
                                ),
                              )
                                  : ListView.builder(
                                itemCount: controller.selectedItemNames.length,
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemBuilder: (context, index) {
                                  final itemName = controller
                                      .selectedItemNames[index];
                                  final itemPrice = controller
                                      .selectedItemPrice[index];
                                  final itemUnit = controller
                                      .selectedItemUnitName[index];
                                  final itemQuantity = controller
                                      .selectedItemQuantity[index];
                                  final itemDiscount = controller
                                      .selectedItemDiscount[index];
                                  final itemTaxRate = controller
                                      .selectedItemTaxRate[index];
                                  final itemDescription = controller
                                      .selectedItemDescription[index];
                                  final itemAmount = controller
                                      .selectedItemAmount[index];

                                  return GestureDetector(
                                    onTap: () {
                                      AppSingletons().isComingFromBottomBar =
                                      false;
                                      Get.toNamed(
                                          Routes.addEditItemView, arguments: {
                                        'indexId': index,
                                        'itemName': itemName.toString(),
                                        'itemPrice': itemPrice.toString(),
                                        'itemUnit': itemUnit.toString(),
                                        'itemQuantity': itemQuantity.toString(),
                                        'itemDiscount': itemDiscount.toString(),
                                        'itemTaxRate': itemTaxRate.toString(),
                                        'itemDescription': itemDescription
                                            .toString(),
                                      });

                                      AppSingletons.isEditingItemDataFromInvoice
                                          .value = true;

                                      debugPrint('${AppSingletons
                                          .isEditingItemDataFromInvoice
                                          .value}');

                                      debugPrint('IndexId: $index');
                                      debugPrint('ItemUnit: $itemUnit');
                                      debugPrint('itemQuantity: $itemQuantity');
                                      debugPrint('itemDiscount: $itemDiscount');
                                      debugPrint('itemTaxRate: $itemTaxRate');
                                      debugPrint(
                                          'itemDescription: $itemDescription');
                                    },
                                    child: Container(
                                      margin: const EdgeInsets.symmetric(
                                          horizontal: 9, vertical: 5),
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 15, vertical: 5),
                                      decoration: BoxDecoration(
                                          color: lightShadePurple,
                                          borderRadius: BorderRadius.circular(5)
                                      ),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment
                                            .spaceBetween,
                                        children: [
                                          Column(
                                            mainAxisSize: MainAxisSize.min,
                                            mainAxisAlignment: MainAxisAlignment
                                                .start,
                                            crossAxisAlignment: CrossAxisAlignment
                                                .start,
                                            children: [
                                              Text(itemName,
                                                style: const TextStyle(
                                                    fontSize: 14,
                                                    fontFamily: 'Montserrat',
                                                    fontWeight: FontWeight.w700,
                                                    color: grey_1
                                                ),
                                              ),
                                              Obx(() {
                                                return Text(
                                                  '(${AppSingletons
                                                      .currencyNameINV
                                                      ?.value ??
                                                      'Rs'}$itemPrice X $itemQuantity)',
                                                  style: const TextStyle(
                                                      fontSize: 14,
                                                      fontFamily: 'Montserrat',
                                                      fontWeight: FontWeight
                                                          .w500,
                                                      color: grey_1
                                                  ),
                                                );
                                              }),

                                              Visibility(
                                                visible: itemDiscount != null,
                                                child: Text(
                                                  'Discount (- $itemDiscount%)',
                                                  style: const TextStyle(
                                                      fontSize: 14,
                                                      fontFamily: 'Montserrat',
                                                      fontWeight: FontWeight
                                                          .w500,
                                                      color: grey_1
                                                  ),
                                                ),
                                              ),

                                              Visibility(
                                                visible: itemTaxRate != null,
                                                child: Text(
                                                  'Tax (+ $itemTaxRate%)',
                                                  style: const TextStyle(
                                                      fontSize: 14,
                                                      fontFamily: 'Montserrat',
                                                      fontWeight: FontWeight
                                                          .w500,
                                                      color: grey_1
                                                  ),
                                                ),
                                              ),

                                            ],
                                          ),
                                          Column(
                                            crossAxisAlignment: CrossAxisAlignment
                                                .end,
                                            children: [
                                              Row(
                                                children: [
                                                  Obx(() {
                                                    return Text(
                                                      AppSingletons
                                                          .currencyNameINV
                                                          ?.value ?? 'Rs',
                                                      style: const TextStyle(
                                                          fontSize: 15,
                                                          fontFamily: 'Montserrat',
                                                          fontWeight: FontWeight
                                                              .w700,
                                                          color: grey_2
                                                      ),
                                                    );
                                                  }),
                                                  const SizedBox(width: 2,),
                                                  Text(itemAmount.toString(),
                                                    style: const TextStyle(
                                                        fontSize: 15,
                                                        fontFamily: 'Montserrat',
                                                        fontWeight: FontWeight
                                                            .w700,
                                                        color: grey_2
                                                    ),
                                                  ),
                                                ],
                                              ),

                                              const SizedBox(height: 8,),

                                              Row(
                                                children: [
                                                  GestureDetector(onTap: () {
                                                    controller
                                                        .subtractItemQuantity(
                                                        index);
                                                  },
                                                      child: Container(
                                                          decoration: BoxDecoration(
                                                              color: mainPurpleColor,
                                                              borderRadius: BorderRadius
                                                                  .circular(3)
                                                          ),
                                                          padding: const EdgeInsets
                                                              .symmetric(
                                                              vertical: 3,
                                                              horizontal: 12),
                                                          child: const Text(
                                                            '-',
                                                            style: TextStyle(
                                                                fontSize: 18,
                                                                fontFamily: 'Montserrat',
                                                                fontWeight: FontWeight
                                                                    .w700,
                                                                color: sWhite
                                                            ),)
                                                      )),

                                                  const SizedBox(width: 8,),

                                                  Text(itemQuantity.toString(),
                                                    style: const TextStyle(
                                                      fontSize: 17,
                                                      fontFamily: 'Montserrat',
                                                      fontWeight: FontWeight
                                                          .w700,
                                                      color: grey_2,
                                                    ),
                                                  ),

                                                  const SizedBox(width: 8,),

                                                  GestureDetector(
                                                    onTap: () {
                                                      controller
                                                          .addItemQuantity(
                                                          index);
                                                    },
                                                    child: Container(
                                                        decoration: BoxDecoration(
                                                            color: mainPurpleColor,
                                                            borderRadius: BorderRadius
                                                                .circular(3)
                                                        ),
                                                        padding: const EdgeInsets
                                                            .symmetric(
                                                            vertical: 3,
                                                            horizontal: 10),
                                                        child: const Text(
                                                          '+', style: TextStyle(
                                                            fontSize: 18,
                                                            fontFamily: 'Montserrat',
                                                            fontWeight: FontWeight
                                                                .w600,
                                                            color: sWhite
                                                        ),)),)
                                                ],
                                              )
                                            ],
                                          ),
                                        ],
                                      ),
                                      // ListTile(
                                      //   onTap: () {
                                      //     AppSingletons().isComingFromBottomBar = false;
                                      //     Get.toNamed(Routes.addEditItemView, arguments: {
                                      //       'indexId': index,
                                      //       'itemName': itemName.toString(),
                                      //       'itemPrice': itemPrice.toString(),
                                      //       'itemUnit': itemUnit.toString(),
                                      //       'itemQuantity': itemQuantity.toString(),
                                      //       'itemDiscount': itemDiscount.toString(),
                                      //       'itemTaxRate': itemTaxRate.toString(),
                                      //       'itemDescription': itemDescription.toString(),
                                      //     });
                                      //
                                      //     AppSingletons.isEditingItemDataFromInvoice
                                      //         .value = true;
                                      //
                                      //     debugPrint('${AppSingletons
                                      //         .isEditingItemDataFromInvoice.value}');
                                      //
                                      //     debugPrint('IndexId: $index');
                                      //     debugPrint('ItemUnit: $itemUnit');
                                      //     debugPrint('itemQuantity: $itemQuantity');
                                      //     debugPrint('itemDiscount: $itemDiscount');
                                      //     debugPrint('itemTaxRate: $itemTaxRate');
                                      //     debugPrint('itemDescription: $itemDescription');
                                      //   },
                                      //   leading: Column(
                                      //     mainAxisSize: MainAxisSize.min,
                                      //     mainAxisAlignment: MainAxisAlignment.start,
                                      //     crossAxisAlignment: CrossAxisAlignment.start,
                                      //     children: [
                                      //       Text(itemName,
                                      //         style: const TextStyle(
                                      //             fontSize: 14,
                                      //             fontFamily: 'Montserrat',
                                      //             fontWeight: FontWeight.w700,
                                      //             color: grey_1
                                      //         ),
                                      //       ),
                                      //       Text('($itemPrice X $itemQuantity)',
                                      //         style: const TextStyle(
                                      //             fontSize: 14,
                                      //             fontFamily: 'Montserrat',
                                      //             fontWeight: FontWeight.w500,
                                      //             color: grey_1
                                      //         ),
                                      //       ),
                                      //
                                      //       Visibility(
                                      //         visible: itemDiscount != null,
                                      //         child: Text('Discount (- $itemDiscount%)',
                                      //           style: const TextStyle(
                                      //               fontSize: 14,
                                      //               fontFamily: 'Montserrat',
                                      //               fontWeight: FontWeight.w500,
                                      //               color: grey_1
                                      //           ),
                                      //         ),
                                      //       ),
                                      //
                                      //       Visibility(
                                      //         visible: itemTaxRate != null,
                                      //         child: Text('Tax (+ $itemTaxRate%)',
                                      //           style: const TextStyle(
                                      //               fontSize: 14,
                                      //               fontFamily: 'Montserrat',
                                      //               fontWeight: FontWeight.w500,
                                      //               color: grey_1
                                      //           ),
                                      //         ),
                                      //       ),
                                      //
                                      //     ],
                                      //   ),
                                      //   // title: Text(itemName,
                                      //   //   style: const TextStyle(
                                      //   //       fontSize: 14,
                                      //   //       fontFamily: 'Montserrat',
                                      //   //       fontWeight: FontWeight.w600,
                                      //   //       color: grey_1
                                      //   //   ),
                                      //   // ),
                                      //   trailing: Text(itemAmount.toString(),
                                      //     style: const TextStyle(
                                      //         fontSize: 12,
                                      //         fontFamily: 'Montserrat',
                                      //         fontWeight: FontWeight.w500,
                                      //         color: grey_2
                                      //     ),
                                      //   ),
                                      // ),
                                    ),
                                  );
                                },
                              )),
                              const SizedBox(height: 10,),
                              InkWell(
                                onTap: () {
                                  // Get.offAndToNamed(Routes.itemsView);
                                  Get.toNamed(Routes.itemsView);

                                  AppSingletons().isComingFromBottomBar = false;
                                },
                                child: Container(
                                  margin: const EdgeInsets.symmetric(
                                      horizontal: 9),
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                      color: lightShadePurple,
                                      borderRadius: BorderRadius.circular(5)),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Container(
                                        margin: const EdgeInsets.all(8),
                                        height: 20,
                                        width: 20,
                                        alignment: Alignment.center,
                                        decoration: const BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: mainPurpleColor),
                                        child: const Icon(
                                          Icons.add,
                                          color: sWhite,
                                          size: 13,
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      const Text(
                                        'Add Items',
                                        style: TextStyle(
                                          fontFamily: 'Montserrat',
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Container(
                                margin: const EdgeInsets.symmetric(
                                    horizontal: 9),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 10),
                                width: double.infinity,
                                decoration: BoxDecoration(
                                    color: lightShadePurple,
                                    borderRadius: BorderRadius.circular(5)),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment
                                      .spaceBetween,
                                  children: [
                                    const Text(
                                      'SubTotal',
                                      style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          color: grey_1,
                                          fontFamily: 'Montserrat',
                                          fontSize: 13
                                      ),
                                    ),
                                    Obx(() {
                                      return Row(
                                        children: [
                                          Text(
                                            '${ AppSingletons.currencyNameINV
                                                ?.value}',
                                            style: const TextStyle(
                                              color: grey_1,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                          Text(
                                            '${ AppSingletons.subTotal?.value
                                                .toStringAsFixed(
                                                0)}',
                                            style: const TextStyle(
                                              color: grey_1,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ],
                                      );
                                    })
                                  ],
                                ),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              ListTile(
                                onTap: () {
                                  addDiscountInTotal();
                                },
                                leading: const Icon(
                                  Icons.percent,
                                  color: grey_1,
                                ),
                                title: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'Discount',
                                      style: TextStyle(
                                          fontFamily: 'Montserrat',
                                          fontWeight: FontWeight.w600,
                                          color: grey_1,
                                          fontSize: 14),
                                    ),
                                    Obx(() {
                                      return Visibility(
                                        visible: AppSingletons
                                            .discountPercentage!
                                            .value !=
                                            '',
                                        child: Text(
                                          '(${AppSingletons.discountPercentage
                                              ?.value ??
                                              'N/A'}%)',
                                          style: const TextStyle(),
                                        ),
                                      );
                                    })
                                  ],
                                ),
                                trailing: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Obx(() {
                                      return Visibility(
                                        visible: AppSingletons.discountAmount
                                            .value
                                            .isNotEmpty ||
                                            AppSingletons.discountAmount
                                                .value !=
                                                '0',
                                        child: Text(
                                          '-${AppSingletons.discountAmount
                                              .value}',
                                          style: const TextStyle(
                                              fontWeight: FontWeight.w500,
                                              fontSize: 16,
                                              color: grey_1),
                                        ),
                                      );
                                    }),
                                    const SizedBox(
                                      width: 5,
                                    ),
                                    const Icon(
                                      Icons.keyboard_arrow_right_outlined,
                                      color: grey_1,
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              ListTile(
                                onTap: () {
                                  addTaxInTotal();
                                },
                                leading: const Icon(
                                  Icons.cut,
                                  color: grey_1,
                                ),
                                title: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'Tax',
                                      style: TextStyle(
                                          fontFamily: 'Montserrat',
                                          fontWeight: FontWeight.w600,
                                          color: grey_1,
                                          fontSize: 14),
                                    ),
                                    Obx(() {
                                      return Visibility(
                                        visible: AppSingletons.taxPercentage!
                                            .value !=
                                            '',
                                        child: Text(
                                          '(${AppSingletons.taxPercentage
                                              ?.value ??
                                              'N/A'}%)',
                                          style: const TextStyle(),
                                        ),
                                      );
                                    })
                                  ],
                                ),
                                trailing: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Obx(() {
                                      return Visibility(
                                        visible: AppSingletons.taxAmount.value
                                            .isNotEmpty ||
                                            AppSingletons.taxAmount.value !=
                                                '0',
                                        child: Text(
                                          '+${AppSingletons.taxAmount.value}',
                                          style: const TextStyle(
                                              fontWeight: FontWeight.w500,
                                              fontSize: 16,
                                              color: grey_1),
                                        ),
                                      );
                                    }),
                                    const SizedBox(
                                      width: 5,
                                    ),
                                    const Icon(
                                      Icons.keyboard_arrow_right_outlined,
                                      color: grey_1,
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              ListTile(
                                onTap: () {
                                  addShippingCostinTotal();
                                },
                                leading: const Icon(
                                  Icons.local_shipping_outlined,
                                  color: grey_1,
                                ),
                                title: const Column(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Shipping',
                                      style: TextStyle(
                                          fontFamily: 'Montserrat',
                                          fontWeight: FontWeight.w600,
                                          color: grey_1,
                                          fontSize: 14),
                                    ),
                                  ],
                                ),
                                trailing: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Obx(() {
                                      return Text(
                                        '+${AppSingletons.shippingCost.value}',
                                        style: const TextStyle(
                                            fontWeight: FontWeight.w500,
                                            fontSize: 16,
                                            color: grey_1),
                                      );
                                    }),
                                    const SizedBox(
                                      width: 5,
                                    ),
                                    const Icon(
                                      Icons.keyboard_arrow_right_outlined,
                                      color: grey_1,
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Container(
                                width: double.infinity,
                                decoration: const BoxDecoration(
                                    color: mainPurpleColor,
                                    borderRadius: BorderRadius.only(
                                        bottomLeft: Radius.circular(5),
                                        bottomRight: Radius.circular(5))),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 10),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment
                                      .spaceBetween,
                                  children: [
                                    const Text(
                                      'Total',
                                      style: TextStyle(
                                          fontFamily: 'Montserrat',
                                          color: sWhite,
                                          fontWeight: FontWeight.w600,
                                          fontSize: 13
                                      ),
                                    ),
                                    Obx(() {
                                      return Row(
                                        children: [
                                          Text(
                                            '${AppSingletons.currencyNameINV
                                                ?.value}',
                                            style: const TextStyle(
                                              color: sWhite,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                          Text(
                                            '${AppSingletons.finalPriceTotal
                                                ?.value
                                                .toStringAsFixed(0)}',
                                            style: const TextStyle(
                                              color: sWhite,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ],
                                      );
                                    })
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        GestureDetector(
                          onTap: () {
                            showCurrencyPicker(
                              context: context,
                              showFlag: false,
                              showCurrencyName: true,
                              showCurrencyCode: true,
                              onSelect: (Currency currency) {
                                controller.selectCurrency(currency);
                                debugPrint(
                                    'Selected currency: ${currency.name}');
                              },
                            );
                          },

                          child: CustomContainer(
                            childContainer: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Container(
                                      height: 60,
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10),
                                      decoration: const BoxDecoration(
                                          color: mainPurpleColor,
                                          borderRadius: BorderRadius.only(
                                            bottomLeft: Radius.circular(8),
                                            topLeft: Radius.circular(8),
                                          )
                                      ),
                                      child: const Icon(
                                        Icons.money,
                                        color: sWhite,
                                      ),
                                    ),
                                    const SizedBox(width: 17,),
                                    const Text(
                                      'Currency',
                                      style: TextStyle(
                                          fontFamily: 'Montserrat',
                                          fontWeight: FontWeight.w600,
                                          color: grey_1,
                                          fontSize: 14),
                                    ),
                                  ],
                                ),

                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Obx(() {
                                      return Text(
                                        AppSingletons.currencyNameINV?.value ??
                                            '',
                                        style: const TextStyle(
                                          color: grey_1,
                                          fontSize: 13,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      );
                                    }),
                                    const Icon(
                                      Icons.keyboard_arrow_right_outlined,
                                      color: grey_1,
                                    ),
                                    const SizedBox(width: 10,),
                                  ],
                                ),
                              ],
                            ),
                          ),

                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        GestureDetector(
                          onTap: () {
                            Get.toNamed(Routes.signatureView);
                            AppSingletons().isComingFromBottomBar = false;
                          },

                          child: CustomContainer(
                            childContainer: Row(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Container(
                                      height: 60,
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10),
                                      decoration: const BoxDecoration(
                                          borderRadius: BorderRadius.only(
                                              topLeft: Radius.circular(8),
                                              bottomLeft: Radius.circular(8)
                                          ),
                                          color: mainPurpleColor
                                      ),
                                      child: const Icon(
                                        Icons.mode_edit_outline_outlined,
                                        color: sWhite,
                                      ),
                                    ),
                                    const SizedBox(width: 17,),
                                    const Text(
                                      'Signature',
                                      style: TextStyle(
                                          fontFamily: 'Montserrat',
                                          fontWeight: FontWeight.w600,
                                          color: grey_1,
                                          fontSize: 14),
                                    ),
                                  ],
                                ),

                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Obx(() =>
                                    AppSingletons.signatureImgINV!.value.isEmpty
                                        ? const SizedBox.shrink()
                                        : Image.memory(
                                      AppSingletons.signatureImgINV?.value ??
                                          Uint8List(0),
                                      width: 30,
                                      height: 30,
                                      color: orangeDark_3,
                                      fit: BoxFit.fill,
                                    )),
                                    const Icon(
                                      Icons.keyboard_arrow_right_outlined,
                                      color: grey_1,
                                    ),

                                    const SizedBox(width: 10,)

                                  ],
                                ),

                              ],
                            ),
                          ),

                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        GestureDetector(
                          onTap: () {
                            Get.toNamed(Routes.termsAndConditionView);
                            AppSingletons().isComingFromBottomBar = false;
                          },
                          child: CustomContainer(
                            childContainer: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Expanded(
                                  child: Row(
                                    children: [
                                      Obx(() {
                                        return Container(
                                          height: AppSingletons
                                              .termAndConditionINV!
                                              .value.isNotEmpty ? 80 : 60,
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 10),
                                          decoration: const BoxDecoration(
                                              color: mainPurpleColor,
                                              borderRadius: BorderRadius.only(
                                                  bottomLeft: Radius.circular(
                                                      8),
                                                  topLeft: Radius.circular(8)
                                              )
                                          ),
                                          child: const Icon(
                                            Icons.event_note_sharp,
                                            color: sWhite,
                                          ),
                                        );
                                      }),
                                      const SizedBox(width: 17,),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment
                                              .start,
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            const Text(
                                              'Terms & Condition',
                                              style: TextStyle(
                                                  fontFamily: 'Montserrat',
                                                  fontWeight: FontWeight.w600,
                                                  color: grey_1,
                                                  fontSize: 14),
                                            ),
                                            Obx(() {
                                              return Visibility(
                                                visible: AppSingletons
                                                    .termAndConditionINV!.value
                                                    .isNotEmpty,
                                                child: Text(
                                                  AppSingletons
                                                      .termAndConditionINV
                                                      ?.value ?? '',
                                                  maxLines: 2,
                                                  style: const TextStyle(
                                                      fontWeight: FontWeight
                                                          .w500,
                                                      color: grey_4,
                                                      fontSize: 13),
                                                ),
                                              );
                                            }),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10),
                                  child: const Icon(
                                    Icons.keyboard_arrow_right_outlined,
                                    color: grey_1,
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        GestureDetector(
                          onTap: () {
                            Get.toNamed(Routes.paymentView);
                            AppSingletons().isComingFromBottomBar = false;
                          },
                          child: CustomContainer(
                            childContainer: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Expanded(
                                  child: Row(
                                    children: [
                                      Obx(() {
                                        return Container(
                                          height: AppSingletons
                                              .paymentMethodINV!
                                              .value
                                              .isNotEmpty ? 80 : 60,
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 10),
                                          decoration: const BoxDecoration(
                                              color: mainPurpleColor,
                                              borderRadius: BorderRadius.only(
                                                  bottomLeft: Radius.circular(
                                                      8),
                                                  topLeft: Radius.circular(8)
                                              )
                                          ),
                                          child: const Icon(
                                            Icons.payment_outlined,
                                            color: sWhite,
                                          ),
                                        );
                                      }),
                                      const SizedBox(width: 17,),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment
                                              .start,
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            const Text(
                                              'Payment Method',
                                              style: TextStyle(
                                                  fontFamily: 'Montserrat',
                                                  fontWeight: FontWeight.w600,
                                                  color: grey_1,
                                                  fontSize: 14),
                                            ),
                                            Obx(() {
                                              return Visibility(
                                                visible: AppSingletons
                                                    .paymentMethodINV!
                                                    .value.isNotEmpty,
                                                child: Text(
                                                  AppSingletons.paymentMethodINV
                                                      ?.value ?? '',
                                                  maxLines: 2,
                                                  style: const TextStyle(
                                                      fontWeight: FontWeight
                                                          .w500,
                                                      color: grey_4,
                                                      fontSize: 13),
                                                ),
                                              );
                                            }),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10),
                                  child: const Icon(
                                    Icons.keyboard_arrow_right_outlined,
                                    color: grey_1,
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 90,
                        ),
                      ],
                    ),
                  );
                }),
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: Container(
                      decoration: BoxDecoration(
                          color: mainPurpleColor,
                          borderRadius: BorderRadius.circular(10)
                      ),
                      child: Row(
                        children: [
                          Expanded(
                              flex: 1,
                              child: GestureDetector(
                                onTap: () async {
                                  int templateId = 0;
                                  debugPrint('Singleton temp ID: ${AppSingletons
                                      .invoiceTemplateIdINV.value}');
                                  if (AppSingletons.invoiceTemplateIdINV.value
                                      .isNotEmpty) {
                                    templateId = int.parse(
                                        AppSingletons.invoiceTemplateIdINV
                                            .value);
                                  }
                                  AppSingletons.isPreviewingPdfBeforeSave
                                      .value = true;
                                  AppSingletons.isPreviewEstimateDoc.value =
                                  false;
                                  debugPrint(
                                      'isItPreviewBeforeSaving: ${AppSingletons
                                          .isPreviewingPdfBeforeSave.value}');
                                  debugPrint('Temp ID: $templateId');
                                  Get.toNamed(Routes.pdfPreviewPages);
                                },
                                child: Container(
                                  height: 50,
                                  alignment: Alignment.center,
                                  margin: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 10),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(
                                          color: sWhite, width: 1)),
                                  child: const Text(
                                    'Preview',
                                    style: TextStyle(
                                        color: sWhite,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              )),
                          Expanded(
                            flex: 2,
                            child: InkWell(
                              onTap: () async {
                                if (AppSingletons.isEditInvoice.value) {
                                  await controller.editInvoiceData();
                                } else {
                                  await controller.saveDataInInvoice();

                                }
                              },
                              child: Container(
                                height: 50,
                                alignment: Alignment.center,
                                margin: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 10),
                                constraints: const BoxConstraints(
                                    minHeight: 50),
                                decoration: BoxDecoration(
                                    color: sWhite,
                                    borderRadius: BorderRadius.circular(10)),
                                child: const Text(
                                  'Save',
                                  style: TextStyle(
                                      color: mainPurpleColor,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                          )
                        ],
                      )),)
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future editDataAndInvoiceNumber(BuildContext context,bool isMobileScreen) async {
    return await showGeneralDialog(
        context: context,
        barrierLabel:
        MaterialLocalizations
            .of(context)
            .modalBarrierDismissLabel,
        pageBuilder: (BuildContext buildContext, Animation animation,
            Animation secondaryAnimation) {
          return isMobileScreen
              ? Scaffold(
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
                  'invoice_info'.tr,
                  style: const TextStyle(
                      fontFamily: 'SFProDisplay',
                      color: sWhite,
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 1.5),
                ),
                actions: [
                  IconButton(
                      onPressed: () async {
                        if (controller.invoiceNumberController.text.isEmpty) {
                          Utils().snackBarMsg(
                              'invoice_number'.tr, 'must_be_entered'.tr);
                        } else {
                          await controller.onSave();
                        }
                      },
                      icon: Image.asset(
                        'assets/icons/check.png',
                        color: sWhite,
                        height: 20,
                        width: 20,
                      ))
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
                          const SizedBox(
                            height: 20,
                          ),
                           Row(
                            children: [
                              Text(
                                'invoice_number'.tr,
                                style: const TextStyle(
                                    fontFamily: 'Montserrat',
                                    fontWeight: FontWeight.w600,
                                    color: orangeDark_3),
                              ),
                              const SizedBox(
                                width: 5,
                              ),
                              const Text(
                                '*',
                                style: TextStyle(
                                    fontFamily: 'Montserrat', color: starColor),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          CommonTextField(
                            textEditingController: controller
                                .invoiceNumberController,
                            hintText: 'enter_number'.tr,
                            maxLines: 1,
                            maxLength: 10,
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                           Row(
                            children: [
                              Text(
                                'creation_date'.tr,
                                style: const TextStyle(
                                    fontFamily: 'Montserrat',
                                    fontWeight: FontWeight.w600,
                                    color: orangeDark_3),
                              ),
                              const SizedBox(
                                width: 5,
                              ),
                              const Text(
                                '*',
                                style: TextStyle(
                                    fontFamily: 'Montserrat', color: starColor),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          InkWell(
                            onTap: () {
                              _creationDateAndTime(context);
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 5),
                              height: 50,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                  color: textFieldColor,
                                  borderRadius: BorderRadius.circular(10)),
                              child: Obx(() {
                                return Row(
                                  mainAxisAlignment: MainAxisAlignment
                                      .spaceBetween,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      DateFormat('dd-MM-yyyy')
                                          .format(
                                          AppSingletons.creationDate.value)
                                          .toString(),
                                      style: const TextStyle(
                                        color: orangeDark_3,
                                      ),
                                    ),
                                    const Icon(
                                      Icons.calendar_today,
                                      color: orangeDark_3,
                                    ),
                                  ],
                                );
                              }),
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Text(
                            'due_terms'.tr,
                            style: const TextStyle(
                                fontFamily: 'Montserrat',
                                fontWeight: FontWeight.w600,
                                color: orangeDark_3),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: textFieldColor,
                            ),
                            child: Obx(() =>
                                Container(
                                  padding:
                                  const EdgeInsets.symmetric(horizontal: 20.0),
                                  child: DropdownButtonFormField<int>(
                                    style: const TextStyle(
                                        color: orangeDark_3,
                                        fontWeight: FontWeight.w600),
                                    dropdownColor: blueLightOne,
                                    decoration: const InputDecoration(
                                      border: OutlineInputBorder(
                                          borderSide: BorderSide.none),
                                      enabledBorder: UnderlineInputBorder(
                                          borderSide: BorderSide.none),
                                      focusedBorder: UnderlineInputBorder(
                                          borderSide: BorderSide.none),
                                    ),
                                    isExpanded: true,
                                    value: controller.dueTermValue.value,
                                    menuMaxHeight: 300,
                                    iconEnabledColor: orangeDark_3,
                                    items: [
                                      ...List.generate(31, (index) => index + 1)
                                          .map((value) {
                                        return DropdownMenuItem<int>(
                                          value: value,
                                          child: Text(
                                            '$value ${'days'.tr}',
                                            style: const TextStyle(
                                                fontWeight: FontWeight.w500),
                                          ),
                                        );
                                      }).toList(),
                                    ],
                                    onChanged: (value) {
                                      controller.dueTermValue.value = value!;

                                      // AppSingletons.dueDate.value =
                                      //     DateTime.parse(
                                      //         DateTime
                                      //             .now()
                                      //             .add(Duration(
                                      //             days: controller.dueTermValue
                                      //                 .value))
                                      //             .obs
                                      //             .toString());

                                      AppSingletons.dueDate.value = DateTime.parse(
                                          AppSingletons.creationDate.value
                                              .add(Duration(days: controller.dueTermValue.value)).obs
                                              .toString());

                                      debugPrint(
                                          'Value: ${controller.dueTermValue
                                              .value}');
                                    },
                                  ),
                                )),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                           Text(
                            'due_date'.tr,
                            style: const TextStyle(
                                fontFamily: 'Montserrat',
                                fontWeight: FontWeight.w600,
                                color: orangeDark_3),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          InkWell(
                            onTap: () {
                              _dueDateAndTime(context);
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 5),
                              height: 50,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                  color: textFieldColor,
                                  borderRadius: BorderRadius.circular(10)),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment
                                    .spaceBetween,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Obx(() {
                                    return Text(
                                      DateFormat('dd-MM-yyyy')
                                          .format(AppSingletons.dueDate.value)
                                          .toString(),
                                      style: const TextStyle(
                                        color: orangeDark_3,
                                      ),
                                    );
                                  }),
                                  const Icon(
                                    Icons.calendar_today,
                                    color: orangeDark_3,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          const Text(
                            'P.O.#',
                            style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontFamily: 'Montserrat',
                                color: orangeDark_3),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          CommonTextField(
                            textEditingController: controller.poController,
                            hintText: '',
                            maxLength: 40,
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                           Text(
                            'invoice_title_name'.tr,
                            style: const TextStyle(
                                fontFamily: 'Montserrat',
                                fontWeight: FontWeight.w600,
                                color: orangeDark_3),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          CommonTextField(
                            textEditingController: controller
                                .titleNameController,
                            hintText: '',
                            maxLength: 40,
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                        ],
                      ),
                    ),
                  )),
          ) :
          Scaffold(
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
                  'invoice_info'.tr,
                  style: const TextStyle(
                      fontFamily: 'SFProDisplay',
                      color: sWhite,
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 1.5),
                ),
                actions: [
                  IconButton(
                      onPressed: () async {
                        if (controller.invoiceNumberController.text.isEmpty) {
                          Utils().snackBarMsg(
                              'invoice_number'.tr, 'must_be_entered'.tr);
                        } else {
                          await controller.onSave();
                        }
                      },
                      icon: Image.asset(
                        'assets/icons/check.png',
                        color: sWhite,
                        height: 20,
                        width: 20,
                      ))
                ],
              ),
              body: SingleChildScrollView(
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      vertical: 20,
                      horizontal: MediaQuery
                          .of(context)
                          .size
                          .width * 0.2,
                    ),
                    decoration: const BoxDecoration(
                        image: DecorationImage(
                            image: AssetImage(
                                'assets/images/invoice_entrance_back.jpg'
                            ),
                            fit: BoxFit.fill
                        )
                    ),
                    child: CustomContainer(
                      horizontalPadding: 10,
                      verticalPadding: 10,
                      childContainer: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(
                            height: 20,
                          ),
                          Row(
                            children: [
                              Text(
                                'invoice_number'.tr,
                                style: const TextStyle(
                                    fontFamily: 'Montserrat',
                                    fontWeight: FontWeight.w600,
                                    color: orangeDark_3),
                              ),
                              const SizedBox(
                                width: 5,
                              ),
                              const Text(
                                '*',
                                style: TextStyle(
                                    fontFamily: 'Montserrat', color: starColor),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          CommonTextField(
                            textEditingController: controller.invoiceNumberController,
                            hintText: 'enter_number'.tr,
                            maxLines: 1,
                            maxLength: 10,
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                           Row(
                            children: [
                              Text(
                                'creation_date'.tr,
                                style: const TextStyle(
                                    fontFamily: 'Montserrat',
                                    fontWeight: FontWeight.w600,
                                    color: orangeDark_3),
                              ),
                              const SizedBox(
                                width: 5,
                              ),
                              const Text(
                                '*',
                                style: TextStyle(
                                    fontFamily: 'Montserrat', color: starColor),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          InkWell(
                            onTap: () {
                              _creationDateAndTime(context);
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 5),
                              height: 50,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                  color: textFieldColor,
                                  borderRadius: BorderRadius.circular(10)),
                              child: Obx(() {
                                return Row(
                                  mainAxisAlignment: MainAxisAlignment
                                      .spaceBetween,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      DateFormat('dd-MM-yyyy')
                                          .format(
                                          AppSingletons.creationDate.value)
                                          .toString(),
                                      style: const TextStyle(
                                        color: orangeDark_3,
                                      ),
                                    ),
                                    const Icon(
                                      Icons.calendar_today,
                                      color: orangeDark_3,
                                    ),
                                  ],
                                );
                              }),
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Text(
                            'due_terms'.tr,
                            style: const TextStyle(
                                fontFamily: 'Montserrat',
                                fontWeight: FontWeight.w600,
                                color: orangeDark_3),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: textFieldColor,
                            ),
                            child: Obx(() =>
                                Container(
                                  padding:
                                  const EdgeInsets.symmetric(horizontal: 20.0),
                                  child: DropdownButtonFormField<int>(
                                    style: const TextStyle(
                                        color: orangeDark_3,
                                        fontWeight: FontWeight.w600),
                                    dropdownColor: blueLightOne,
                                    decoration: const InputDecoration(
                                      border: OutlineInputBorder(
                                          borderSide: BorderSide.none),
                                      enabledBorder: UnderlineInputBorder(
                                          borderSide: BorderSide.none),
                                      focusedBorder: UnderlineInputBorder(
                                          borderSide: BorderSide.none),
                                    ),
                                    isExpanded: true,
                                    value: controller.dueTermValue.value,
                                    menuMaxHeight: 300,
                                    iconEnabledColor: orangeDark_3,
                                    items: [
                                      ...List.generate(31, (index) => index + 1)
                                          .map((value) {
                                        return DropdownMenuItem<int>(
                                          value: value,
                                          child: Text(
                                            '$value ${'days'.tr}',
                                            style: const TextStyle(
                                                fontWeight: FontWeight.w500),
                                          ),
                                        );
                                      }).toList(),
                                    ],
                                    onChanged: (value) {
                                      controller.dueTermValue.value = value!;

                                      // AppSingletons.dueDate.value =
                                      //     DateTime.parse(
                                      //         DateTime
                                      //             .now()
                                      //             .add(Duration(
                                      //             days: controller.dueTermValue
                                      //                 .value))
                                      //             .obs
                                      //             .toString());

                                      AppSingletons.dueDate.value = DateTime.parse(
                                          AppSingletons.creationDate.value
                                              .add(Duration(days: controller.dueTermValue.value)).obs
                                              .toString());

                                      debugPrint(
                                          'Value: ${controller.dueTermValue
                                              .value}');
                                    },
                                  ),
                                )),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Text(
                            'due_date'.tr,
                            style: const TextStyle(
                                fontFamily: 'Montserrat',
                                fontWeight: FontWeight.w600,
                                color: orangeDark_3),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          InkWell(
                            onTap: () {
                              _dueDateAndTime(context);
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 5),
                              height: 50,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                  color: textFieldColor,
                                  borderRadius: BorderRadius.circular(10)),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment
                                    .spaceBetween,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Obx(() {
                                    return Text(
                                      DateFormat('dd-MM-yyyy')
                                          .format(AppSingletons.dueDate.value)
                                          .toString(),
                                      style: const TextStyle(
                                        color: orangeDark_3,
                                      ),
                                    );
                                  }),
                                  const Icon(
                                    Icons.calendar_today,
                                    color: orangeDark_3,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          const Text(
                            'P.O.#',
                            style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontFamily: 'Montserrat',
                                color: orangeDark_3),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          CommonTextField(
                            textEditingController: controller.poController,
                            hintText: '',
                            maxLength: 40,
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                           Text(
                            'invoice_title_name'.tr,
                            style: const TextStyle(
                                fontFamily: 'Montserrat',
                                fontWeight: FontWeight.w600,
                                color: orangeDark_3),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          CommonTextField(
                            textEditingController: controller
                                .titleNameController,
                            hintText: '',
                            maxLength: 40,
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                        ],
                      ),
                    ),
                  ))
          );
        });
  }

  Future<void> _creationDateAndTime(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
        keyboardType: TextInputType.datetime,
        context: context,
        initialDate: AppSingletons.creationDate.value,
        firstDate: DateTime(2000),
        lastDate: DateTime(2101),
        builder: (context, child) {
          return Theme(
              data: Theme.of(context).copyWith(
                  colorScheme: ColorScheme.fromSeed(
                    primary: orangeDark_3,
                    onPrimary: sWhite,
                    seedColor: mainPurpleColor,
                  ),
                  textButtonTheme: TextButtonThemeData(
                      style: TextButton.styleFrom(
                          foregroundColor: orangeDark_3,
                          textStyle: const TextStyle(
                              fontFamily: 'Montserrat',
                              color: orangeDark_3,
                              fontWeight: FontWeight.w600)))),
              child: child!);
        });

    if (pickedDate != null) {
      controller.startDate(pickedDate);
    }
  }

  Future<void> _dueDateAndTime(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
        context: context,
        initialDate: AppSingletons.dueDate.value,
        firstDate: DateTime(2000),
        lastDate: DateTime(2101),
        builder: (context, child) {
          return Theme(
              data: Theme.of(context).copyWith(
                  colorScheme: ColorScheme.fromSeed(
                    primary: orangeDark_3,
                    onPrimary: sWhite,
                    seedColor: mainPurpleColor,
                  ),
                  textButtonTheme: TextButtonThemeData(
                      style: TextButton.styleFrom(
                          foregroundColor: orangeDark_3,
                          textStyle: const TextStyle(
                              fontFamily: 'Montserrat',
                              color: orangeDark_3,
                              fontWeight: FontWeight.w600)))),
              child: child!);
        });

    if (pickedDate != null) {
      controller.endDate(pickedDate);
    }
  }

  Future selectInvoiceLanguage(bool isMobileScreen) async {
    var selectedLocale = const Locale('en', 'US').obs;
    var selectedName = '';
    return Get.dialog(
        AlertDialog(
          backgroundColor: offWhite_2,
          shape: const Border.symmetric(),
          title: Container(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
            decoration: BoxDecoration(
                color: mainPurpleColor,
                borderRadius: BorderRadius.circular(5)
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                GestureDetector(
                  onTap: () {
                    Get.back();
                  },
                  child: const Icon(
                    Icons.arrow_back,
                    color: orangeLight_1,
                    size: 20,
                  ),
                ),
                const SizedBox(
                  width: 20,
                ),
                 Text(
                  'invoice_languages'.tr,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: orangeLight_1,
                    fontWeight: FontWeight.w800,
                    fontFamily: 'Montserrat',
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          content: SizedBox(
            width: isMobileScreen
                ? double.maxFinite : MediaQuery
                .of(Get.context!)
                .size
                .width * 0.3,
            child: ListView.separated(
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  return InkWell(
                    onTap: () async {
                      selectedLocale.value = controller.locale[index]['locale'];
                      selectedName = controller.locale[index]['name'];

                      debugPrint(selectedLocale.value.toString());
                      AppSingletons.languageName?.value = selectedName;
                      AppSingletons.selectedLocale_2?.value =
                      controller.locale[index]['locale'];

                      AppSingletons.invDefaultLanguageName?.value =
                          selectedName;

                      Get.back();
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 5),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            controller.locale[index]['name'],
                            textAlign: TextAlign.left,
                            style: const TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 13,
                                fontFamily: 'Montserrat',
                                color: grey_1
                            ),
                          ),
                          Obx(() {
                            return Visibility(
                                visible: AppSingletons.selectedLocale_2
                                    ?.value ==
                                    controller.locale[index]['locale'],
                                child: const Icon(
                                  Icons.check, color: mainPurpleColor,));
                          }),
                        ],
                      ),
                    ),
                  );
                },
                separatorBuilder: (context, index) {
                  return const SizedBox(height: 10,);
                },
                itemCount: controller.locale.length),
          ),
        ));
  }

  Future addDiscountInTotal() async {
    return Get.dialog(
        AlertDialog(
          backgroundColor: sWhite,
          title:  Text(
            'discount'.tr,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: mainPurpleColor,
              fontWeight: FontWeight.w700,
              fontFamily: 'Montserrat',
              fontSize: 14,
            ),
          ),

          content: SizedBox(
            height: 110,
            child: Column(
              children: [
                Obx(() {
                  return Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            controller.discountHeading.value = 'Discount %';
                            controller.discPercentageFocusNode.requestFocus();
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: controller.discountHeading.value ==
                                  'Discount %'
                                  ? mainPurpleColor : sWhite,
                              borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(10),
                                  bottomLeft: Radius.circular(10)
                              ),
                            ),
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            alignment: Alignment.center,
                            child: Text('percentage'.tr,
                              style: TextStyle(
                                  color: controller.discountHeading.value ==
                                      'Discount %'
                                      ? sWhite : blackColor,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 15
                              ),
                            ),

                          ),
                        ),
                      ),
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            controller.discountHeading.value =
                            'Discount flat amount';
                            controller.discFlatAmountFocusNode.requestFocus();
                          },
                          child: Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            decoration: BoxDecoration(
                              color: controller.discountHeading.value ==
                                  'Discount %'
                                  ? sWhite : mainPurpleColor,
                              borderRadius: const BorderRadius.only(
                                  topRight: Radius.circular(10),
                                  bottomRight: Radius.circular(10)
                              ),
                            ),

                            alignment: Alignment.center,
                            child: Text('flat_amount'.tr,
                              style: TextStyle(
                                  color: controller.discountHeading.value ==
                                      'Discount %'
                                      ? blackColor : sWhite,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 15
                              ),
                            ),

                          ),
                        ),
                      ),
                    ],
                  );
                }),
                const SizedBox(height: 15,),
                Obx(() {
                  return controller.discountHeading.value == 'Discount %'
                      ? CommonTextField(
                    textInputAction: TextInputAction.done,
                    textInputType: TextInputType.number,
                    textEditingController: controller.discountInTotalControl,
                    focusNode: controller.discPercentageFocusNode,
                    maxLines: 1,
                    hintText: '0%',
                    inputFormatter: [
                      FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
                      PercentageInputFormatter(),
                    ],
                    autoFocus: true,
                  )
                      : CommonTextField(
                    textInputAction: TextInputAction.done,
                    textInputType: TextInputType.number,
                    focusNode: controller.discFlatAmountFocusNode,
                    maxLines: 1,
                    hintText: 'enter_amount'.tr,
                    textEditingController: controller.discFlatAmountController,
                  );
                }),
              ],
            ),
          ),
          actions: [
            TextButton(
                onPressed: () {
                  Get.back();
                },
                child: Text(
                  'cancel'.tr,
                  style: const TextStyle(
                      fontFamily: 'Montserrat',
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: grey_1),
                )),
            TextButton(
                onPressed: () async {
                  if (controller.discountHeading.value == 'Discount %') {
                    if (controller.discountInTotalControl.text.isNotEmpty) {
                      AppSingletons.discountPercentage?.value =
                          controller.discountInTotalControl.text;

                      await controller.minusDiscountAmount();

                      Get.back();
                    } else {
                      Utils().snackBarMsg('empty'.tr, '${'discount'.tr} ${'amount'.tr}');
                    }
                  } else {
                    if (controller.discFlatAmountController.text.isNotEmpty) {
                      AppSingletons.discountAmount.value =
                          controller.discFlatAmountController.text;

                      AppSingletons.discountPercentage?.value = '';

                      await controller.minusDiscountAmount();

                      Get.back();
                    } else {
                      Utils().snackBarMsg('empty'.tr, '${'discount'.tr} ${'amount'.tr}');
                    }
                  }
                },
                child: Text(
                  'add'.tr,
                  style: const TextStyle(
                      fontFamily: 'Montserrat',
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: mainPurpleColor),
                )),
          ],
        ));
  }

  Future addTaxInTotal() async {
    return Get.dialog(AlertDialog(
      backgroundColor: sWhite,
      title: Text(
        'tax'.tr,
        textAlign: TextAlign.center,
        style: const TextStyle(
          color: mainPurpleColor,
          fontFamily: 'Montserrat',
          fontWeight: FontWeight.w600,
          fontSize: 14,
        ),
      ),
      content: SizedBox(
        height: 110,
        child: Column(
          children: [
            Obx(() {
              return Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        controller.taxRateHeading.value = 'Tax %';
                        controller.taxPercentageFocusNode.requestFocus();
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: controller.taxRateHeading.value == 'Tax %'
                              ? mainPurpleColor : sWhite,
                          borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(10),
                              bottomLeft: Radius.circular(10)
                          ),
                        ),
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        alignment: Alignment.center,
                        child: Text('percentage'.tr,
                          style: TextStyle(
                              color: controller.taxRateHeading.value == 'Tax %'
                                  ? sWhite : blackColor,
                              fontWeight: FontWeight.w600,
                              fontSize: 15
                          ),
                        ),

                      ),
                    ),
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        controller.taxRateHeading.value = 'Tax flat amount';
                        controller.taxFlatAmountFocusNode.requestFocus();
                      },
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        decoration: BoxDecoration(
                          color: controller.taxRateHeading.value == 'Tax %'
                              ? sWhite : mainPurpleColor,
                          borderRadius: const BorderRadius.only(
                              topRight: Radius.circular(10),
                              bottomRight: Radius.circular(10)
                          ),
                        ),

                        alignment: Alignment.center,
                        child: Text('flat_amount'.tr,
                          style: TextStyle(
                              color: controller.taxRateHeading.value == 'Tax %'
                                  ? blackColor : sWhite,
                              fontWeight: FontWeight.w600,
                              fontSize: 15
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              );
            }),
            const SizedBox(height: 15,),
            Obx(() {
              return controller.taxRateHeading.value == 'Tax %'
                  ? CommonTextField(
                textInputAction: TextInputAction.done,
                textInputType: TextInputType.number,
                maxLines: 1,
                focusNode: controller.taxPercentageFocusNode,
                hintText: '0%',
                textEditingController: controller.taxInTotalControl,
                inputFormatter: [
                  FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
                  PercentageInputFormatter(),
                ],
                autoFocus: true,
              )
                  : CommonTextField(
                textInputAction: TextInputAction.done,
                textInputType: TextInputType.number,
                focusNode: controller.taxFlatAmountFocusNode,
                maxLines: 1,
                hintText: 'enter_amount'.tr,
                textEditingController: controller.taxFlatAmountController,
              );
            }),
          ],
        ),
      ),
      actions: [
        TextButton(
            onPressed: () {
              Get.back();
            },
            child: Text(
              'cancel'.tr,
              style: const TextStyle(
                  fontFamily: 'Montserrat',
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: grey_1),
            )),
        TextButton(
            onPressed: () async {
              if (controller.taxRateHeading.value == 'Tax %') {
                if (controller.taxInTotalControl.text.isNotEmpty) {
                  AppSingletons.taxPercentage?.value =
                      controller.taxInTotalControl.text;
                  await controller.addTaxInAmount();
                  Get.back();
                } else {
                  Utils().snackBarMsg('empty'.tr, '${'tax'.tr} ${'amount'.tr}');
                }
              } else {
                if (controller.taxFlatAmountController.text.isNotEmpty) {
                  AppSingletons.taxAmount.value =
                      controller.taxFlatAmountController.text;
                  AppSingletons.taxPercentage?.value = '';
                  await controller.addTaxInAmount();
                  Get.back();
                } else {
                  Utils().snackBarMsg('empty'.tr, '${'tax'.tr} ${'amount'.tr}');
                }
              }
            },
            child: Text(
              'add'.tr,
              style: const TextStyle(
                  fontFamily: 'Montserrat',
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: mainPurpleColor),
            )),
      ],
    ));
  }

  Future addShippingCostinTotal() async {
    return Get.dialog(AlertDialog(
      backgroundColor: sWhite,
      title: Text(
        'shipping'.tr,
        textAlign: TextAlign.center,
        style: const TextStyle(
          color: mainPurpleColor,
          fontWeight: FontWeight.w700,
          fontFamily: 'Montserrat',
          fontSize: 16,
        ),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
           Text(
            'shipping_amount'.tr,
            style: const TextStyle(
                fontFamily: 'Montserrat',
                fontWeight: FontWeight.w700, fontSize: 13),
          ),
          const SizedBox(
            height: 10,
          ),
          CommonTextField(
            textInputAction: TextInputAction.done,
            textInputType: TextInputType.number,
            maxLines: 1,
            hintText: '0',
            inputFormatter: [AmountInputFormatter()],
            textEditingController: controller.shippingCostControl,
            autoFocus: true,
          ),
        ],
      ),
      actions: [
        TextButton(
            onPressed: () {
              Get.back();
            },
            child: Text(
              'cancel'.tr,
              style: const TextStyle(
                  fontFamily: 'Montserrat',
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: grey_1),
            )),
        TextButton(
            onPressed: () async {
              if (controller.shippingCostControl.text.isNotEmpty) {
                AppSingletons.shippingCost.value =
                    controller.shippingCostControl.text;

                await controller.addShippingCostInAmount();

                Get.back();
              } else {
                Utils().snackBarMsg('empty'.tr, '${'shipping'.tr} ${'amount'.tr}');
              }
            },
            child: Text(
              'add'.tr,
              style: const TextStyle(
                  fontFamily: 'Montserrat',
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: mainPurpleColor),
            )),
      ],
    ));
  }

  Future leaveInvoiceAlert() async {
    return Get.dialog(AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15)
      ),
      backgroundColor: sWhite,
      title: Text(
        'alert'.tr,
        textAlign: TextAlign.center,
        style: const TextStyle(
          color: mainPurpleColor,
          fontWeight: FontWeight.w700,
          fontFamily: 'Montserrat',
          fontSize: 16,
        ),
      ),
      content:  Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'are_you_sure_you_want_to_leave_all_of_your_recent_activity_will_be_discarded'.tr,
            textAlign: TextAlign.center,
            style: const TextStyle(
                fontFamily: 'Montserrat',
                fontWeight: FontWeight.w500, fontSize: 14),
          ),
        ],
      ),
      actions: [
        Row(
          children: [
            Expanded(
              child: InkWell(
                  onTap: () {
                    Get.back();
                  },
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    decoration: const BoxDecoration(
                        color: grey_4,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(08),
                          bottomLeft: Radius.circular(08),
                        )
                    ),
                    child: Text(
                      'cancel'.tr,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontFamily: 'Montserrat',
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: sWhite,),
                    ),
                  )),
            ),
            Expanded(
              child: InkWell(
                  onTap: () {
                    Utils.clearInvoiceVariables();

                    Get.back();

                    Get.offNamedUntil(Routes.bottomNavBar, (route) => false);

                    debugPrint('Call Back Clicked');
                  },
                  child: Container(
                    width: double.infinity,
                    decoration: const BoxDecoration(
                        color: mainPurpleColor,
                        borderRadius: BorderRadius.only(
                          bottomRight: Radius.circular(08),
                          topRight: Radius.circular(08),
                        )
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Text(
                      textAlign: TextAlign.center,
                      'leave'.tr,
                      style: const TextStyle(
                          fontFamily: 'Montserrat',
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: orangeLight_1),
                    ),
                  )),
            ),
          ],
        ),
      ],
    ));
  }
}
