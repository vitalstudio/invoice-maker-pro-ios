import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../core/constants/app_constants/App_Constants.dart';
import '../../core/widgets/common_text_field.dart';
import '../../core/routes/routes.dart';
import '../../core/utils/utils.dart';
import '../../core/widgets/dialogueToDelete.dart';
import '../../core/app_singletons/app_singletons.dart';
import '../../core/constants/color/color.dart';
import 'home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put<HomeController>(HomeController());

    bool checkIsMobileLayout = AppConstants.isMobileScreen.value;

    return checkIsMobileLayout
        ? mainMobileLayout(context)
        : mainDesktopLayout(context);
  }

  Widget mainMobileLayout(BuildContext context) {
    return Scaffold(
      backgroundColor: orangeLight_1,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Obx(() {
              return Visibility(
                visible: AppSingletons.isSearchingInvoice.value,
                child: Focus(
                  onFocusChange: (value) {
                    controller.updateKeyboardVisibility(value);
                  },
                  child: Container(
                    margin: const EdgeInsets.all(15),
                    child: TextField(
                      controller: controller.searchController,
                      autofocus: true,
                      decoration: InputDecoration(
                          contentPadding: const EdgeInsets.all(10),
                          hintText: 'search_invoice'.tr,
                          prefixIcon: const Icon(Icons.search),
                          border: OutlineInputBorder(
                              borderSide: BorderSide.none,
                              borderRadius: BorderRadius.circular(15)),
                          fillColor: textFieldColor,
                          filled: true),
                    ),
                  ),
                ),
              );
            }),
            Obx(() {
              return Visibility(
                  visible: !AppSingletons.isSearchingInvoice.value,
                  child: const SizedBox(
                    height: 10,
                  ));
            }),
            const SizedBox(
              height: 5,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  width: 15,
                ),
                Expanded(
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    decoration: BoxDecoration(
                      color: sWhite,
                      boxShadow: const [
                        BoxShadow(
                            color: grey_4,
                            spreadRadius: 1,
                            blurRadius: 4,
                            offset: Offset(-1, 1))
                      ],
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      children: [
                        const SizedBox(
                          height: 10,
                        ),
                        Text(
                          'total_unpaid'.tr,
                          style: const TextStyle(
                              fontFamily: 'Montserrat',
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 1),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        Obx(() {
                          return Text(
                            '${AppSingletons.storedInvoiceCurrency.value}${AppSingletons.totalUnpaidInvoices.value}',
                            style: const TextStyle(
                              fontFamily: 'Montserrat',
                              fontSize: 25,
                              fontWeight: FontWeight.w600,
                            ),
                          );
                        }),
                        const SizedBox(
                          height: 10,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    decoration: BoxDecoration(
                      color: sWhite,
                      boxShadow: const [
                        BoxShadow(
                            color: grey_4,
                            spreadRadius: 1,
                            blurRadius: 4,
                            offset: Offset(2, 1))
                      ],
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      children: [
                        const SizedBox(
                          height: 10,
                        ),
                        Text(
                          'total_overdue'.tr,
                          style: const TextStyle(
                              fontFamily: 'Montserrat',
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 1),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        Obx(() {
                          return Text(
                            '${AppSingletons.storedInvoiceCurrency.value}${AppSingletons.totalOverdueInvoices.value}',
                            style: const TextStyle(
                                fontFamily: 'Montserrat',
                                fontSize: 25,
                                fontWeight: FontWeight.w600,
                                color: orangeMedium_1),
                          );
                        }),
                        const SizedBox(
                          height: 10,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  width: 15,
                ),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            Stack(children: [
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Obx(() {
                  return Row(
                    children: [
                      Visibility(
                          visible: AppSingletons.storedAppLanguage.value ==
                              AppConstants.arabic,
                          child: const SizedBox(
                            width: 50,
                          )),
                      GestureDetector(
                        onTap: () {
                          controller.listShowingType.value = AppConstants.all;
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 15, vertical: 5),
                          margin: const EdgeInsets.only(right: 5, left: 18),
                          decoration: BoxDecoration(
                              color: controller.listShowingType.value ==
                                      AppConstants.all
                                  ? mainPurpleColor
                                  : offWhite_2,
                              borderRadius: BorderRadius.circular(100)),
                          child: Text(
                            'all'.tr,
                            style: TextStyle(
                                color: controller.listShowingType.value ==
                                        AppConstants.all
                                    ? sWhite
                                    : blackColor,
                                fontFamily: 'Montserrat',
                                fontSize: 14,
                                fontWeight: FontWeight.w600),
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          controller.listShowingType.value =
                              AppConstants.unpaidInvoice;
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 15, vertical: 5),
                          margin: const EdgeInsets.symmetric(horizontal: 5),
                          decoration: BoxDecoration(
                              color: controller.listShowingType.value ==
                                      AppConstants.unpaidInvoice
                                  ? mainPurpleColor
                                  : offWhite_2,
                              borderRadius: BorderRadius.circular(100)),
                          child: Text(
                            'unpaid'.tr,
                            style: TextStyle(
                                color: controller.listShowingType.value ==
                                        AppConstants.unpaidInvoice
                                    ? sWhite
                                    : blackColor,
                                fontFamily: 'Montserrat',
                                fontSize: 14,
                                fontWeight: FontWeight.w600),
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          controller.listShowingType.value =
                              AppConstants.partiallyPaidInvoice;
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 15, vertical: 5),
                          margin: const EdgeInsets.symmetric(horizontal: 5),
                          decoration: BoxDecoration(
                              color: controller.listShowingType.value ==
                                      AppConstants.partiallyPaidInvoice
                                  ? mainPurpleColor
                                  : offWhite_2,
                              borderRadius: BorderRadius.circular(100)),
                          child: Text(
                            'partially_paid'.tr,
                            style: TextStyle(
                                color: controller.listShowingType.value ==
                                        AppConstants.partiallyPaidInvoice
                                    ? sWhite
                                    : blackColor,
                                fontSize: 14,
                                fontFamily: 'Montserrat',
                                fontWeight: FontWeight.w600),
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          controller.listShowingType.value =
                              AppConstants.overdue;
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 15, vertical: 5),
                          margin: const EdgeInsets.symmetric(horizontal: 5),
                          decoration: BoxDecoration(
                              color: controller.listShowingType.value ==
                                      AppConstants.overdue
                                  ? mainPurpleColor
                                  : offWhite_2,
                              borderRadius: BorderRadius.circular(100)),
                          child: Text(
                            'overdue'.tr,
                            style: TextStyle(
                                fontFamily: 'Montserrat',
                                color: controller.listShowingType.value ==
                                        AppConstants.overdue
                                    ? sWhite
                                    : blackColor,
                                fontSize: 14,
                                fontWeight: FontWeight.w600),
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          controller.listShowingType.value =
                              AppConstants.paidInvoice;
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 15, vertical: 5),
                          margin: const EdgeInsets.only(left: 5, right: 60),
                          decoration: BoxDecoration(
                              color: controller.listShowingType.value ==
                                      AppConstants.paidInvoice
                                  ? mainPurpleColor
                                  : offWhite_2,
                              borderRadius: BorderRadius.circular(100)),
                          child: Text(
                            'paid'.tr,
                            style: TextStyle(
                                fontFamily: 'Montserrat',
                                color: controller.listShowingType.value ==
                                        AppConstants.paidInvoice
                                    ? sWhite
                                    : blackColor,
                                fontSize: 14,
                                fontWeight: FontWeight.w600),
                          ),
                        ),
                      ),
                    ],
                  );
                }),
              ),
              Positioned(
                right: 0,
                bottom: 0,
                top: 0,
                child: GestureDetector(
                  onTap: () async {
                    if (controller.isFilteringList.value) {
                      // controller.filteredDataList.value = controller.fetchedDataList.value;
                      // controller.filteredUnpaidList.value = controller.fetchedUnpaidList.value;
                      // controller.filteredPPList.value = controller.fetchedPPList.value;
                      // controller.filteredOverdueList.value = controller.fetchedOverdueList.value;
                      // controller.filteredPaidList.value = controller.fetchedPaidList.value;

                      await controller.loadInvoiceData();

                      controller.isFilteringList.value = false;

                      controller.selectedName.value = '';
                      controller.fromDate.value = null;
                      controller.toDate.value = null;
                    } else {
                      addFilterByClientAndDate(context);
                    }
                  },
                  child: Container(
                    color: orangeLight_1,
                    padding: const EdgeInsets.symmetric(horizontal: 13),
                    child: Obx(() {
                      return Icon(
                        controller.isFilteringList.value
                            ? Icons.filter_alt_off_outlined
                            : Icons.filter_alt_outlined,
                        color: blackColor,
                      );
                    }),
                  ),
                ),
              )
            ]),
            const SizedBox(
              height: 10,
            ),
            Obx(
              () => controller.isLoadingData.value
                  ? const Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: 100,
                        ),
                        CupertinoActivityIndicator(
                          color: mainPurpleColor,
                          radius: 20,
                        ),
                        SizedBox(
                          height: 100,
                        ),
                      ],
                    )
                  : showListAccordingToSelectedTap(),
            ),
          ],
        ),
      ),
      floatingActionButton: Obx(() {
        return Visibility(
          visible: !AppSingletons.isKeyboardVisible.value,
          child: FloatingActionButton(
            onPressed: () {
              // if(AppSingletons.isSubscriptionEnabled.value){
              //   AppSingletons.isInvoiceDocument.value = true;
              //   AppSingletons.isMakingNewINVEST.value = true;
              //   Get.toNamed(Routes.invoiceInputView);
              //   AppSingletons.isEditInvoice.value = false;
              //   AppSingletons.isEditingOnlyTemplate.value = false;
              //
              //   Utils.clearInvoiceVariables();
              // }
              // else {
              //   if(AppSingletons.noOfInvoicesMadeAlready.value >= 3){
              //     Get.toNamed(Routes.proScreenView);
              //   } else {
              //     AppSingletons.isInvoiceDocument.value = true;
              //     AppSingletons.isMakingNewINVEST.value = true;
              //     Get.toNamed(Routes.invoiceInputView);
              //     AppSingletons.isEditInvoice.value = false;
              //     AppSingletons.isEditingOnlyTemplate.value = false;
              //
              //     Utils.clearInvoiceVariables();
              //   }
              // }
              AppSingletons.isInvoiceDocument.value = true;
              AppSingletons.isMakingNewINVEST.value = true;
              Get.toNamed(Routes.invoiceInputView);
              AppSingletons.isEditInvoice.value = false;
              AppSingletons.isEditingOnlyTemplate.value = false;

              Utils.clearInvoiceVariables();
            },
            backgroundColor: mainPurpleColor,
            shape: const CircleBorder(),
            child: const Icon(
              Icons.add,
              color: orangeLight_1,
            ),
          ),
        );
      }),
    );
  }

  Widget mainDesktopLayout(BuildContext context) {
    return Scaffold(
        backgroundColor: mainPurpleColor,
        appBar: AppBar(
          backgroundColor: mainPurpleColor,
          automaticallyImplyLeading: false,
          elevation: 0,
          title: const Text(
            'INVOICE',
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontFamily: 'Montserrat',
                color: sWhite,
                fontSize: 16),
          ),
          actions: [
            Obx(() {
              if (AppSingletons.isSearchingInvoice.value == false) {
                return IconButton(
                    onPressed: () {
                      AppSingletons.isSearchingInvoice.value = true;
                    },
                    icon: const Icon(
                      Icons.search,
                      color: sWhite,
                    ));
              } else {
                return IconButton(
                    onPressed: () {
                      AppSingletons.isSearchingInvoice.value = false;
                      AppSingletons.isKeyboardVisible.value = false;

                      controller.searchController.clear();
                    },
                    icon: const Icon(
                      Icons.cancel,
                      color: sWhite,
                    ));
              }
            }),
            IconButton(
                onPressed: () {
                  Get.toNamed(Routes.chartsView);
                },
                icon: const Icon(
                  Icons.add_chart,
                  color: sWhite,
                )),
            IconButton(
                onPressed: () {
                  Get.toNamed(Routes.proScreenView);
                },
                icon: Image.asset(
                  'assets/icons/vip_icon.png',
                  height: 35,
                  width: 35,
                )),
          ],
        ),
        body: Container(
          height: double.infinity,
          width: double.infinity,
          color: orangeLight_1,
          child: SingleChildScrollView(
              child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const SizedBox(
                height: 5,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    width: 20,
                  ),
                  Expanded(
                      flex: 4,
                      child: SingleChildScrollView(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Obx(() {
                              return Visibility(
                                visible: AppSingletons.isSearchingInvoice.value,
                                child: Focus(
                                  onFocusChange: (value) {
                                    controller.updateKeyboardVisibility(value);
                                  },
                                  child: Container(
                                    margin: const EdgeInsets.all(15),
                                    child: TextField(
                                      controller: controller.searchController,
                                      autofocus: true,
                                      decoration: InputDecoration(
                                          contentPadding:
                                              const EdgeInsets.all(10),
                                          hintText: 'search_invoice',
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
                              );
                            }),
                            Obx(() {
                              return Visibility(
                                  visible:
                                      !AppSingletons.isSearchingInvoice.value,
                                  child: const SizedBox(
                                    height: 10,
                                  ));
                            }),
                            Stack(
                              children: [
                                SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: Obx(() {
                                    return Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        GestureDetector(
                                          onTap: () {
                                            controller.listShowingType.value =
                                                AppConstants.all;
                                          },
                                          child: Container(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 20, vertical: 7),
                                            margin: const EdgeInsets.only(
                                                right: 5, left: 18),
                                            decoration: BoxDecoration(
                                                color: controller
                                                            .listShowingType
                                                            .value ==
                                                        AppConstants.all
                                                    ? mainPurpleColor
                                                    : offWhite_2,
                                                borderRadius:
                                                    BorderRadius.circular(100)),
                                            child: Text(
                                              'All',
                                              style: TextStyle(
                                                  color: controller
                                                              .listShowingType
                                                              .value ==
                                                          AppConstants.all
                                                      ? sWhite
                                                      : blackColor,
                                                  fontFamily: 'Montserrat',
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w600),
                                            ),
                                          ),
                                        ),
                                        GestureDetector(
                                          onTap: () {
                                            controller.listShowingType.value =
                                                AppConstants.unpaidInvoice;
                                          },
                                          child: Container(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 20, vertical: 7),
                                            margin: const EdgeInsets.symmetric(
                                                horizontal: 5),
                                            decoration: BoxDecoration(
                                                color: controller
                                                            .listShowingType
                                                            .value ==
                                                        AppConstants
                                                            .unpaidInvoice
                                                    ? mainPurpleColor
                                                    : offWhite_2,
                                                borderRadius:
                                                    BorderRadius.circular(100)),
                                            child: Text(
                                              'Unpaid',
                                              style: TextStyle(
                                                  color: controller
                                                              .listShowingType
                                                              .value ==
                                                          AppConstants
                                                              .unpaidInvoice
                                                      ? sWhite
                                                      : blackColor,
                                                  fontFamily: 'Montserrat',
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w600),
                                            ),
                                          ),
                                        ),
                                        GestureDetector(
                                          onTap: () {
                                            controller.listShowingType.value =
                                                AppConstants
                                                    .partiallyPaidInvoice;
                                          },
                                          child: Container(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 20, vertical: 7),
                                            margin: const EdgeInsets.symmetric(
                                                horizontal: 5),
                                            decoration: BoxDecoration(
                                                color: controller
                                                            .listShowingType
                                                            .value ==
                                                        AppConstants
                                                            .partiallyPaidInvoice
                                                    ? mainPurpleColor
                                                    : offWhite_2,
                                                borderRadius:
                                                    BorderRadius.circular(100)),
                                            child: Text(
                                              'Partially Paid',
                                              style: TextStyle(
                                                  color: controller
                                                              .listShowingType
                                                              .value ==
                                                          AppConstants
                                                              .partiallyPaidInvoice
                                                      ? sWhite
                                                      : blackColor,
                                                  fontSize: 14,
                                                  fontFamily: 'Montserrat',
                                                  fontWeight: FontWeight.w600),
                                            ),
                                          ),
                                        ),
                                        GestureDetector(
                                          onTap: () {
                                            controller.listShowingType.value =
                                                AppConstants.overdue;
                                          },
                                          child: Container(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 20, vertical: 7),
                                            margin: const EdgeInsets.symmetric(
                                                horizontal: 5),
                                            decoration: BoxDecoration(
                                                color: controller
                                                            .listShowingType
                                                            .value ==
                                                        AppConstants.overdue
                                                    ? mainPurpleColor
                                                    : offWhite_2,
                                                borderRadius:
                                                    BorderRadius.circular(100)),
                                            child: Text(
                                              'Overdue',
                                              style: TextStyle(
                                                  fontFamily: 'Montserrat',
                                                  color: controller
                                                              .listShowingType
                                                              .value ==
                                                          AppConstants.overdue
                                                      ? sWhite
                                                      : blackColor,
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w600),
                                            ),
                                          ),
                                        ),
                                        GestureDetector(
                                          onTap: () {
                                            controller.listShowingType.value =
                                                AppConstants.paidInvoice;
                                          },
                                          child: Container(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 20, vertical: 7),
                                            margin: const EdgeInsets.only(
                                                left: 5, right: 50),
                                            decoration: BoxDecoration(
                                                color: controller
                                                            .listShowingType
                                                            .value ==
                                                        AppConstants.paidInvoice
                                                    ? mainPurpleColor
                                                    : offWhite_2,
                                                borderRadius:
                                                    BorderRadius.circular(100)),
                                            child: Text(
                                              'Paid',
                                              style: TextStyle(
                                                  fontFamily: 'Montserrat',
                                                  color: controller
                                                              .listShowingType
                                                              .value ==
                                                          AppConstants
                                                              .paidInvoice
                                                      ? sWhite
                                                      : blackColor,
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w600),
                                            ),
                                          ),
                                        ),
                                      ],
                                    );
                                  }),
                                ),
                                Positioned(
                                  right: 0,
                                  child: GestureDetector(
                                    onTap: () {
                                      if (controller.isFilteringList.value) {
                                        controller.filteredDataList.value =
                                            controller.fetchedDataList.value;
                                        controller.filteredUnpaidList.value =
                                            controller.fetchedUnpaidList.value;
                                        controller.filteredPPList.value =
                                            controller.fetchedPPList.value;
                                        controller.filteredOverdueList.value =
                                            controller.fetchedOverdueList.value;
                                        controller.filteredPaidList.value =
                                            controller.fetchedPaidList.value;
                                        controller.isFilteringList.value =
                                            false;

                                        controller.selectedName.value = '';
                                        controller.fromDate.value = null;
                                        controller.toDate.value = null;
                                      } else {
                                        addFilterByClientAndDate(context);
                                      }
                                    },
                                    child: Container(
                                      color: orangeLight_1,
                                      height: 35,
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 13),
                                      child: Obx(() {
                                        return Icon(
                                          controller.isFilteringList.value
                                              ? Icons.filter_alt_off_outlined
                                              : Icons.filter_alt_outlined,
                                          color: blackColor,
                                        );
                                      }),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Obx(
                              () => controller.isLoadingData.value
                                  ? const Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        SizedBox(
                                          height: 100,
                                        ),
                                        CupertinoActivityIndicator(
                                          color: mainPurpleColor,
                                          radius: 20,
                                        ),
                                        SizedBox(
                                          height: 100,
                                        ),
                                      ],
                                    )
                                  : showListAccordingToSelectedTap(),
                            ),
                            const SizedBox(
                              height: 70,
                            ),
                          ],
                        ),
                      )),
                  Expanded(
                      flex: 1,
                      child: Column(
                        children: [
                          const SizedBox(
                            height: 10,
                          ),
                          GestureDetector(
                            onTap: () {
                              if (AppSingletons.isSubscriptionEnabled.value) {
                                AppSingletons.isInvoiceDocument.value = true;
                                AppSingletons.isMakingNewINVEST.value = true;
                                Get.toNamed(Routes.invoiceInputView);
                                AppSingletons.isEditInvoice.value = false;
                                AppSingletons.isEditingOnlyTemplate.value =
                                    false;

                                Utils.clearInvoiceVariables();
                              } else {
                                if (AppSingletons
                                        .noOfInvoicesMadeAlready.value >=
                                    3) {
                                  Get.toNamed(Routes.proScreenView);
                                } else {
                                  AppSingletons.isInvoiceDocument.value = true;
                                  AppSingletons.isMakingNewINVEST.value = true;
                                  Get.toNamed(Routes.invoiceInputView);
                                  AppSingletons.isEditInvoice.value = false;
                                  AppSingletons.isEditingOnlyTemplate.value =
                                      false;

                                  Utils.clearInvoiceVariables();
                                }
                              }
                            },
                            child: Container(
                              width: double.infinity,
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              decoration: BoxDecoration(
                                color: sWhite,
                                boxShadow: const [
                                  BoxShadow(
                                      color: grey_4,
                                      spreadRadius: 1,
                                      blurRadius: 10,
                                      offset: Offset(2, 1))
                                ],
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: const Column(
                                children: [
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Text(
                                    'Create New',
                                    style: TextStyle(
                                      fontFamily: 'Montserrat',
                                      fontSize: 15,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 15,
                                  ),
                                  Icon(
                                    Icons.add,
                                    color: mainPurpleColor,
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            decoration: BoxDecoration(
                              color: sWhite,
                              boxShadow: const [
                                BoxShadow(
                                    color: grey_4,
                                    spreadRadius: 1,
                                    blurRadius: 10,
                                    offset: Offset(-1, 1))
                              ],
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Column(
                              children: [
                                const SizedBox(
                                  height: 10,
                                ),
                                const Text(
                                  'Total Unpaid',
                                  style: TextStyle(
                                    fontFamily: 'Montserrat',
                                    fontSize: 15,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                const SizedBox(
                                  height: 15,
                                ),
                                Obx(() {
                                  return Text(
                                    '${AppSingletons.storedInvoiceCurrency.value}${AppSingletons.totalUnpaidInvoices.value}',
                                    style: const TextStyle(
                                      fontFamily: 'Montserrat',
                                      fontSize: 17,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  );
                                }),
                                const SizedBox(
                                  height: 10,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            decoration: BoxDecoration(
                              color: sWhite,
                              boxShadow: const [
                                BoxShadow(
                                    color: grey_4,
                                    spreadRadius: 1,
                                    blurRadius: 10,
                                    offset: Offset(2, 1))
                              ],
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Column(
                              children: [
                                const SizedBox(
                                  height: 10,
                                ),
                                const Text(
                                  'Total Overdue',
                                  style: TextStyle(
                                    fontFamily: 'Montserrat',
                                    fontSize: 15,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                const SizedBox(
                                  height: 15,
                                ),
                                Obx(() {
                                  return Text(
                                    '${AppSingletons.storedInvoiceCurrency.value}${AppSingletons.totalOverdueInvoices.value}',
                                    style: const TextStyle(
                                        fontFamily: 'Montserrat',
                                        fontSize: 17,
                                        fontWeight: FontWeight.w700,
                                        color: orangeMedium_1),
                                  );
                                }),
                                const SizedBox(
                                  height: 10,
                                ),
                              ],
                            ),
                          ),
                        ],
                      )),
                  const SizedBox(
                    width: 20,
                  ),
                ],
              ),
            ],
          )),
        ));
  }

  Future selectInvoiceStatus(BuildContext context, int itemPrice, int invoiceId,
      bool isOverdue, String invoicePaidStatus) async {
    debugPrint('Inside method isOverdue: $isOverdue');
    return showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          controller.invoicePaidStatus.value = invoicePaidStatus;
          return AlertDialog(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            title: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                  color: mainPurpleColor,
                  borderRadius: BorderRadius.circular(8)),
              alignment: Alignment.center,
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Text('mark_as'.tr,
                  style: const TextStyle(
                      fontFamily: 'Montserrat',
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: sWhite)),
            ),
            content: Obx(() {
              return Form(
                key: controller.formKey,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ListTile(
                        contentPadding: EdgeInsets.zero,
                        onTap: () {
                          controller.invoicePaidStatus.value =
                              AppConstants.paidInvoice;
                          debugPrint(controller.invoicePaidStatus.value);
                        },
                        title: Text(
                          'paid'.tr,
                          style: const TextStyle(
                              fontFamily: 'Montserrat',
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: blackColor),
                        ),
                        trailing: Visibility(
                          visible: controller.invoicePaidStatus.value ==
                              AppConstants.paidInvoice,
                          child: const Icon(
                            Icons.check,
                            color: mainPurpleColor,
                          ),
                        ),
                      ),
                      ListTile(
                        contentPadding: EdgeInsets.zero,
                        onTap: () {
                          controller.invoicePaidStatus.value =
                              AppConstants.unpaidInvoice;
                          debugPrint(controller.invoicePaidStatus.value);
                        },
                        title: Text(
                          'unpaid'.tr,
                          style: const TextStyle(
                              fontFamily: 'Montserrat',
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: blackColor),
                        ),
                        trailing: Visibility(
                          visible: controller.invoicePaidStatus.value ==
                              AppConstants.unpaidInvoice,
                          child: const Icon(
                            Icons.check,
                            color: mainPurpleColor,
                          ),
                        ),
                      ),
                      ListTile(
                        contentPadding: EdgeInsets.zero,
                        onTap: () {
                          controller.invoicePaidStatus.value =
                              AppConstants.partiallyPaidInvoice;
                          debugPrint(controller.invoicePaidStatus.value);
                        },
                        title: Text(
                          'partially_paid'.tr,
                          style: const TextStyle(
                              fontFamily: 'Montserrat',
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: blackColor),
                        ),
                        subtitle: Visibility(
                          visible: controller.invoicePaidStatus.value ==
                              AppConstants.partiallyPaidInvoice,
                          child: Container(
                            padding: const EdgeInsets.only(top: 10),
                            child: CommonTextField(
                              textEditingController:
                                  controller.partiallyPaidController,
                              textInputAction: TextInputAction.done,
                              textInputType: TextInputType.number,
                              hintText: 'enter_amount'.tr,
                              inputFormatter: [AmountInputFormatter()],
                              validator: (_) {
                                if (controller
                                    .partiallyPaidController.text.isEmpty) {
                                  return 'please_enter_amount'.tr;
                                } else if (int.parse(controller
                                        .partiallyPaidController.text) >=
                                    itemPrice) {
                                  return 'larger_amount_than_total'.tr;
                                } else {
                                  return null;
                                }
                              },
                            ),
                          ),
                        ),
                        trailing: Visibility(
                          visible: controller.invoicePaidStatus.value ==
                              AppConstants.partiallyPaidInvoice,
                          child: const Icon(
                            Icons.check,
                            color: mainPurpleColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
            actions: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        controller.invoicePaidStatus.value =
                            AppSingletons.invoiceStatus.value;
                        Utils.clearInvoiceVariables();
                        Get.back();
                      },
                      child: Container(
                        width: double.infinity,
                        alignment: Alignment.center,
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        decoration: const BoxDecoration(
                            color: grey_4,
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(5),
                                bottomLeft: Radius.circular(5))),
                        child: Text(
                          'cancel'.tr,
                          style: const TextStyle(
                            fontFamily: 'Montserrat',
                            color: sWhite,
                            fontWeight: FontWeight.w500,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap: () async {
                        if (controller.invoicePaidStatus.value ==
                            AppConstants.partiallyPaidInvoice) {
                          if (controller.formKey.currentState!.validate()) {
                            AppSingletons.invoiceStatus.value =
                                controller.invoicePaidStatus.value.tr;
                            AppSingletons.partialPaymentAmount?.value =
                                controller.partiallyPaidController.text;
                            debugPrint(
                                '${AppSingletons.partialPaymentAmount?.value}');
                            await controller.updatePaidStatusInDatabase(
                                invoiceId,
                                controller.invoicePaidStatus.value.tr,
                                controller.partiallyPaidController.text);
                            controller.isFilteringList.value = false;
                            controller.selectedName.value = '';
                            controller.fromDate.value = null;
                            controller.toDate.value = null;
                            controller.partiallyPaidController.text = '';
                          }
                        } else {
                          AppSingletons.partialPaymentAmount?.value = '';
                          controller.partiallyPaidController.text = '';
                          AppSingletons.invoiceStatus.value =
                              controller.invoicePaidStatus.value.tr;
                          await controller.updatePaidStatusInDatabase(invoiceId,
                              controller.invoicePaidStatus.value, ''.tr);

                          controller.isFilteringList.value = false;
                          controller.selectedName.value = '';
                          controller.fromDate.value = null;
                          controller.toDate.value = null;
                        }
                      },
                      child: Container(
                        width: double.infinity,
                        alignment: Alignment.center,
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        decoration: const BoxDecoration(
                            color: mainPurpleColor,
                            borderRadius: BorderRadius.only(
                                topRight: Radius.circular(5),
                                bottomRight: Radius.circular(5))),
                        child: Text(
                          'change'.tr,
                          style: const TextStyle(
                            fontFamily: 'Montserrat',
                            color: sWhite,
                            fontWeight: FontWeight.w500,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          );
        });
  }

  Widget showListAccordingToSelectedTap() {
    return Obx(() {
      if (controller.listShowingType.value == AppConstants.all) {
        return controller.filteredDataList.value.isNotEmpty
            ? ListView.builder(
                itemCount: controller.filteredDataList.value.length,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  int reverse =
                      controller.filteredDataList.value.length - 1 - index;
                  var note = controller.filteredDataList.value[reverse];

                  return GestureDetector(
                    onTap: () {
                      debugPrint('Sent ID: ${note.id}');

                      Get.toNamed(Routes.savedPdfView);

                      AppSingletons.isPreviewingPdfBeforeSave.value = false;

                      AppSingletons.isInvoiceDocument.value = true;

                      AppSingletons.isMakingNewINVEST.value = false;

                      AppSingletons.invoiceIdWhichWillEdit.value = note.id ?? 0;

                      AppSingletons.isEditInvoice.value = true;

                      AppSingletons.isEditEstimate.value = false;
                    },
                    onLongPress: () {
                      CustomDialogues.showDialogueToDelete(
                          false,
                          'delete_invoice'.tr,
                          'are_you_sure_you_want_to_delete'.tr,
                          '?',
                          () => controller.deleteInvoice(note.id!),
                          () => controller.loadInvoiceData());
                    },
                    child: Container(
                      constraints: const BoxConstraints(
                        minHeight: 100,
                      ),
                      margin: EdgeInsets.symmetric(
                        horizontal:
                            AppConstants.isMobileScreen.value ? 15 : 50.0,
                        vertical: 5.0,
                      ),
                      decoration: BoxDecoration(
                        color: sWhite,
                        borderRadius: BorderRadius.circular(12),
                        // border: const Border(
                        //   top: BorderSide(
                        //     color: mainPurpleColor,
                        //     width: 1,
                        //   ),
                        //   left: BorderSide(
                        //     color: mainPurpleColor,
                        //     width: 1,
                        //   ),
                        //   right: BorderSide(
                        //     color: mainPurpleColor,
                        //     width: 1,
                        //   ),
                        // ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(
                            height: 8,
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 5),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: Text(
                                    note.invoiceId.toString(),
                                    textAlign: TextAlign.start,
                                    style: const TextStyle(
                                        fontFamily: 'Montserrat',
                                        color: orangeDark_3,
                                        fontSize: 15,
                                        fontWeight: FontWeight.w500),
                                  ),
                                ),
                                Expanded(
                                  child: Text(
                                    note.clientName.toString(),
                                    textAlign: TextAlign.end,
                                    style: const TextStyle(
                                        fontFamily: 'Montserrat',
                                        color: orangeDark_3,
                                        fontSize: 15,
                                        fontWeight: FontWeight.w500),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 5),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  DateFormat('dd-MMM-yyyy').format(
                                      DateTime.parse(
                                          note.startDate.toString())),
                                  style: const TextStyle(
                                      fontFamily: 'Montserrat',
                                      color: orangeDark_3,
                                      fontSize: 15,
                                      fontWeight: FontWeight.w500),
                                ),
                                Row(
                                  children: [
                                    Text(
                                      '${note.currencyName ?? ''} ',
                                      style: const TextStyle(
                                          fontFamily: 'Montserrat',
                                          color: orangeDark_3,
                                          fontSize: 15,
                                          fontWeight: FontWeight.w700),
                                    ),
                                    Text(
                                      note.itemPrice.toString(),
                                      style: const TextStyle(
                                          fontFamily: 'Montserrat',
                                          color: orangeDark_3,
                                          fontSize: 15,
                                          fontWeight: FontWeight.w700),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Visibility(
                                visible: note.invoicePaidStatus !=
                                        AppConstants.paidInvoice &&
                                    !note.isOverdue!,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8, vertical: 5),
                                  child: Text(
                                    note.dueDaysData ?? '',
                                    style: const TextStyle(
                                      fontFamily: 'Montserrat',
                                      color: orangeDark_3,
                                    ),
                                  ),
                                ),
                              ),
                              Visibility(
                                visible: note.invoicePaidStatus ==
                                    AppConstants.partiallyPaidInvoice,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8, vertical: 5),
                                  child: Text(
                                    '${AppSingletons.storedInvoiceCurrency.value} ${note.remainingPayableAmount ?? ''}',
                                    style: const TextStyle(
                                      fontFamily: 'Montserrat',
                                      color: redTemplate,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 5),
                            decoration: const BoxDecoration(
                                borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(12),
                                  bottomRight: Radius.circular(12),
                                ),
                                color: grey_5),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Visibility(
                                  visible:
                                      note.partialPaymentAmount!.isNotEmpty,
                                  child: Text(
                                    '${AppSingletons.storedInvoiceCurrency.value}${note.partialPaymentAmount ?? 'paid'.tr} ',
                                    style: const TextStyle(
                                        fontFamily: 'Montserrat',
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                        color: blackColor),
                                  ),
                                ),
                                SizedBox(
                                  height: 33,
                                  child: TextButton(
                                    style: TextButton.styleFrom(
                                        backgroundColor:
                                            controller.giveInvoiceStatusColor(
                                                note.isOverdue ?? false,
                                                note.invoicePaidStatus
                                                    .toString())),
                                    onPressed: () {
                                      selectInvoiceStatus(
                                          context,
                                          note.itemPrice ?? 0,
                                          note.id!,
                                          note.isOverdue ?? false,
                                          note.invoicePaidStatus.toString());

                                      debugPrint('Selected Id: ${note.id}');
                                    },
                                    child: Text(
                                        // note.invoicePaidStatus ==
                                        //     AppConstants.paidInvoice
                                        //     ? 'paid'.tr ?? ''
                                        //     : note.isOverdue!
                                        //     ? 'overdue'.tr
                                        //     : note.invoicePaidStatus ??
                                        //     ''
                                      controller.getInvoiceStatusText(
                                          note.isOverdue ?? false,
                                          note.invoicePaidStatus.toString()
                                      ),
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                          fontFamily: 'Montserrat',
                                          fontSize: 12,
                                          fontWeight: FontWeight.w600,
                                          color: sWhite),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(
                    height: 80,
                  ),
                  Image.asset(
                    'assets/icons/empty_box.png',
                    height: 120,
                    width: 120,
                    color: mainPurpleColor.withOpacity(0.7),
                  ),
                  Text(
                    'tap_plus_to_create_invoice'.tr,
                    style: const TextStyle(
                        fontFamily: 'Montserrat',
                        color: blackColor,
                        fontWeight: FontWeight.w600,
                        fontSize: 16),
                  )
                ],
              );
      } else if (controller.listShowingType.value ==
          AppConstants.unpaidInvoice) {
        return controller.filteredUnpaidList.value.isNotEmpty
            ? ListView.builder(
                itemCount: controller.filteredUnpaidList.value.length,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  int reverse =
                      controller.filteredUnpaidList.value.length - 1 - index;
                  var note = controller.filteredUnpaidList.value[reverse];

                  return GestureDetector(
                    onTap: () {
                      debugPrint('Sent ID: ${note.id}');

                      Get.toNamed(Routes.savedPdfView);

                      AppSingletons.isMakingNewINVEST.value = false;

                      AppSingletons.isPreviewingPdfBeforeSave.value = false;

                      AppSingletons.isInvoiceDocument.value = true;

                      AppSingletons.invoiceIdWhichWillEdit.value = note.id ?? 0;

                      AppSingletons.isEditInvoice.value = true;

                      AppSingletons.isEditEstimate.value = false;
                    },
                    onLongPress: () {
                      CustomDialogues.showDialogueToDelete(
                          false,
                          'delete_invoice'.tr,
                          'are_you_sure_you_want_to_delete'.tr,
                          '?',
                          () => controller.deleteInvoice(note.id!),
                          () => controller.loadInvoiceData());
                    },
                    child: Container(
                      constraints: const BoxConstraints(
                        minHeight: 100,
                      ),
                      margin: EdgeInsets.symmetric(
                        horizontal:
                            AppConstants.isMobileScreen.value ? 15 : 50.0,
                        vertical: 5.0,
                      ),
                      decoration: BoxDecoration(
                        color: sWhite,
                        borderRadius: BorderRadius.circular(12),
                        // border: const Border(
                        //   top: BorderSide(
                        //     color: mainPurpleColor,
                        //     width: 1,
                        //   ),
                        //   left: BorderSide(
                        //     color: mainPurpleColor,
                        //     width: 1,
                        //   ),
                        //   right: BorderSide(
                        //     color: mainPurpleColor,
                        //     width: 1,
                        //   ),
                        // ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(
                            height: 8,
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 5),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: Text(
                                    note.invoiceId.toString(),
                                    textAlign: TextAlign.start,
                                    style: const TextStyle(
                                        fontFamily: 'Montserrat',
                                        color: orangeDark_3,
                                        fontSize: 15,
                                        fontWeight: FontWeight.w500),
                                  ),
                                ),
                                Expanded(
                                  child: Text(
                                    note.clientName.toString(),
                                    textAlign: TextAlign.end,
                                    style: const TextStyle(
                                        fontFamily: 'Montserrat',
                                        color: orangeDark_3,
                                        fontSize: 15,
                                        fontWeight: FontWeight.w500),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 5),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  DateFormat('dd-MMM-yyyy').format(
                                      DateTime.parse(
                                          note.startDate.toString())),
                                  style: const TextStyle(
                                      fontFamily: 'Montserrat',
                                      color: orangeDark_3,
                                      fontSize: 15,
                                      fontWeight: FontWeight.w500),
                                ),
                                Row(
                                  children: [
                                    Text(
                                      '${note.currencyName ?? ''} ',
                                      style: const TextStyle(
                                          fontFamily: 'Montserrat',
                                          color: orangeDark_3,
                                          fontSize: 15,
                                          fontWeight: FontWeight.w700),
                                    ),
                                    Text(
                                      note.itemPrice.toString(),
                                      style: const TextStyle(
                                          fontFamily: 'Montserrat',
                                          color: orangeDark_3,
                                          fontSize: 15,
                                          fontWeight: FontWeight.w700),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          Visibility(
                            visible: note.invoicePaidStatus !=
                                    AppConstants.paidInvoice &&
                                !note.isOverdue!,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 5),
                              child: Text(
                                note.dueDaysData ?? '',
                                style: const TextStyle(
                                  fontFamily: 'Montserrat',
                                  color: orangeDark_3,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 5),
                            decoration: const BoxDecoration(
                                borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(12),
                                  bottomRight: Radius.circular(12),
                                ),
                                color: grey_5),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Visibility(
                                  visible:
                                      note.partialPaymentAmount!.isNotEmpty,
                                  child: Text(
                                    '${AppSingletons.storedInvoiceCurrency.value}${note.partialPaymentAmount ?? ''}',
                                    style: const TextStyle(
                                        fontFamily: 'Montserrat',
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                        color: blackColor),
                                  ),
                                ),
                                SizedBox(
                                  height: 33,
                                  child: TextButton(
                                    style: TextButton.styleFrom(
                                        backgroundColor:
                                            controller.giveInvoiceStatusColor(
                                                note.isOverdue ?? false,
                                                note.invoicePaidStatus
                                                    .toString())),
                                    onPressed: () {
                                      selectInvoiceStatus(
                                          context,
                                          note.itemPrice ?? 0,
                                          note.id!,
                                          note.isOverdue ?? false,
                                          note.invoicePaidStatus.toString());

                                      debugPrint('Selected Id: ${note.id}');
                                    },
                                    child: Text(
                                        controller.getInvoiceStatusText(
                                            note.isOverdue ?? false,
                                            note.invoicePaidStatus.toString()
                                        ),
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                          fontFamily: 'Montserrat',
                                          fontSize: 12,
                                          fontWeight: FontWeight.w600,
                                          color: sWhite),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(
                    height: 80,
                  ),
                  Image.asset(
                    'assets/icons/empty_box.png',
                    height: 120,
                    width: 120,
                    color: mainPurpleColor.withOpacity(0.7),
                  ),
                  Text(
                    'no_invoice'.tr,
                    style: const TextStyle(
                        fontFamily: 'Montserrat',
                        color: blackColor,
                        fontWeight: FontWeight.w600,
                        fontSize: 16),
                  )
                ],
              );
      } else if (controller.listShowingType.value ==
          AppConstants.partiallyPaidInvoice) {
        return controller.filteredPPList.value.isNotEmpty
            ? ListView.builder(
                itemCount: controller.filteredPPList.value.length,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  int reverse =
                      controller.filteredPPList.value.length - 1 - index;
                  var note = controller.filteredPPList.value[reverse];

                  return GestureDetector(
                    onTap: () {
                      debugPrint('Sent ID: ${note.id}');
                      debugPrint(
                          'Partially Paid ON UI: ${note.partialPaymentAmount}');

                      Get.toNamed(Routes.savedPdfView);

                      AppSingletons.isMakingNewINVEST.value = false;

                      AppSingletons.isPreviewingPdfBeforeSave.value = false;

                      AppSingletons.invoiceIdWhichWillEdit.value = note.id ?? 0;

                      AppSingletons.isInvoiceDocument.value = true;

                      AppSingletons.isEditInvoice.value = true;

                      AppSingletons.isEditEstimate.value = false;
                    },
                    onLongPress: () {
                      CustomDialogues.showDialogueToDelete(
                          false,
                          'delete_invoice'.tr,
                          'are_you_sure_you_want_to_delete'.tr,
                          '?',
                          () => controller.deleteInvoice(note.id!),
                          () => controller.loadInvoiceData());
                    },
                    child: Container(
                      constraints: const BoxConstraints(
                        minHeight: 100,
                      ),
                      margin: EdgeInsets.symmetric(
                        horizontal:
                            AppConstants.isMobileScreen.value ? 15 : 50.0,
                        vertical: 5.0,
                      ),
                      decoration: BoxDecoration(
                        color: sWhite,
                        borderRadius: BorderRadius.circular(12),
                        // border: const Border(
                        //   top: BorderSide(
                        //     color: mainPurpleColor,
                        //     width: 1,
                        //   ),
                        //   left: BorderSide(
                        //     color: mainPurpleColor,
                        //     width: 1,
                        //   ),
                        //   right: BorderSide(
                        //     color: mainPurpleColor,
                        //     width: 1,
                        //   ),
                        // ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(
                            height: 8,
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 5),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: Text(
                                    note.invoiceId.toString(),
                                    textAlign: TextAlign.start,
                                    style: const TextStyle(
                                        fontFamily: 'Montserrat',
                                        color: orangeDark_3,
                                        fontSize: 15,
                                        fontWeight: FontWeight.w500),
                                  ),
                                ),
                                Expanded(
                                  child: Text(
                                    note.clientName.toString(),
                                    textAlign: TextAlign.end,
                                    style: const TextStyle(
                                        fontFamily: 'Montserrat',
                                        color: orangeDark_3,
                                        fontSize: 15,
                                        fontWeight: FontWeight.w500),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 5),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  DateFormat('dd-MMM-yyyy').format(
                                      DateTime.parse(
                                          note.startDate.toString())),
                                  style: const TextStyle(
                                      fontFamily: 'Montserrat',
                                      color: orangeDark_3,
                                      fontSize: 15,
                                      fontWeight: FontWeight.w500),
                                ),
                                Row(
                                  children: [
                                    Text(
                                      '${note.currencyName ?? ''} ',
                                      style: const TextStyle(
                                          fontFamily: 'Montserrat',
                                          color: orangeDark_3,
                                          fontSize: 15,
                                          fontWeight: FontWeight.w700),
                                    ),
                                    Text(
                                      note.itemPrice.toString(),
                                      style: const TextStyle(
                                          fontFamily: 'Montserrat',
                                          color: orangeDark_3,
                                          fontSize: 15,
                                          fontWeight: FontWeight.w700),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Visibility(
                                visible: note.invoicePaidStatus !=
                                        AppConstants.paidInvoice &&
                                    !note.isOverdue!,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8, vertical: 5),
                                  child: Text(
                                    note.dueDaysData ?? '',
                                    style: const TextStyle(
                                      fontFamily: 'Montserrat',
                                      color: orangeDark_3,
                                    ),
                                  ),
                                ),
                              ),
                              Visibility(
                                visible: note.invoicePaidStatus ==
                                    AppConstants.partiallyPaidInvoice,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8, vertical: 5),
                                  child: Text(
                                    '${AppSingletons.storedInvoiceCurrency.value} ${note.remainingPayableAmount ?? ''}',
                                    style: const TextStyle(
                                      fontFamily: 'Montserrat',
                                      color: redTemplate,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 5),
                            decoration: const BoxDecoration(
                                borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(12),
                                  bottomRight: Radius.circular(12),
                                ),
                                color: grey_5),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Visibility(
                                  visible:
                                      note.partialPaymentAmount!.isNotEmpty,
                                  child: Text(
                                    '${AppSingletons.storedInvoiceCurrency.value}${note.partialPaymentAmount ?? ''} Paid',
                                    style: const TextStyle(
                                        fontFamily: 'Montserrat',
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                        color: blackColor),
                                  ),
                                ),
                                SizedBox(
                                  height: 33,
                                  child: TextButton(
                                    style: TextButton.styleFrom(
                                        backgroundColor:
                                            controller.giveInvoiceStatusColor(
                                                note.isOverdue ?? false,
                                                note.invoicePaidStatus
                                                    .toString())),
                                    onPressed: () {
                                      selectInvoiceStatus(
                                          context,
                                          note.itemPrice ?? 0,
                                          note.id!,
                                          note.isOverdue ?? false,
                                          note.invoicePaidStatus.toString());

                                      debugPrint('Selected Id: ${note.id}');
                                    },
                                    child: Text(
                                      controller.getInvoiceStatusText(
                                          note.isOverdue ?? false,
                                          note.invoicePaidStatus.toString()
                                      ),
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                          fontFamily: 'Montserrat',
                                          fontSize: 12,
                                          fontWeight: FontWeight.w600,
                                          color: sWhite),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(
                    height: 80,
                  ),
                  Image.asset(
                    'assets/icons/empty_box.png',
                    height: 120,
                    width: 120,
                    color: mainPurpleColor.withOpacity(0.7),
                  ),
                  Text(
                    'no_invoice'.tr,
                    style: const TextStyle(
                        fontFamily: 'Montserrat',
                        color: blackColor,
                        fontWeight: FontWeight.w600,
                        fontSize: 16),
                  )
                ],
              );
      } else if (controller.listShowingType.value == AppConstants.overdue) {
        return controller.filteredOverdueList.value.isNotEmpty
            ? ListView.builder(
                itemCount: controller.filteredOverdueList.value.length,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  int reverse =
                      controller.filteredOverdueList.value.length - 1 - index;
                  var note = controller.filteredOverdueList.value[reverse];

                  return GestureDetector(
                    onTap: () {
                      debugPrint('Sent ID: ${note.id}');

                      Get.toNamed(Routes.savedPdfView);

                      AppSingletons.isMakingNewINVEST.value = false;

                      AppSingletons.isPreviewingPdfBeforeSave.value = false;

                      AppSingletons.isInvoiceDocument.value = true;

                      AppSingletons.invoiceIdWhichWillEdit.value = note.id ?? 0;

                      AppSingletons.isEditInvoice.value = true;

                      AppSingletons.isEditEstimate.value = false;
                    },
                    onLongPress: () {
                      CustomDialogues.showDialogueToDelete(
                          false,
                          'delete_invoice'.tr,
                          'are_you_sure_you_want_to_delete'.tr,
                          '?',
                          () => controller.deleteInvoice(note.id!),
                          () => controller.loadInvoiceData());
                    },
                    child: Container(
                      constraints: const BoxConstraints(
                        minHeight: 100,
                      ),
                      margin: EdgeInsets.symmetric(
                        horizontal:
                            AppConstants.isMobileScreen.value ? 15 : 50.0,
                        vertical: 5.0,
                      ),
                      decoration: BoxDecoration(
                        color: sWhite,
                        borderRadius: BorderRadius.circular(12),
                        // border: const Border(
                        //   top: BorderSide(
                        //     color: mainPurpleColor,
                        //     width: 1,
                        //   ),
                        //   left: BorderSide(
                        //     color: mainPurpleColor,
                        //     width: 1,
                        //   ),
                        //   right: BorderSide(
                        //     color: mainPurpleColor,
                        //     width: 1,
                        //   ),
                        // ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(
                            height: 8,
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 5),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: Text(
                                    note.invoiceId.toString(),
                                    textAlign: TextAlign.start,
                                    style: const TextStyle(
                                        fontFamily: 'Montserrat',
                                        color: orangeDark_3,
                                        fontSize: 15,
                                        fontWeight: FontWeight.w500),
                                  ),
                                ),
                                Expanded(
                                  child: Text(
                                    note.clientName.toString(),
                                    textAlign: TextAlign.end,
                                    style: const TextStyle(
                                        fontFamily: 'Montserrat',
                                        color: orangeDark_3,
                                        fontSize: 15,
                                        fontWeight: FontWeight.w500),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 5),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  DateFormat('dd-MMM-yyyy').format(
                                      DateTime.parse(
                                          note.startDate.toString())),
                                  style: const TextStyle(
                                      fontFamily: 'Montserrat',
                                      color: orangeDark_3,
                                      fontSize: 15,
                                      fontWeight: FontWeight.w500),
                                ),
                                Row(
                                  children: [
                                    Text(
                                      '${note.currencyName ?? ''} ',
                                      style: const TextStyle(
                                          fontFamily: 'Montserrat',
                                          color: orangeDark_3,
                                          fontSize: 15,
                                          fontWeight: FontWeight.w700),
                                    ),
                                    Text(
                                      note.itemPrice.toString(),
                                      style: const TextStyle(
                                          fontFamily: 'Montserrat',
                                          color: orangeDark_3,
                                          fontSize: 15,
                                          fontWeight: FontWeight.w700),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Visibility(
                                visible: note.invoicePaidStatus !=
                                        AppConstants.paidInvoice &&
                                    !note.isOverdue!,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8, vertical: 5),
                                  child: Text(
                                    note.dueDaysData ?? '',
                                    style: const TextStyle(
                                      fontFamily: 'Montserrat',
                                      color: orangeDark_3,
                                    ),
                                  ),
                                ),
                              ),
                              Visibility(
                                visible: note.invoicePaidStatus ==
                                    AppConstants.partiallyPaidInvoice,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8, vertical: 5),
                                  child: Text(
                                    '${AppSingletons.storedInvoiceCurrency.value} ${note.remainingPayableAmount ?? ''}',
                                    style: const TextStyle(
                                      fontFamily: 'Montserrat',
                                      color: redTemplate,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 5),
                            decoration: const BoxDecoration(
                                borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(12),
                                  bottomRight: Radius.circular(12),
                                ),
                                color: grey_5),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Visibility(
                                  visible:
                                      note.partialPaymentAmount!.isNotEmpty,
                                  child: Text(
                                    '${AppSingletons.storedInvoiceCurrency.value}${note.partialPaymentAmount ?? ''}',
                                    style: const TextStyle(
                                        fontFamily: 'Montserrat',
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                        color: blackColor),
                                  ),
                                ),
                                SizedBox(
                                  height: 33,
                                  child: TextButton(
                                    style: TextButton.styleFrom(
                                        backgroundColor:
                                            controller.giveInvoiceStatusColor(
                                                note.isOverdue ?? false,
                                                note.invoicePaidStatus
                                                    .toString())),
                                    onPressed: () {
                                      selectInvoiceStatus(
                                          context,
                                          note.itemPrice ?? 0,
                                          note.id!,
                                          note.isOverdue ?? false,
                                          note.invoicePaidStatus.toString());

                                      debugPrint('Selected Id: ${note.id}');
                                    },
                                    child: Text(
                                      controller.getInvoiceStatusText(
                                          note.isOverdue ?? false,
                                          note.invoicePaidStatus.toString()
                                      ),
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                          fontFamily: 'Montserrat',
                                          fontSize: 12,
                                          fontWeight: FontWeight.w600,
                                          color: sWhite),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(
                    height: 80,
                  ),
                  Image.asset(
                    'assets/icons/empty_box.png',
                    height: 120,
                    width: 120,
                    color: mainPurpleColor.withOpacity(0.7),
                  ),
                  Text(
                    'no_invoice'.tr,
                    style: const TextStyle(
                        fontFamily: 'Montserrat',
                        color: blackColor,
                        fontWeight: FontWeight.w600,
                        fontSize: 16),
                  )
                ],
              );
      } else if (controller.listShowingType.value == AppConstants.paidInvoice) {
        return controller.filteredPaidList.value.isNotEmpty
            ? ListView.builder(
                itemCount: controller.filteredPaidList.value.length,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  int reverse =
                      controller.filteredPaidList.value.length - 1 - index;
                  var note = controller.filteredPaidList.value[reverse];

                  return GestureDetector(
                    onTap: () {
                      debugPrint('Sent ID: ${note.id}');

                      Get.toNamed(Routes.savedPdfView);

                      AppSingletons.isMakingNewINVEST.value = false;

                      AppSingletons.isPreviewingPdfBeforeSave.value = false;

                      AppSingletons.isInvoiceDocument.value = true;

                      AppSingletons.invoiceIdWhichWillEdit.value = note.id ?? 0;

                      AppSingletons.isEditInvoice.value = true;

                      AppSingletons.isEditEstimate.value = false;
                    },
                    onLongPress: () {
                      CustomDialogues.showDialogueToDelete(
                          false,
                          'delete_invoice'.tr,
                          'are_you_sure_you_want_to_delete'.tr,
                          '?',
                          () => controller.deleteInvoice(note.id!),
                          () => controller.loadInvoiceData());
                    },
                    child: Container(
                      constraints: const BoxConstraints(
                        minHeight: 100,
                      ),
                      margin: EdgeInsets.symmetric(
                        horizontal:
                            AppConstants.isMobileScreen.value ? 15 : 50.0,
                        vertical: 5.0,
                      ),
                      decoration: BoxDecoration(
                        color: sWhite,
                        borderRadius: BorderRadius.circular(12),
                        // border: const Border(
                        //   top: BorderSide(
                        //     color: mainPurpleColor,
                        //     width: 1,
                        //   ),
                        //   left: BorderSide(
                        //     color: mainPurpleColor,
                        //     width: 1,
                        //   ),
                        //   right: BorderSide(
                        //     color: mainPurpleColor,
                        //     width: 1,
                        //   ),
                        // ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(
                            height: 8,
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 5),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: Text(
                                    note.invoiceId.toString(),
                                    textAlign: TextAlign.start,
                                    style: const TextStyle(
                                        fontFamily: 'Montserrat',
                                        color: orangeDark_3,
                                        fontSize: 15,
                                        fontWeight: FontWeight.w500),
                                  ),
                                ),
                                Expanded(
                                  child: Text(
                                    note.clientName.toString(),
                                    textAlign: TextAlign.end,
                                    style: const TextStyle(
                                        fontFamily: 'Montserrat',
                                        color: orangeDark_3,
                                        fontSize: 15,
                                        fontWeight: FontWeight.w500),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 5),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  DateFormat('dd-MMM-yyyy').format(
                                      DateTime.parse(
                                          note.startDate.toString())),
                                  style: const TextStyle(
                                      fontFamily: 'Montserrat',
                                      color: orangeDark_3,
                                      fontSize: 15,
                                      fontWeight: FontWeight.w500),
                                ),
                                Row(
                                  children: [
                                    Text(
                                      '${note.currencyName ?? ''} ',
                                      style: const TextStyle(
                                          fontFamily: 'Montserrat',
                                          color: orangeDark_3,
                                          fontSize: 15,
                                          fontWeight: FontWeight.w700),
                                    ),
                                    Text(
                                      note.itemPrice.toString(),
                                      style: const TextStyle(
                                          fontFamily: 'Montserrat',
                                          color: orangeDark_3,
                                          fontSize: 15,
                                          fontWeight: FontWeight.w700),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          Visibility(
                            visible: note.invoicePaidStatus !=
                                    AppConstants.paidInvoice &&
                                !note.isOverdue!,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 5),
                              child: Text(
                                note.dueDaysData ?? '',
                                style: const TextStyle(
                                  fontFamily: 'Montserrat',
                                  color: orangeDark_3,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 5),
                            decoration: const BoxDecoration(
                                borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(12),
                                  bottomRight: Radius.circular(12),
                                ),
                                color: grey_5),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Visibility(
                                  visible:
                                      note.partialPaymentAmount!.isNotEmpty,
                                  child: Text(
                                    '${AppSingletons.storedInvoiceCurrency.value}${note.partialPaymentAmount ?? ''}',
                                    style: const TextStyle(
                                        fontFamily: 'Montserrat',
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                        color: blackColor),
                                  ),
                                ),
                                SizedBox(
                                  height: 33,
                                  child: TextButton(
                                    style: TextButton.styleFrom(
                                        backgroundColor:
                                            controller.giveInvoiceStatusColor(
                                                note.isOverdue ?? false,
                                                note.invoicePaidStatus
                                                    .toString())),
                                    onPressed: () {
                                      selectInvoiceStatus(
                                          context,
                                          note.itemPrice ?? 0,
                                          note.id!,
                                          note.isOverdue ?? false,
                                          note.invoicePaidStatus.toString());

                                      debugPrint('Selected Id: ${note.id}');
                                    },
                                    child: Text(
                                      controller.getInvoiceStatusText(
                                          note.isOverdue ?? false,
                                          note.invoicePaidStatus.toString()
                                      ),
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                          fontFamily: 'Montserrat',
                                          fontSize: 12,
                                          fontWeight: FontWeight.w600,
                                          color: sWhite),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(
                    height: 80,
                  ),
                  Image.asset(
                    'assets/icons/empty_box.png',
                    height: 120,
                    width: 120,
                    color: mainPurpleColor.withOpacity(0.7),
                  ),
                  Text(
                    'no_invoice'.tr,
                    style: const TextStyle(
                        fontFamily: 'Montserrat',
                        color: blackColor,
                        fontWeight: FontWeight.w600,
                        fontSize: 16),
                  )
                ],
              );
      } else {
        return Container();
      }
    });
  }

  Future addFilterByClientAndDate(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            contentPadding: EdgeInsets.zero,
            backgroundColor: sWhite,
            title: Text(
              'filter_by'.tr,
              style: const TextStyle(
                fontFamily: 'Montserrat',
                fontSize: 17,
                fontWeight: FontWeight.w700,
                color: mainPurpleColor,
              ),
            ),
            content: Container(
              margin: const EdgeInsets.symmetric(horizontal: 24),
              height: 250,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 15,
                  ),
                  Text(
                    'client_name'.tr,
                    style: const TextStyle(
                      fontFamily: 'Montserrat',
                      fontSize: 14,
                      color: grey_4,
                    ),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Container(
                    width: double.infinity,
                    height: 45,
                    decoration: BoxDecoration(
                        color: textFieldColor,
                        borderRadius: BorderRadius.circular(5)),
                    child: PopupMenuButton(
                      itemBuilder: (BuildContext context) {
                        return controller.allClientNameList.map((client) {
                          return PopupMenuItem<String>(
                            value: client.clientName,
                            child: Text(client.clientName.toString()),
                          );
                        }).toList();
                      },
                      onSelected: (String value) {
                        controller.selectedName.value = value;
                        print(value);
                      },
                      child: Container(
                        width: double.infinity,
                        height: 45,
                        decoration: BoxDecoration(
                            color: textFieldColor,
                            borderRadius: BorderRadius.circular(5)),
                        alignment: Alignment.center,
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Obx(() {
                              return Text(
                                controller.selectedName.value.isNotEmpty
                                    ? controller.selectedName.value
                                    : 'all_clients'.tr,
                                style: const TextStyle(
                                  fontFamily: 'Montserrat',
                                  fontSize: 14,
                                  color: blackColor,
                                ),
                              );
                            }),
                            const Icon(
                              Icons.arrow_drop_down_sharp,
                              color: blackColor,
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Text(
                    'creation_date'.tr,
                    style: const TextStyle(
                      fontFamily: 'Montserrat',
                      fontSize: 14,
                      color: grey_4,
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              'date_from'.tr,
                              style: const TextStyle(
                                fontFamily: 'Montserrat',
                                fontSize: 12,
                                color: blackColor,
                              ),
                            ),
                            const SizedBox(
                              height: 3,
                            ),
                            GestureDetector(
                              onTap: () {
                                _creationDateAndTime(context);
                              },
                              child: Container(
                                width: double.infinity,
                                height: 50,
                                decoration: BoxDecoration(
                                    color: textFieldColor,
                                    borderRadius: BorderRadius.circular(5)),
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 6),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Obx(() {
                                      return Text(
                                        controller.fromDate.value != null
                                            ? DateFormat('dd-MM-yyyy')
                                                .format(
                                                    controller.fromDate.value!)
                                                .toString()
                                            : '',
                                        style: const TextStyle(
                                          fontFamily: 'Montserrat',
                                          fontSize: 12,
                                          color: blackColor,
                                        ),
                                      );
                                    }),
                                    const Icon(
                                      Icons.calendar_month_outlined,
                                      color: blackColor,
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              'date_to'.tr,
                              style: const TextStyle(
                                fontFamily: 'Montserrat',
                                fontSize: 12,
                                color: blackColor,
                              ),
                            ),
                            const SizedBox(
                              height: 3,
                            ),
                            GestureDetector(
                              onTap: () {
                                _dueDateAndTime(context);
                              },
                              child: Container(
                                width: double.infinity,
                                height: 45,
                                decoration: BoxDecoration(
                                    color: textFieldColor,
                                    borderRadius: BorderRadius.circular(5)),
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 6),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Obx(() {
                                      return Text(
                                        controller.toDate.value != null
                                            ? DateFormat('dd-MM-yyyy')
                                                .format(
                                                    controller.toDate.value!)
                                                .toString()
                                            : '',
                                        style: const TextStyle(
                                          fontFamily: 'Montserrat',
                                          fontSize: 12,
                                          color: blackColor,
                                        ),
                                      );
                                    }),
                                    const Icon(
                                      Icons.calendar_month_outlined,
                                      color: blackColor,
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  )
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
                      fontFamily: 'Montserrat', fontSize: 14, color: grey_4),
                ),
              ),
              TextButton(
                onPressed: () {
                  controller.filterData();
                  Get.back();
                },
                child: Text(
                  'apply'.tr,
                  style: const TextStyle(
                      fontFamily: 'Montserrat',
                      fontSize: 14,
                      color: mainPurpleColor),
                ),
              )
            ],
          );
        });
  }

  Future<void> _creationDateAndTime(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
        keyboardType: TextInputType.datetime,
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2000),
        lastDate: DateTime(2101),
        cancelText: 'cancel'.tr,
        confirmText: 'ok'.tr,
        builder: (context, child) {
          return Theme(
              data: Theme.of(context).copyWith(
                colorScheme: ColorScheme.fromSeed(
                  primary: mainPurpleColor,
                  onPrimary: sWhite,
                  seedColor: mainPurpleColor,
                ),
                textButtonTheme: TextButtonThemeData(
                    style: TextButton.styleFrom(
                        foregroundColor: orangeDark_3,
                        textStyle: const TextStyle(
                            fontFamily: 'Montserrat',
                            color: orangeDark_3,
                            fontWeight: FontWeight.w600))),
              ),
              child: child!);
        });

    if (pickedDate != null) {
      controller.dateFrom(pickedDate);
    }
  }

  Future<void> _dueDateAndTime(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2000),
        lastDate: DateTime(2101),
        cancelText: 'cancel'.tr,
        confirmText: 'ok'.tr,
        builder: (context, child) {
          return Theme(
              data: Theme.of(context).copyWith(
                  colorScheme: ColorScheme.fromSeed(
                    primary: mainPurpleColor,
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
      controller.dateTo(pickedDate);
    }
  }
}
