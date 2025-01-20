import 'dart:io';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:intl/intl.dart';
import '../../core/routes/routes.dart';
import '../../core/utils/chart_data_methods.dart';
import '../../modules/charts_of_data/fl_chart_invoices.dart';
import '../../core/widgets/custom_container.dart';
import '../../core/app_singletons/app_singletons.dart';
import '../../core/constants/color/color.dart';
import '../../core/constants/app_constants/App_Constants.dart';
import 'charts_controller.dart';

class ChartsView extends GetView<ChartsController> {
  @override
  Widget build(BuildContext context) {

    bool checkIsMobileLayout = AppConstants.isMobileScreen.value;

    return  checkIsMobileLayout ? mainMobileLayout(context) : mainDesktopLayout(context);
  }

  Widget mainMobileLayout(BuildContext context) {
    final controller = Get.put<ChartsController>(ChartsController());

    return Scaffold(
      backgroundColor: orangeLight_1,
      appBar: AppBar(
        backgroundColor: mainPurpleColor,
        title: const Text('Report',
          style: TextStyle(
              fontFamily: 'SFProDisplay',
              fontWeight: FontWeight.w700,
              fontSize: 16,
              letterSpacing: 1,
              color: orangeLight_1
          ),),
        leading: IconButton(
          onPressed: () {
            Get.back();
          }, icon: const Icon(Icons.arrow_back, color: orangeLight_1,),
        ),

      ),
      body: Obx(() {
        return controller.isLoadingData.value
            ? const Center(
          child: CupertinoActivityIndicator(
            color: mainPurpleColor,
            radius: 15,
          ),
        )
            : SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              const SizedBox(height: 15,),

              Row(
                children: [
                  const SizedBox(width: 15,),
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                          color: sWhite,
                          borderRadius: BorderRadius.circular(5),
                          boxShadow: const [
                            BoxShadow(
                                color: greyColor,
                                blurRadius: 10,
                                spreadRadius: 5
                            )
                          ]
                      ),
                      alignment: Alignment.center,
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          const SizedBox(width: 10,),
                          const Icon(Icons.money),
                          const SizedBox(width: 30,),
                          Text(
                            AppSingletons.storedInvoiceCurrency.value,
                            style: const TextStyle(
                                fontFamily: 'Montserrat',
                                fontSize: 15,
                                color: blackColor,
                                fontWeight: FontWeight.w600),
                          ),
                          const SizedBox(width: 10,),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 15,),
                  Expanded(
                    child: PopupMenuButton<String>(
                        onSelected: (value) {
                          // Apply the selected filter
                          if (value == 'custom') {
                            _showCustomDateRangeDialog(context);
                          } else {
                            controller.filterTopClients(value);
                            controller.filterTopItems(value);
                            controller.filterInvoicesData(value);
                          }
                        },
                        itemBuilder: (context) =>
                        [
                          const PopupMenuItem(
                              value: 'last7days', child: Text('Last 7 Days')),
                          const PopupMenuItem(
                              value: 'last30days', child: Text('Last 30 Days')),
                          const PopupMenuItem(
                              value: 'thismonth', child: Text('This Month')),
                          const PopupMenuItem(
                              value: 'thisquarter',
                              child: Text('This Quarter')),
                          const PopupMenuItem(value: 'thisyear',
                              child: Text('This Year')),
                          const PopupMenuItem(
                              value: 'lastmonth', child: Text('Last Month')),
                          const PopupMenuItem(
                              value: 'lastquarter',
                              child: Text('Last Quarter')),
                          const PopupMenuItem(value: 'lastyear',
                              child: Text('Last Year')),
                          const PopupMenuItem(value: 'custom',
                              child: Text('Custom')),
                        ],
                        child: Container(
                            width: double.infinity,
                            alignment: Alignment.center,
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            decoration: BoxDecoration(
                                color: sWhite,
                                borderRadius: BorderRadius.circular(5),
                                boxShadow: const [
                                  BoxShadow(
                                      color: greyColor,
                                      blurRadius: 10,
                                      spreadRadius: 5
                                  )
                                ]
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                const Icon(
                                  Icons.calendar_today, color: blackColor,),
                                Text(controller.selectedDateFilter.value),
                                const Icon(Icons.arrow_drop_down_sharp,
                                  color: blackColor,),
                              ],
                            )
                        )
                    ),
                  ),
                  const SizedBox(width: 15,),
                ],
              ),

              const SizedBox(height: 15,),

              CustomContainer(
                horizontalPadding: 10,
                verticalPadding: 15,
                childContainer: Row(
                  children: [
                    Expanded(
                      child: Column(
                        children: [
                          const Text('Total Sales',
                            style: TextStyle(
                                fontFamily: 'Montserrat',
                                fontSize: 14,
                                color: greyColor
                            ),
                          ),

                          const SizedBox(height: 10,),

                          Obx(() {
                            return Text(
                              '${AppSingletons.storedInvoiceCurrency
                                  .value}${controller.totalSalesValue.value
                                  .toString()}',
                              style: const TextStyle(
                                  fontFamily: 'Montserrat',
                                  fontSize: 22,
                                  fontWeight: FontWeight.w600,
                                  color: blackColor
                              ),
                            );
                          }),
                        ],
                      ),
                    ),
                    Container(height: 60, width: 1, color: greyColor,),
                    Expanded(
                      child: Column(
                        children: [
                          const Text('Total Paid',
                            style: TextStyle(
                                fontFamily: 'Montserrat',
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: greyColor
                            ),
                          ),
                          const SizedBox(height: 10,),

                          Text(
                            '${AppSingletons.storedInvoiceCurrency
                                .value}${controller.totalPaidSalesValue.value
                                .toString()}',
                            style: const TextStyle(
                                fontFamily: 'Montserrat',
                                fontSize: 22,
                                fontWeight: FontWeight.w600,
                                color: blackColor
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 15,),

              CustomContainer(
                  verticalPadding: 10,
                  horizontalPadding: 10,
                  childContainer: Obx(() {
                    return Column(
                      children: [

                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              margin: const EdgeInsets.only(left: 10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  const Text('Sales Trending',
                                    style: TextStyle(
                                        fontFamily: 'Montserrat',
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                        color: blackColor
                                    ),
                                  ),
                                  Text('${DateFormat('dd/MM').format(
                                      controller.startChosenDate
                                          .value)} - ${DateFormat('dd/MM')
                                      .format(controller.endChosenDate.value)}',
                                    style: const TextStyle(
                                        fontFamily: 'Montserrat',
                                        fontSize: 12,
                                        color: greyColor
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.only(right: 10),
                              child: IconButton(
                                  onPressed: () {
                                    AppSingletons.shareChartDetailTitle.value =
                                        AppConstants.salesTrending;
                                    AppSingletons.selectedTimePeriod.value =
                                        controller.selectedFilterValue.value;
                                    Get.toNamed(Routes.shareChartDetailView);
                                  },
                                  icon: const Row(
                                    children: [
                                      Text('More',
                                        style: TextStyle(
                                            fontFamily: 'Montserrat',
                                            fontSize: 12,
                                            fontWeight: FontWeight.w600,
                                            color: greyColor
                                        ),
                                      ),
                                      SizedBox(width: 5,),
                                      Icon(Icons.arrow_forward_ios_rounded,
                                        size: 15, color: greyColor,)
                                    ],
                                  )
                              ),
                            ),
                          ],
                        ),

                        Container(
                            height: 200,
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: InvoicesLineChart(
                              lineChartData: ChartDataMethods.getLineChartData(
                                  controller.startChosenDate.value,
                                  controller.endChosenDate.value,
                                  controller.filteredInvoices
                              ),
                              dateLabels: ChartDataMethods.generateDateLabels(
                                controller.startChosenDate.value,
                                controller.endChosenDate.value,
                                controller.selectedFilterValue.value,
                              ),
                              filterType: controller.selectedFilterValue.value,
                            )
                        ),
                      ],
                    );
                  }
                  )
              ),

              const SizedBox(height: 15,),

              CustomContainer(
                verticalPadding: 10,
                childContainer: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          margin: const EdgeInsets.only(left: 10),
                          child: const Text('Sales by Client (Top 5)',
                            style: TextStyle(
                                fontFamily: 'Montserrat',
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                                color: blackColor
                            ),
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(right: 10),
                          child: IconButton(
                              onPressed: () {
                                AppSingletons.shareChartDetailTitle.value =
                                    AppConstants.salesByClient;
                                Get.toNamed(Routes.shareChartDetailView);
                              },
                              icon: const Row(
                                children: [
                                  Text('More',
                                    style: TextStyle(
                                        fontFamily: 'Montserrat',
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                        color: greyColor
                                    ),
                                  ),
                                  SizedBox(width: 5,),
                                  Icon(
                                    Icons.arrow_forward_ios_rounded, size: 15,
                                    color: greyColor,)
                                ],
                              )
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 15,),
                    Obx(() =>
                        SizedBox(
                          height: 200,
                          child: PieChart(
                            PieChartData(
                              sections: controller.topClients
                                  .asMap()
                                  .entries
                                  .map((entry) {
                                int index = entry.key;
                                final client = entry.value;
                                return PieChartSectionData(
                                  value: client.percentage,
                                  title: '${client.percentage.toStringAsFixed(
                                      1)}%',
                                  color: controller.giveBoxValues(index),
                                  radius: 50,
                                  // Adjust radius as needed
                                  titleStyle: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                );
                              }).toList(),
                              sectionsSpace: 2, // Space between sections
                              centerSpaceRadius: 40, // Space in the center of the pie chart
                            ),
                          ),
                        )),
                    Obx(() {
                      if (controller.topClients.isEmpty) {
                        return const Center(
                            child: Text(
                                'No clients found for the selected period.'));
                      }
                      return ListView.builder(
                        itemCount: controller.topClients.length,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) {
                          final client = controller.topClients[index];
                          return ListTile(
                            leading: Container(
                              width: 50,
                              height: 40,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                  color: controller.giveBoxValues(index),
                                  borderRadius: BorderRadius.circular(8)
                              ),
                              padding: const EdgeInsets.symmetric(
                                  vertical: 8, horizontal: 2),
                              child: Text(
                                '${client.percentage.toStringAsFixed(1)}%',
                                style: const TextStyle(
                                    fontFamily: 'Montserrat',
                                    fontSize: 12,
                                    color: sWhite,
                                    fontWeight: FontWeight.w600),
                              ),
                            ),
                            title: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      client.clientName,
                                      style: const TextStyle(
                                          fontFamily: 'Montserrat',
                                          fontSize: 15,
                                          color: blackColor,
                                          fontWeight: FontWeight.w600),
                                    ),
                                    Text(
                                      'Invoices: ${client.count.toString()}',
                                      style: const TextStyle(
                                          fontFamily: 'Montserrat',
                                          fontSize: 12,
                                          color: greyColor
                                      ),
                                    )
                                  ],
                                ),
                                Container(
                                  alignment: Alignment.centerRight,
                                  width: 100,
                                  child: Text(
                                    '${AppSingletons.storedInvoiceCurrency
                                        .value}${client.totalAmount
                                        .toStringAsFixed(0)}',
                                    style: const TextStyle(
                                      fontFamily: 'Montserrat',
                                      fontSize: 13,
                                      color: blackColor,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            subtitle: LinearProgressIndicator(
                              value: client.percentage / 100,
                              color: controller.giveBoxValues(index),
                              borderRadius: BorderRadius.circular(50),
                            ),
                          );
                        },
                      );
                    }),
                  ],
                ),
              ),

              const SizedBox(height: 15,),

              CustomContainer(
                verticalPadding: 10,
                childContainer: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          margin: const EdgeInsets.only(left: 10),
                          child: const Text('Sales by Items (Top 5)',
                            style: TextStyle(
                                fontFamily: 'Montserrat',
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                                color: blackColor
                            ),
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(right: 10),
                          child: IconButton(
                              onPressed: () {
                                AppSingletons.shareChartDetailTitle.value =
                                    AppConstants.salesByItem;
                                Get.toNamed(Routes.shareChartDetailView);
                              },
                              icon: const Row(
                                children: [
                                  Text('More',
                                    style: TextStyle(
                                        fontFamily: 'Montserrat',
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                        color: greyColor
                                    ),
                                  ),
                                  SizedBox(width: 5,),
                                  Icon(
                                    Icons.arrow_forward_ios_rounded, size: 15,
                                    color: greyColor,)
                                ],
                              )
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 15,),
                    Obx(() =>
                        SizedBox(
                          height: 200,
                          child: PieChart(
                            PieChartData(
                              sections: controller.topItems
                                  .asMap()
                                  .entries
                                  .map((entry) {
                                int index = entry.key;
                                final items = entry.value;
                                return PieChartSectionData(
                                  value: items.percentage,
                                  title: '${items.percentage.toStringAsFixed(
                                      1)}%',
                                  color: controller.giveBoxValues(index),
                                  radius: 50,
                                  titleStyle: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                );
                              }).toList(),
                              sectionsSpace: 2, // Space between sections
                              centerSpaceRadius: 40, // Space in the center of the pie chart
                            ),
                          ),
                        )),
                    const SizedBox(height: 15,),
                    Obx(() {
                      if (controller.topItems.isEmpty) {
                        return const Center(
                            child: Text(
                                'No Items found for the selected period.'));
                      }
                      return ListView.builder(
                        itemCount: controller.topItems.length,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) {
                          final items = controller.topItems[index];
                          return ListTile(
                            leading: Container(
                              width: 50,
                              height: 40,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                  color: controller.giveBoxValues(index),
                                  borderRadius: BorderRadius.circular(8)
                              ),
                              padding: const EdgeInsets.symmetric(
                                  vertical: 8, horizontal: 2),
                              child: Text(
                                '${items.percentage.toStringAsFixed(1)}%',
                                style: const TextStyle(
                                    fontFamily: 'Montserrat',
                                    fontSize: 12,
                                    color: sWhite,
                                    fontWeight: FontWeight.w600),
                              ),
                            ),
                            title: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      items.itemName,
                                      style: const TextStyle(
                                          fontFamily: 'Montserrat',
                                          fontSize: 15,
                                          color: blackColor,
                                          fontWeight: FontWeight.w600),
                                    ),
                                    Text(
                                      'QTY: ${items.quantity.toString()}',
                                      style: const TextStyle(
                                          fontFamily: 'Montserrat',
                                          fontSize: 12,
                                          color: greyColor
                                      ),
                                    )
                                  ],
                                ),
                                Container(
                                  alignment: Alignment.centerRight,
                                  width: 100,
                                  child: Text(
                                    '${AppSingletons.storedInvoiceCurrency
                                        .value}${items.totalAmount
                                        .toStringAsFixed(0)}',
                                    style: const TextStyle(
                                      fontFamily: 'Montserrat',
                                      fontSize: 13,
                                      color: blackColor,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            subtitle: LinearProgressIndicator(
                              value: items.percentage / 100,
                              color: controller.giveBoxValues(index),
                            ),
                          );
                        },
                      );
                    }),
                  ],
                ),
              ),

              const SizedBox(height: 15,),

            ],
          ),
        );
      }),
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
      backgroundColor: mainPurpleColor,
      appBar: AppBar(
        backgroundColor: mainPurpleColor,
        title: const Text(
          'CHARTS',
          style: TextStyle(
              fontWeight: FontWeight.bold,
              fontFamily: 'Montserrat',
              color: sWhite,
              fontSize: 16),
        ),
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: const Icon(
            Icons.arrow_back,
            color: sWhite,
          ),
        ),
      ),
      body: Center(
          child: Container(
            width: MediaQuery
                .of(context)
                .size
                .width * 0.5,
            height: double.infinity,
            margin: const EdgeInsets.symmetric(vertical: 15),
            decoration: BoxDecoration(
                color: sWhite, borderRadius: BorderRadius.circular(10)),
            alignment: Alignment.center,
            child: Obx(() {
              return controller.isLoadingData.value
                  ? const Center(
                child: CupertinoActivityIndicator(
                  color: mainPurpleColor,
                  radius: 15,
                ),
              )
                  : SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    const SizedBox(height: 15,),

                    Row(
                      children: [
                        const SizedBox(width: 15,),
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                                color: sWhite,
                                borderRadius: BorderRadius.circular(5),
                                boxShadow: const [
                                  BoxShadow(
                                      color: greyColor,
                                      blurRadius: 10,
                                      spreadRadius: 5
                                  )
                                ]
                            ),
                            alignment: Alignment.center,
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                const SizedBox(width: 10,),
                                const Icon(Icons.money),
                                const SizedBox(width: 30,),
                                Text(
                                  AppSingletons.storedInvoiceCurrency.value,
                                  style: const TextStyle(
                                      fontFamily: 'Montserrat',
                                      fontSize: 15,
                                      color: blackColor,
                                      fontWeight: FontWeight.w600),
                                ),
                                const SizedBox(width: 10,),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(width: 15,),
                        Expanded(
                          child: PopupMenuButton<String>(
                              onSelected: (value) {
                                // Apply the selected filter
                                if (value == 'custom') {
                                  _showCustomDateRangeDialog(context);
                                } else {
                                  controller.filterTopClients(value);
                                  controller.filterTopItems(value);
                                  controller.filterInvoicesData(value);
                                }
                              },
                              itemBuilder: (context) =>
                              [
                                const PopupMenuItem(
                                    value: 'last7days',
                                    child: Text('Last 7 Days')),
                                const PopupMenuItem(
                                    value: 'last30days',
                                    child: Text('Last 30 Days')),
                                const PopupMenuItem(
                                    value: 'thismonth',
                                    child: Text('This Month')),
                                const PopupMenuItem(
                                    value: 'thisquarter',
                                    child: Text('This Quarter')),
                                const PopupMenuItem(value: 'thisyear',
                                    child: Text('This Year')),
                                const PopupMenuItem(
                                    value: 'lastmonth',
                                    child: Text('Last Month')),
                                const PopupMenuItem(
                                    value: 'lastquarter',
                                    child: Text('Last Quarter')),
                                const PopupMenuItem(value: 'lastyear',
                                    child: Text('Last Year')),
                                const PopupMenuItem(value: 'custom',
                                    child: Text('Custom')),
                              ],
                              child: Container(
                                  width: double.infinity,
                                  alignment: Alignment.center,
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 8),
                                  decoration: BoxDecoration(
                                      color: sWhite,
                                      borderRadius: BorderRadius.circular(5),
                                      boxShadow: const [
                                        BoxShadow(
                                            color: greyColor,
                                            blurRadius: 10,
                                            spreadRadius: 5
                                        )
                                      ]
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment
                                        .spaceAround,
                                    children: [
                                      const Icon(
                                        Icons.calendar_today,
                                        color: blackColor,),
                                      Text(controller.selectedDateFilter.value),
                                      const Icon(Icons.arrow_drop_down_sharp,
                                        color: blackColor,),
                                    ],
                                  )
                              )
                          ),
                        ),
                        const SizedBox(width: 15,),
                      ],
                    ),

                    const SizedBox(height: 15,),

                    CustomContainer(
                      horizontalPadding: 10,
                      verticalPadding: 15,
                      childContainer: Row(
                        children: [
                          Expanded(
                            child: Column(
                              children: [
                                const Text('Total Sales',
                                  style: TextStyle(
                                      fontFamily: 'Montserrat',
                                      fontSize: 14,
                                      color: greyColor
                                  ),
                                ),

                                const SizedBox(height: 10,),

                                Obx(() {
                                  return Text(
                                    '${AppSingletons.storedInvoiceCurrency
                                        .value}${controller.totalSalesValue
                                        .value.toString()}',
                                    style: const TextStyle(
                                        fontFamily: 'Montserrat',
                                        fontSize: 22,
                                        fontWeight: FontWeight.w600,
                                        color: blackColor
                                    ),
                                  );
                                }),
                              ],
                            ),
                          ),
                          Container(height: 60, width: 1, color: greyColor,),
                          Expanded(
                            child: Column(
                              children: [
                                const Text('Total Paid',
                                  style: TextStyle(
                                      fontFamily: 'Montserrat',
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      color: greyColor
                                  ),
                                ),
                                const SizedBox(height: 10,),

                                Text(
                                  '${AppSingletons.storedInvoiceCurrency
                                      .value}${controller.totalPaidSalesValue
                                      .value.toString()}',
                                  style: const TextStyle(
                                      fontFamily: 'Montserrat',
                                      fontSize: 22,
                                      fontWeight: FontWeight.w600,
                                      color: blackColor
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 15,),

                    CustomContainer(
                        verticalPadding: 10,
                        horizontalPadding: 10,
                        childContainer: Obx(() {
                          return Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment
                                    .spaceBetween,
                                children: [
                                  Container(
                                    margin: const EdgeInsets.only(left: 10),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment
                                          .start,
                                      mainAxisAlignment: MainAxisAlignment
                                          .start,
                                      children: [
                                        const Text('Sales Trending',
                                          style: TextStyle(
                                              fontFamily: 'Montserrat',
                                              fontSize: 14,
                                              fontWeight: FontWeight.w600,
                                              color: blackColor
                                          ),
                                        ),
                                        Text('${DateFormat('dd/MM').format(
                                            controller.startChosenDate
                                                .value)} - ${DateFormat('dd/MM')
                                            .format(
                                            controller.endChosenDate.value)}',
                                          style: const TextStyle(
                                              fontFamily: 'Montserrat',
                                              fontSize: 12,
                                              color: greyColor
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    margin: const EdgeInsets.only(right: 10),
                                    child: IconButton(
                                        onPressed: () {
                                          AppSingletons.shareChartDetailTitle
                                              .value =
                                              AppConstants.salesTrending;
                                          AppSingletons.selectedTimePeriod
                                              .value =
                                              controller.selectedFilterValue
                                                  .value;
                                          Get.toNamed(
                                              Routes.shareChartDetailView);
                                        },
                                        icon: const Row(
                                          children: [
                                            Text('More',
                                              style: TextStyle(
                                                  fontFamily: 'Montserrat',
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w600,
                                                  color: greyColor
                                              ),
                                            ),
                                            SizedBox(width: 5,),
                                            Icon(
                                              Icons.arrow_forward_ios_rounded,
                                              size: 15, color: greyColor,)
                                          ],
                                        )
                                    ),
                                  ),
                                ],
                              ),
                              Obx(() {
                                return Container(
                                    height: 200,
                                    padding: EdgeInsets.symmetric(
                                        horizontal: controller.selectedFilterValue.value
                                            == AppConstants.custom || controller.selectedFilterValue.value
                                            == AppConstants.last7Days
                                        ? 110 :
                                        10
                                    ),
                                    child: InvoicesLineChart(
                                      lineChartData: ChartDataMethods
                                          .getLineChartData(
                                          controller.startChosenDate.value,
                                          controller.endChosenDate.value,
                                          controller.filteredInvoices
                                      ),
                                      dateLabels: ChartDataMethods
                                          .generateDateLabels(
                                        controller.startChosenDate.value,
                                        controller.endChosenDate.value,
                                        controller.selectedFilterValue.value,
                                      ),
                                      filterType: controller.selectedFilterValue.value,
                                    )
                                );
                              }),
                            ],
                          );
                        }
                        )
                    ),

                    const SizedBox(height: 15,),

                    CustomContainer(
                      verticalPadding: 10,
                      childContainer: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                margin: const EdgeInsets.only(left: 10),
                                child: const Text('Sales by Client (Top 5)',
                                  style: TextStyle(
                                      fontFamily: 'Montserrat',
                                      fontSize: 15,
                                      fontWeight: FontWeight.w600,
                                      color: blackColor
                                  ),
                                ),
                              ),
                              Container(
                                margin: const EdgeInsets.only(right: 10),
                                child: IconButton(
                                    onPressed: () {
                                      AppSingletons.shareChartDetailTitle
                                          .value = AppConstants.salesByClient;
                                      Get.toNamed(Routes.shareChartDetailView);
                                    },
                                    icon: const Row(
                                      children: [
                                        Text('More',
                                          style: TextStyle(
                                              fontFamily: 'Montserrat',
                                              fontSize: 12,
                                              fontWeight: FontWeight.w600,
                                              color: greyColor
                                          ),
                                        ),
                                        SizedBox(width: 5,),
                                        Icon(
                                          Icons.arrow_forward_ios_rounded,
                                          size: 15,
                                          color: greyColor,)
                                      ],
                                    )
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 15,),
                          Obx(() =>
                              SizedBox(
                                height: 200,
                                child: PieChart(
                                  PieChartData(
                                    sections: controller.topClients
                                        .asMap()
                                        .entries
                                        .map((entry) {
                                      int index = entry.key;
                                      final client = entry.value;
                                      return PieChartSectionData(
                                        value: client.percentage,
                                        title: '${client.percentage
                                            .toStringAsFixed(
                                            1)}%',
                                        color: controller.giveBoxValues(index),
                                        radius: 50,
                                        // Adjust radius as needed
                                        titleStyle: const TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                      );
                                    }).toList(),
                                    sectionsSpace: 2, // Space between sections
                                    centerSpaceRadius: 40, // Space in the center of the pie chart
                                  ),
                                ),
                              )),
                          Obx(() {
                            if (controller.topClients.isEmpty) {
                              return const Center(
                                  child: Text(
                                      'No clients found for the selected period.'));
                            }
                            return ListView.builder(
                              itemCount: controller.topClients.length,
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemBuilder: (context, index) {
                                final client = controller.topClients[index];
                                return ListTile(
                                  leading: Container(
                                    decoration: BoxDecoration(
                                        color: controller.giveBoxValues(index),
                                        borderRadius: BorderRadius.circular(8)
                                    ),
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 8, horizontal: 2),
                                    child: Text(
                                      '${client.percentage.toStringAsFixed(
                                          1)}%',
                                      style: const TextStyle(
                                          fontFamily: 'Montserrat',
                                          fontSize: 12,
                                          color: sWhite,
                                          fontWeight: FontWeight.w600),
                                    ),
                                  ),
                                  title: Row(
                                    mainAxisAlignment: MainAxisAlignment
                                        .spaceBetween,
                                    crossAxisAlignment: CrossAxisAlignment
                                        .center,
                                    children: [
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment
                                            .start,
                                        children: [
                                          Text(
                                            client.clientName,
                                            style: const TextStyle(
                                                fontFamily: 'Montserrat',
                                                fontSize: 15,
                                                color: blackColor,
                                                fontWeight: FontWeight.w600),
                                          ),
                                          Text(
                                            'Invoices: ${client.count
                                                .toString()}',
                                            style: const TextStyle(
                                                fontFamily: 'Montserrat',
                                                fontSize: 12,
                                                color: greyColor
                                            ),
                                          )
                                        ],
                                      ),
                                      Container(
                                        alignment: Alignment.centerRight,
                                        width: 100,
                                        child: Text(
                                          '${AppSingletons.storedInvoiceCurrency
                                              .value}${client.totalAmount
                                              .toStringAsFixed(0)}',
                                          style: const TextStyle(
                                            fontFamily: 'Montserrat',
                                            fontSize: 13,
                                            color: blackColor,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  subtitle: LinearProgressIndicator(
                                    value: client.percentage / 100,
                                    color: controller.giveBoxValues(index),
                                    borderRadius: BorderRadius.circular(50),
                                  ),
                                );
                              },
                            );
                          }),
                        ],
                      ),
                    ),

                    const SizedBox(height: 15,),

                    CustomContainer(
                      verticalPadding: 10,
                      childContainer: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                margin: const EdgeInsets.only(left: 10),
                                child: const Text('Sales by Items (Top 5)',
                                  style: TextStyle(
                                      fontFamily: 'Montserrat',
                                      fontSize: 15,
                                      fontWeight: FontWeight.w600,
                                      color: blackColor
                                  ),
                                ),
                              ),
                              Container(
                                margin: const EdgeInsets.only(right: 10),
                                child: IconButton(
                                    onPressed: () {
                                      AppSingletons.shareChartDetailTitle
                                          .value = AppConstants.salesByItem;
                                      Get.toNamed(Routes.shareChartDetailView);
                                    },
                                    icon: const Row(
                                      children: [
                                        Text('More',
                                          style: TextStyle(
                                              fontFamily: 'Montserrat',
                                              fontSize: 12,
                                              fontWeight: FontWeight.w600,
                                              color: greyColor
                                          ),
                                        ),
                                        SizedBox(width: 5,),
                                        Icon(
                                          Icons.arrow_forward_ios_rounded,
                                          size: 15,
                                          color: greyColor,)
                                      ],
                                    )
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 15,),
                          Obx(() =>
                              SizedBox(
                                height: 200,
                                child: PieChart(
                                  PieChartData(
                                    sections: controller.topItems
                                        .asMap()
                                        .entries
                                        .map((entry) {
                                      int index = entry.key;
                                      final items = entry.value;
                                      return PieChartSectionData(
                                        value: items.percentage,
                                        title: '${items.percentage
                                            .toStringAsFixed(
                                            1)}%',
                                        color: controller.giveBoxValues(index),
                                        radius: 50,
                                        titleStyle: const TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                      );
                                    }).toList(),
                                    sectionsSpace: 2, // Space between sections
                                    centerSpaceRadius: 40, // Space in the center of the pie chart
                                  ),
                                ),
                              )),
                          const SizedBox(height: 15,),
                          Obx(() {
                            if (controller.topItems.isEmpty) {
                              return const Center(
                                  child: Text(
                                      'No Items found for the selected period.'));
                            }
                            return ListView.builder(
                              itemCount: controller.topItems.length,
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemBuilder: (context, index) {
                                final items = controller.topItems[index];
                                return ListTile(
                                  leading: Container(
                                    decoration: BoxDecoration(
                                        color: controller.giveBoxValues(index),
                                        borderRadius: BorderRadius.circular(8)
                                    ),
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 8, horizontal: 2),
                                    child: Text(
                                      '${items.percentage.toStringAsFixed(1)}%',
                                      style: const TextStyle(
                                          fontFamily: 'Montserrat',
                                          fontSize: 12,
                                          color: sWhite,
                                          fontWeight: FontWeight.w600),
                                    ),
                                  ),
                                  title: Row(
                                    mainAxisAlignment: MainAxisAlignment
                                        .spaceBetween,
                                    crossAxisAlignment: CrossAxisAlignment
                                        .center,
                                    children: [
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment
                                            .start,
                                        children: [
                                          Text(
                                            items.itemName,
                                            style: const TextStyle(
                                                fontFamily: 'Montserrat',
                                                fontSize: 15,
                                                color: blackColor,
                                                fontWeight: FontWeight.w600),
                                          ),
                                          Text(
                                            'QTY: ${items.quantity.toString()}',
                                            style: const TextStyle(
                                                fontFamily: 'Montserrat',
                                                fontSize: 12,
                                                color: greyColor
                                            ),
                                          )
                                        ],
                                      ),
                                      Container(
                                        alignment: Alignment.centerRight,
                                        width: 100,
                                        child: Text(
                                          '${AppSingletons.storedInvoiceCurrency
                                              .value}${items.totalAmount
                                              .toStringAsFixed(0)}',
                                          style: const TextStyle(
                                            fontFamily: 'Montserrat',
                                            fontSize: 13,
                                            color: blackColor,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  subtitle: LinearProgressIndicator(
                                    value: items.percentage / 100,
                                    color: controller.giveBoxValues(index),
                                  ),
                                );
                              },
                            );
                          }),
                        ],
                      ),
                    ),

                    const SizedBox(height: 15,),

                  ],
                ),
              );
            }),
          )
      ),
    );
  }

  void _showCustomDateRangeDialog(BuildContext context) async {
    DateTimeRange? pickedRange = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );

    if (pickedRange != null) {
      controller.filterTopClients(
        'custom',
        startDate: pickedRange.start,
        endDate: pickedRange.end,
      );

      controller.filterTopItems(
        'custom',
        startDate: pickedRange.start,
        endDate: pickedRange.end,
      );

      controller.filterInvoicesData(
        'custom',
        startDate: pickedRange.start,
        endDate: pickedRange.end,
      );
    }
  }

}
