import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import '../../core/routes/routes.dart';
import '../../core/utils/unlock_temp_dialogue.dart';
import '../../core/constants/app_constants/App_Constants.dart';
import '../../core/utils/triangle_painter.dart';
import '../../core/app_singletons/app_singletons.dart';
import '../../core/constants/color/color.dart';
import 'templates_controller.dart';

class TemplatesView extends GetView<TemplatesController> {
  const TemplatesView({super.key});

  @override
  Widget build(BuildContext context) {
    AppConstants.updateScreenWidthForTemplate(MediaQuery
        .of(context)
        .size
        .width);

    final controller = Get.put<TemplatesController>(TemplatesController());

    bool checkIsMobileLayout = AppConstants.isMobileScreen.value;

    return checkIsMobileLayout
        ? mainMobileLayout(context)
        : mainDesktopLayout(context);
  }

  Widget mainDesktopLayout(BuildContext context) {
    return Scaffold(
        backgroundColor: orangeLight_1,
        appBar: AppBar(
          backgroundColor: mainPurpleColor,
          title: const Text(
            'Select a Templates',
            style: TextStyle(
                fontFamily: 'Montserrat',
                color: sWhite,
                fontWeight: FontWeight.w600,
                fontSize: 16),
          ),
          leading: IconButton(
            onPressed: () {
              Get.back();
            },
            icon: const Icon(
              Icons.arrow_back,
              color: sWhite,
              size: 16,
            ),
          ),
          actions: [
            IconButton(
                onPressed: () {
                  if(!AppSingletons.isSubscriptionEnabled.value){
                    if(controller.selectedTempIndexId.value == 0 || controller.selectedTempIndexId.value == 1) {
                      if (AppSingletons.isEditingOnlyTemplate.value) {
                        controller.changeTemplateCall();
                      }
                      else {
                        if (AppSingletons.isInvoiceDocument.value) {
                          AppSingletons.invoiceTemplateIdINV.value =
                              controller.selectedTempIndexId.value.toString();
                          Get.back();
                          debugPrint(
                              'selected tempId for INV: ${AppSingletons
                                  .invoiceTemplateIdINV.value}');
                        } else {
                          AppSingletons.estTemplateIdINV.value =
                              controller.selectedTempIndexId.value.toString();
                          Get.back();
                          debugPrint(
                              'selected tempId for EST: ${AppSingletons
                                  .estTemplateIdINV.value}');
                        }
                      }
                    }
                    else{
                      Get.toNamed(Routes.proScreenView);
                    }
                  }
                  else {
                    if (AppSingletons.isEditingOnlyTemplate.value) {
                      controller.changeTemplateCall();
                    }
                    else {
                      if (AppSingletons.isInvoiceDocument.value) {
                        AppSingletons.invoiceTemplateIdINV.value =
                            controller.selectedTempIndexId.value.toString();
                        Get.back();
                        debugPrint(
                            'selected tempId for INV: ${AppSingletons
                                .invoiceTemplateIdINV.value}');
                      } else {
                        AppSingletons.estTemplateIdINV.value =
                            controller.selectedTempIndexId.value.toString();
                        Get.back();
                        debugPrint(
                            'selected tempId for EST: ${AppSingletons
                                .estTemplateIdINV.value}');
                      }
                    }
                  }
                },
                icon: const Icon(
                  Icons.check,
                  color: sWhite,
                ))
          ],
        ),
        body: Row(
          children: [
            const SizedBox(width: 10,),
            Expanded(
              flex: 2,
              child: Obx(() {
                double dpi = 96;
                double a4WidthInPixels = controller.mmToPixels(210, dpi);
                double a4HeightInPixels = controller.mmToPixels(297, dpi);
                double childAspectRatio = a4WidthInPixels / a4HeightInPixels;

                return controller.isLoadingTemps.value
                    ? const Center(
                  child: CupertinoActivityIndicator(
                    color: mainPurpleColor,
                    radius: 15,
                  ),
                ) :
                GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    childAspectRatio: childAspectRatio,
                    crossAxisSpacing: 8,
                    mainAxisSpacing: 8,
                  ),
                  padding: const EdgeInsets.symmetric(
                      vertical: 10, horizontal: 8),
                  itemCount: controller.tempDesignList.length,
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    return Obx(() {
                      return GestureDetector(

                        onTap: () {
                          controller.selectedTempIndexId.value = index;
                          debugPrint('New Selected Index: ${controller
                              .selectedTempIndexId.value}');
                        },
                        child: Stack(
                          children: [
                            Container(
                              width: a4WidthInPixels / 2,
                              height: a4HeightInPixels / 2,
                              alignment: Alignment.center,
                              child: Image.asset(
                                controller.tempDesignList[index],
                                fit: BoxFit.fill,
                                height: double.infinity,
                                width: double.infinity,
                              ),
                            ),
                            Visibility(
                              visible: index != 0 && index != 1,
                              child: CustomPaint(
                                size: const Size(40, 40), // Full-size overlay
                                painter: TrianglePainter(
                                  color: proIconColor, // Color changes based on the condition
                                ),
                                child: Container(
                                  height: 50,
                                  width: 40,
                                  padding: const EdgeInsets.only(left: 15),
                                  child: Transform.rotate(
                                    angle: -0.854,
                                    child: const Text('PRO',
                                      style: TextStyle(
                                        color: sWhite,
                                        fontFamily: 'Montserrat',
                                        fontSize: 10,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              decoration: BoxDecoration(
                                  color: controller.selectedTempIndexId.value ==
                                      index
                                      ? mainPurpleColor.withOpacity(0.2)
                                      : Colors.transparent,
                                  border: Border.all(
                                      color: controller.selectedTempIndexId
                                          .value == index
                                          ? mainPurpleColor
                                          : Colors.transparent,
                                      width: 3
                                  )
                              ),
                            ),
                            // CustomPaint(
                            //   size: const Size(double.infinity,double.infinity),
                            //   painter: TrianglePainter(
                            //     color: proIconColor,
                            //   ),
                            //   child: const Text('Pro',
                            //     style: TextStyle(
                            //         color: sWhite,
                            //         fontFamily: 'Montserrat',
                            //         fontSize: 10
                            //     ),
                            //   ),
                            // ),
                          ],
                        ),
                      );
                    });
                  },
                );
              }),
            ),
            const SizedBox(width: 20,),
            Expanded(
                flex: 1,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(
                      color: mainPurpleColor,
                      width: 5,
                    ),
                  ),
                  padding: const EdgeInsets.all(8),
                  child: Obx(() {
                    return Image.asset(controller.getSelectedPdfTemplate(
                        controller.selectedTempIndexId.value));
                  }),
                )),
            const SizedBox(width: 10,),
          ],
        )
    );
  }

  Widget mainMobileLayout(BuildContext context) {
    return Scaffold(
      backgroundColor: orangeLight_1,
      appBar: AppBar(
        backgroundColor: mainPurpleColor,
        title:  Text(
          'select_a_template'.tr,
          style: const TextStyle(
              fontFamily: 'Montserrat',
              color: sWhite,
              fontWeight: FontWeight.w600,
              fontSize: 16),
        ),
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: const Icon(
            Icons.arrow_back,
            color: sWhite,
            size: 16,
          ),
        ),
        actions: [
          IconButton(
              onPressed: () {
                // if (AppSingletons.isEditingOnlyTemplate.value) {
                //   controller.changeTemplateCall();
                // }
                // else {
                //   if (AppSingletons.isInvoiceDocument.value) {
                //     AppSingletons.invoiceTemplateIdINV.value =
                //         controller.selectedTempIndexId.value.toString();
                //     Get.back();
                //     debugPrint(
                //         'selected tempId for INV: ${AppSingletons
                //             .invoiceTemplateIdINV.value}');
                //   } else {
                //     AppSingletons.estTemplateIdINV.value =
                //         controller.selectedTempIndexId.value.toString();
                //     Get.back();
                //     debugPrint(
                //         'selected tempId for EST: ${AppSingletons
                //             .estTemplateIdINV.value}');
                //   }
                // }
                if(!AppSingletons.isSubscriptionEnabled.value){

                    // if(controller.selectedTempIndexId.value == 0 || controller.selectedTempIndexId.value == 1) {
                    //   if (AppSingletons.isEditingOnlyTemplate.value) {
                    //     controller.changeTemplateCall();
                    //   }
                    //   else {
                    //     if (AppSingletons.isInvoiceDocument.value) {
                    //       AppSingletons.invoiceTemplateIdINV.value =
                    //           controller.selectedTempIndexId.value.toString();
                    //       Get.back();
                    //       debugPrint(
                    //           'selected tempId for INV: ${AppSingletons
                    //               .invoiceTemplateIdINV.value}');
                    //     } else {
                    //       AppSingletons.estTemplateIdINV.value =
                    //           controller.selectedTempIndexId.value.toString();
                    //       Get.back();
                    //       debugPrint(
                    //           'selected tempId for EST: ${AppSingletons
                    //               .estTemplateIdINV.value}');
                    //     }
                    //   }
                    // }
                    // else {
                    //   Get.toNamed(Routes.proScreenView);
                    // }

                  if (AppSingletons.isEditingOnlyTemplate.value) {
                    if(
                    controller.selectedTempIndexId.value == 0 ||
                        controller.selectedTempIndexId.value == 1
                    ) {
                      controller.changeTemplateCall();
                    }
                    else{
                      Get.toNamed(Routes.proScreenView);
                    }
                  }
                  else {
                    if (AppSingletons.isInvoiceDocument.value) {
                      AppSingletons.invoiceTemplateIdINV.value =
                          controller.selectedTempIndexId.value.toString();

                      AppSingletons.selectedTempIndexToCheck.value =
                          controller.selectedTempIndexId.value;

                      Get.back();
                      debugPrint(
                          'selected tempId for INV: ${AppSingletons
                              .invoiceTemplateIdINV.value}');
                    } else {
                      AppSingletons.estTemplateIdINV.value =
                          controller.selectedTempIndexId.value.toString();

                      AppSingletons.selectedTempIndexToCheck.value =
                          controller.selectedTempIndexId.value;

                      Get.back();
                      debugPrint(
                          'selected tempId for EST: ${AppSingletons
                              .estTemplateIdINV.value}');
                    }
                  }

                } else {
                  if (AppSingletons.isEditingOnlyTemplate.value) {
                    controller.changeTemplateCall();
                  }
                  else {
                    if (AppSingletons.isInvoiceDocument.value) {
                      AppSingletons.invoiceTemplateIdINV.value =
                          controller.selectedTempIndexId.value.toString();
                      Get.back();
                      debugPrint(
                          'selected tempId for INV: ${AppSingletons
                              .invoiceTemplateIdINV.value}');
                    } else {
                      AppSingletons.estTemplateIdINV.value =
                          controller.selectedTempIndexId.value.toString();
                      Get.back();
                      debugPrint('selected tempId for EST: ${AppSingletons
                              .estTemplateIdINV.value}');
                    }
                  }
                }
              },
              icon: const Icon(
                Icons.check,
                color: sWhite,
              ))
        ],
      ),
      body: Obx(() {
        double dpi = 96;
        double a4WidthInPixels = controller.mmToPixels(210, dpi);
        double a4HeightInPixels = controller.mmToPixels(297, dpi);
        double childAspectRatio = a4WidthInPixels / a4HeightInPixels;

        return controller.isLoadingTemps.value
            ? const Center(
          child: CupertinoActivityIndicator(
            color: mainPurpleColor,
            radius: 15,
          ),
        ) : GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: childAspectRatio,
            crossAxisSpacing: 8,
            mainAxisSpacing: 8,
          ),
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
          itemCount: controller.tempDesignList.length,
          shrinkWrap: true,
          itemBuilder: (context, index) {
            return Obx(() {
              return GestureDetector(

                onTap: () {
                  controller.selectedTempIndexId.value = index;
                  debugPrint('New Selected Index: ${controller
                      .selectedTempIndexId.value}');
                },
                child: Stack(
                  children: [
                    Container(
                      width: a4WidthInPixels / 2,
                      height: a4HeightInPixels / 2,
                      alignment: Alignment.center,
                      child: Image.asset(
                        controller.tempDesignList[index],
                        fit: BoxFit.fill,
                        height: double.infinity,
                        width: double.infinity,
                      ),
                    ),
                    // Visibility(
                    //   visible: !AppSingletons.isSubscriptionEnabled.value,
                    //   child: Visibility(
                    //     visible: index != 0 && index != 1 ,
                    //     child: CustomPaint(
                    //       size: const Size(40, 40), // Full-size overlay
                    //       painter: TrianglePainter(
                    //         color: proIconColor, // Color changes based on the condition
                    //       ),
                    //       child: Container(
                    //         height: 50,
                    //         width: 40,
                    //           padding: const EdgeInsets.only(left: 15),
                    //           child: Transform.rotate(
                    //             angle: -0.854,
                    //             child: const Text('PRO',
                    //               style: TextStyle(
                    //                   color: sWhite,
                    //                   fontFamily: 'Montserrat',
                    //                   fontSize: 10,
                    //               ),
                    //             ),
                    //           ),
                    //       ),
                    //     ),
                    //   ),
                    // ),
                    Container(
                      decoration: BoxDecoration(
                          color: controller.selectedTempIndexId.value == index
                              ? mainPurpleColor.withOpacity(0.2)
                              : Colors.transparent,
                          border: Border.all(
                              color: controller.selectedTempIndexId.value ==
                                  index
                                  ? mainPurpleColor
                                  : Colors.transparent,
                              width: 3
                          )
                      ),
                    ),
                    // CustomPaint(
                    //   size: const Size(double.infinity,double.infinity),
                    //   painter: TrianglePainter(
                    //     color: proIconColor,
                    //   ),
                    //   child: const Text('Pro',
                    //     style: TextStyle(
                    //         color: sWhite,
                    //         fontFamily: 'Montserrat',
                    //         fontSize: 10
                    //     ),
                    //   ),
                    // ),
                  ],
                ),
              );
            });
          },
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

// Widget mainMobileLayout(BuildContext context) {
//   return Scaffold(
//     backgroundColor: orangeLight_1,
//     appBar: AppBar(
//       backgroundColor: mainPurpleColor,
//       title: const Text(
//         'Select a Templates',
//         style: TextStyle(
//             fontFamily: 'Montserrat',
//             color: sWhite,
//             fontWeight: FontWeight.w600,
//             fontSize: 16),
//       ),
//       leading: IconButton(
//         onPressed: () {
//           Get.back();
//         },
//         icon: const Icon(
//           Icons.arrow_back,
//           color: sWhite,
//           size: 16,
//         ),
//       ),
//       actions: [
//         IconButton(
//             onPressed: () async{
//               if (AppSingletons.isEditingOnlyTemplate.value) {
//                 controller.changeTemplateCall();
//               } else {
//                 if (AppSingletons.isInvoiceDocument.value) {
//                   AppSingletons.invoiceTemplateIdINV.value =
//                       controller.selectedTempIndexId.value.toString();
//                   Get.back();
//                   debugPrint(
//                       'selected tempId for INV: ${AppSingletons
//                           .invoiceTemplateIdINV.value}');
//                 } else {
//                   AppSingletons.estTemplateIdINV.value =
//                       controller.selectedTempIndexId.value.toString();
//                   Get.back();
//                   debugPrint(
//                       'selected tempId for EST: ${AppSingletons
//                           .estTemplateIdINV.value}');
//                 }
//               }
//             },
//             icon: const Icon(
//               Icons.check,
//               color: sWhite,
//             ))
//       ],
//     ),
//     body: Obx(() {
//       return controller.isLoadingTemps.value
//           ? const Center(
//         child: CupertinoActivityIndicator(
//           color: mainPurpleColor,
//           radius: 15,
//         ),
//       ) : SizedBox(
//         height: MediaQuery
//             .of(context)
//             .size
//             .height * 0.7,
//         child: PageView(
//           controller: PageController(
//             initialPage: controller.selectedTempIndexId.value,
//             viewportFraction: 0.8,
//           ),
//           scrollDirection: Axis.horizontal,
//           onPageChanged: (value) {
//             debugPrint('Temp ID: $value');
//             controller.selectedTempIndexId.value = value;
//           },
//           children: [
//             Container(
//                 margin: EdgeInsets.only(
//                     left: 5,
//                     right: 5,
//                     bottom: 5,
//                     top: controller.selectedTempIndexId.value == 0 ? 5 : 15),
//                 decoration: BoxDecoration(
//                     border: Border.all(
//                         color: controller.selectedTempIndexId.value == 0
//                             ? mainPurpleColor
//                             : Colors.transparent,
//                         width: 3
//                     )
//                 ),
//                 child: const SimpleRedTemplatesDesign()),
//             Container(
//                 margin: EdgeInsets.only(
//                     left: 5,
//                     right: 5,
//                     bottom: 5,
//                     top: controller.selectedTempIndexId.value == 1 ? 5 : 15),
//                 decoration: BoxDecoration(
//                     border: Border.all(
//                         color: controller.selectedTempIndexId.value == 1
//                             ? mainPurpleColor
//                             : Colors.transparent,
//                         width: 3
//                     )
//                 ),
//                 child: const SimpleBlueTemplatesDesign()),
//             Container(
//                 margin: EdgeInsets.only(
//                     left: 5,
//                     right: 5,
//                     bottom: 5,
//                     top: controller.selectedTempIndexId.value == 2 ? 5 : 15),
//                 decoration: BoxDecoration(
//                     border: Border.all(
//                         color: controller.selectedTempIndexId.value == 2
//                             ? mainPurpleColor
//                             : Colors.transparent,
//                         width: 3
//                     )
//                 ),
//                 child: Stack(
//                   children: [
//                     const PurpleShadeTemplatesDesign(),
//                     CustomPaint(
//                       painter: TrianglePainter(color: Colors.amber),
//                       child: Container(
//                         height: 50,
//                         width: 50,
//                         padding: const EdgeInsets.only(left: 13),
//                         child: Transform.rotate(
//                           angle: -0.785398,
//                           child: const Text(
//                             'PRO',
//                             style: TextStyle(
//                                 color: sWhite,
//                                 fontFamily: 'Montserrat',
//                                 fontSize: 11,
//                                 fontWeight: FontWeight.bold
//                             ),
//                           ),
//                         ),
//                       ),
//                     ),
//                   ],
//                 )),
//             Container(
//                 margin: EdgeInsets.only(
//                     left: 5,
//                     right: 5,
//                     bottom: 5,
//                     top: controller.selectedTempIndexId.value == 3 ? 5 : 15),
//                 decoration: BoxDecoration(
//                     border: Border.all(
//                         color: controller.selectedTempIndexId.value == 3
//                             ? mainPurpleColor
//                             : Colors.transparent,
//                         width: 3
//                     )
//                 ),
//                 child: Stack(
//                   children: [
//                     const MatBrownTemplatesDesign(),
//                     CustomPaint(
//                       painter: TrianglePainter(color: Colors.amber),
//                       child: Container(
//                         height: 50,
//                         width: 50,
//                         padding: const EdgeInsets.only(left: 13),
//                         child: Transform.rotate(
//                           angle: -0.785398,
//                           child: const Text(
//                             'PRO',
//                             style: TextStyle(
//                                 color: sWhite,
//                                 fontFamily: 'Montserrat',
//                                 fontSize: 11,
//                                 fontWeight: FontWeight.bold
//                             ),
//                           ),
//                         ),
//                       ),
//                     ),
//                   ],
//                 )),
//             Container(
//                 margin: EdgeInsets.only(
//                     left: 5,
//                     right: 5,
//                     bottom: 5,
//                     top: controller.selectedTempIndexId.value == 4 ? 5 : 15),
//                 decoration: BoxDecoration(
//                     border: Border.all(
//                         color: controller.selectedTempIndexId.value == 4
//                             ? mainPurpleColor
//                             : Colors.transparent,
//                         width: 3
//                     )
//                 ),
//                 child: Stack(
//                   children: [
//                     const BlueTapTemplatesDesign(),
//                     CustomPaint(
//                       painter: TrianglePainter(color: Colors.amber),
//                       child: Container(
//                         height: 50,
//                         width: 50,
//                         padding: const EdgeInsets.only(left: 13),
//                         child: Transform.rotate(
//                           angle: -0.785398,
//                           child: const Text(
//                             'PRO',
//                             style: TextStyle(
//                                 color: sWhite,
//                                 fontFamily: 'Montserrat',
//                                 fontSize: 11,
//                                 fontWeight: FontWeight.bold
//                             ),
//                           ),
//                         ),
//                       ),
//                     ),
//                   ],
//                 )),
//             Container(
//                 margin: EdgeInsets.only(
//                     left: 5,
//                     right: 5,
//                     bottom: 5,
//                     top: controller.selectedTempIndexId.value == 5 ? 5 : 15),
//                 decoration: BoxDecoration(
//                     border: Border.all(
//                         color: controller.selectedTempIndexId.value == 5
//                             ? mainPurpleColor
//                             : Colors.transparent,
//                         width: 3
//                     )
//                 ),
//                 child: Stack(
//                   children: [
//                     const BlackYellowTemplatesDesign(),
//                     CustomPaint(
//                       painter: TrianglePainter(color: Colors.amber),
//                       child: Container(
//                         height: 50,
//                         width: 50,
//                         padding: const EdgeInsets.only(left: 13),
//                         child: Transform.rotate(
//                           angle: -0.785398,
//                           child: const Text(
//                             'PRO',
//                             style: TextStyle(
//                                 color: sWhite,
//                                 fontFamily: 'Montserrat',
//                                 fontSize: 11,
//                                 fontWeight: FontWeight.bold
//                             ),
//                           ),
//                         ),
//                       ),
//                     ),
//                   ],
//                 )),
//             Container(
//                 margin: EdgeInsets.only(
//                     left: 5,
//                     right: 5,
//                     bottom: 5,
//                     top: controller.selectedTempIndexId.value == 6 ? 5 : 15),
//                 decoration: BoxDecoration(
//                     border: Border.all(
//                         color: controller.selectedTempIndexId.value == 6
//                             ? mainPurpleColor
//                             : Colors.transparent,
//                         width: 3
//                     )
//                 ),
//                 child: Stack(
//                   children: [
//                     const PinkBlueTemplatesDesign(),
//                     CustomPaint(
//                       painter: TrianglePainter(color: Colors.amber),
//                       child: Container(
//                         height: 50,
//                         width: 50,
//                         padding: const EdgeInsets.only(left: 13),
//                         child: Transform.rotate(
//                           angle: -0.785398,
//                           child: const Text(
//                             'PRO',
//                             style: TextStyle(
//                                 color: sWhite,
//                                 fontFamily: 'Montserrat',
//                                 fontSize: 11,
//                                 fontWeight: FontWeight.bold
//                             ),
//                           ),
//                         ),
//                       ),
//                     ),
//                   ],
//                 )),
//             Container(
//                 margin: EdgeInsets.only(
//                     left: 5,
//                     right: 5,
//                     bottom: 5,
//                     top: controller.selectedTempIndexId.value == 7 ? 5 : 15),
//                 decoration: BoxDecoration(
//                     border: Border.all(
//                         color: controller.selectedTempIndexId.value == 7
//                             ? mainPurpleColor
//                             : Colors.transparent,
//                         width: 3
//                     )
//                 ),
//                 child: Stack(
//                   children: [
//                     const OrangeBlackTemplatesDesign(),
//                     CustomPaint(
//                       painter: TrianglePainter(color: Colors.amber),
//                       child: Container(
//                         height: 50,
//                         width: 50,
//                         padding: const EdgeInsets.only(left: 13),
//                         child: Transform.rotate(
//                           angle: -0.785398,
//                           child: const Text(
//                             'PRO',
//                             style: TextStyle(
//                                 color: sWhite,
//                                 fontFamily: 'Montserrat',
//                                 fontSize: 11,
//                                 fontWeight: FontWeight.bold
//                             ),
//                           ),
//                         ),
//                       ),
//                     ),
//                   ],
//                 )),
//             Container(
//                 margin: EdgeInsets.only(
//                     left: 5,
//                     right: 5,
//                     bottom: 5,
//                     top: controller.selectedTempIndexId.value == 8 ? 5 : 15),
//                 decoration: BoxDecoration(
//                     border: Border.all(
//                         color: controller.selectedTempIndexId.value == 8
//                             ? mainPurpleColor
//                             : Colors.transparent,
//                         width: 3
//                     )
//                 ),
//                 child: Stack(
//                   children: [
//                     const BlueBlackDottedTemplatesDesign(),
//                     CustomPaint(
//                       painter: TrianglePainter(color: Colors.amber),
//                       child: Container(
//                         height: 50,
//                         width: 50,
//                         padding: const EdgeInsets.only(left: 13),
//                         child: Transform.rotate(
//                           angle: -0.785398,
//                           child: const Text(
//                             'PRO',
//                             style: TextStyle(
//                                 color: sWhite,
//                                 fontFamily: 'Montserrat',
//                                 fontSize: 11,
//                                 fontWeight: FontWeight.bold
//                             ),
//                           ),
//                         ),
//                       ),
//                     ),
//                   ],
//                 )),
//             Container(
//                 margin: EdgeInsets.only(
//                     left: 5,
//                     right: 5,
//                     bottom: 5,
//                     top: controller.selectedTempIndexId.value == 9 ? 5 : 15),
//                 decoration: BoxDecoration(
//                     border: Border.all(
//                         color: controller.selectedTempIndexId.value == 9
//                             ? mainPurpleColor
//                             : Colors.transparent,
//                         width: 3
//                     )
//                 ),
//                 child: Stack(
//                   children: [
//                     const GreyWallpaperTemplatesDesign(),
//                     CustomPaint(
//                       painter: TrianglePainter(color: Colors.amber),
//                       child: Container(
//                         height: 50,
//                         width: 50,
//                         padding: const EdgeInsets.only(left: 13),
//                         child: Transform.rotate(
//                           angle: -0.785398,
//                           child: const Text(
//                             'PRO',
//                             style: TextStyle(
//                                 color: sWhite,
//                                 fontFamily: 'Montserrat',
//                                 fontSize: 11,
//                                 fontWeight: FontWeight.bold
//                             ),
//                           ),
//                         ),
//                       ),
//                     ),
//                   ],
//                 )),
//           ],
//         ),
//       );
//     }),
//   );
// }

}
