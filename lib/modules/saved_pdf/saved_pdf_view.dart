import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:path_provider/path_provider.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'saved_pdf_controller.dart';
import 'package:open_file_manager/open_file_manager.dart';
import 'package:printing/printing.dart';
import '../../core/app_singletons/app_singletons.dart';
import '../../core/constants/app_constants/App_Constants.dart';
import '../../core/constants/color/color.dart';
import '../../core/preferenceManager/sharedPreferenceManager.dart';
import '../../core/routes/routes.dart';
import '../../core/utils/utils.dart';
import '../bottom_nav_bar/bottom_nav_bar_controller.dart';

class SavedPdfView extends GetView<SavedPdfController>{
  const SavedPdfView({super.key});

  @override
  Widget build(BuildContext context) {

    final controller = Get.put<SavedPdfController>(SavedPdfController());

    bool checkIsMobileLayout = AppConstants.isMobileScreen.value;

    return checkIsMobileLayout
    ? mainMobileScreen(context)
    : mainDesktopScreen(context);
  }

  Widget mainMobileScreen(BuildContext context) {
    return Scaffold(
      backgroundColor: orangeLight_1,
      appBar: AppBar(
        backgroundColor: mainPurpleColor,
        leading: IconButton(
          onPressed: (){
            if (AppSingletons.isInvoiceDocument.value) {
              Utils.clearInvoiceVariables();
              controller.homeScController.loadInvoiceData();
              AppSingletons.storedInvoiceCurrency.value = SharedPreferencesManager.getValue('setDefaultCurrency_INV') ?? 'Rs';
              if (!AppSingletons.isEditInvoice.value) {
                Timer(const Duration(milliseconds: 500), () async {
                  await Utils.rateUs(
                      'invoice_success'.tr);
                });
              }
              Get.offAllNamed(Routes.bottomNavBar);
            }
            else {
              Utils.clearEstimateVariables();
              controller.estListController.loadEstimateData();
              Get.offAllNamed(Routes.bottomNavBar);
              Future.delayed(const Duration(milliseconds: 80), () {
                Get.find<BottomNavController>().changePage(1);
              });
            }
          },
          icon: const Icon(Icons.arrow_back,color: sWhite,),
        ),
        title: Text(
         AppSingletons.isInvoiceDocument.value ? 'invoice'.tr : 'estimate'.tr,
          style: const TextStyle(
              fontFamily: 'SFProDisplay',
              color: sWhite,
              fontWeight: FontWeight.w700,
              letterSpacing: 1,
              fontSize: 16),
        ),
        actions: [
          Obx(() {
            return Visibility(
              visible: !AppSingletons.isMakingNewINVEST.value,
              child: IconButton(
                  onPressed: () {
                    if (AppSingletons.isEditInvoice.value) {
                      Get.toNamed(
                        Routes.invoiceInputView,
                      );
                    } else {
                      Get.toNamed(
                        Routes.estimateInputView,
                      );
                    }
                    AppSingletons.isEditingOnlyTemplate.value = false;
                  },
                  icon: const Icon(
                    Icons.edit,
                    color: sWhite,
                    size: 20,
                  )),
            );
          }),
        ],
      ),
      body: WillPopScope(
        onWillPop: () async {
          if (AppSingletons.isInvoiceDocument.value) {
            await Utils.clearInvoiceVariables();
            controller.homeScController.loadInvoiceData();
            AppSingletons.storedInvoiceCurrency.value =
                SharedPreferencesManager.getValue('setDefaultCurrency_INV') ??
                    'Rs';
            if (!AppSingletons.isEditInvoice.value) {
              Timer(const Duration(milliseconds: 500), () async {
                await Utils.rateUs('Congratulations! You made an invoice!');
              });
            }
          }
          else {
            await Utils.clearEstimateVariables();
            controller.estListController.loadEstimateData();
          }
          return true;
        }, child: Obx((){
            return controller.isLoading.value
                ? const Center(
              child: CupertinoActivityIndicator(
                color: mainPurpleColor,
                radius: 20,
              ),
            )
                : Stack(
              children: [
                Container(
                  margin: const EdgeInsets.only(top: 15, bottom: 100),
                  child:
                      FutureBuilder<Uint8List> (
                        future: controller.pdfFuture,
                        builder: (context, snapshot) {
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return const Center(child: CupertinoActivityIndicator(color: mainPurpleColor,radius: 15,));
                          } else if (snapshot.hasError) {
                            return const Center(child: Text('LOADING...'));
                          } else if (snapshot.hasData) {
                            return SfPdfViewerTheme(
                              data: const SfPdfViewerThemeData(
                                backgroundColor: orangeLight_1,
                                progressBarColor: mainPurpleColor,
                              ),
                              child: SfPdfViewer.memory(
                                  snapshot.data!,
                                  onTap: (_){

                                      Get.toNamed(Routes.pdfTemplateSelect);
                                      AppSingletons.isEditingOnlyTemplate.value = true;
                                      debugPrint('ABC 2');

                                  },
                              ),
                            );
                          } else {
                            return Center(child: Text('no_pdf_data'.tr));
                          }
                        },
                  ),

                  // PdfPreviewCustom(
                  //   scrollViewDecoration: const BoxDecoration(
                  //     color: orangeLight_1,
                  //   ),
                  //   loadingWidget: const CupertinoActivityIndicator(
                  //     color: mainPurpleColor,
                  //     radius: 20,
                  //   ),
                  //   pageFormat: PdfPageFormat.a4,
                  //   previewPageMargin: const EdgeInsets.all(8.0),
                  //   build: (format) => controller.loadTemplateData(),
                  // ),

                ),
                Obx(() {
                  if (controller.currentStatusOfData.value == AppConstants.paidInvoice) {
                    return Transform.rotate(
                      angle: -0.7854,
                      child: Center(
                        child: Container(
                          decoration: BoxDecoration(
                              border:
                              Border.all(color: greenColor, width: 2),
                              borderRadius: BorderRadius.circular(10)),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 15, vertical: 10),
                          child: Text(
                            'paid'.tr,
                            style: const TextStyle(
                                fontFamily: 'Montserrat',
                                fontWeight: FontWeight.w600,
                                color: greenColor,
                                fontSize: 20),
                          ),
                        ),
                      ),
                    );
                  } else if (controller.isOverdue.value) {
                    return const SizedBox.shrink();
                  } else if (controller.currentStatusOfData.value ==
                          AppConstants.partiallyPaidInvoice) {
                    return Transform.rotate(
                      angle: -0.7854,
                      child: Center(
                        child: Container(
                          decoration: BoxDecoration(
                              border:
                              Border.all(color: greenColor, width: 2),
                              borderRadius: BorderRadius.circular(10)),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 15, vertical: 10),
                          child: Text(
                            'partially_paid'.tr,
                            style: const TextStyle(
                                fontFamily: 'Montserrat',
                                fontWeight: FontWeight.w600,
                                color: greenColor,
                                fontSize: 20),
                          ),
                        ),
                      ),
                    );
                  } else {
                    return const SizedBox.shrink();
                  }
                }),
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10),
                    decoration: BoxDecoration(
                        color: sWhite,
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: const [
                          BoxShadow(
                              color: shadowColor,
                              spreadRadius: 5,
                              blurRadius: 3,
                              offset: Offset(5, 5)),
                        ]),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                                onPressed: () async {
                                  Printing.sharePdf(
                                      bytes: await controller.loadTemplateData(),
                                      filename: 'my_doc_${controller.randomId}.pdf');
                                  debugPrint('SHARE PDF FILE CLICKED');
                                },
                                icon: const Icon(
                                  Icons.share,
                                  size: 30,
                                  color: grey_1,
                                )),
                             Text(
                              'share'.tr,
                              style: const TextStyle(
                                fontFamily: 'Montserrat',
                                color: grey_1,
                                fontSize: 16,
                              ),
                            )
                          ],
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                                onPressed: () async {

                                  Uint8List pdfBytes = await controller.loadTemplateData();
                                  String fileName = "INV${controller.randomId}.pdf";

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
                                  }
                                  else if(Platform.isIOS){
                                    try{
                                      Directory documentsDir = await getApplicationDocumentsDirectory();
                                      String invFileDir = "${documentsDir.path}/$fileName";
                                      File file = await File(invFileDir).create(recursive: true);
                                      file.writeAsBytesSync(pdfBytes);
                                    }catch(e){
                                      debugPrint('Error: $e');
                                    }
                                  }
                                  debugPrint('SAVE PDF FILE CLICKED');
                                  Get.snackbar(
                                    onTap: (_) async {
                                      debugPrint(
                                          'File Name: INV${controller.randomId}.pdf');
                                      openFileManager();
                                    },
                                    'INV${controller.randomId}.pdf',
                                    'Saved in download directory',
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
                                },
                                icon: const Icon(
                                  Icons.download,
                                  size: 30,
                                  color: grey_1,
                                )),
                             Text(
                              'download'.tr,
                              style: const TextStyle(
                                fontFamily: 'Montserrat',
                                color: grey_1,
                                fontSize: 16,
                              ),
                            )
                          ],
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                                onPressed: () {
                                  Printing.layoutPdf(onLayout:
                                      (pdfPageFormatPdfPageFormat) async {
                                    return controller.loadTemplateData();
                                  });
                                  debugPrint('PRINT PDF FILE CLICKED');
                                },
                                icon: const Icon(
                                  Icons.print,
                                  size: 30,
                                  color: grey_1,
                                )),
                             Text(
                              'print'.tr,
                              style: const TextStyle(
                                fontFamily: 'Montserrat',
                                color: grey_1,
                                fontSize: 16,
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          }
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

  Widget mainDesktopScreen(BuildContext context) {
    return Scaffold(
      backgroundColor: orangeLight_1,
      appBar: AppBar(
        backgroundColor: mainPurpleColor,
        leading: IconButton(
          onPressed: (){
            if (AppSingletons.isInvoiceDocument.value) {
              Utils.clearInvoiceVariables();
              controller.homeScController.loadInvoiceData();
              AppSingletons.storedInvoiceCurrency.value = SharedPreferencesManager.getValue('setDefaultCurrency_INV') ?? 'Rs';
              // if (!AppSingletons.isEditInvoice.value) {
              //   Timer(const Duration(milliseconds: 500), () async {
              //     await Utils.rateUs(
              //         'Congratulations! You made an invoice!');
              //   });
              // }
              Get.offAllNamed(Routes.bottomNavBar);
            }
            else {
              Utils.clearEstimateVariables();
              controller.estListController.loadEstimateData();
              Get.offAllNamed(Routes.bottomNavBar);
              Future.delayed(const Duration(milliseconds: 80), () {
                Get.find<BottomNavController>().changePage(1);
              });
            }
          },
          icon: const Icon(Icons.arrow_back,color: sWhite,),
        ),
        title: Text(
          AppSingletons.isInvoiceDocument.value ? 'invoice'.tr : 'estimate'.tr,
          style: const TextStyle(
              fontFamily: 'SFProDisplay',
              color: sWhite,
              fontWeight: FontWeight.w700,
              letterSpacing: 1,
              fontSize: 16),
        ),
        actions: [
          Obx(() {
            return Visibility(
              visible: !AppSingletons.isMakingNewINVEST.value,
              child: IconButton(
                  onPressed: () {
                    if (AppSingletons.isEditInvoice.value) {
                      Get.toNamed(
                        Routes.invoiceInputView,
                      );
                    } else {
                      Get.toNamed(
                        Routes.estimateInputView,
                      );
                    }
                    AppSingletons.isEditingOnlyTemplate.value = false;
                  },
                  icon: const Icon(
                    Icons.edit,
                    color: sWhite,
                    size: 20,
                  )),
            );
          }),
        ],
      ),
      body: Container(
        alignment: Alignment.center,
        child: Obx(
                (){
              return controller.isLoading.value
                  ? const Center(
                child: CupertinoActivityIndicator(
                  color: mainPurpleColor,
                  radius: 20,
                ),
              )
                  : Container(
                    width: MediaQuery.of(context).size.width * 0.5,
                    alignment: Alignment.center,
                    child: Stack(
                    children: [
                    Container(
                      margin: const EdgeInsets.only(top: 15, bottom: 100),
                      child: FutureBuilder<Uint8List> (
                        future: controller.loadTemplateData(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return const Center(child: CupertinoActivityIndicator(color: mainPurpleColor,radius: 15,));
                          } else if (snapshot.hasError) {
                            return const Center(child: Text('LOADING...'));
                          } else if (snapshot.hasData) {
                            return SfPdfViewerTheme(
                              data: const SfPdfViewerThemeData(
                                backgroundColor: orangeLight_1,
                                progressBarColor: mainPurpleColor,
                              ),
                              child: SfPdfViewer.memory(
                                snapshot.data!,
                                onTap: (_){

                                    Get.toNamed(Routes.pdfTemplateSelect);
                                    AppSingletons.isEditingOnlyTemplate.value = true;
                                    debugPrint('ABC 2');

                                },
                              ),
                            );
                          } else {
                            return const Center(child: Text('No PDF data available'));
                          }
                        },
                      ),
                    ),
                    Obx(() {
                      if (controller.currentStatusOfData.value == AppConstants.paidInvoice) {
                        return Transform.rotate(
                          angle: -0.7854,
                          child: Center(
                            child: Container(
                              decoration: BoxDecoration(
                                  border:
                                  Border.all(color: greenColor, width: 2),
                                  borderRadius: BorderRadius.circular(10)),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 15, vertical: 10),
                              child: Text(
                                controller.currentStatusOfData.value,
                                style: const TextStyle(
                                    fontFamily: 'Montserrat',
                                    fontWeight: FontWeight.w600,
                                    color: greenColor,
                                    fontSize: 20),
                              ),
                            ),
                          ),
                        );
                      } else if (controller.isOverdue.value) {
                        return const SizedBox.shrink();
                      } else if (controller.currentStatusOfData.value ==
                          AppConstants.partiallyPaidInvoice) {
                        return Transform.rotate(
                          angle: -0.7854,
                          child: Center(
                            child: Container(
                              decoration: BoxDecoration(
                                  border:
                                  Border.all(color: greenColor, width: 2),
                                  borderRadius: BorderRadius.circular(10)),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 15, vertical: 10),
                              child: Text(
                                controller.currentStatusOfData.value,
                                style: const TextStyle(
                                    fontFamily: 'Montserrat',
                                    fontWeight: FontWeight.w600,
                                    color: greenColor,
                                    fontSize: 20),
                              ),
                            ),
                          ),
                        );
                      } else {
                        return const SizedBox.shrink();
                      }
                    }),

                      Positioned(
                        bottom: 0,
                        left: 0,
                        right: 0,
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 10),
                          decoration: BoxDecoration(
                              color: sWhite,
                              borderRadius: BorderRadius.circular(8),
                              boxShadow: const [
                                BoxShadow(
                                    color: shadowColor,
                                    spreadRadius: 5,
                                    blurRadius: 3,
                                    offset: Offset(5, 5)),
                              ]),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                      onPressed: () async {
                                        controller.sharePdfFromDesktop(
                                            await controller
                                                .loadTemplateData(),
                                            'INV${controller.randomId}.pdf');
                                        debugPrint('SHARE PDF FILE CLICKED');
                                      },
                                      icon: const Icon(
                                        Icons.share,
                                        size: 30,
                                        color: grey_1,
                                      )),
                                  const Text(
                                    'Share',
                                    style: TextStyle(
                                      fontFamily: 'Montserrat',
                                      color: grey_1,
                                      fontSize: 16,
                                    ),
                                  )
                                ],
                              ),
                              const SizedBox(
                                width: 5,
                              ),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                      onPressed: () async {
                                        try {
                                          Directory? downloadsDirectory = await getDownloadsDirectory();

                                          if (downloadsDirectory == null) {
                                            throw Exception(
                                                'Could not find the downloads directory');
                                          }

                                          final filePath = '${downloadsDirectory.path}/INV${controller.randomId}.pdf';
                                          final file = File(filePath);

                                          await file.writeAsBytes(await controller.loadTemplateData());

                                          debugPrint('SAVE PDF FILE CLICKED');

                                          Utils().snackBarMsg(
                                            'INV${controller.randomId}.pdf',
                                            'Saved in Downloads directory',
                                          );
                                        } catch (e) {
                                          debugPrint('Error saving PDF: $e');
                                          Utils().snackBarMsg('Error', 'Failed to save the file');
                                        }

                                        // File()
                                        // final file = File('${dir_2.path}/INV${controller.randomId}.pdf');
                                        // await file.writeAsBytes(await controller.loadTemplateData());

                                        //
                                        // String fileName = 'INV${controller.randomId}';
                                        // String fileExtension = 'pdf';
                                        //
                                        // await FileSaver.instance.saveFile(
                                        //   name: fileName,
                                        //   bytes: pdfBytes,
                                        //   filePath: dir_2.path,
                                        //   ext: fileExtension,
                                        //   mimeType: MimeType.pdf
                                        // ).catchError((onError) {
                                        //   debugPrint('Error: $onError');
                                        // });

                                        debugPrint('SAVE PDF FILE CLICKED');

                                        // Utils().snackBarMsg(
                                        //     'my_doc_${controller.randomId}.pdf',
                                        //     'Saved in download directory');

                                        Get.snackbar(
                                          onTap: (_) async {
                                            debugPrint(
                                                'File Name: INV${controller.randomId}.pdf');
                                            openFileManager();
                                          },
                                          'INV${controller.randomId}.pdf',
                                          'Saved in download directory',
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
                                      },
                                      icon: const Icon(
                                        Icons.download,
                                        size: 30,
                                        color: grey_1,
                                      )),
                                  const Text(
                                    'Download',
                                    style: TextStyle(
                                      fontFamily: 'Montserrat',
                                      color: grey_1,
                                      fontSize: 16,
                                    ),
                                  )
                                ],
                              ),
                              const SizedBox(
                                width: 5,
                              ),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                      onPressed: () {
                                        Printing.layoutPdf(onLayout:
                                            (pdfPageFormatPdfPageFormat) async {
                                          return controller.loadTemplateData();
                                        });
                                        debugPrint('PRINT PDF FILE CLICKED');
                                      },
                                      icon: const Icon(
                                        Icons.print,
                                        size: 30,
                                        color: grey_1,
                                      )),
                                  const Text(
                                    'Print',
                                    style: TextStyle(
                                      fontFamily: 'Montserrat',
                                      color: grey_1,
                                      fontSize: 16,
                                    ),
                                  )
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                       ],
                    ),
                );
            }
         ),
      ),
    );
  }

}