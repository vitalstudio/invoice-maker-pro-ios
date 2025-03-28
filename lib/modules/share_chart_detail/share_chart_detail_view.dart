import 'dart:io';
import 'dart:math';
import 'dart:typed_data';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:intl/intl.dart';
import 'package:open_file_manager/open_file_manager.dart';
import 'package:path_provider/path_provider.dart';
import 'package:printing/printing.dart';
import '../../core/widgets/custom_container.dart';
import '../../core/app_singletons/app_singletons.dart';
import '../../core/constants/color/color.dart';
import '../../core/utils/chart_data_methods.dart';
import '../charts_of_data/fl_chart_invoices.dart';
import 'share_chart_detail_controller.dart';
import '../../core/constants/app_constants/App_Constants.dart';

class ShareChartDetailView extends GetView<ShareChartDetailController> {
  const ShareChartDetailView({super.key});

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
        title: Text(
          AppSingletons.shareChartDetailTitle.value == AppConstants.salesTrending
          ? 'sales_trending'.tr
          : AppSingletons.shareChartDetailTitle.value == AppConstants.salesByClient
          ? 'sales_by_client'.tr
          : AppSingletons.shareChartDetailTitle.value == AppConstants.salesByItem
          ? 'sales_by_items'.tr
          : '',
          style: const TextStyle(
            fontFamily: 'SFProDisplay',
            color: sWhite,
            fontSize: 18,
            fontWeight: FontWeight.w700,
            letterSpacing: 1,
          ),
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
      body: Stack(
        children: [
          Positioned(
            left: 0,
            right: 0,
            top: 0,
            bottom: 0,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(
                    height: 15,
                  ),
                  Row(
                    children: [
                      const SizedBox(
                        width: 15,
                      ),
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                              color: sWhite,
                              borderRadius: BorderRadius.circular(5),
                              boxShadow: const [
                                BoxShadow(
                                    color: greyColor,
                                    blurRadius: 10,
                                    spreadRadius: 5)
                              ]),
                          alignment: Alignment.center,
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              const SizedBox(
                                width: 10,
                              ),
                              const Icon(Icons.money),
                              const SizedBox(
                                width: 30,
                              ),
                              Text(
                                AppSingletons.storedInvoiceCurrency.value,
                                style: const TextStyle(
                                    fontFamily: 'Montserrat',
                                    fontSize: 15,
                                    color: blackColor,
                                    fontWeight: FontWeight.w600),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 15,
                      ),
                      Expanded(
                        child: PopupMenuButton<String>(
                            onSelected: (value) {
                              // Apply the selected filter
                              if (value == 'custom') {
                                _showCustomDateRangeDialog(context);
                              } else {
                                controller.filterInvoicesData(value);
                                controller.filterAllClients(value);
                                controller.filterTopItems(value);
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
                              const PopupMenuItem(
                                  value: 'thisyear',
                                  child: Text('This Year')),
                              const PopupMenuItem(
                                  value: 'lastmonth',
                                  child: Text('Last Month')),
                              const PopupMenuItem(
                                  value: 'lastquarter',
                                  child: Text('Last Quarter')),
                              const PopupMenuItem(
                                  value: 'lastyear',
                                  child: Text('Last Year')),
                              const PopupMenuItem(
                                  value: 'custom', child: Text('Custom')),
                            ],
                            child: Container(
                                width: double.infinity,
                                alignment: Alignment.center,
                                padding:
                                const EdgeInsets.symmetric(vertical: 8),
                                decoration: BoxDecoration(
                                    color: sWhite,
                                    borderRadius: BorderRadius.circular(5),
                                    boxShadow: const [
                                      BoxShadow(
                                          color: greyColor,
                                          blurRadius: 10,
                                          spreadRadius: 5)
                                    ]),
                                child: Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceAround,
                                  children: [
                                    const Icon(
                                      Icons.calendar_today,
                                      color: blackColor,
                                    ),
                                    Obx(() {
                                      return Text(
                                          controller.selectedDateFilter.value);
                                    }),
                                    const Icon(
                                      Icons.arrow_drop_down_sharp,
                                      color: blackColor,
                                    ),
                                  ],
                                ))),
                      ),
                      const SizedBox(
                        width: 15,
                      ),
                    ],
                  ),
                  Obx(() {
                    if (AppSingletons.shareChartDetailTitle.value ==
                        AppConstants.salesTrending) {
                      return showDataForSalesTrending(context);
                    } else if (AppSingletons.shareChartDetailTitle.value ==
                        AppConstants.salesByClient) {
                      return showDataForSalesByClient(context);
                    } else {
                      return showDataForSalesByItems(context);
                    }
                  }),
                ],
              ),
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 20,
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: sWhite,
                boxShadow: const [
                  BoxShadow(
                      color: shadowColor, blurRadius: 5, offset: Offset(3, 3)),
                ],
              ),
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Row(
                children: [
                  Expanded(
                      child: InkWell(
                        onTap: () {
                          Printing.layoutPdf(onLayout:
                              (pdfPageFormatPdfPageFormat) async {
                           if(AppSingletons.shareChartDetailTitle.value ==
                               AppConstants.salesTrending){
                             return controller.loadChartPdf();
                           } else if(AppSingletons.shareChartDetailTitle.value ==
                               AppConstants.salesByClient){
                             return controller.loadSalesByClientPdf();
                           } else {
                             return controller.loadSalesByItemPdf();
                           }
                          });
                          debugPrint('PRINT PDF FILE CLICKED');
                        },
                        child:  SizedBox(
                          width: double.infinity,
                          child: Column(
                            children: [
                              const Icon(
                                Icons.print,
                                color: orangeDark_3,
                              ),
                              const SizedBox(height: 5,),
                              Text(
                                'print'.tr,
                                style: const TextStyle(
                                    fontFamily: 'Montserrat',
                                    fontSize: 15,
                                    fontWeight: FontWeight.normal),
                              )
                            ],
                          ),
                        ),
                      )),
                  Expanded(
                      child: InkWell(
                        onTap: () async{
                          if(AppSingletons.shareChartDetailTitle.value == AppConstants.salesTrending)
                          {

                            Uint8List pdfBytes = await controller.loadChartPdf();
                            String fileName = "Sales Trending_${controller.randomNumberId}_${controller.randomAlphabetId}.pdf";

                            if(Platform.isAndroid){
                              try {
                                const downloadsFolderPath = '/storage/emulated/0/Download';
                                Directory dir_2 = Directory(downloadsFolderPath);
                                String invFileDir = "${dir_2.path}/$fileName";
                                File file = await File(invFileDir).create(recursive: true);
                                file.writeAsBytesSync(pdfBytes);
                                debugPrint("File: Path: ${file.path}");
                              } catch (e) {
                                debugPrint('Error: $e');
                              }
                            } else if(Platform.isIOS){
                              try{
                                Directory documentsDir = await getApplicationDocumentsDirectory();
                                String invFileDir = "${documentsDir.path}/$fileName";
                                File file = await File(invFileDir).create(recursive: true);
                                file.writeAsBytesSync(pdfBytes);
                              }catch(e){
                                debugPrint('Error: $e');
                              }
                            }

                            Get.snackbar(
                              onTap: (_) async {
                                debugPrint('File Name: Sales Trending_${controller.randomNumberId}_${controller.randomAlphabetId}.pdf');
                                openFileManager();
                              },
                              'Sales Trending_${controller.randomNumberId}_${controller.randomAlphabetId}.pdf',
                              'PDF Exported to download directory',
                              colorText: orangeLight_1,
                              borderRadius: 8,
                              margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                              backgroundColor: mainPurpleColor,
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                              snackPosition: SnackPosition.BOTTOM,
                              isDismissible: true,
                              dismissDirection:
                              DismissDirection.startToEnd,
                              forwardAnimationCurve:
                              Curves.easeOutBack,
                            );

                          }
                          else if(AppSingletons.shareChartDetailTitle.value == AppConstants.salesByClient)
                          {
                            Uint8List pdfBytes = await controller.loadSalesByClientPdf();
                            String fileName = "Sales By Client_${controller.randomNumberId}_${controller.randomAlphabetId}.pdf";

                            if(Platform.isAndroid){
                              try {
                                const downloadsFolderPath = '/storage/emulated/0/Download';
                                Directory dir_2 = Directory(downloadsFolderPath);
                                String invFileDir = "${dir_2.path}/$fileName";
                                File file = await File(invFileDir).create(recursive: true);
                                file.writeAsBytesSync(pdfBytes);
                                debugPrint("File: Path: ${file.path}");
                              } catch (e) {
                                debugPrint('Error: $e');
                              }
                            } else if(Platform.isIOS){
                              try{
                                Directory documentsDir = await getApplicationDocumentsDirectory();
                                String invFileDir = "${documentsDir.path}/$fileName";
                                File file = await File(invFileDir).create(recursive: true);
                                file.writeAsBytesSync(pdfBytes);
                              }catch(e){
                                debugPrint('Error: $e');
                              }
                            }

                            Get.snackbar(
                              onTap: (_) async {
                                debugPrint('File Name: Sales By Client_${controller.randomNumberId}_${controller.randomAlphabetId}.pdf');
                                openFileManager();
                              },
                              'Sales By Client_${controller.randomNumberId}_${controller.randomAlphabetId}.pdf',
                              'PDF Exported to download directory',
                              colorText: orangeLight_1,
                              borderRadius: 8,
                              margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                              backgroundColor: mainPurpleColor,
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                              snackPosition: SnackPosition.BOTTOM,
                              isDismissible: true,
                              dismissDirection:
                              DismissDirection.startToEnd,
                              forwardAnimationCurve:
                              Curves.easeOutBack,
                            );
                          }
                          else
                          {
                            Uint8List pdfBytes = await controller.loadSalesByItemPdf();
                            String fileName = "Sales By Item_${controller.randomNumberId}_${controller.randomAlphabetId}.pdf";

                            if(Platform.isAndroid){
                              try {
                                const downloadsFolderPath = '/storage/emulated/0/Download';
                                Directory dir_2 = Directory(downloadsFolderPath);
                                String invFileDir = "${dir_2.path}/$fileName";
                                File file = await File(invFileDir).create(recursive: true);
                                file.writeAsBytesSync(pdfBytes);
                                debugPrint("File: Path: ${file.path}");
                              } catch (e) {
                                debugPrint('Error: $e');
                              }
                            } else  if(Platform.isIOS){
                              try{
                                Directory documentsDir = await getApplicationDocumentsDirectory();
                                String invFileDir = "${documentsDir.path}/$fileName";
                                File file = await File(invFileDir).create(recursive: true);
                                file.writeAsBytesSync(pdfBytes);
                              }catch(e){
                                debugPrint('Error: $e');
                              }
                            }

                            Get.snackbar(
                              onTap: (_) async {
                                debugPrint('File Name: Sales By Item_${controller.randomNumberId}_${controller.randomAlphabetId}.pdf');
                                openFileManager();
                              },
                              'Sales By Item_${controller.randomNumberId}_${controller.randomAlphabetId}.pdf',
                              'PDF Exported to download directory',
                              colorText: orangeLight_1,
                              borderRadius: 8,
                              margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                              backgroundColor: mainPurpleColor,
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                              snackPosition: SnackPosition.BOTTOM,
                              isDismissible: true,
                              dismissDirection:
                              DismissDirection.startToEnd,
                              forwardAnimationCurve:
                              Curves.easeOutBack,
                            );
                          }
                        },
                        child:  SizedBox(
                          width: double.infinity,
                          child: Column(
                            children: [
                              const  Icon(
                                Icons.picture_as_pdf_outlined,
                                color: orangeDark_3,
                              ),
                              const SizedBox(height: 5,),
                              Text(
                                'export'.tr,
                                style: const TextStyle(
                                    fontFamily: 'Montserrat',
                                    fontSize: 15,
                                    fontWeight: FontWeight.normal),
                              )
                            ],
                          ),
                        ),
                      )),
                  Expanded(
                      child: InkWell(
                        onTap: () async{
                          if(AppSingletons.shareChartDetailTitle.value ==
                              AppConstants.salesTrending){
                            Printing.sharePdf(
                                bytes: await controller.loadChartPdf(),
                          filename: 'Sales Trending_${controller.randomNumberId}_${controller.randomAlphabetId}.pdf'
                          );
                          } else if(AppSingletons.shareChartDetailTitle.value ==
                          AppConstants.salesByClient){
                          Printing.sharePdf(
                          bytes: await controller.loadSalesByClientPdf(),
                          filename: 'Sales By Client${controller.randomNumberId}_${controller.randomAlphabetId}.pdf'
                          );
                          } else {
                          Printing.sharePdf(
                          bytes: await controller.loadSalesByItemPdf(),
                          filename: 'Sales By Item${controller.randomNumberId}_${controller.randomAlphabetId}.pdf'
                          );
                          }
                        },
                        child:  SizedBox(
                          width: double.infinity,
                          child: Column(
                            children: [
                              const Icon(
                                Icons.share,
                                color: orangeDark_3,
                              ),
                              const SizedBox(height: 5,),
                              Text(
                                'share'.tr,
                                style: const TextStyle(
                                    fontFamily: 'Montserrat',
                                    fontSize: 15,
                                    fontWeight: FontWeight.normal),
                              )
                            ],
                          ),
                        ),
                      )),
                ],
              ),
            ),
          )
        ],
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
        title: Text(
          AppSingletons.shareChartDetailTitle.value,
          style: const TextStyle(
            fontFamily: 'SFProDisplay',
            color: sWhite,
            fontSize: 18,
            fontWeight: FontWeight.w700,
            letterSpacing: 1,
          ),
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
      body: Container(
        width: double.infinity,
        height: double.infinity,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            end: Alignment.bottomCenter,
            begin: Alignment.topCenter,
            colors: [
              mainPurpleColor.withOpacity(0.4),
              mainPurpleColor.withOpacity(0.7),
              mainPurpleColor,
            ]
          )
        ),
        child: Container(
          width: MediaQuery
              .of(context)
              .size
              .width * 0.5,
          height: double.infinity,
          margin: const EdgeInsets.symmetric(vertical: 15),
          decoration: BoxDecoration(
              color: sWhite, borderRadius: BorderRadius.circular(10)),
          child: Stack(
            children: [
              Positioned(
                left: 0,
                right: 0,
                top: 0,
                bottom: 0,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 15,
                      ),
                      Row(
                        children: [
                          const SizedBox(
                            width: 15,
                          ),
                          Expanded(
                            child: Container(
                              decoration: BoxDecoration(
                                  color: sWhite,
                                  borderRadius: BorderRadius.circular(5),
                                  boxShadow: const [
                                    BoxShadow(
                                        color: greyColor,
                                        blurRadius: 10,
                                        spreadRadius: 5)
                                  ]),
                              alignment: Alignment.center,
                              padding: const EdgeInsets.symmetric(vertical: 8),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  const Icon(Icons.money),
                                  const SizedBox(
                                    width: 30,
                                  ),
                                  Text(
                                    AppSingletons.storedInvoiceCurrency.value,
                                    style: const TextStyle(
                                        fontFamily: 'Montserrat',
                                        fontSize: 15,
                                        color: blackColor,
                                        fontWeight: FontWeight.w600),
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 15,
                          ),
                          Expanded(
                            child: PopupMenuButton<String>(
                                onSelected: (value) {
                                  // Apply the selected filter
                                  if (value == 'custom') {
                                    _showCustomDateRangeDialog(context);
                                  } else {
                                    controller.filterInvoicesData(value);
                                    controller.filterAllClients(value);
                                    controller.filterTopItems(value);
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
                                  const PopupMenuItem(
                                      value: 'thisyear',
                                      child: Text('This Year')),
                                  const PopupMenuItem(
                                      value: 'lastmonth',
                                      child: Text('Last Month')),
                                  const PopupMenuItem(
                                      value: 'lastquarter',
                                      child: Text('Last Quarter')),
                                  const PopupMenuItem(
                                      value: 'lastyear',
                                      child: Text('Last Year')),
                                  const PopupMenuItem(
                                      value: 'custom', child: Text('Custom')),
                                ],
                                child: Container(
                                    width: double.infinity,
                                    alignment: Alignment.center,
                                    padding:
                                    const EdgeInsets.symmetric(vertical: 8),
                                    decoration: BoxDecoration(
                                        color: sWhite,
                                        borderRadius: BorderRadius.circular(5),
                                        boxShadow: const [
                                          BoxShadow(
                                              color: greyColor,
                                              blurRadius: 10,
                                              spreadRadius: 5)
                                        ]),
                                    child: Row(
                                      mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                      children: [
                                        const Icon(
                                          Icons.calendar_today,
                                          color: blackColor,
                                        ),
                                        Obx(() {
                                          return Text(
                                              controller.selectedDateFilter.value);
                                        }),
                                        const Icon(
                                          Icons.arrow_drop_down_sharp,
                                          color: blackColor,
                                        ),
                                      ],
                                    ))),
                          ),
                          const SizedBox(
                            width: 15,
                          ),
                        ],
                      ),
                      Obx(() {
                        if (AppSingletons.shareChartDetailTitle.value ==
                            AppConstants.salesTrending) {
                          return showDataForSalesTrending(context);
                        } else if (AppSingletons.shareChartDetailTitle.value ==
                            AppConstants.salesByClient) {
                          return showDataForSalesByClient(context);
                        } else {
                          return showDataForSalesByItems(context);
                        }
                      }),
                    ],
                  ),
                ),
              ),
              Positioned(
                left: 0,
                right: 0,
                bottom: 20,
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: sWhite,
                    boxShadow: const [
                      BoxShadow(
                          color: shadowColor, blurRadius: 5, offset: Offset(3, 3)),
                    ],
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Row(
                    children: [
                      Expanded(
                          child: InkWell(
                            onTap: () {
                              Printing.layoutPdf(onLayout:
                                  (pdfPageFormatPdfPageFormat) async {
                                if(AppSingletons.shareChartDetailTitle.value ==
                                    AppConstants.salesTrending){
                                  return controller.loadChartPdf();
                                } else if(AppSingletons.shareChartDetailTitle.value ==
                                    AppConstants.salesByClient){
                                  return controller.loadSalesByClientPdf();
                                } else {
                                  return controller.loadSalesByItemPdf();
                                }
                              });
                              debugPrint('PRINT PDF FILE CLICKED');
                            },
                            child: const SizedBox(
                              width: double.infinity,
                              child: Column(
                                children: [
                                  Icon(
                                    Icons.print,
                                    color: orangeDark_3,
                                  ),
                                  SizedBox(height: 5,),
                                  Text(
                                    'Print',
                                    style: TextStyle(
                                        fontFamily: 'Montserrat',
                                        fontSize: 15,
                                        fontWeight: FontWeight.normal),
                                  )
                                ],
                              ),
                            ),
                          )),
                      Expanded(
                          child: InkWell(
                            onTap: () async{
                              if(AppSingletons.shareChartDetailTitle.value == AppConstants.salesTrending)
                              {
                                try {

                                  Uint8List pdfBytes = await controller.loadChartPdf();
                                  String fileName = "Sales Trending_${controller.randomNumberId}_${controller.randomAlphabetId}.pdf";
                                  controller.downloadPdfInDesktop(pdfBytes, fileName);

                                } catch (e) {
                                  debugPrint('Error: $e');
                                }

                                Get.snackbar(
                                  onTap: (_) async {
                                    debugPrint('File Name: Sales Trending_${controller.randomNumberId}_${controller.randomAlphabetId}.pdf');
                                    openFileManager();
                                  },
                                  'Sales Trending_${controller.randomNumberId}_${controller.randomAlphabetId}.pdf',
                                  'PDF Exported to download directory',
                                  colorText: orangeLight_1,
                                  borderRadius: 8,
                                  margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                                  backgroundColor: mainPurpleColor,
                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                  snackPosition: SnackPosition.BOTTOM,
                                  isDismissible: true,
                                  dismissDirection:
                                  DismissDirection.startToEnd,
                                  forwardAnimationCurve:
                                  Curves.easeOutBack,
                                );

                              }
                              else if(AppSingletons.shareChartDetailTitle.value == AppConstants.salesByClient)
                              {
                                try {
                                  Uint8List pdfBytes = await controller.loadSalesByClientPdf();
                                  String fileName = "Sales By Client_${controller.randomNumberId}_${controller.randomAlphabetId}.pdf";
                                  controller.downloadPdfInDesktop(pdfBytes, fileName);
                                } catch (e) {
                                  debugPrint('Error: $e');
                                }

                                Get.snackbar(
                                  onTap: (_) async {
                                    debugPrint('File Name: Sales By Client_${controller.randomNumberId}_${controller.randomAlphabetId}.pdf');
                                    openFileManager();
                                  },
                                  'Sales By Client_${controller.randomNumberId}_${controller.randomAlphabetId}.pdf',
                                  'PDF Exported to download directory',
                                  colorText: orangeLight_1,
                                  borderRadius: 8,
                                  margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                                  backgroundColor: mainPurpleColor,
                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                  snackPosition: SnackPosition.BOTTOM,
                                  isDismissible: true,
                                  dismissDirection:
                                  DismissDirection.startToEnd,
                                  forwardAnimationCurve:
                                  Curves.easeOutBack,
                                );
                              }
                              else
                              {
                                try {

                                  Uint8List pdfBytes = await controller.loadSalesByItemPdf();
                                  String fileName = "Sales By Item_${controller.randomNumberId}_${controller.randomAlphabetId}.pdf";
                                  controller.downloadPdfInDesktop(pdfBytes, fileName);

                                } catch (e) {
                                  debugPrint('Error: $e');
                                }

                                Get.snackbar(
                                  onTap: (_) async {
                                    debugPrint('File Name: Sales By Item_${controller.randomNumberId}_${controller.randomAlphabetId}.pdf');
                                    openFileManager();
                                  },
                                  'Sales By Item_${controller.randomNumberId}_${controller.randomAlphabetId}.pdf',
                                  'PDF Exported to download directory',
                                  colorText: orangeLight_1,
                                  borderRadius: 8,
                                  margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                                  backgroundColor: mainPurpleColor,
                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                  snackPosition: SnackPosition.BOTTOM,
                                  isDismissible: true,
                                  dismissDirection:
                                  DismissDirection.startToEnd,
                                  forwardAnimationCurve:
                                  Curves.easeOutBack,
                                );
                              }
                            },
                            child: const SizedBox(
                              width: double.infinity,
                              child: Column(
                                children: [
                                  Icon(
                                    Icons.picture_as_pdf_outlined,
                                    color: orangeDark_3,
                                  ),
                                  SizedBox(height: 5,),
                                  Text(
                                    'Export',
                                    style: TextStyle(
                                        fontFamily: 'Montserrat',
                                        fontSize: 15,
                                        fontWeight: FontWeight.normal),
                                  )
                                ],
                              ),
                            ),
                          )),
                      Expanded(
                          child: InkWell(
                            onTap: () async{
                              if(AppSingletons.shareChartDetailTitle.value ==
                                  AppConstants.salesTrending){
                                controller.sharePdfFile(
                                    await controller.loadChartPdf(),
                                    'Sales Trending_${controller.randomNumberId}_${controller.randomAlphabetId}.pdf'
                                );

                              } else if(AppSingletons.shareChartDetailTitle.value ==
                                  AppConstants.salesByClient){
                                controller.sharePdfFile(
                                    await controller.loadSalesByClientPdf(),
                                    'Sales By Client${controller.randomNumberId}_${controller.randomAlphabetId}.pdf'
                                );
                              } else {
                                controller.sharePdfFile(
                                    await controller.loadSalesByItemPdf(),
                                    'Sales By Item${controller.randomNumberId}_${controller.randomAlphabetId}.pdf'
                                );

                              }
                            },
                            child: const SizedBox(
                              width: double.infinity,
                              child: Column(
                                children: [
                                  Icon(
                                    Icons.share,
                                    color: orangeDark_3,
                                  ),
                                  SizedBox(height: 5,),
                                  Text(
                                    'Share',
                                    style: TextStyle(
                                        fontFamily: 'Montserrat',
                                        fontSize: 15,
                                        fontWeight: FontWeight.normal),
                                  )
                                ],
                              ),
                            ),
                          )),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget showDataForSalesTrending(BuildContext context) {
    return Obx(() {
      return controller.isLoadingData.value
          ? const Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            height: 300,
          ),
          Center(
            child: CupertinoActivityIndicator(
              color: mainPurpleColor,
              radius: 15,
            ),
          ),
        ],
      )
          : Column(
        children: [
          const SizedBox(
            height: 15,
          ),
          CustomContainer(
            verticalPadding: 10,
            horizontalPadding: 10,
            childContainer: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                     Text(
                      'line_chart'.tr,
                      style: const TextStyle(
                          fontFamily: 'Montserrat',
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: blackColor,
                          letterSpacing: 1),
                    ),
                    Text(
                      '${DateFormat('dd/MM').format(controller.startChosenDate
                          .value)} - ${DateFormat('dd/MM').format(controller
                          .endChosenDate.value)} ',
                      style: const TextStyle(
                        fontFamily: 'Montserrat',
                        fontSize: 15,
                        color: greyColor,
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 15,
                ),
                Container(
                    height: 200,
                    padding: EdgeInsets.symmetric(horizontal:
                    AppConstants.isMobileScreen.value
                        ? 10
                        :  controller.selectedFilterValue.value == AppConstants.custom
                    || controller.selectedFilterValue.value == AppConstants.last7Days
                        ? 110 : 10
                    ),
                    child: InvoicesLineChart(
                      lineChartData: ChartDataMethods.getLineChartData(
                          controller.startChosenDate.value,
                          controller.endChosenDate.value,
                          controller.filteredInvoices),
                      dateLabels: ChartDataMethods.generateDateLabels(
                        controller.startChosenDate.value,
                        controller.endChosenDate.value,
                        controller.selectedFilterValue.value,
                      ),
                      filterType: controller.selectedFilterValue.value,
                    )),
              ],
            ),
          ),
          const SizedBox(
            height: 15,
          ),
          Obx(() =>
              CustomContainer(
                childContainer: Table(
                  children: [
                    TableRow(
                      decoration: BoxDecoration(
                          color: greyColor.withOpacity(0.6),
                          borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(8),
                              topRight: Radius.circular(8))),
                      children: [
                        Container(
                          alignment: Alignment.center,
                          padding:
                          const EdgeInsets.symmetric(vertical: 8),
                          child:  Text(
                            'date'.tr,
                            style:
                            const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                        Container(
                          alignment: Alignment.center,
                          padding:
                          const EdgeInsets.symmetric(vertical: 8),
                          child: Text(
                            'invoices'.tr,
                            style:
                            const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                        Container(
                          alignment: Alignment.center,
                          padding:
                          const EdgeInsets.symmetric(vertical: 8),
                          child: Text(
                            'sales'.tr,
                            style:
                            const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                        Container(
                          alignment: Alignment.center,
                          padding:
                          const EdgeInsets.symmetric(vertical: 8),
                          child: Text(
                            'paid'.tr,
                            style:
                            const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                    ...List.generate(controller.fetchAllDates.length,
                            (index) {
                          return TableRow(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(8.0),
                                alignment: Alignment.center,
                                child: Text(
                                  controller.fetchAllDates[index],
                                  style: const TextStyle(fontSize: 12),
                                ),
                              ),
                              Container(
                                alignment: Alignment.center,
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  controller.fetchInvoiceCount[index],
                                  style: const TextStyle(fontSize: 12),
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.all(8.0),
                                alignment: Alignment.center,
                                child: Text(
                                  controller
                                      .fetchFinalAmountTotalList[index],
                                  style: const TextStyle(fontSize: 12),
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.all(8.0),
                                alignment: Alignment.center,
                                child: Text(
                                  controller.fetchOnlyPaidAmountList[index],
                                  style: const TextStyle(fontSize: 12),
                                ),
                              ),
                            ],
                          );
                        }),
                    TableRow(
                      decoration: BoxDecoration(
                          color: greyColor.withOpacity(0.6),
                          borderRadius: const BorderRadius.only(
                              bottomRight: Radius.circular(8),
                              bottomLeft: Radius.circular(8))),
                      children: [
                        Container(
                          alignment: Alignment.center,
                          padding:
                          const EdgeInsets.symmetric(vertical: 8),
                          child: const Text(
                            'Total',
                            style:
                            TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                        Container(
                          alignment: Alignment.center,
                          padding:
                          const EdgeInsets.symmetric(vertical: 8),
                          child: Text(
                            '${controller.totalInvoicesCount.value}',
                            style: const TextStyle(
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        Container(
                          alignment: Alignment.center,
                          padding:
                          const EdgeInsets.symmetric(vertical: 8),
                          child: Text(
                            '${controller.totalSalesAmount.value}',
                            style: const TextStyle(
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        Container(
                          alignment: Alignment.center,
                          padding:
                          const EdgeInsets.symmetric(vertical: 8),
                          child: Text(
                            '${controller.totalPaid.value}',
                            style: const TextStyle(
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              )),
          const SizedBox(
            height: 100,
          ),
        ],
      );
    });
  }

  Widget showDataForSalesByClient(BuildContext context) {
    return Obx(() {
      return controller.isLoadingData.value
          ? const Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            height: 300,
          ),
          Center(
            child: CupertinoActivityIndicator(
              color: mainPurpleColor,
              radius: 15,
            ),
          ),
        ],
      )
          : Column(
        children: [
          const SizedBox(height: 15,),

          CustomContainer(
            horizontalPadding: 10,
            verticalPadding: 15,
            childContainer: Row(
              children: [
                Expanded(
                  child: Column(
                    children: [
                       Text('${'total'.tr} ${'invoices'.tr}',
                        style: const TextStyle(
                            fontFamily: 'Montserrat',
                            fontSize: 14,
                            color: greyColor
                        ),
                      ),

                      const SizedBox(height: 10,),

                      Obx(() {
                        return Text(
                          '${controller.totalInvoicesCount.value}',
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
                       Text('total_sales'.tr,
                        style: const TextStyle(
                            fontFamily: 'Montserrat',
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: greyColor
                        ),
                      ),
                      const SizedBox(height: 10,),

                      Obx(() {
                        return Text(
                          '${AppSingletons.storedInvoiceCurrency
                              .value}${controller.totalSalesAsClient.value}',
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
              ],
            ),
          ),

          const SizedBox(height: 15,),
          ListView.builder(
              itemCount: controller.filterByClient.length,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                var clientSummary = controller.filterByClient[index];
                return Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  child: CustomContainer(
                    childContainer: ListTile(
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
                            '${clientSummary.percentage.toStringAsFixed(1)}%',
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
                                  clientSummary.clientName,
                                  style: const TextStyle(
                                      fontFamily: 'Montserrat',
                                      fontSize: 15,
                                      color: blackColor,
                                      fontWeight: FontWeight.w600),
                                ),
                                Text(
                                  'Invoices: ${clientSummary.count.toString()}',
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
                                    .value}${clientSummary.totalAmount
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
                          value: clientSummary.percentage / 100,
                          color: controller.giveBoxValues(index),
                          borderRadius: BorderRadius.circular(50),
                        )
                    ),
                  ),
                );
              }),
          const SizedBox(height: 100,),
        ],
      );
    });
  }

  Widget showDataForSalesByItems(BuildContext context) {
    return Obx(() {
      return controller.isLoadingData.value
          ? const Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            height: 300,
          ),
          Center(
            child: CupertinoActivityIndicator(
              color: mainPurpleColor,
              radius: 15,
            ),
          ),
        ],
      )
          : Column(
        children: [
          const SizedBox(height: 15,),
          CustomContainer(
            horizontalPadding: 10,
            verticalPadding: 15,
            childContainer: Row(
              children: [
                Expanded(
                  child: Column(
                    children: [
                      const Text('Total Quantity',
                        style: TextStyle(
                            fontFamily: 'Montserrat',
                            fontSize: 14,
                            color: greyColor
                        ),
                      ),

                      const SizedBox(height: 10,),

                      Obx(() {
                        return Text(
                          '${controller.totalItemsQTY.value}',
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
                       Text('total_sales'.tr,
                        style: const TextStyle(
                            fontFamily: 'Montserrat',
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: greyColor
                        ),
                      ),
                      const SizedBox(height: 10,),

                      Obx(() {
                        return Text(
                          '${AppSingletons.storedInvoiceCurrency
                              .value}${controller.totalSalesByItems.value}',
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
              ],
            ),
          ),
          const SizedBox(height: 15,),
          ListView.builder(
              itemCount: controller.filterAllItems.length,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                var itemSummary = controller.filterAllItems[index];
                return Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  child: CustomContainer(
                    childContainer: ListTile(
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
                            '${itemSummary.percentage.toStringAsFixed(1)}%',
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
                                  itemSummary.itemName,
                                  style: const TextStyle(
                                      fontFamily: 'Montserrat',
                                      fontSize: 15,
                                      color: blackColor,
                                      fontWeight: FontWeight.w600),
                                ),
                                Text(
                                  'QTY: ${itemSummary.quantity.toString()}',
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
                                    .value}${itemSummary.totalAmount
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
                          value: itemSummary.percentage / 100,
                          color: controller.giveBoxValues(index),
                          borderRadius: BorderRadius.circular(50),
                        )
                    ),
                  ),
                );
              }),
          const SizedBox(height: 100,),
        ],
      );
    });
  }

  void _showCustomDateRangeDialog(BuildContext context) async {
    DateTimeRange? pickedRange = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );

    if (pickedRange != null) {
      controller.filterAllClients(
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

  Color getRandomColor() {
    Color color;
    do {
      color =
          Color((Random().nextDouble() * 0xFFFFFF).toInt()).withOpacity(1.0);
    } while (color.computeLuminance() > 0.8);

    return color;
  }
}
