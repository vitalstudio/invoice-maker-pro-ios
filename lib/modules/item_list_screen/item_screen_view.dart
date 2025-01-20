import 'dart:async';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import '../../core/constants/app_constants/App_Constants.dart';
import '../../core/routes/routes.dart';
import '../../core/app_singletons/app_singletons.dart';
import '../../core/constants/color/color.dart';
import '../../core/widgets/dialogueToDelete.dart';
import 'item_screen_controller.dart';

class ItemScreenView extends GetView<ItemScreenController> {
  const ItemScreenView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put<ItemScreenController>(ItemScreenController());

    bool checkIsMobileLayout = AppConstants.isMobileScreen.value;

    return checkIsMobileLayout
        ? mainMobileLayout()
        : mainDesktopLayout(context);
  }

  Widget mainMobileLayout() {
    return Scaffold(
      backgroundColor: orangeLight_1,
      appBar: AppSingletons().isComingFromBottomBar
          ? null
          : AppBar(
        backgroundColor: mainPurpleColor,
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: const Icon(
            Icons.arrow_back,
            color: sWhite,
            size: 20,
          ),
        ),
        title: const Text(
          'Items Info',
          style: TextStyle(
              fontFamily: 'Montserrat',
              color: sWhite,
              fontWeight: FontWeight.w600,
              fontSize: 16),
        ),
        actions: [
          Obx(() {
            return IconButton(onPressed: () {
              if (AppSingletons.isSearchingItem.value) {
                AppSingletons.isSearchingItem.value = false;
              } else if (AppSingletons.isSearchingItem.value == false) {
                AppSingletons.isSearchingItem.value = true;
              }
            }, icon: Icon(
              AppSingletons.isSearchingItem.value ? Icons.cancel : Icons.search,
              color: sWhite,)
            );
          }),

        ],
      ),
      body: WillPopScope(
        onWillPop: () async {
          if (AppSingletons().isComingFromBottomBar == false) {
            print('Navigating to invoiceInputView');
            // Get.offNamed(Routes.invoiceInputView);
            Get.back();
          }

          AppSingletons.isStartDeletingItem.value = false;
          return true;
        },
        child: Obx(() =>
            Column(
              children: [
                Visibility(
                  visible: AppSingletons.isSearchingItem.value,
                  child: Focus(
                    onFocusChange: (value) {
                      controller.updateKeyboardVisibility(value);
                    },
                    child: Container(
                      margin: const EdgeInsets.all(15),
                      child: TextField(
                        controller: controller.searchItemController,
                        autofocus: true,
                        decoration: InputDecoration(
                            contentPadding: const EdgeInsets.all(10),
                            hintText: 'Search Item',
                            prefixIcon: const Icon(Icons.search),
                            border: OutlineInputBorder(
                                borderSide: BorderSide.none,
                                borderRadius: BorderRadius.circular(15)),
                            fillColor: textFieldColor,
                            filled: true),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: controller.isLoadingData.value
                      ? const Center(
                      child: CupertinoActivityIndicator(
                        color: mainPurpleColor,
                        radius: 20,
                        animating: true,
                      ))
                      : controller.filteredItemList.isEmpty
                      ? Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Image.asset(
                        'assets/icons/empty_box.png',
                        height: 120,
                        width: 120,
                        color: mainPurpleColor.withOpacity(0.7),
                      ),
                      const Center(
                        child: Text(
                          'Tap + to add Items',
                          style: TextStyle(
                              fontFamily: 'Montserrat',
                              color: grey_1,
                              fontSize: 16,
                              fontWeight: FontWeight.w600),
                        ),
                      ),
                    ],
                  )
                      : ListView.builder(
                      itemCount: controller.filteredItemList.length,
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        int reverse = controller.filteredItemList.length - 1 -
                            index;
                        final note = controller.filteredItemList[reverse];

                        note.itemPrice ??= '';

                        return Container(
                          margin: const EdgeInsets.symmetric(
                              horizontal: 15, vertical: 6),
                          decoration: BoxDecoration(
                              color: sWhite,
                              borderRadius: BorderRadius.circular(8),
                              boxShadow: const [
                                BoxShadow(
                                    color: shadowColor,
                                    spreadRadius: 1,
                                    blurRadius: 5,
                                    offset: Offset(2, 2)),
                              ]),
                          child: ListTile(
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 5),
                            onTap: () {
                              // AppSingletons().isEditingItemInfo = true;
                              // AppSingletons.isEditingItemDataFromInvoice
                              //     .value = false;
                              // Get.offNamed(Routes.addEditItemView,
                              //     arguments: {
                              //       'indexId': note.id,
                              //       'itemName':
                              //           note.itemName.toString(),
                              //       'itemPrice':
                              //           note.itemPrice.toString(),
                              //       'unitToMeasure':
                              //           note.unitToMeasure.toString(),
                              //       'itemDetail':
                              //           note.itemDetail.toString(),
                              //       'itemQuantity':
                              //           note.itemQuantity.toString(),
                              //       'discount':
                              //           note.discount.toString(),
                              //       'taxRate': note.tax.toString(),
                              //     });

                              if (!AppSingletons().isComingFromBottomBar) {
                                AppSingletons().isEditingItemInfo = false;

                                AppSingletons.isAddingItemInINVEST = true;

                                AppSingletons.isAddNewItemInINVEST = false;

                                AppSingletons.isSearchingItem.value = false;

                                Get.toNamed(Routes.addEditItemView,
                                    arguments: {
                                      'indexId': note.id,
                                      'itemName': note.itemName.toString(),
                                      'itemPrice': note.itemPrice.toString(),
                                      'unitToMeasure': note.unitToMeasure.toString(),
                                      'itemDetail': note.itemDetail.toString(),
                                    });
                                // controller.addingItemsInInvoice(
                                //     note.itemName.toString(),
                                //     note.itemFinalAmount.toString(),
                                //     note.itemDiscount.toString(),
                                //     note.itemPrice.toString(),
                                //     note.itemQuantity.toString(),
                                //     note.itemTaxRate.toString(),
                                //     note.unitToMeasure.toString(),
                                //     note.itemDetail.toString());
                              }
                              else {
                                AppSingletons.isEditingItemDataFromInvoice
                                    .value = false;

                                AppSingletons().isEditingItemInfo = true;

                                AppSingletons.isSearchingItem.value = false;

                                Get.toNamed(Routes.addEditItemView,
                                    arguments: {
                                      'indexId': note.id,
                                      'itemName': note.itemName.toString(),
                                      'itemPrice': note.itemPrice.toString(),
                                      'unitToMeasure': note.unitToMeasure.toString(),
                                      'itemDetail': note.itemDetail.toString(),
                                      // 'itemQuantity': note.itemQuantity.toString(),
                                      // 'itemDiscount': note.itemDiscount.toString(),
                                      // 'itemTaxRate': note.itemTaxRate.toString(),
                                      // 'itemFinalAmount': note.itemFinalAmount.toString()
                                    });
                              }
                            },
                            title: Text(
                              note.itemName.toString(),
                              style: const TextStyle(
                                  fontFamily: 'Montserrat',
                                  color: grey_1,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16),
                            ),
                            trailing: Obx(() {
                              return AppSingletons.isStartDeletingItem.value
                                  ? Obx(() {
                                return Checkbox(
                                  value: note.isChecked.value ?? false,
                                  activeColor: blackColor,
                                  onChanged: (bool? value) {
                                    if (value !=
                                        null) { // Ensure value is not null
                                      note.isChecked.value = value;
                                      print(
                                          'isChecked: ${note.isChecked.value}');
                                    } else {
                                      print(
                                          'Received null value'); // This shouldn't happen normally
                                    }
                                  },
                                );
                              }) :
                              Container(
                                width: 150,
                                alignment: Alignment.centerRight,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Expanded(
                                      child: Container(
                                        alignment: Alignment.centerRight,
                                        margin: const EdgeInsets.symmetric(
                                            vertical: 5),
                                        child: Text(
                                          note.itemPrice.toString(),
                                          style: const TextStyle(
                                              fontFamily: 'Montserrat',
                                              fontWeight: FontWeight.w500,
                                              fontSize: 14),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 5,),
                                    Visibility(
                                      visible: AppSingletons()
                                          .isComingFromBottomBar,
                                      child: PopupMenuButton(
                                        color: sWhite,
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 5),
                                        shape: const Border.symmetric(),
                                        itemBuilder: (context) =>
                                        [
                                          PopupMenuItem(
                                            value: 0,
                                            onTap: () {
                                              CustomDialogues
                                                  .showDialogueToDelete(
                                                  false,
                                                  'Delete Item',
                                                  'Are you sure you want to delete ${note
                                                      .itemName}?',
                                                      () =>
                                                      controller
                                                          .deleteItem(note.id!),
                                                      () =>
                                                      controller.loadData());
                                            },
                                            child: const Row(
                                              mainAxisAlignment:
                                              MainAxisAlignment
                                                  .spaceBetween,
                                              children: [
                                                Text(
                                                  'Delete',
                                                  style: TextStyle(
                                                      color: grey_1,
                                                      fontWeight:
                                                      FontWeight.w500,
                                                      fontSize: 16),
                                                ),
                                                Icon(
                                                  Icons.delete,
                                                  color: grey_1,
                                                  size: 16,
                                                )
                                              ],
                                            ),
                                          ),
                                          PopupMenuItem(
                                            value: 1,
                                            onTap: () {
                                              AppSingletons()
                                                  .isEditingItemInfo = true;

                                              AppSingletons
                                                  .isEditingItemDataFromInvoice
                                                  .value = false;
                                              AppSingletons.isSearchingItem
                                                  .value = false;
                                              Get.toNamed(
                                                  Routes.addEditItemView,
                                                  arguments: {
                                                    'indexId': note.id,
                                                    'itemName': note.itemName
                                                        .toString(),
                                                    'itemPrice': note.itemPrice
                                                        .toString(),
                                                    'unitToMeasure': note
                                                        .unitToMeasure
                                                        .toString(),
                                                    'itemDetail': note
                                                        .itemDetail.toString(),
                                                    // 'itemQuantity': note.itemQuantity.toString(),
                                                    // 'itemDiscount': note.itemDiscount.toString(),
                                                    // 'itemTaxRate': note.itemTaxRate.toString(),
                                                    // 'itemFinalAmount': note.itemFinalAmount.toString(),
                                                  });
                                            },
                                            child: const Row(
                                              mainAxisAlignment:
                                              MainAxisAlignment
                                                  .spaceBetween,
                                              children: [
                                                Text(
                                                  'Edit',
                                                  style: TextStyle(
                                                      fontFamily: 'Montserrat',
                                                      color: grey_1,
                                                      fontWeight:
                                                      FontWeight.w500,
                                                      fontSize: 16),
                                                ),
                                                Icon(
                                                  Icons.edit,
                                                  color: grey_1,
                                                  size: 16,
                                                )
                                              ],
                                            ),
                                          ),
                                        ],
                                        icon: const Icon(
                                          Icons.more_vert,
                                          color: grey_1,
                                          size: 20,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }),
                          ),
                        );
                      }),
                ),
              ],
            )),
      ),
      floatingActionButton: Visibility(
        visible: true,
        child: Obx(() {
          return Visibility(
            visible: !AppSingletons.isKeyboardVisible.value,
            child: FloatingActionButton(
              onPressed: () {
                AppSingletons().isEditingItemInfo = false;
                AppSingletons.isEditingItemDataFromInvoice.value = false;

                if (AppSingletons().isComingFromBottomBar) {
                  AppSingletons.isAddNewItemInINVEST = false;
                } else {
                  AppSingletons.isAddNewItemInINVEST = true;
                }

                Get.toNamed(Routes.addEditItemView);
                AppSingletons.isSearchingItem.value = false;
              },
              backgroundColor: mainPurpleColor,
              shape: const CircleBorder(),
              child: const Icon(
                Icons.add,
                color: sWhite,
              ),
            ),
          );
        }),
      ),
      bottomNavigationBar: Visibility(
        visible: !AppSingletons().isComingFromBottomBar,
        child: Obx(() {
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
      ),
    );
  }

  Widget mainDesktopLayout(BuildContext context) {
    return Scaffold(
        backgroundColor: mainPurpleColor,
        appBar: AppBar(
          backgroundColor: mainPurpleColor,
          title: const Text(
            'ITEMS',
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontFamily: 'Montserrat',
                color: sWhite,
                fontSize: 16),
          ),
          leading: Visibility(
            visible: !AppSingletons().isComingFromBottomBar,
            child: IconButton(
              icon: const Icon(
                Icons.arrow_back,
                color: sWhite,
              ),
              onPressed: () {
                Get.back();
              },
            ),
          ),
          actions: [
            Obx(() =>
                Visibility(
                  visible: AppSingletons.isStartDeletingItem.value ==
                      false &&
                      AppSingletons().isComingFromBottomBar,
                  child: IconButton(
                      onPressed: () {
                        AppSingletons.isStartDeletingItem.value = true;
                      },
                      icon: const Icon(Icons.delete, color: sWhite,)),
                )),

            Obx(() =>
                Visibility(
                  visible: AppSingletons.isStartDeletingItem.value ==
                      true &&
                      AppSingletons().isComingFromBottomBar,
                  child: IconButton(
                      onPressed: () {
                        AppSingletons.isStartDeletingItem.value = false;
                      },
                      icon: const Icon(
                        Icons.cancel_rounded, color: sWhite,)),
                )),

            Obx(() =>
                Visibility(
                  visible: AppSingletons.isStartDeletingItem.value ==
                      true &&
                      AppSingletons().isComingFromBottomBar,
                  child: IconButton(
                      onPressed: () {
                        if (AppSingletons.isSelectedAll.value) {
                          controller.deSelectAllItems();
                        } else {
                          controller.selectAllItems();
                        }
                      },
                      icon: Icon(
                        AppSingletons.isSelectedAll.value
                            ? Icons.deselect : Icons.select_all,
                        color: sWhite,)),
                )),

            Obx(() =>
                Visibility(
                  visible: AppSingletons.isStartDeletingItem.value ==
                      true &&
                      AppSingletons().isComingFromBottomBar,
                  child: IconButton(
                      onPressed: () {

                        CustomDialogues.showDialogueToDelete(
                            false,
                            'Delete Items',
                            'Are you sure you want to delete selected Items?',
                                () => {
                              controller.itemDbHelper!.deleteCheckedItems(
                                  Get.find<ItemScreenController>()
                                      .filteredItemList
                              )
                            },
                                () => {
                              Timer(const Duration(seconds: 2), () {
                                controller.loadData();
                              })
                            });

                        // controller.itemDbHelper!.deleteCheckedItems(
                        //     controller.filteredItemList
                        // );
                        //
                        // Timer(const Duration(seconds: 2), () {
                        //   controller.loadData();
                        // });
                      },
                      icon: const Icon(
                        Icons.delete_sweep, color: sWhite,)),
                )),

            Obx(() {
              return Visibility(
                visible: AppSingletons.isStartDeletingItem.value ==
                    false &&
                    AppSingletons().isComingFromBottomBar,
                child: IconButton(
                    onPressed: () {
                      Get.toNamed(Routes.proScreenView);
                    },
                    icon: Image.asset(
                      'assets/icons/vip_icon.png', height: 35, width: 35,)
                ),
              );
            })
          ],
        ),
        body: Container(
          height: double.infinity,
          width: double.infinity,
          decoration: AppSingletons().isComingFromBottomBar
              ? const BoxDecoration(
              color: orangeLight_1
          ) : const BoxDecoration(
              image: DecorationImage(
                  image: AssetImage('assets/images/item_screen_back.jpg'),
                  fit: BoxFit.fill)),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const SizedBox(
                height: 15,
              ),
              Expanded(
                child: Center(
                  child: Container(
                    width: !AppSingletons().isComingFromBottomBar
                        ? MediaQuery
                        .of(context)
                        .size
                        .width * 0.5
                        : double.infinity,
                    alignment: Alignment.topCenter,
                    decoration: !AppSingletons().isComingFromBottomBar
                        ? BoxDecoration(
                        color: sWhite,
                        borderRadius: BorderRadius.circular(15))
                        : const BoxDecoration(),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Expanded(
                              flex: 5,
                              child: Focus(
                                onFocusChange: (value) {
                                  controller.updateKeyboardVisibility(value);
                                },
                                child: Container(
                                  width: double.infinity,
                                  margin: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 10),
                                  child: TextField(
                                    controller: controller.searchItemController,
                                    autofocus: true,
                                    decoration: InputDecoration(
                                        contentPadding:
                                        const EdgeInsets.all(10),
                                        hintText: 'Search Items',
                                        prefixIcon: const Icon(Icons.search),
                                        border: OutlineInputBorder(
                                            borderSide: BorderSide.none,
                                            borderRadius:
                                            BorderRadius.circular(15)),
                                        fillColor: textFieldColor,
                                        filled: true),
                                  ),
                                ),
                              ),
                            ),
                            Visibility(
                              visible: AppSingletons().isComingFromBottomBar,
                              child: Expanded(
                                flex: 2,
                                child: GestureDetector(
                                  onTap: () {
                                      AppSingletons().isEditingItemInfo = false;
                                      AppSingletons.isEditingItemDataFromInvoice.value = false;

                                      if (AppSingletons().isComingFromBottomBar) {
                                        AppSingletons.isAddNewItemInINVEST = false;
                                      } else {
                                        AppSingletons.isAddNewItemInINVEST = true;
                                      }

                                      Get.toNamed(Routes.addEditItemView);
                                      AppSingletons.isSearchingItem.value = false;

                                  },
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10),
                                    margin: const EdgeInsets.only(
                                        top: 0, left: 10, right: 10),
                                    width: double.infinity,
                                    height: 45,
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                      color: mainPurpleColor,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: const Row(
                                      mainAxisAlignment: MainAxisAlignment
                                          .center,
                                      crossAxisAlignment:
                                      CrossAxisAlignment.center,
                                      children: [
                                        Text(
                                          'Add New',
                                          style: TextStyle(
                                              fontFamily: 'Montserrat',
                                              fontSize: 15,
                                              fontWeight: FontWeight.w700,
                                              color: sWhite),
                                        ),
                                        SizedBox(
                                          width: 5,
                                        ),
                                        Icon(
                                          Icons.add,
                                          color: sWhite,
                                          size: 20,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        Expanded(
                          child: Obx(() => controller.isLoadingData.value
                              ? const Center(
                              child: CupertinoActivityIndicator(
                                color: mainPurpleColor,
                                radius: 20,
                                animating: true,
                              ))
                              : controller.filteredItemList.isEmpty
                              ? Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Image.asset(
                                'assets/icons/empty_box.png',
                                height: 120,
                                width: 120,
                                color: mainPurpleColor.withOpacity(0.7),
                              ),
                              const Center(
                                child: Text(
                                  'Tap + to add Items',
                                  style: TextStyle(
                                      fontFamily: 'Montserrat',
                                      color: grey_1,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600),
                                ),
                              ),
                            ],
                          ) :
                          ListView.builder(
                              itemCount: controller.filteredItemList.length,
                              shrinkWrap: true,
                              itemBuilder: (context, index) {
                                int reverse = controller.filteredItemList.length - 1 -
                                    index;
                                final note = controller.filteredItemList[reverse];

                                note.itemPrice ??= '';

                                return Container(
                                  margin: const EdgeInsets.symmetric(
                                      horizontal: 15, vertical: 6),
                                  decoration: BoxDecoration(
                                      color: sWhite,
                                      borderRadius: BorderRadius.circular(8),
                                      boxShadow: const [
                                        BoxShadow(
                                            color: shadowColor,
                                            spreadRadius: 1,
                                            blurRadius: 5,
                                            offset: Offset(2, 2)),
                                      ]),
                                  child: ListTile(
                                    contentPadding: const EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 5),
                                    onTap: () {
                                      // AppSingletons().isEditingItemInfo = true;
                                      // AppSingletons.isEditingItemDataFromInvoice
                                      //     .value = false;
                                      // Get.offNamed(Routes.addEditItemView,
                                      //     arguments: {
                                      //       'indexId': note.id,
                                      //       'itemName':
                                      //           note.itemName.toString(),
                                      //       'itemPrice':
                                      //           note.itemPrice.toString(),
                                      //       'unitToMeasure':
                                      //           note.unitToMeasure.toString(),
                                      //       'itemDetail':
                                      //           note.itemDetail.toString(),
                                      //       'itemQuantity':
                                      //           note.itemQuantity.toString(),
                                      //       'discount':
                                      //           note.discount.toString(),
                                      //       'taxRate': note.tax.toString(),
                                      //     });

                                      if (!AppSingletons().isComingFromBottomBar) {
                                        AppSingletons().isEditingItemInfo = false;

                                        AppSingletons.isAddingItemInINVEST = true;

                                        AppSingletons.isAddNewItemInINVEST = false;

                                        AppSingletons.isSearchingItem.value = false;

                                        Get.toNamed(Routes.addEditItemView,
                                            arguments: {
                                              'indexId': note.id,
                                              'itemName': note.itemName.toString(),
                                              'itemPrice': note.itemPrice.toString(),
                                              'unitToMeasure': note.unitToMeasure
                                                  .toString(),
                                              'itemDetail': note.itemDetail.toString(),
                                            });
                                        // controller.addingItemsInInvoice(
                                        //     note.itemName.toString(),
                                        //     note.itemFinalAmount.toString(),
                                        //     note.itemDiscount.toString(),
                                        //     note.itemPrice.toString(),
                                        //     note.itemQuantity.toString(),
                                        //     note.itemTaxRate.toString(),
                                        //     note.unitToMeasure.toString(),
                                        //     note.itemDetail.toString());
                                      }
                                      else {
                                        AppSingletons.isEditingItemDataFromInvoice
                                            .value = false;

                                        AppSingletons().isEditingItemInfo = true;

                                        AppSingletons.isSearchingItem.value = false;

                                        Get.toNamed(Routes.addEditItemView,
                                            arguments: {
                                              'indexId': note.id,
                                              'itemName': note.itemName.toString(),
                                              'itemPrice': note.itemPrice.toString(),
                                              'unitToMeasure': note.unitToMeasure
                                                  .toString(),
                                              'itemDetail': note.itemDetail.toString(),
                                              // 'itemQuantity': note.itemQuantity.toString(),
                                              // 'itemDiscount': note.itemDiscount.toString(),
                                              // 'itemTaxRate': note.itemTaxRate.toString(),
                                              // 'itemFinalAmount': note.itemFinalAmount.toString()
                                            });
                                      }
                                    },
                                    title: Text(
                                      note.itemName.toString(),
                                      style: const TextStyle(
                                          fontFamily: 'Montserrat',
                                          color: grey_1,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16),
                                    ),
                                    trailing: Obx(() {
                                      return AppSingletons.isStartDeletingItem.value
                                          ? Obx(() {
                                        return Checkbox(
                                          value: note.isChecked.value ?? false,
                                          activeColor: blackColor,
                                          onChanged: (bool? value) {
                                            if (value !=
                                                null) { // Ensure value is not null
                                              note.isChecked.value = value;
                                              print(
                                                  'isChecked: ${note.isChecked.value}');
                                            } else {
                                              print(
                                                  'Received null value'); // This shouldn't happen normally
                                            }
                                          },
                                        );
                                      }) :
                                      Container(
                                        width: 150,
                                        alignment: Alignment.centerRight,
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.end,
                                          children: [
                                            Expanded(
                                              child: Container(
                                                alignment: Alignment.centerRight,
                                                margin: const EdgeInsets.symmetric(
                                                    vertical: 5),
                                                child: Text(
                                                  note.itemPrice.toString(),
                                                  style: const TextStyle(
                                                      fontFamily: 'Montserrat',
                                                      fontWeight: FontWeight.w500,
                                                      fontSize: 14),
                                                ),
                                              ),
                                            ),
                                            const SizedBox(width: 5,),
                                            Visibility(
                                              visible: AppSingletons()
                                                  .isComingFromBottomBar,
                                              child: PopupMenuButton(
                                                color: sWhite,
                                                padding: const EdgeInsets.symmetric(
                                                    horizontal: 5),
                                                shape: const Border.symmetric(),
                                                itemBuilder: (context) =>
                                                [
                                                  PopupMenuItem(
                                                    value: 0,
                                                    onTap: () {
                                                      CustomDialogues
                                                          .showDialogueToDelete(
                                                          false,
                                                          'Delete Item',
                                                          'Are you sure you want to delete ${note
                                                              .itemName}?',
                                                              () =>
                                                              controller
                                                                  .deleteItem(note.id!),
                                                              () =>
                                                              controller.loadData());
                                                    },
                                                    child: const Row(
                                                      mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                      children: [
                                                        Text(
                                                          'Delete',
                                                          style: TextStyle(
                                                              color: grey_1,
                                                              fontWeight:
                                                              FontWeight.w500,
                                                              fontSize: 16),
                                                        ),
                                                        Icon(
                                                          Icons.delete,
                                                          color: grey_1,
                                                          size: 16,
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                  PopupMenuItem(
                                                    value: 1,
                                                    onTap: () {
                                                      AppSingletons()
                                                          .isEditingItemInfo = true;

                                                      AppSingletons
                                                          .isEditingItemDataFromInvoice
                                                          .value = false;
                                                      AppSingletons.isSearchingItem
                                                          .value = false;
                                                      Get.toNamed(
                                                          Routes.addEditItemView,
                                                          arguments: {
                                                            'indexId': note.id,
                                                            'itemName': note.itemName
                                                                .toString(),
                                                            'itemPrice': note.itemPrice
                                                                .toString(),
                                                            'unitToMeasure': note
                                                                .unitToMeasure
                                                                .toString(),
                                                            'itemDetail': note
                                                                .itemDetail.toString(),
                                                            // 'itemQuantity': note.itemQuantity.toString(),
                                                            // 'itemDiscount': note.itemDiscount.toString(),
                                                            // 'itemTaxRate': note.itemTaxRate.toString(),
                                                            // 'itemFinalAmount': note.itemFinalAmount.toString(),
                                                          });
                                                    },
                                                    child: const Row(
                                                      mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                      children: [
                                                        Text(
                                                          'Edit',
                                                          style: TextStyle(
                                                              fontFamily: 'Montserrat',
                                                              color: grey_1,
                                                              fontWeight:
                                                              FontWeight.w500,
                                                              fontSize: 16),
                                                        ),
                                                        Icon(
                                                          Icons.edit,
                                                          color: grey_1,
                                                          size: 16,
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                                icon: const Icon(
                                                  Icons.more_vert,
                                                  color: grey_1,
                                                  size: 20,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                                    }),
                                  ),
                                );
                              }),)
                        ),
                        Visibility(
                          visible: !AppSingletons().isComingFromBottomBar,
                          child: Container(
                              alignment: Alignment.bottomCenter,
                              child: GestureDetector(
                                onTap: () {
                                  // AppSingletons().isEditingItemInfo = false;
                                  // AppSingletons.isEditingItemDataFromInvoice.value = false;
                                  //
                                  // if (AppSingletons().isComingFromBottomBar) {
                                  //   AppSingletons.isAddNewItemInINVEST = false;
                                  // } else {
                                  //   AppSingletons.isAddNewItemInINVEST = true;
                                  // }
                                  //
                                  // Get.toNamed(Routes.addEditItemView);
                                  // AppSingletons.isSearchingItem.value = false;

                                  AppSingletons().isEditingItemInfo = false;
                                  AppSingletons.isEditingItemDataFromInvoice.value = false;

                                  if (AppSingletons().isComingFromBottomBar) {
                                    AppSingletons.isAddNewItemInINVEST = false;
                                  } else {
                                    AppSingletons.isAddNewItemInINVEST = true;
                                  }

                                  Get.toNamed(Routes.addEditItemView);
                                  AppSingletons.isSearchingItem.value = false;

                                },
                                child: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 10),
                                  margin: const EdgeInsets.only(top: 0, left: 10, right: 10),
                                  width: double.infinity,
                                  height: 45,
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    color: mainPurpleColor,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: const Row(
                                    mainAxisAlignment: MainAxisAlignment
                                        .center,
                                    crossAxisAlignment:
                                    CrossAxisAlignment.center,
                                    children: [
                                      Text(
                                        'Add New',
                                        style: TextStyle(
                                            fontFamily: 'Montserrat',
                                            fontSize: 15,
                                            fontWeight: FontWeight.w700,
                                            color: sWhite),
                                      ),
                                      SizedBox(
                                        width: 5,
                                      ),
                                      Icon(
                                        Icons.add,
                                        color: sWhite,
                                        size: 20,
                                      ),
                                    ],
                                  ),
                                ),
                              ),

                          ),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 15,
              ),
            ],
          ),
        ));
  }
}
