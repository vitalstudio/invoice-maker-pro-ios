import 'dart:async';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import '../../core/constants/app_constants/App_Constants.dart';
import '../../core/app_singletons/app_singletons.dart';
import '../../core/routes/routes.dart';
import '../../core/widgets/dialogueToDelete.dart';
import 'client_list_controller.dart';
import '../../core/constants/color/color.dart';

class ClientListView extends GetView<ClientListController> {
  const ClientListView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put<ClientListController>(ClientListController());

    bool checkIsMobileLayout = AppConstants.isMobileScreen.value;

    return  checkIsMobileLayout ? mainMobileLayout() : mainDesktopLayout(context);
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
        title: Text(
          'client_info'.tr,
          style: const TextStyle(
              fontFamily: 'Montserrat',
              color: sWhite,
              fontWeight: FontWeight.w600,
              fontSize: 16),
        ),
      ),
      body: Obx(() =>
          Column(
            children: [
              Visibility(
                visible: AppSingletons.isSearchingClient.value,
                child: Focus(
                  onFocusChange: (value) {
                    controller.updateKeyboardVisibility(value);
                  },
                  child: Container(
                    margin: const EdgeInsets.all(15),
                    child: TextField(
                      controller: controller.searchClientList,
                      autofocus: true,
                      decoration: InputDecoration(
                          contentPadding: const EdgeInsets.all(10),
                          hintText: 'search_client'.tr,
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
                      : controller.filteredClientList.isEmpty
                      ? Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Center(
                        child: Image.asset(
                          'assets/icons/empty_box.png',
                          height: 120,
                          width: 120,
                          color: mainPurpleColor.withValues(alpha: 0.7),
                        ),
                      ),
                       Center(
                        child: Text(
                          'tap_to_add_client'.tr,
                          style: const TextStyle(
                              fontFamily: 'Montserrat',
                              color: grey_1,
                              fontSize: 16,
                              fontWeight: FontWeight.w600),
                        ),
                      ),
                    ],
                  )
                      : ListView.builder(
                      itemCount: controller.filteredClientList.length,
                      itemBuilder: (context, index) {
                        int reverse = controller.filteredClientList.length - 1 -
                            index;
                        final note = controller.filteredClientList[reverse];

                        return Container(
                          margin: const EdgeInsets.symmetric(
                              horizontal: 15, vertical: 8),
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
                                horizontal: 10),
                            onTap: () {
                              if (AppSingletons()
                                  .isComingFromBottomBar) {
                                AppSingletons().isEditingClientInfo =
                                true;
                                Get.toNamed(Routes.addClientView,
                                    arguments: {
                                      'indexId': note.id,
                                      'clientName': note.clientName.toString(),
                                      'clientEmail': note.clientEmailAddress
                                          .toString(),
                                      'clientPhoneNo': note.clientPhoneNo
                                          .toString(),
                                      'clientBillAddress': note
                                          .firstBillingAddress.toString(),
                                      'clientShipAddress': note
                                          .firstShippingAddress.toString(),
                                      'clientDetail': note.clientDetail
                                          .toString(),
                                    });
                              } else {
                                debugPrint('else condition is running');
                                if (AppSingletons.isInvoiceDocument.value) {
                                  debugPrint('Added in invoice doc');
                                  AppSingletons.clientNameINV?.value =
                                      note.clientName.toString();
                                  AppSingletons.clientEmailINV?.value =
                                      note.clientEmailAddress.toString();
                                  AppSingletons.clientDetailINV?.value =
                                      note.clientDetail.toString();
                                  AppSingletons.clientPhoneNumberINV?.value =
                                      note.clientPhoneNo.toString();
                                  AppSingletons.clientBillingAddressINV?.value =
                                      note.firstBillingAddress.toString();
                                  AppSingletons.clientShippingAddressINV
                                      ?.value =
                                      note.firstShippingAddress.toString();
                                  debugPrint(
                                      'Cname: ${AppSingletons.clientNameINV
                                          ?.value ?? ''}');
                                  debugPrint(
                                      'CEmail: ${AppSingletons.clientEmailINV
                                          ?.value ?? ''}');

                                  Get.back();
                                } else {
                                  debugPrint('Added in estimate doc');
                                  AppSingletons.estClientNameINV?.value =
                                      note.clientName.toString();
                                  AppSingletons.estClientEmailINV?.value =
                                      note.clientEmailAddress.toString();
                                  AppSingletons.estClientDetailINV?.value =
                                      note.clientDetail.toString();
                                  AppSingletons.estClientPhoneNumberINV?.value =
                                      note.clientPhoneNo.toString();
                                  AppSingletons.estClientBillingAddressINV
                                      ?.value =
                                      note.firstBillingAddress.toString();
                                  AppSingletons.estClientShippingAddressINV
                                      ?.value =
                                      note.firstShippingAddress.toString();
                                  debugPrint(
                                      'Cname: ${AppSingletons.estClientNameINV
                                          ?.value ?? ''}');
                                  debugPrint(
                                      'CEmail: ${AppSingletons.estClientEmailINV
                                          ?.value ?? ''}');

                                  Get.back();
                                }
                              }
                            },
                            title: Text(
                              note.clientName.toString(),
                              style: const TextStyle(
                                  fontFamily: 'Montserrat',
                                  color: grey_1,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16),
                            ),
                            subtitle: Text(
                              note.clientPhoneNo
                                  .toString()
                                  .isNotEmpty
                                  ? note.clientPhoneNo.toString()
                                  : 'N/A',
                              style: const TextStyle(
                                  fontFamily: 'Montserrat',
                                  fontWeight: FontWeight.w500,
                                  fontSize: 14),
                            ),
                            trailing: Visibility(
                              visible: AppSingletons().isComingFromBottomBar,
                              child: Obx(() {
                                return AppSingletons.isStartDeletingItem.value
                                    ? Obx(() {
                                  return Checkbox(
                                    value: note.isChecked.value ?? false,
                                    activeColor: blackColor,
                                    onChanged: (bool? value) {
                                      if (value !=
                                          null) { // Ensure value is not null
                                        note.isChecked.value = value;
                                        debugPrint('isChecked: ${note.isChecked
                                            .value}');
                                      } else {
                                        debugPrint('Received null value');
                                      }
                                    },
                                  );
                                }) :
                                PopupMenuButton(
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
                                              'delete_client'.tr,
                                              'are_you_sure_you_want_to_delete'.tr,
                                                  '${note.clientName}?',
                                                  () => controller.deleteClient(note.id!),
                                                  () => controller.loadData());
                                        },
                                        child: Row(
                                          mainAxisAlignment:
                                          MainAxisAlignment
                                              .spaceBetween,
                                          children: [
                                            Text(
                                              'delete'.tr,
                                              style: const TextStyle(
                                                  fontFamily: 'Montserrat',
                                                  color: grey_1,
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 16),
                                            ),
                                            const Icon(
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
                                              .isEditingClientInfo =
                                          true;

                                          Get.toNamed(
                                              Routes.addClientView,
                                              arguments: {
                                                'indexId': note.id,
                                                'clientName': note
                                                    .clientName
                                                    .toString(),
                                                'clientEmail': note
                                                    .clientEmailAddress
                                                    .toString(),
                                                'clientPhoneNo': note
                                                    .clientPhoneNo
                                                    .toString(),
                                                'clientBillAddress': note
                                                    .firstBillingAddress
                                                    .toString(),
                                                'clientShipAddress': note
                                                    .firstShippingAddress
                                                    .toString(),
                                                'clientDetail': note
                                                    .clientDetail
                                                    .toString(),
                                              });
                                        },
                                        child: Row(
                                          mainAxisAlignment:
                                          MainAxisAlignment
                                              .spaceBetween,
                                          children: [
                                            Text(
                                              'edit'.tr,
                                              style: const TextStyle(
                                                  fontFamily: 'Montserrat',
                                                  color: grey_1,
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 16),
                                            ),
                                            const Icon(
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
                                    ));
                              }),
                            ),
                          ),
                        );
                      }))
            ],
          )),
      floatingActionButton: Obx(() {
        return Visibility(
          visible: !AppSingletons.isKeyboardVisible.value
          // && AppSingletons().isComingFromBottomBar
          ,
          child: FloatingActionButton(
            onPressed: () {
              Get.toNamed(Routes.addClientView);
              AppSingletons().isEditingClientInfo = false;
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
          'CLIENT',
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

                      CustomDialogues.showDialogueToDelete(
                          false,
                          'Delete Clients',
                          'Are you sure you want to delete selected Clients?',
                              '',
                              () => {
                            controller.clientDbHelper!.deleteCheckedClients(
                                Get.find<ClientListController>()
                                    .filteredClientList
                            )
                          },
                              () => {
                            Timer(const Duration(seconds: 2), () {
                              controller.loadData();
                            })
                          });

                      // controller.clientDbHelper!.deleteCheckedClients(
                      //     controller.filteredClientList
                      // );
                      // Timer(const Duration(seconds: 2), () {
                      //   controller.loadData();
                      // });
                    },
                    icon: const Icon(
                      Icons.delete_sweep, color: sWhite,)),
              )),
          Obx(() =>
              Visibility(
                visible: AppSingletons.isStartDeletingItem.value ==
                    true &&
                    AppSingletons().isComingFromBottomBar,
                child: IconButton(
                    onPressed: () {
                      if (AppSingletons.isSelectedAll.value) {
                        controller.deSelectAllClients();
                      } else {
                        controller.selectAllClients();
                      }
                    },
                    icon: Icon(
                      AppSingletons.isSelectedAll.value
                          ? Icons.deselect : Icons.select_all,
                      color: sWhite,)),
              )),
          Obx(() {
            return Visibility(
              visible: AppSingletons.isStartDeletingItem.value == false &&
                  AppSingletons().isComingFromBottomBar,
              child: IconButton(
                  onPressed: () {
                    Get.toNamed(Routes.proScreenView);
                  },
                  icon: Image.asset(
                    'assets/icons/vip_icon.png', height: 35, width: 35,)
              ),
            );
          }),
        ],
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: !AppSingletons().isComingFromBottomBar
            ? const BoxDecoration(
            image: DecorationImage(
                image: AssetImage(
                  'assets/images/client_screen_desk.jpg',
                ),
                fit: BoxFit.fill))
            : const BoxDecoration(
            color: orangeLight_1
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
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
                                    controller: controller.searchClientList,
                                    autofocus: false,
                                    decoration: InputDecoration(
                                        contentPadding:
                                        const EdgeInsets.all(10),
                                        hintText: 'Search client',
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
                                    Get.toNamed(Routes.addClientView);
                                    AppSingletons().isEditingClientInfo = false;
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
                                      mainAxisAlignment:
                                      MainAxisAlignment.center,
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
                                : controller.filteredClientList.isEmpty
                                ? Column(
                              mainAxisAlignment:
                              MainAxisAlignment.center,
                              crossAxisAlignment:
                              CrossAxisAlignment.center,
                              children: [
                                Center(
                                  child: Image.asset(
                                    'assets/icons/empty_box.png',
                                    height: 120,
                                    width: 120,
                                    color: mainPurpleColor
                                        .withValues(alpha: 0.7),
                                  ),
                                ),
                                const Center(
                                  child: Text(
                                    'Tap + to add client',
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
                                itemCount: controller
                                    .filteredClientList.length,
                                itemBuilder: (context, index) {
                                  int reverse = controller.filteredClientList.length - 1 - index;
                                  final note = controller.filteredClientList[reverse];

                                  return Container(
                                    margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                                    decoration: BoxDecoration(
                                        color: sWhite,
                                        borderRadius:
                                        BorderRadius.circular(12),
                                        boxShadow: const [
                                          BoxShadow(
                                              color: shadowColor,
                                              spreadRadius: 1,
                                              blurRadius: 5,
                                              offset: Offset(2, 2)),
                                        ]),
                                    child: ListTile(
                                      contentPadding:
                                      const EdgeInsets.symmetric(
                                          horizontal: 10),
                                      onTap: () {
                                        if (AppSingletons().isComingFromBottomBar) {
                                          AppSingletons().isEditingClientInfo = true;
                                          Get.toNamed(Routes.addClientView,
                                              arguments: {
                                                'indexId': note.id,
                                                'clientName': note.clientName.toString(),
                                                'clientEmail': note.clientEmailAddress.toString(),
                                                'clientPhoneNo': note.clientPhoneNo.toString(),
                                                'clientBillAddress': note.firstBillingAddress.toString(),
                                                'clientShipAddress': note.firstShippingAddress.toString(),
                                                'clientDetail': note.clientDetail.toString(),
                                              });
                                        } else {
                                          debugPrint('else condition is running');
                                          if (AppSingletons.isInvoiceDocument.value) {
                                            debugPrint('Added in invoice doc');
                                            AppSingletons.clientNameINV?.value = note.clientName.toString();
                                            AppSingletons.clientEmailINV?.value = note.clientEmailAddress.toString();
                                            AppSingletons.clientDetailINV?.value = note.clientDetail.toString();
                                            AppSingletons.clientPhoneNumberINV?.value = note.clientPhoneNo.toString();
                                            AppSingletons.clientBillingAddressINV?.value = note.firstBillingAddress.toString();
                                            AppSingletons.clientShippingAddressINV?.value = note.firstShippingAddress.toString();
                                            debugPrint('Cname: ${AppSingletons.clientNameINV?.value ?? ''}');
                                            debugPrint('CEmail: ${AppSingletons.clientEmailINV?.value ?? ''}');
                                            Get.back();
                                          } else {
                                            debugPrint(
                                                'Added in estimate doc');
                                            AppSingletons
                                                .estClientNameINV
                                                ?.value =
                                                note.clientName
                                                    .toString();
                                            AppSingletons
                                                .estClientEmailINV
                                                ?.value =
                                                note.clientEmailAddress
                                                    .toString();
                                            AppSingletons
                                                .estClientDetailINV
                                                ?.value =
                                                note.clientDetail
                                                    .toString();
                                            AppSingletons
                                                .estClientPhoneNumberINV
                                                ?.value =
                                                note.clientPhoneNo
                                                    .toString();
                                            AppSingletons
                                                .estClientBillingAddressINV
                                                ?.value =
                                                note.firstBillingAddress
                                                    .toString();
                                            AppSingletons
                                                .estClientShippingAddressINV
                                                ?.value =
                                                note.firstShippingAddress
                                                    .toString();
                                            debugPrint(
                                                'Cname: ${AppSingletons
                                                    .estClientNameINV?.value ??
                                                    ''}');
                                            debugPrint(
                                                'CEmail: ${AppSingletons
                                                    .estClientEmailINV?.value ??
                                                    ''}');
                                            Get.back();
                                          }
                                        }
                                      },
                                      title: Text(
                                        note.clientName.toString(),
                                        style: const TextStyle(
                                            fontFamily: 'Montserrat',
                                            color: grey_1,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16),
                                      ),
                                      subtitle: Text(
                                        note.clientPhoneNo
                                            .toString()
                                            .isNotEmpty
                                            ? note.clientPhoneNo
                                            .toString()
                                            : 'N/A',
                                        style: const TextStyle(
                                            fontFamily: 'Montserrat',
                                            fontWeight: FontWeight.w500,
                                            fontSize: 14),
                                      ),
                                      trailing: Visibility(
                                        visible: AppSingletons().isComingFromBottomBar,
                                        child: Obx(() {
                                          return AppSingletons.isStartDeletingItem.value
                                              ? Obx(() {
                                            return Checkbox(
                                              value: note.isChecked.value ?? false,
                                              activeColor: blackColor,
                                              onChanged: (bool? value) {
                                                if (value !=
                                                    null) { // Ensure value is not null
                                                  note.isChecked.value = value;
                                                  debugPrint('isChecked: ${note.isChecked
                                                      .value}');
                                                } else {
                                                  debugPrint('Received null value');
                                                }
                                              },
                                            );
                                          }) :
                                          PopupMenuButton(
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
                                                        'Delete Client',
                                                        'Are you sure you want to delete ${note
                                                            .clientName}?',
                                                            '',
                                                            () =>
                                                            controller
                                                                .deleteClient(
                                                                note.id!),
                                                            () =>
                                                            controller
                                                                .loadData());
                                                  },
                                                  child: const Row(
                                                    mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                    children: [
                                                      Text(
                                                        'Delete',
                                                        style: TextStyle(
                                                            fontFamily:
                                                            'Montserrat',
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
                                                        .isEditingClientInfo =
                                                    true;

                                                    Get.toNamed(
                                                        Routes.addClientView,
                                                        arguments: {
                                                          'indexId': note.id,
                                                          'clientName': note
                                                              .clientName
                                                              .toString(),
                                                          'clientEmail': note
                                                              .clientEmailAddress
                                                              .toString(),
                                                          'clientPhoneNo': note
                                                              .clientPhoneNo
                                                              .toString(),
                                                          'clientBillAddress': note
                                                              .firstBillingAddress
                                                              .toString(),
                                                          'clientShipAddress': note
                                                              .firstShippingAddress
                                                              .toString(),
                                                          'clientDetail': note
                                                              .clientDetail
                                                              .toString(),
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
                                                            fontFamily:
                                                            'Montserrat',
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
                                              ));
                                        }),
                                      ),
                                    ),
                                  );
                                }))
                        ),

                        Visibility(
                          visible: !AppSingletons().isComingFromBottomBar,
                          child: GestureDetector(
                            onTap: () {
                              Get.toNamed(Routes.addClientView);
                              AppSingletons().isEditingClientInfo = false;
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10),
                              margin: const EdgeInsets.symmetric(horizontal: 10),
                              width: double.infinity,
                              height: 45,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: mainPurpleColor,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: const Row(
                                mainAxisAlignment:
                                MainAxisAlignment.center,
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

                        const SizedBox(
                          height: 15,
                        ),
                      ],
                    )),
              ),
            ),
            const SizedBox(
              height: 15,
            )
          ],
        ),
      ),
    );
  }

  // showDialogueToDelete(int indexId, String clientName) async {
  //   return Get.dialog(
  //     AlertDialog(
  //       backgroundColor: sWhite,
  //       title: const Text(
  //         'Delete Client',
  //         style: TextStyle(
  //           fontFamily: 'SFProDisplay',
  //           color: grey_1,
  //           letterSpacing: 1,
  //           fontWeight: FontWeight.w700,
  //           fontSize: 16,
  //         ),
  //       ),
  //       content: Text(
  //         'Are your sure you want to delete $clientName?',
  //         style: const TextStyle(
  //           fontFamily: 'Montserrat',
  //           color: grey_1,
  //           fontWeight: FontWeight.w400,
  //           fontSize: 16,
  //         ),
  //       ),
  //       alignment: Alignment.center,
  //       actions: [
  //         TextButton(
  //           onPressed: () {
  //             Get.back();
  //           },
  //           child: const Text(
  //             'Cancel',
  //             style: TextStyle(
  //               fontFamily: 'Montserrat',
  //               color: grey_1,
  //               fontWeight: FontWeight.w500,
  //               fontSize: 16,
  //             ),
  //           ),
  //         ),
  //         TextButton(
  //           onPressed: () {
  //             controller.deleteClient(indexId);
  //             Get.back();
  //           },
  //           child: const Text(
  //             'Delete',
  //             style: TextStyle(
  //               fontFamily: 'Montserrat',
  //               color: grey_1,
  //               fontWeight: FontWeight.w500,
  //               fontSize: 16,
  //             ),
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }
}
