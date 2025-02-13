import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../core/app_singletons/app_singletons.dart';
import '../../core/constants/app_constants/App_Constants.dart';
import '../../core/constants/color/color.dart';
import '../../core/routes/routes.dart';
import '../../core/utils/utils.dart';
import '../../core/widgets/dialogueToDelete.dart';
import 'estimate_list_controller.dart';

class EstimateListView extends GetView<EstimateListController> {

  const EstimateListView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(EstimateListController());

    bool checkIsMobileLayout = AppConstants.isMobileScreen.value;

    return checkIsMobileLayout ? mainMobileLayout(context) : mainDesktopLayout(context);
  }

  Widget mainMobileLayout(BuildContext context){
    return Scaffold(
      backgroundColor: orangeLight_1,
      body: Column(
        children: [
          const SizedBox(width: double.infinity,),
          Obx(() {
            return Visibility(
              visible: AppSingletons.isSearchingEstimate.value,
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
                        hintText: 'Search estimate',
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
          Stack(
            children: [
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Obx(() {
                  return Row(
                    children: [
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
                            'All',
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
                          controller.listShowingType.value = AppConstants.pending;
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 15, vertical: 5),
                          margin: const EdgeInsets.symmetric(horizontal: 5),
                          decoration: BoxDecoration(
                              color: controller.listShowingType.value == AppConstants.pending
                                  ? mainPurpleColor
                                  : offWhite_2,
                              borderRadius: BorderRadius.circular(100)),
                          child: Text(
                            'Pending',
                            style: TextStyle(
                                color: controller.listShowingType.value == AppConstants.pending
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
                          controller.listShowingType.value = AppConstants.approved;
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 15, vertical: 5),
                          margin: const EdgeInsets.symmetric(horizontal: 5),
                          decoration: BoxDecoration(
                              color: controller.listShowingType.value == AppConstants.approved
                                  ? mainPurpleColor
                                  : offWhite_2,
                              borderRadius: BorderRadius.circular(100)),
                          child: Text(
                            'Approved',
                            style: TextStyle(
                                color: controller.listShowingType.value ==
                                    AppConstants.approved
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
                          controller.listShowingType.value = AppConstants.overdue;
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
                            'Overdue',
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
                              AppConstants.cancel;
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 15, vertical: 5),
                          margin: const EdgeInsets.only(left: 5, right: 60),
                          decoration: BoxDecoration(
                              color: controller.listShowingType.value ==
                                  AppConstants.cancel
                                  ? mainPurpleColor
                                  : offWhite_2,
                              borderRadius: BorderRadius.circular(100)),
                          child: Text(
                            'Cancel',
                            style: TextStyle(
                                fontFamily: 'Montserrat',
                                color: controller.listShowingType.value ==
                                    AppConstants.cancel
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
                  onTap: () async{
                    if(controller.isFilteringList.value){
                      // controller.filteredDataList.value = controller.fetchedDataList.value;
                      // controller.filteredPendingList.value = controller.fetchedPendingList.value;
                      // controller.filteredApprovedList.value = controller.fetchedApprovedList.value;
                      // controller.filteredOverdueList.value = controller.fetchedOverdueList.value;
                      // controller.filteredCancelList.value = controller.fetchedCancelList.value;

                      await controller.loadEstimateData();

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
                        color: blackColor,);
                    }),
                  ),
                ),
              )
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          Expanded(
            child: Obx(
                  () =>
              controller.isLoadingData.value
                  ? const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: 100,),
                  CupertinoActivityIndicator(
                    color: mainPurpleColor,
                    radius: 20,
                  ),
                  SizedBox(height: 100,),
                ],
              )
                  : showEstimateList(),
            ),
          ),
        ],
      ),
      floatingActionButton: Obx(() {
        return Visibility(
          visible: !AppSingletons.isKeyboardVisible.value,
          child: FloatingActionButton(
            onPressed: () {

              if(AppSingletons.isSubscriptionEnabled.value){
                AppSingletons.isInvoiceDocument.value = false;
                Get.toNamed(Routes.estimateInputView);
                AppSingletons.isEditEstimate.value = false;
                AppSingletons.isMakingNewINVEST.value = true;
                AppSingletons.isEditingOnlyTemplate.value = false;

                Utils.clearEstimateVariables();
              } else {
                if(AppSingletons.noOfEstimatesMadeAlready.value >= 3){
                  Get.toNamed(Routes.proScreenView);
                } else {
                  AppSingletons.isInvoiceDocument.value = false;
                  Get.toNamed(Routes.estimateInputView);
                  AppSingletons.isEditEstimate.value = false;
                  AppSingletons.isMakingNewINVEST.value = true;
                  AppSingletons.isEditingOnlyTemplate.value = false;

                  Utils.clearEstimateVariables();
                }
              }

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
          title: const Text('ESTIMATE',
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontFamily: 'Montserrat',
                color: sWhite,
                fontSize: 16
            ),
          ),
          actions: [
            Obx((){
              if(AppSingletons.isSearchingEstimate.value == false){
                return IconButton(onPressed:(){
                  AppSingletons.isSearchingEstimate.value = true;
                }, icon: const Icon(Icons.search,color: sWhite,));
              } else {
                return IconButton(onPressed:(){
                  AppSingletons.isSearchingEstimate.value = false;
                  AppSingletons.isKeyboardVisible.value = false;

                  controller.searchController.clear();

                }, icon: const Icon(Icons.cancel,color: sWhite,));
              }
            }),
            IconButton(onPressed: (){
              Get.toNamed(Routes.proScreenView);
            },
                icon: Image.asset('assets/icons/vip_icon.png',height: 35,width: 35,)
            )
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
                      const SizedBox(width: 100,),
                      Expanded(
                          flex: 4,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Obx(() {
                                return Visibility(
                                  visible: AppSingletons.isSearchingEstimate.value,
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
                                            hintText: 'Search estimate',
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
                                    visible: !AppSingletons.isSearchingEstimate.value,
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
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          GestureDetector(
                                            onTap: () {
                                              controller.listShowingType.value = AppConstants.all;
                                            },
                                            child: Container(
                                              padding: const EdgeInsets.symmetric(
                                                  horizontal: 20, vertical: 7),
                                              margin: const EdgeInsets.only(right: 5, left: 18),
                                              decoration: BoxDecoration(
                                                  color: controller.listShowingType.value ==
                                                      AppConstants.all
                                                      ? mainPurpleColor
                                                      : offWhite_2,
                                                  borderRadius: BorderRadius.circular(100)),
                                              child: Text(
                                                'All',
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
                                                  AppConstants.pending;
                                            },
                                            child: Container(
                                              padding: const EdgeInsets.symmetric(
                                                  horizontal: 20, vertical: 7),
                                              margin: const EdgeInsets.symmetric(horizontal: 5),
                                              decoration: BoxDecoration(
                                                  color: controller.listShowingType.value ==
                                                      AppConstants.pending
                                                      ? mainPurpleColor
                                                      : offWhite_2,
                                                  borderRadius: BorderRadius.circular(100)),
                                              child: Text(
                                                'Pending',
                                                style: TextStyle(
                                                    color: controller.listShowingType.value ==
                                                        AppConstants.pending
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
                                                  AppConstants.approved;
                                            },
                                            child: Container(
                                              padding: const EdgeInsets.symmetric(
                                                  horizontal: 20, vertical: 7),
                                              margin: const EdgeInsets.symmetric(horizontal: 5),
                                              decoration: BoxDecoration(
                                                  color: controller.listShowingType.value ==
                                                      AppConstants.approved
                                                      ? mainPurpleColor
                                                      : offWhite_2,
                                                  borderRadius: BorderRadius.circular(100)),
                                              child: Text(
                                                'Approved',
                                                style: TextStyle(
                                                    color: controller.listShowingType.value ==
                                                        AppConstants.approved
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
                                              controller.listShowingType.value = AppConstants.overdue;
                                            },
                                            child: Container(
                                              padding: const EdgeInsets.symmetric(
                                                  horizontal: 20, vertical: 7),
                                              margin: const EdgeInsets.symmetric(horizontal: 5),
                                              decoration: BoxDecoration(
                                                  color: controller.listShowingType.value ==
                                                      AppConstants.overdue
                                                      ? mainPurpleColor
                                                      : offWhite_2,
                                                  borderRadius: BorderRadius.circular(100)),
                                              child: Text(
                                                'Overdue',
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
                                                  AppConstants.cancel;
                                            },
                                            child: Container(
                                              padding: const EdgeInsets.symmetric(
                                                  horizontal: 20, vertical: 7),
                                              margin: const EdgeInsets.only(left: 5, right: 50),
                                              decoration: BoxDecoration(
                                                  color: controller.listShowingType.value ==
                                                      AppConstants.cancel
                                                      ? mainPurpleColor
                                                      : offWhite_2,
                                                  borderRadius: BorderRadius.circular(100)),
                                              child: Text(
                                                'Cancel',
                                                style: TextStyle(
                                                    fontFamily: 'Montserrat',
                                                    color: controller.listShowingType.value ==
                                                        AppConstants.cancel
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
                                      onTap: () {
                                        if(controller.isFilteringList.value){
                                          controller.filteredDataList.value = controller.fetchedDataList.value;
                                          controller.filteredPendingList.value = controller.fetchedPendingList.value;
                                          controller.filteredApprovedList.value = controller.fetchedApprovedList.value;
                                          controller.filteredOverdueList.value = controller.fetchedOverdueList.value;
                                          controller.filteredCancelList.value = controller.fetchedCancelList.value;
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
                                            color: blackColor,);
                                        }),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Obx(() {
                                return controller.isLoadingData.value
                                ? const Center(
                                  child: CupertinoActivityIndicator(
                                    color: mainPurpleColor,
                                    radius: 20,
                                  ),
                                ) : showEstimateList();
                              }),
                              const SizedBox(
                                height: 70,
                              ),
                            ],
                          )),

                      Expanded(
                        flex: 1,
                      child: GestureDetector(
                        onTap: (){
                         if(AppSingletons.isSubscriptionEnabled.value){
                           AppSingletons.isInvoiceDocument.value = false;
                           Get.toNamed(Routes.estimateInputView);
                           AppSingletons.isEditEstimate.value = false;
                           AppSingletons.isMakingNewINVEST.value = true;
                           AppSingletons.isEditingOnlyTemplate.value = false;

                           Utils.clearEstimateVariables();
                         } else {
                           if(AppSingletons.noOfEstimatesMadeAlready.value >= 3){
                             Get.toNamed(Routes.proScreenView);
                           } else {
                             AppSingletons.isInvoiceDocument.value = false;
                             Get.toNamed(Routes.estimateInputView);
                             AppSingletons.isEditEstimate.value = false;
                             AppSingletons.isMakingNewINVEST.value = true;
                             AppSingletons.isEditingOnlyTemplate.value = false;

                             Utils.clearEstimateVariables();
                           }
                         }

                        },
                        child: Container(
                          width: double.infinity,
                          margin: const EdgeInsets.only(top: 10),
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
                              Icon(Icons.add,color: mainPurpleColor,),
                              SizedBox(
                                height: 10,
                              ),
                            ],
                          ),
                        ),
                      ),
                      ),

                      const SizedBox(width: 20,),
                    ],
                  ),
                ],
              )
          ),
        )
    );
  }

  Future selectEstimateStatus(BuildContext context, int estimateId, bool isOverdue,String estimateStatus) async {
    debugPrint('Inside method isOverdue: $isOverdue');

    controller.estimateStatus.value = estimateStatus;

    return showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10)
            ),
            title: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: mainPurpleColor,
                borderRadius: BorderRadius.circular(10)
              ),
              alignment: Alignment.center,
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: const Text('Mark as',
                  style: TextStyle(
                      fontFamily: 'Montserrat',
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: sWhite)),
            ),
            content: Obx(() {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    onTap: () {
                        controller.estimateStatus.value = AppConstants.pending;
                        debugPrint(controller.estimateStatus.value);
                    },
                    title: const Text(
                      'Pending',
                      style: TextStyle(
                          fontFamily: 'Montserrat',
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: blackColor),
                    ),
                    trailing: Visibility(
                      visible: controller.estimateStatus.value == AppConstants.pending,
                      child: const Icon(
                        Icons.check,
                        color: mainPurpleColor,
                      ),
                    ),
                  ),
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    onTap: () {
                        controller.estimateStatus.value = AppConstants.approved;
                        debugPrint(controller.estimateStatus.value);
                    },
                    title: const Text(
                      'Approved',
                      style: TextStyle(
                          fontFamily: 'Montserrat',
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: blackColor),
                    ),
                    trailing: Visibility(
                      visible: controller.estimateStatus.value == AppConstants.approved,
                      child: const Icon(
                        Icons.check,
                        color: mainPurpleColor,
                      ),
                    ),
                  ),
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    onTap: () {
                        controller.estimateStatus.value = AppConstants.cancel;
                        debugPrint(controller.estimateStatus.value);
                    },
                    title: const Text(
                      'Cancel',
                      style: TextStyle(
                          fontFamily: 'Montserrat',
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: blackColor),
                    ),
                    trailing: Visibility(
                      visible: controller.estimateStatus.value == AppConstants.cancel,
                      child: const Icon(
                        Icons.check,
                        color: mainPurpleColor,
                      ),
                    ),
                  ),
                ],
              );
            }),
            actions: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: (){
                        controller.estimateStatus.value = AppSingletons.estimateStatus.value;
                        Utils.clearEstimateVariables();
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
                                bottomLeft: Radius.circular(5)
                            )
                        ),
                        child: const Text('CANCEL',
                          style: TextStyle(
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
                      onTap: ()async {
                        AppSingletons.estimateStatus.value = controller.estimateStatus.value;
                        await controller.updateEstimateStatusInDatabase(
                            estimateId, controller.estimateStatus.value);
                        controller.isFilteringList.value = false;
                        controller.selectedName.value = '';
                        controller.fromDate.value = null;
                        controller.toDate.value = null;
                      },
                      child: Container(
                        width: double.infinity,
                        alignment: Alignment.center,
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        decoration: const BoxDecoration(
                            color: mainPurpleColor,
                            borderRadius: BorderRadius.only(
                                topRight: Radius.circular(5),
                                bottomRight: Radius.circular(5)
                            )
                        ),
                        child: const Text('CHANGE',
                          style: TextStyle(
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

  Widget showEstimateList() {
    return Obx(() {
      if (controller.listShowingType.value == AppConstants.all) {
        return controller.filteredDataList.value.isNotEmpty
            ? ListView.builder(
          itemCount: controller.filteredDataList.value.length,
          shrinkWrap: true,
          itemBuilder: (context, index) {
            int reverse = controller.filteredDataList.value.length - 1 - index;
            var note = controller.filteredDataList.value[reverse];

            return GestureDetector(
              onTap: () {
                debugPrint('Sent ID: ${note.id}');

                Get.toNamed(Routes.savedPdfView);

                AppSingletons.isMakingNewINVEST.value = false;

                AppSingletons.isPreviewingPdfBeforeSave.value = false;

                AppSingletons.isInvoiceDocument.value = false;

                AppSingletons.estimateIdWhichWillEdit.value = note.id ?? 0;

                AppSingletons.isEditInvoice.value = false;

                AppSingletons.isEditEstimate.value = true;
              },
              onLongPress: () {
                CustomDialogues.showDialogueToDelete(
                    false,
                    'Delete Estimate',
                    'Are you sure you want to delete this estimate?',
                        () => controller.deleteEstimate(note.id!),
                        () => controller.loadEstimateData());
              },
              child: Container(
                constraints: const BoxConstraints(
                  minHeight: 100,
                ),
                margin: EdgeInsets.symmetric(
                  horizontal: AppConstants.isMobileScreen.value ? 15.0 : 50,
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
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
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
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            DateFormat('dd-MMM-yyyy').format(
                                DateTime.parse(note.startDate.toString())),
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
                          Text(
                            note.partialPaymentAmount ?? '',
                            style: const TextStyle(
                                fontFamily: 'Montserrat',
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: blackColor),
                          ),
                          SizedBox(
                            height: 33,
                            child: TextButton(
                              style: TextButton.styleFrom(
                                  backgroundColor: controller.
                                  giveInvoiceStatusColor(
                                      note.isOverdue ?? false,
                                      note.invoicePaidStatus.toString())
                              ),
                              onPressed: () {

                                selectEstimateStatus(context, note.id!, note.isOverdue ?? false,note.invoicePaidStatus.toString());

                                debugPrint('Selected Id: ${note.id}');
                              },
                              child: Text(
                                controller.getEstimateStatusText(note.isOverdue!, note.invoicePaidStatus ?? ''),
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
            SizedBox(height: AppConstants.isMobileScreen.value ? 0 : 100,),
            Image.asset(
              'assets/icons/empty_box.png',
              height: 120,
              width: 120,
              color: mainPurpleColor.withOpacity(0.7),
            ),
            const Text(
              'Tap + to create estimate',
              style: TextStyle(
                  fontFamily: 'Montserrat',
                  color: blackColor,
                  fontWeight: FontWeight.w600,
                  fontSize: 16),
            )
          ],
        );
      }
      else if (controller.listShowingType.value == AppConstants.pending) {
        return controller.filteredPendingList.value.isNotEmpty
            ? ListView.builder(
          itemCount: controller.filteredPendingList.value.length,
          shrinkWrap: true,
          itemBuilder: (context, index) {
            int reverse = controller.filteredPendingList.value.length - 1 - index;
            var note = controller.filteredPendingList.value[reverse];

            return GestureDetector(
              onTap: () {
                debugPrint('Sent ID: ${note.id}');

                Get.toNamed(Routes.savedPdfView);

                AppSingletons.isMakingNewINVEST.value = false;

                AppSingletons.isPreviewingPdfBeforeSave.value = false;

                AppSingletons.isInvoiceDocument.value = false;

                AppSingletons.estimateIdWhichWillEdit.value = note.id ?? 0;

                AppSingletons.isEditInvoice.value = false;

                AppSingletons.isEditEstimate.value = true;
              },
              onLongPress: () {
                CustomDialogues.showDialogueToDelete(
                    false,
                    'Delete Estimate',
                    'Are you sure you want to delete this estimate?',
                        () => controller.deleteEstimate(note.id!),
                        () => controller.loadEstimateData());
              },
              child: Container(
                constraints: const BoxConstraints(
                  minHeight: 100,
                ),
                margin: EdgeInsets.symmetric(
                  horizontal: AppConstants.isMobileScreen.value ? 15.0 : 50,
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
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
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
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            DateFormat('dd-MMM-yyyy').format(
                                DateTime.parse(note.startDate.toString())),
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
                          Text(
                            note.partialPaymentAmount ?? '',
                            style: const TextStyle(
                                fontFamily: 'Montserrat',
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: blackColor),
                          ),
                          SizedBox(
                            height: 33,
                            child: TextButton(
                              style: TextButton.styleFrom(
                                  backgroundColor: controller.
                                  giveInvoiceStatusColor(
                                      note.isOverdue ?? false,
                                      note.invoicePaidStatus.toString())
                              ),
                              onPressed: () {

                                selectEstimateStatus(context, note.id!, note.isOverdue ?? false,note.invoicePaidStatus.toString());

                                debugPrint('Selected Id: ${note.id}');
                              },
                              child: Text(
                                  controller.getEstimateStatusText(note.isOverdue!, note.invoicePaidStatus ?? ''),
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
            SizedBox(height: AppConstants.isMobileScreen.value ? 0 : 100),
            Image.asset(
              'assets/icons/empty_box.png',
              height: 120,
              width: 120,
              color: mainPurpleColor.withOpacity(0.7),
            ),
            const Text(
              'No Estimate',
              style: TextStyle(
                  fontFamily: 'Montserrat',
                  color: blackColor,
                  fontWeight: FontWeight.w600,
                  fontSize: 16),
            )
          ],
        );
      }
      else if (controller.listShowingType.value == AppConstants.approved) {
        return controller.filteredApprovedList.value.isNotEmpty
            ? ListView.builder(
          itemCount: controller.filteredApprovedList.value.length,
          shrinkWrap: true,
          itemBuilder: (context, index) {
            int reverse =
                controller.filteredApprovedList.value.length - 1 - index;
            var note = controller.filteredApprovedList.value[reverse];

            return GestureDetector(
              onTap: () {
                debugPrint('Sent ID: ${note.id}');

                Get.toNamed(Routes.savedPdfView);

                AppSingletons.isMakingNewINVEST.value = false;

                AppSingletons.isPreviewingPdfBeforeSave.value = false;

                AppSingletons.isInvoiceDocument.value = false;

                AppSingletons.estimateIdWhichWillEdit.value = note.id ?? 0;

                AppSingletons.isEditInvoice.value = false;

                AppSingletons.isEditEstimate.value = true;
              },
              onLongPress: () {
                CustomDialogues.showDialogueToDelete(
                    false,
                    'Delete Estimate',
                    'Are you sure you want to delete this estimate?',
                        () => controller.deleteEstimate(note.id!),
                        () => controller.loadEstimateData());
              },
              child: Container(
                constraints: const BoxConstraints(
                  minHeight: 100,
                ),
                margin: EdgeInsets.symmetric(
                  horizontal: AppConstants.isMobileScreen.value ? 15.0 : 50,
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
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
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
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            DateFormat('dd-MMM-yyyy').format(
                                DateTime.parse(note.startDate.toString())),
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
                          Text(
                            note.partialPaymentAmount ?? '',
                            style: const TextStyle(
                                fontFamily: 'Montserrat',
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: blackColor),
                          ),
                          SizedBox(
                            height: 33,
                            child: TextButton(
                              style: TextButton.styleFrom(
                                  backgroundColor: controller.
                                  giveInvoiceStatusColor(
                                      note.isOverdue ?? false,
                                      note.invoicePaidStatus.toString())
                              ),
                              onPressed: () {

                                selectEstimateStatus(context, note.id!, note.isOverdue ?? false,note.invoicePaidStatus.toString());

                                debugPrint('Selected Id: ${note.id}');
                              },
                              child: Text(
                                  controller.getEstimateStatusText(note.isOverdue!, note.invoicePaidStatus ?? ''),
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
            SizedBox(height: AppConstants.isMobileScreen.value ? 0 : 100,),
            Image.asset(
              'assets/icons/empty_box.png',
              height: 120,
              width: 120,
              color: mainPurpleColor.withOpacity(0.7),
            ),
            const Text(
              'No Estimate',
              style: TextStyle(
                  fontFamily: 'Montserrat',
                  color: blackColor,
                  fontWeight: FontWeight.w600,
                  fontSize: 16),
            )
          ],
        );
      }
      else if (controller.listShowingType.value == AppConstants.overdue) {
        return controller.filteredOverdueList.value.isNotEmpty
            ? ListView.builder(
          itemCount: controller.filteredOverdueList.value.length,
          shrinkWrap: true,
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

                AppSingletons.isInvoiceDocument.value = false;

                AppSingletons.estimateIdWhichWillEdit.value = note.id ?? 0;

                AppSingletons.isEditInvoice.value = false;

                AppSingletons.isEditEstimate.value = true;
              },
              onLongPress: () {
                CustomDialogues.showDialogueToDelete(
                    false,
                    'Delete Estimate',
                    'Are you sure you want to delete this estimate?',
                        () => controller.deleteEstimate(note.id!),
                        () => controller.loadEstimateData());
              },
              child: Container(
                constraints: const BoxConstraints(
                  minHeight: 100,
                ),
                margin: EdgeInsets.symmetric(
                  horizontal: AppConstants.isMobileScreen.value ? 15.0 : 50,
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
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
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
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            DateFormat('dd-MMM-yyyy').format(
                                DateTime.parse(note.startDate.toString())),
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
                          Text(
                            note.partialPaymentAmount ?? '',
                            style: const TextStyle(
                                fontFamily: 'Montserrat',
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: blackColor),
                          ),
                          SizedBox(
                            height: 33,
                            child: TextButton(
                              style: TextButton.styleFrom(
                                  backgroundColor: controller.
                                  giveInvoiceStatusColor(
                                      note.isOverdue ?? false,
                                      note.invoicePaidStatus.toString())
                              ),
                              onPressed: () {

                                selectEstimateStatus(context, note.id!, note.isOverdue ?? false,note.invoicePaidStatus.toString());

                                debugPrint('Selected Id: ${note.id}');
                              },
                              child: Text(
                                  controller.getEstimateStatusText(note.isOverdue!, note.invoicePaidStatus ?? ''),
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
            SizedBox(height: AppConstants.isMobileScreen.value ? 0 : 100,),
            Image.asset(
              'assets/icons/empty_box.png',
              height: 120,
              width: 120,
              color: mainPurpleColor.withOpacity(0.7),
            ),
            const Text(
              'No Estimate',
              style: TextStyle(
                  fontFamily: 'Montserrat',
                  color: blackColor,
                  fontWeight: FontWeight.w600,
                  fontSize: 16),
            )
          ],
        );
      }
      else if (controller.listShowingType.value == AppConstants.cancel) {
        return controller.filteredCancelList.value.isNotEmpty
            ? ListView.builder(
          itemCount: controller.filteredCancelList.value.length,
          shrinkWrap: true,
          itemBuilder: (context, index) {
            int reverse =
                controller.filteredCancelList.value.length - 1 - index;
            var note = controller.filteredCancelList.value[reverse];

            return GestureDetector(
              onTap: () {
                debugPrint('Sent ID: ${note.id}');

                AppSingletons.isMakingNewINVEST.value = false;

                Get.toNamed(Routes.savedPdfView);

                AppSingletons.isPreviewingPdfBeforeSave.value = false;

                AppSingletons.isInvoiceDocument.value = false;

                AppSingletons.estimateIdWhichWillEdit.value = note.id ?? 0;

                AppSingletons.isEditInvoice.value = false;

                AppSingletons.isEditEstimate.value = true;
              },
              onLongPress: () {
                CustomDialogues.showDialogueToDelete(
                    false,
                    'Delete Estimate',
                    'Are you sure you want to delete this estimate?',
                        () => controller.deleteEstimate(note.id!),
                        () => controller.loadEstimateData());
              },
              child: Container(
                constraints: const BoxConstraints(
                  minHeight: 100,
                ),
                margin: EdgeInsets.symmetric(
                  horizontal: AppConstants.isMobileScreen.value ? 15.0 : 50,
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
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
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
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            DateFormat('dd-MMM-yyyy').format(
                                DateTime.parse(note.startDate.toString())),
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
                          Text(
                            note.partialPaymentAmount ?? '',
                            style: const TextStyle(
                                fontFamily: 'Montserrat',
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: blackColor),
                          ),
                          SizedBox(
                            height: 35,
                            child: TextButton(
                              style: TextButton.styleFrom(
                                  backgroundColor: controller.
                                  giveInvoiceStatusColor(
                                      note.isOverdue ?? false,
                                      note.invoicePaidStatus.toString())
                              ),
                              onPressed: () {

                                selectEstimateStatus(context, note.id!, note.isOverdue ?? false,note.invoicePaidStatus.toString());

                                debugPrint('Selected Id: ${note.id}');
                              },
                              child: Text(
                                controller.getEstimateStatusText(note.isOverdue!, note.invoicePaidStatus ?? ''),
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
            SizedBox(height: AppConstants.isMobileScreen.value ? 0 : 100,),
            Image.asset(
              'assets/icons/empty_box.png',
              height: 120,
              width: 120,
              color: mainPurpleColor.withOpacity(0.7),
            ),
            const Text(
              'No Estimate',
              style: TextStyle(
                  fontFamily: 'Montserrat',
                  color: blackColor,
                  fontWeight: FontWeight.w600,
                  fontSize: 16),
            )
          ],
        );
      }
      else {
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
            title: const Text('Filter By',
              style: TextStyle(
                fontFamily: 'Montserrat',
                fontSize: 17,
                fontWeight: FontWeight.w700,
                color: mainPurpleColor,
              ),
            ),
            content: Container(
              margin: const EdgeInsets.symmetric(horizontal: 24),
              height: 200,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 15,),
                  const Text('Client Name',
                    style: TextStyle(
                      fontFamily: 'Montserrat',
                      fontSize: 14,
                      color: grey_4,
                    ),
                  ),

                  const SizedBox(height: 5,),

                  Container(
                    width: double.infinity,
                    height: 45,
                    decoration: BoxDecoration(
                        color: textFieldColor,
                        borderRadius: BorderRadius.circular(5)
                    ),

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
                            borderRadius: BorderRadius.circular(5)
                        ),
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
                                    : 'All Clients',
                                style: const TextStyle(
                                  fontFamily: 'Montserrat',
                                  fontSize: 14,
                                  color: blackColor,
                                ),
                              );
                            }),
                            const Icon(
                              Icons.arrow_drop_down_sharp, color: blackColor,)
                          ],
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 15,),

                  const Text('Creation Date',
                    style: TextStyle(
                      fontFamily: 'Montserrat',
                      fontSize: 14,
                      color: grey_4,
                    ),
                  ),

                  const SizedBox(height: 10,),

                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            const Text('Date From',
                              style: TextStyle(
                                fontFamily: 'Montserrat',
                                fontSize: 12,
                                color: blackColor,
                              ),
                            ),

                            const SizedBox(height: 3,),

                            GestureDetector(
                              onTap: () {
                                _creationDateAndTime(context);
                              },
                              child: Container(
                                width: double.infinity,
                                height: 45,
                                decoration: BoxDecoration(
                                    color: textFieldColor,
                                    borderRadius: BorderRadius.circular(5)
                                ),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 6),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment
                                      .spaceBetween,
                                  children: [
                                    Obx(() {
                                      return Text(
                                        controller.fromDate.value != null
                                            ? DateFormat('dd-MM-yyyy')
                                            .format(controller.fromDate.value!)
                                            .toString() : '',
                                        style: const TextStyle(
                                          fontFamily: 'Montserrat',
                                          fontSize: 12,
                                          color: blackColor,
                                        ),
                                      );
                                    }),
                                    const Icon(Icons.calendar_month_outlined,
                                      color: blackColor,)
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 10,),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            const Text('Date To',
                              style: TextStyle(
                                fontFamily: 'Montserrat',
                                fontSize: 12,
                                color: blackColor,
                              ),
                            ),
                            const SizedBox(height: 3,),
                            GestureDetector(
                              onTap: () {
                                _dueDateAndTime(context);
                              },
                              child: Container(
                                width: double.infinity,
                                height: 45,
                                decoration: BoxDecoration(
                                    color: textFieldColor,
                                    borderRadius: BorderRadius.circular(5)
                                ),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 6),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment
                                      .spaceBetween,
                                  children: [
                                    Obx(() {
                                      return Text(
                                        controller.toDate.value != null
                                            ? DateFormat('dd-MM-yyyy')
                                            .format(controller.toDate.value!)
                                            .toString() : '',
                                        style: const TextStyle(
                                          fontFamily: 'Montserrat',
                                          fontSize: 12,
                                          color: blackColor,
                                        ),
                                      );
                                    }),
                                    const Icon(Icons.calendar_month_outlined,
                                      color: blackColor,)
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
                }, child: const Text('CANCEL',
                style: TextStyle(
                    fontFamily: 'Montserrat',
                    fontSize: 14,
                    color: grey_4
                ),
              ),),
              TextButton(
                onPressed: () {
                  controller.filterData();
                  controller.isFilteringList.value = true;
                  Get.back();

                }, child: const Text('APPLY',
                style: TextStyle(
                    fontFamily: 'Montserrat',
                    fontSize: 14,
                    color: mainPurpleColor
                ),
              ),)
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
        cancelText: 'CANCEL',
        confirmText: 'OK',
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
        cancelText: 'CANCEL',
        confirmText: 'OK',
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