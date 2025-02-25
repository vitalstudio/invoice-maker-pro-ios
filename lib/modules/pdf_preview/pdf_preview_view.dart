import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
// import '../../core/utils/triangle_painter.dart';
import '../../pdf_templates/simple_red_template/simple_red_temp_pdf.dart';
import 'package:open_file_manager/open_file_manager.dart';
import '../../core/constants/app_constants/App_Constants.dart';
import '../../core/preferenceManager/sharedPreferenceManager.dart';
import '../../core/utils/utils.dart';
import '../../core/routes/routes.dart';
import '../../../core/app_singletons/app_singletons.dart';
import '../../../core/constants/color/color.dart';
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';
import '../../pdf_templates/black_yellow_temp/black_yellow_template.dart';
import '../../pdf_templates/blue_black_dotted_temp/black_dotted_pdf.dart';
import '../../pdf_templates/blue_tap_temp/blue_tap_template.dart';
import '../../pdf_templates/grey_wallpaper_temp/gery_wall_pdf.dart';
import '../../pdf_templates/mat_brown_temp/mat_brown.dart';
import '../../pdf_templates/orange_black_temp/orange_temp_pdf.dart';
import '../../pdf_templates/pink_and_blue_temp/pink_temp_pdf.dart';
import '../../pdf_templates/purple_temp/purple_template.dart';
import '../../pdf_templates/simple_blue_template/simple_blue_template_pdf.dart';
import 'pdf_preview_controller.dart';

class PdfPreviewView extends GetView<PdfPreviewController> {
  const PdfPreviewView({super.key});

  @override
  Widget build(BuildContext context) {
    bool checkIsMobileLayout = AppConstants.isMobileScreen.value;

    return checkIsMobileLayout
        ? mainMobileLayout()
        : mainDesktopLayout(context);
  }

  Widget mainMobileLayout() {
    return Scaffold(
      backgroundColor: orangeLight_1,
      appBar: AppBar(
        backgroundColor: mainPurpleColor,
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: const Icon(
            Icons.arrow_back,
            color: sWhite,
            size: 25,
          ),
        ),
        title: Text(
          AppSingletons.isPreviewingPdfBeforeSave.value
              ? 'Preview'
              : AppSingletons.isInvoiceDocument.value
                  ? 'INVOICE'
                  : 'ESTIMATE',
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
              visible: !AppSingletons.isPreviewingPdfBeforeSave.value &&
                  !AppSingletons.isMakingNewINVEST.value,
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
          Obx(() => Visibility(
                visible: AppSingletons.isPreviewingPdfBeforeSave.value,
                child: IconButton(
                  onPressed: () {
                    if (!AppSingletons.isSubscriptionEnabled.value) {
                      // if(controller.previewTempNo.value == 0 || controller.previewTempNo.value == 1) {
                      //
                      //
                      // }
                      // else{
                      //   Get.toNamed(Routes.proScreenView);
                      // }

                      if (AppSingletons.isInvoiceDocument.value) {
                        AppSingletons.invoiceTemplateIdINV.value =
                            controller.previewTempNo.value.toString();
                        AppSingletons.selectedTempIndexToCheck.value =
                            controller.previewTempNo.value;
                        Get.back();
                        debugPrint(
                            'selected tempId for INV: ${AppSingletons
                                .invoiceTemplateIdINV.value}');
                      } else {
                        AppSingletons.estTemplateIdINV.value =
                            controller.previewTempNo.value.toString();
                        AppSingletons.selectedTempIndexToCheck.value =
                            controller.previewTempNo.value;
                        Get.back();
                        debugPrint(
                            'selected tempId for EST: ${AppSingletons
                                .estTemplateIdINV.value}');
                      }

                    } else{
                      if (AppSingletons.isInvoiceDocument.value) {
                        AppSingletons.invoiceTemplateIdINV.value =
                            controller.previewTempNo.value.toString();
                        Get.back();
                        debugPrint(
                            'selected tempId for INV: ${AppSingletons.invoiceTemplateIdINV.value}');
                      } else {
                        AppSingletons.estTemplateIdINV.value =
                            controller.previewTempNo.value.toString();
                        Get.back();
                        debugPrint(
                            'selected tempId for EST: ${AppSingletons.estTemplateIdINV.value}');
                      }
                    }
                  },
                  icon: const Icon(
                    Icons.check,
                    color: sWhite,
                  ),
                ),
              ))
        ],
      ),
      body: WillPopScope(
        onWillPop: () async {
          if (AppSingletons.isPreviewingPdfBeforeSave.value) {
            Get.back();
            AppSingletons.isPreviewingPdfBeforeSave.value = false;
          } else {
            AppSingletons.isPreviewingPdfBeforeSave.value = false;

            if (AppSingletons.isInvoiceDocument.value) {
              Utils.clearInvoiceVariables();
              controller.homeScController.loadInvoiceData();
              AppSingletons.storedInvoiceCurrency.value =
                  SharedPreferencesManager.getValue('setDefaultCurrency_INV') ??
                      'Rs';
              if (!AppSingletons.isEditInvoice.value) {
                Timer(const Duration(milliseconds: 500), () async {
                  await Utils.rateUs('Congratulations! You made an invoice!');
                });
              }
            } else {
              Utils.clearEstimateVariables();
              controller.estListController.loadEstimateData();
            }
          }

          return true;
        },
        child: Obx(() {
          return controller.isLoading.value
              ? const Center(
                  child: CupertinoActivityIndicator(
                    color: mainPurpleColor,
                    radius: 20,
                  ),
                )
              : Stack(
                  children: [
                    // Obx(() => AppSingletons.isPreviewingPdfBeforeSave.value
                    //     ? showingAllTemplatesInPreview()
                    //     : GestureDetector(
                    //   onTap: () {
                    //     if (!AppSingletons.isPreviewingPdfBeforeSave.value &&
                    //         !AppSingletons.isMakingNewINVEST.value) {
                    //       Get.toNamed(Routes.pdfTemplateSelect);
                    //       AppSingletons.isPreviewingPdfBeforeSave.value = false;
                    //       AppSingletons.isEditingOnlyTemplate.value = true;
                    //       debugPrint('ABC');
                    //     }
                    //   },
                    //   child: Container(
                    //     margin: const EdgeInsets.only(top: 15, bottom: 100),
                    //     child: PdfPreviewCustom(
                    //       scrollViewDecoration: const BoxDecoration(
                    //         color: orangeLight_1,
                    //       ),
                    //       loadingWidget: const CupertinoActivityIndicator(
                    //         color: mainPurpleColor,
                    //         radius: 20,
                    //       ),
                    //       pageFormat: PdfPageFormat.a4,
                    //       previewPageMargin: const EdgeInsets.all(8.0),
                    //       build: (format) => controller.loadTemplateData(),
                    //     ),
                    //   ),
                    // ),
                    // ),

                    showingAllTemplatesInPreview(),

                    Obx(() {
                      if (controller.isOverdue.value) {
                        return const SizedBox.shrink();
                      } else if (controller.currentStatusOfData.value ==
                              AppConstants.paidInvoice ||
                          controller.currentStatusOfData.value ==
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
                    Obx(() {
                      return Visibility(
                        visible: !AppSingletons.isPreviewingPdfBeforeSave.value,
                        child: Positioned(
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
                                              bytes: await controller
                                                  .loadTemplateData(),
                                              filename:
                                                  'my_doc_${controller.randomId}.pdf');
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
                                            const downloadsFolderPath =
                                                '/storage/emulated/0/Download';
                                            Directory dir_2 =
                                                Directory(downloadsFolderPath);
                                            Uint8List pdfBytes =
                                                await controller
                                                    .loadTemplateData();
                                            String fileName =
                                                "INV${controller.randomId}.pdf";
                                            String invFileDir =
                                                "${dir_2.path}/$fileName";
                                            File file = await File(invFileDir)
                                                .create(recursive: true);
                                            file.writeAsBytesSync(pdfBytes);
                                            debugPrint(
                                                "File: Path: ${file.path}");
                                          } catch (e) {
                                            debugPrint('Error: $e');
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
                                            margin: const EdgeInsets.symmetric(
                                                horizontal: 20, vertical: 20),
                                            backgroundColor: mainPurpleColor,
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 10, vertical: 5),
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
                                              (PdfPageFormatpdfPageFormat) async {
                                            return controller
                                                .loadTemplateData();
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
                      );
                    }),
                  ],
                );
        }),
      ),
      bottomNavigationBar: Obx(() {
        return Visibility(
            visible: !AppSingletons.isSubscriptionEnabled.value,
            child: Visibility(
              visible: (Platform.isAndroid &&
                      AppSingletons.androidBannerAdsEnabled.value) ||
                  (Platform.isIOS && AppSingletons.iOSBannerAdsEnabled.value),
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
            Icons.arrow_back,
            color: sWhite,
            size: 25,
          ),
        ),
        title: const Text(
          'Preview',
          style: TextStyle(
              fontFamily: 'SFProDisplay',
              color: sWhite,
              letterSpacing: 1,
              fontWeight: FontWeight.w600,
              fontSize: 16),
        ),
        actions: [
          Obx(() => Visibility(
                visible: AppSingletons.isPreviewingPdfBeforeSave.value,
                child: IconButton(
                  onPressed: () {
                    if (!AppSingletons.isSubscriptionEnabled.value) {
                      if (controller.previewTempNo.value == 0 ||
                          controller.previewTempNo.value == 1) {
                        if (AppSingletons.isInvoiceDocument.value) {
                          AppSingletons.invoiceTemplateIdINV.value =
                              controller.previewTempNo.value.toString();
                          Get.back();
                          debugPrint(
                              'selected tempId for INV: ${AppSingletons.invoiceTemplateIdINV.value}');
                        } else {
                          AppSingletons.estTemplateIdINV.value =
                              controller.previewTempNo.value.toString();
                          Get.back();
                          debugPrint(
                              'selected tempId for EST: ${AppSingletons.estTemplateIdINV.value}');
                        }
                      } else {
                        Get.toNamed(Routes.proScreenView);
                      }
                    } else {
                      if (AppSingletons.isInvoiceDocument.value) {
                        AppSingletons.invoiceTemplateIdINV.value =
                            controller.previewTempNo.value.toString();
                        Get.back();
                        debugPrint(
                            'selected tempId for INV: ${AppSingletons.invoiceTemplateIdINV.value}');
                      } else {
                        AppSingletons.estTemplateIdINV.value =
                            controller.previewTempNo.value.toString();
                        Get.back();
                        debugPrint(
                            'selected tempId for EST: ${AppSingletons.estTemplateIdINV.value}');
                      }
                    }
                  },
                  icon: const Icon(
                    Icons.check,
                    color: sWhite,
                  ),
                ),
              ))
        ],
      ),
      body: WillPopScope(
        onWillPop: () async {
          if (AppSingletons.isPreviewingPdfBeforeSave.value) {
            Get.back();
            AppSingletons.isPreviewingPdfBeforeSave.value = false;
          } else {
            AppSingletons.isPreviewingPdfBeforeSave.value = false;

            if (AppSingletons.isInvoiceDocument.value) {
              Utils.clearInvoiceVariables();
              controller.homeScController.loadInvoiceData();
              AppSingletons.storedInvoiceCurrency.value =
                  SharedPreferencesManager.getValue('setDefaultCurrency_INV') ??
                      'Rs';
              if (!AppSingletons.isEditInvoice.value) {
                Timer(const Duration(milliseconds: 500), () async {
                  await Utils.rateUs('Congratulations! You made an invoice!');
                });
              }
            } else {
              Utils.clearEstimateVariables();
              controller.estListController.loadEstimateData();
            }
          }
          return true;
        },
        child: Container(
          alignment: Alignment.center,
          child: Obx(() {
            return controller.isLoading.value
                ? const Center(
                    child: CupertinoActivityIndicator(
                      color: mainPurpleColor,
                      radius: 20,
                    ),
                  )
                : Stack(
                    children: [
                      SizedBox(
                          width: MediaQuery.of(context).size.width * 0.5,
                          child: ScrollConfiguration(
                              behavior: ScrollConfiguration.of(context).copyWith(
                                dragDevices: {
                                  PointerDeviceKind.mouse,
                                  PointerDeviceKind.touch,
                                },
                              ),
                              child: showingAllTemplatesInPreview())),
                      Positioned(
                        bottom: 15,
                        left: 0,
                        right: 0,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            GestureDetector(
                              onTap: () {
                                controller.previousPage();
                              },
                              child: Container(
                                padding: const EdgeInsets.all(10),
                                decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: mainPurpleColor),
                                child: const Icon(
                                  Icons.arrow_back,
                                  color: sWhite,
                                ),
                              ),
                            ),
                            const SizedBox(
                              width: 30,
                            ),
                            GestureDetector(
                              onTap: () {
                                controller.nextPage();
                              },
                              child: Container(
                                padding: const EdgeInsets.all(10),
                                decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: mainPurpleColor),
                                child: const Icon(
                                  Icons.arrow_forward,
                                  color: sWhite,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
          }),
        ),
      ),
    );
  }

  Widget showingAllTemplatesInPreview() {
    return PageView(
      scrollDirection: Axis.horizontal,
      controller: controller.pageController,
      onPageChanged: (value) async {
        debugPrint('Temp ID: $value');
        controller.previewTempNo.value = value;
        debugPrint('Change Temp ID: ${controller.previewTempNo.value}');
      },
      children: [
        Container(
          margin: EdgeInsets.only(
              top: controller.previewTempNo.value == 0 ? 15 : 30),
          child: PdfPreviewCustom(
            scrollViewDecoration: const BoxDecoration(
              color: orangeLight_1,
            ),
            pages: const [0],
            loadingWidget: const CupertinoActivityIndicator(
              color: mainPurpleColor,
              radius: 20,
            ),
            pageFormat: PdfPageFormat.a4,
            previewPageMargin: const EdgeInsets.all(8.0),

            build: (format) async {
              final pdfData = await PdfSimpleRedTemplate.createPreviewPdf(controller.invoiceDataModel!);
              if (pdfData.isEmpty) {
                throw Exception("No pages generated for preview.");
              }
              return pdfData;
            },
            //
            // build: (format) => PdfSimpleRedTemplate.createPreviewPdf(
            //     controller.invoiceDataModel!),
          ),
        ),
        Container(
          margin: EdgeInsets.only(
              top: controller.previewTempNo.value == 1 ? 15 : 30),
          child: PdfPreviewCustom(
            scrollViewDecoration: const BoxDecoration(
              color: orangeLight_1,
            ),
            pages: const [0],
            loadingWidget: const CupertinoActivityIndicator(
              color: mainPurpleColor,
              radius: 20,
            ),
            pageFormat: PdfPageFormat.a4,
            previewPageMargin: const EdgeInsets.all(8.0),

            build: (format) async {
              final pdfData = await PdfSimpleBlueTemplate.createPreviewPdf(controller.invoiceDataModel!);
              if (pdfData.isEmpty) {
                throw Exception("No pages generated for preview.");
              }
              return pdfData;
            },

          ),
        ),
        Container(
          margin: EdgeInsets.only(
              top: controller.previewTempNo.value == 2 ? 15 : 30),
          child: Stack(
            children: [
              PdfPreviewCustom(
                scrollViewDecoration: const BoxDecoration(
                  color: orangeLight_1,
                ),
                pages: const [0],
                loadingWidget: const CupertinoActivityIndicator(
                  color: mainPurpleColor,
                  radius: 20,
                ),
                pageFormat: PdfPageFormat.a4,
                previewPageMargin: const EdgeInsets.all(8.0),
                build: (format) async {
                  final pdfData = await PdfPurpleTemplate.createPreviewPdf(controller.invoiceDataModel!);
                  if (pdfData.isEmpty) {
                    throw Exception("No pages generated for preview.");
                  }
                  return pdfData;
                },
                // build: (format) => PdfPurpleTemplate.createPreviewPdf(
                //     controller.invoiceDataModel!),
              ),

              // Visibility(
              //   visible: !AppSingletons.isSubscriptionEnabled.value,
              //   child: Visibility(
              //     visible: !controller.isUnlocked(2),
              //     child: Container(
              //       margin: const EdgeInsets.all(8.0),
              //       child: CustomPaint(
              //         size: const Size(40, 40), // Full-size overlay
              //         painter: TrianglePainter(
              //           color: proIconColor, // Color changes based on the condition
              //         ),
              //         child: Container(
              //           height: 50,
              //           width: 40,
              //           padding: const EdgeInsets.only(left: 15),
              //           child: Transform.rotate(
              //             angle: -0.854,
              //             child: const Text('PRO',
              //               style: TextStyle(
              //                 color: sWhite,
              //                 fontFamily: 'Montserrat',
              //                 fontSize: 10,
              //               ),
              //             ),
              //           ),
              //         ),
              //       ),
              //     ),
              //   ),
              // ),
            ],
          ),
        ),
        Container(
          margin: EdgeInsets.only(
              top: controller.previewTempNo.value == 3 ? 15 : 30),
          child: Stack(
            children: [
              PdfPreviewCustom(
                scrollViewDecoration: const BoxDecoration(
                  color: orangeLight_1,
                ),
                pages: const [0],
                loadingWidget: const CupertinoActivityIndicator(
                  color: mainPurpleColor,
                  radius: 20,
                ),
                pageFormat: PdfPageFormat.a4,
                previewPageMargin: const EdgeInsets.all(8.0),
                build: (format) async {
                  final pdfData = await PdfMatBrownTemplate.createPreviewPdf(controller.invoiceDataModel!);
                  if (pdfData.isEmpty) {
                    throw Exception("No pages generated for preview.");
                  }
                  return pdfData;
                },
                // build: (format) => PdfMatBrownTemplate.createPreviewPdf(
                //     controller.invoiceDataModel!),
              ),
              // Visibility(
              //   visible: !AppSingletons.isSubscriptionEnabled.value,
              //   child: Visibility(
              //     visible: !controller.isUnlocked(3),
              //     child: Container(
              //       margin: const EdgeInsets.all(8.0),
              //       child: CustomPaint(
              //         size: const Size(40, 40), // Full-size overlay
              //         painter: TrianglePainter(
              //           color: proIconColor, // Color changes based on the condition
              //         ),
              //         child: Container(
              //           height: 50,
              //           width: 40,
              //           padding: const EdgeInsets.only(left: 15),
              //           child: Transform.rotate(
              //             angle: -0.854,
              //             child: const Text('PRO',
              //               style: TextStyle(
              //                 color: sWhite,
              //                 fontFamily: 'Montserrat',
              //                 fontSize: 10,
              //               ),
              //             ),
              //           ),
              //         ),
              //       ),
              //     ),
              //   ),
              // ),
            ],
          ),
        ),
        Container(
          margin: EdgeInsets.only(
              top: controller.previewTempNo.value == 4 ? 15 : 30),
          child: Stack(
            children: [
              PdfPreviewCustom(
                scrollViewDecoration: const BoxDecoration(
                  color: orangeLight_1,
                ),
                pages: const [0],
                loadingWidget: const CupertinoActivityIndicator(
                  color: mainPurpleColor,
                  radius: 20,
                ),
                pageFormat: PdfPageFormat.a4,
                previewPageMargin: const EdgeInsets.all(8.0),
                build: (format) async {
                  final pdfData = await PdfBlueTapTemplate.createPreviewPdf(controller.invoiceDataModel!);
                  if (pdfData.isEmpty) {
                    throw Exception("No pages generated for preview.");
                  }
                  return pdfData;
                },
                // build: (format) => PdfBlueTapTemplate.createPreviewPdf(
                //     controller.invoiceDataModel!),
              ),
              // Visibility(
              //   visible: !AppSingletons.isSubscriptionEnabled.value,
              //   child: Visibility(
              //     visible: !controller.isUnlocked(4),
              //     child: Container(
              //       margin: const EdgeInsets.all(8.0),
              //       child: CustomPaint(
              //         size: const Size(40, 40), // Full-size overlay
              //         painter: TrianglePainter(
              //           color: proIconColor, // Color changes based on the condition
              //         ),
              //         child: Container(
              //           height: 50,
              //           width: 40,
              //           padding: const EdgeInsets.only(left: 15),
              //           child: Transform.rotate(
              //             angle: -0.854,
              //             child: const Text('PRO',
              //               style: TextStyle(
              //                 color: sWhite,
              //                 fontFamily: 'Montserrat',
              //                 fontSize: 10,
              //               ),
              //             ),
              //           ),
              //         ),
              //       ),
              //     ),
              //   ),
              // ),
            ],
          ),
        ),
        Container(
          margin: EdgeInsets.only(
              top: controller.previewTempNo.value == 5 ? 15 : 30),
          child: Stack(
            children: [
              PdfPreviewCustom(
                scrollViewDecoration: const BoxDecoration(
                  color: orangeLight_1,
                ),
                pages: const [0],
                loadingWidget: const CupertinoActivityIndicator(
                  color: mainPurpleColor,
                  radius: 20,
                ),
                pageFormat: PdfPageFormat.a4,
                previewPageMargin: const EdgeInsets.all(8.0),
                build: (format) async {
                  final pdfData = await PdfBlackYellowTemplate.createPreviewPdf(controller.invoiceDataModel!);
                  if (pdfData.isEmpty) {
                    throw Exception("No pages generated for preview.");
                  }
                  return pdfData;
                },
                // build: (format) => PdfBlackYellowTemplate.createPreviewPdf(
                //     controller.invoiceDataModel!),
              ),
              // Visibility(
              //   visible: !AppSingletons.isSubscriptionEnabled.value,
              //   child: Visibility(
              //     visible: !controller.isUnlocked(5),
              //     child: Container(
              //       margin: const EdgeInsets.all(8.0),
              //       child: CustomPaint(
              //         size: const Size(40, 40), // Full-size overlay
              //         painter: TrianglePainter(
              //           color: proIconColor, // Color changes based on the condition
              //         ),
              //         child: Container(
              //           height: 50,
              //           width: 40,
              //           padding: const EdgeInsets.only(left: 15),
              //           child: Transform.rotate(
              //             angle: -0.854,
              //             child: const Text('PRO',
              //               style: TextStyle(
              //                 color: sWhite,
              //                 fontFamily: 'Montserrat',
              //                 fontSize: 10,
              //               ),
              //             ),
              //           ),
              //         ),
              //       ),
              //     ),
              //   ),
              // ),
            ],
          ),
        ),
        Container(
          margin: EdgeInsets.only(
              top: controller.previewTempNo.value == 6 ? 15 : 30),
          child: Stack(
            children: [
              PdfPreviewCustom(
                scrollViewDecoration: const BoxDecoration(
                  color: orangeLight_1,
                ),
                pages: const [0],
                loadingWidget: const CupertinoActivityIndicator(
                  color: mainPurpleColor,
                  radius: 20,
                ),
                pageFormat: PdfPageFormat.a4,
                previewPageMargin: const EdgeInsets.all(8.0),
                build: (format) async {
                  final pdfData = await PdfPinkBlueTemplate.createPreviewPdf(controller.invoiceDataModel!);
                  if (pdfData.isEmpty) {
                    throw Exception("No pages generated for preview.");
                  }
                  return pdfData;
                },
                // build: (format) => PdfPinkBlueTemplate.createPreviewPdf(
                //     controller.invoiceDataModel!),
              ),
              // Visibility(
              //   visible: !AppSingletons.isSubscriptionEnabled.value,
              //   child: Visibility(
              //     visible: !controller.isUnlocked(6),
              //     child: Container(
              //       margin: const EdgeInsets.all(8.0),
              //       child: CustomPaint(
              //         size: const Size(40, 40), // Full-size overlay
              //         painter: TrianglePainter(
              //           color: proIconColor, // Color changes based on the condition
              //         ),
              //         child: Container(
              //           height: 50,
              //           width: 40,
              //           padding: const EdgeInsets.only(left: 15),
              //           child: Transform.rotate(
              //             angle: -0.854,
              //             child: const Text('PRO',
              //               style: TextStyle(
              //                 color: sWhite,
              //                 fontFamily: 'Montserrat',
              //                 fontSize: 10,
              //               ),
              //             ),
              //           ),
              //         ),
              //       ),
              //     ),
              //   ),
              // ),
            ],
          ),
        ),
        Container(
          margin: EdgeInsets.only(
              top: controller.previewTempNo.value == 7 ? 15 : 30),
          child: Stack(
            children: [
              PdfPreviewCustom(
                scrollViewDecoration: const BoxDecoration(
                  color: orangeLight_1,
                ),
                pages: const [0],
                loadingWidget: const CupertinoActivityIndicator(
                  color: mainPurpleColor,
                  radius: 20,
                ),
                pageFormat: PdfPageFormat.a4,
                previewPageMargin: const EdgeInsets.all(8.0),
                build: (format) async {
                  final pdfData = await PdfOrangeBlackTemplate.createPreviewPdf(controller.invoiceDataModel!);
                  if (pdfData.isEmpty) {
                    throw Exception("No pages generated for preview.");
                  }
                  return pdfData;
                },
                // build: (format) => PdfOrangeBlackTemplate.createPreviewPdf(
                //     controller.invoiceDataModel!),
              ),
              // Visibility(
              //   visible: !AppSingletons.isSubscriptionEnabled.value,
              //   child: Visibility(
              //     visible: !controller.isUnlocked(7),
              //     child: Container(
              //       margin: const EdgeInsets.all(8.0),
              //       child: CustomPaint(
              //         size: const Size(40, 40), // Full-size overlay
              //         painter: TrianglePainter(
              //           color: proIconColor, // Color changes based on the condition
              //         ),
              //         child: Container(
              //           height: 50,
              //           width: 40,
              //           padding: const EdgeInsets.only(left: 15),
              //           child: Transform.rotate(
              //             angle: -0.854,
              //             child: const Text('PRO',
              //               style: TextStyle(
              //                 color: sWhite,
              //                 fontFamily: 'Montserrat',
              //                 fontSize: 10,
              //               ),
              //             ),
              //           ),
              //         ),
              //       ),
              //     ),
              //   ),
              // ),
            ],
          ),
        ),
        Container(
          margin: EdgeInsets.only(
              top: controller.previewTempNo.value == 8 ? 15 : 30),
          child: Stack(
            children: [
              PdfPreviewCustom(
                scrollViewDecoration: const BoxDecoration(
                  color: orangeLight_1,
                ),
                pages: const [0],
                loadingWidget: const CupertinoActivityIndicator(
                  color: mainPurpleColor,
                  radius: 20,
                ),
                pageFormat: PdfPageFormat.a4,
                previewPageMargin: const EdgeInsets.all(8.0),
                build: (format) async {
                  final pdfData = await PdfBlueBlackDottedTemplate.createPreviewPdf(controller.invoiceDataModel!);
                  if (pdfData.isEmpty) {
                    throw Exception("No pages generated for preview.");
                  }
                  return pdfData;
                },
                // build: (format) => PdfBlueBlackDottedTemplate.createPreviewPdf(
                //     controller.invoiceDataModel!),
              ),
              // Visibility(
              //   visible: !AppSingletons.isSubscriptionEnabled.value,
              //   child: Visibility(
              //     visible: !controller.isUnlocked(8),
              //     child: Container(
              //       margin: const EdgeInsets.all(8.0),
              //       child: CustomPaint(
              //         size: const Size(40, 40), // Full-size overlay
              //         painter: TrianglePainter(
              //           color: proIconColor, // Color changes based on the condition
              //         ),
              //         child: Container(
              //           height: 50,
              //           width: 40,
              //           padding: const EdgeInsets.only(left: 15),
              //           child: Transform.rotate(
              //             angle: -0.854,
              //             child: const Text('PRO',
              //               style: TextStyle(
              //                 color: sWhite,
              //                 fontFamily: 'Montserrat',
              //                 fontSize: 10,
              //               ),
              //             ),
              //           ),
              //         ),
              //       ),
              //     ),
              //   ),
              // ),
            ],
          ),
        ),
        Container(
          margin: EdgeInsets.only(
              top: controller.previewTempNo.value == 9 ? 15 : 30),
          child: Stack(
            children: [
              PdfPreviewCustom(
                scrollViewDecoration: const BoxDecoration(
                  color: orangeLight_1,
                ),
                pages: const [0],
                loadingWidget: const CupertinoActivityIndicator(
                  color: mainPurpleColor,
                  radius: 20,
                ),
                pageFormat: PdfPageFormat.a4,
                previewPageMargin: const EdgeInsets.all(8.0),
                build: (format) async {
                  final pdfData = await PdfGreyWallpaperTemplate.createPreviewPdf(controller.invoiceDataModel!);
                  if (pdfData.isEmpty) {
                    throw Exception("No pages generated for preview.");
                  }
                  return pdfData;
                },
                // build: (format) => PdfGreyWallpaperTemplate.createPreviewPdf(
                //     controller.invoiceDataModel!),
              ),
              // Visibility(
              //   visible: !AppSingletons.isSubscriptionEnabled.value,
              //   child: Visibility(
              //     visible: !controller.isUnlocked(9),
              //     child: Container(
              //       margin: const EdgeInsets.all(8.0),
              //       child: CustomPaint(
              //         size: const Size(40, 40), // Full-size overlay
              //         painter: TrianglePainter(
              //           color: proIconColor, // Color changes based on the condition
              //         ),
              //         child: Container(
              //           height: 50,
              //           width: 40,
              //           padding: const EdgeInsets.only(left: 15),
              //           child: Transform.rotate(
              //             angle: -0.854,
              //             child: const Text('PRO',
              //               style: TextStyle(
              //                 color: sWhite,
              //                 fontFamily: 'Montserrat',
              //                 fontSize: 10,
              //               ),
              //             ),
              //           ),
              //         ),
              //       ),
              //     ),
              //   ),
              // ),
            ],
          ),
        ),
      ],
    );
  }
}
