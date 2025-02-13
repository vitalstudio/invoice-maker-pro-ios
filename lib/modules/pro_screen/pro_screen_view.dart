import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../core/utils/pro_screen_text.dart';
import '../../core/app_singletons/app_singletons.dart';
import '../../core/constants/app_constants/App_Constants.dart';
import '../../core/constants/color/color.dart';
import '../../core/preferenceManager/sharedPreferenceManager.dart';
import 'pro_screen_controller.dart';
import 'package:carousel_slider/carousel_slider.dart';

class ProScreenView extends GetView<ProScreenController> {
  @override
  Widget build(BuildContext context) {
    bool checkIsMobileLayout = AppConstants.isMobileScreen.value;

    return checkIsMobileLayout
        ? mainMobileLayout(context)
        : mainDesktopLayout(context);
  }

  Widget mainMobileLayout(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Column(
        children: [
          const SizedBox(
            height: 30,
          ),
          Expanded(
            flex: 1,
            child: GestureDetector(
              onTap: () {},
              child: Stack(
                children: [
                  CarouselSlider(
                    items: controller.imagesList
                        .map((e) =>
                        SizedBox(
                          height: double.infinity,
                          child: Image.asset(
                            e.toString(),
                            fit: BoxFit.fill,
                          ),
                        ))
                        .toList(),
                    options: CarouselOptions(
                        height: double.infinity,
                        viewportFraction: 1,
                        autoPlayCurve: Curves.decelerate,
                        autoPlay: true,
                        autoPlayInterval: const Duration(seconds: 2)),
                  ),
                  Positioned(
                    right: 20,
                    left: 0,
                    top: 15,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          onPressed: () {
                            SharedPreferencesManager.setValue(
                                'isAppLaunchFirstTime', false);
                            Get.back();
                          },
                          icon: const Icon(
                            Icons.cancel,
                            color: sWhite,
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            controller.getRestoreProduct();
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(50),
                              color: mainPurpleColor,
                            ),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 5),
                            child: const Text(
                              'RESTORE',
                              style: TextStyle(
                                  fontFamily: 'Montserrat',
                                  fontSize: 12,
                                  color: sWhite,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Container(
              width: double.infinity,
              color: sWhite,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'Invoice Generator',
                          style: TextStyle(
                              fontFamily: 'Montserrat',
                              fontSize: 25,
                              color: blackColor,
                              fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              vertical: 2, horizontal: 10),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              gradient: LinearGradient(colors: [
                                mainPurpleColor,
                                mainPurpleColor.withOpacity(0.7),
                                mainPurpleColor.withOpacity(0.4)
                              ])),
                          child: const Text(
                            'Pro',
                            style: TextStyle(
                                fontFamily: 'Montserrat',
                                fontWeight: FontWeight.w700,
                                color: sWhite,
                                fontSize: 16),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 20),
                      child: const Text(
                        'Unlimited access to everything',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontFamily: 'Montserrat',
                            fontSize: 20,
                            color: blackColor,
                            fontWeight: FontWeight.w700),
                      ),
                    ),

                    const SizedBox(
                      height: 20,
                    ),

                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 20),
                      child: const Row(
                        children: [
                          Expanded(
                              child: ProScreenTextRow(
                                  iconData: Icons.check_circle_rounded,
                                  text: 'Unlimited Invoices')),
                          SizedBox(width: 5,),
                          Expanded(
                              child: ProScreenTextRow(
                                  iconData: Icons.check_circle_rounded,
                                  text: 'Unlimited Clients')),
                        ],
                      ),
                    ),

                    const SizedBox(height: 10,),

                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 20),
                      child: const Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                              child: ProScreenTextRow(
                                  iconData: Icons.check_circle_rounded,
                                  text: 'Unlimited Business')),
                          SizedBox(width: 5,),
                          Expanded(
                              child: ProScreenTextRow(
                                  iconData: Icons.check_circle_rounded,
                                  text: 'Unlimited Items')),
                        ],
                      ),
                    ),

                    const SizedBox(height: 10,),

                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 20),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                              child: ProScreenTextRow(
                                  iconData: Icons.check_circle_rounded,
                                  text: 'Professional Templates')),
                          SizedBox(width: 5,),
                          Expanded(
                              child: ProScreenTextRow(
                                  iconData: Icons.check_circle_rounded,
                                  text: 'Unlimited Estimates')),
                        ],
                      ),
                    ),

                    const SizedBox(height: 10,),

                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 20),
                      child: const ProScreenTextRow(
                          iconData: Icons.check_circle_rounded,
                          text: 'Ads Free'),
                    ),

                    const SizedBox(
                      height: 20,
                    ),

                    Obx(() =>
                        Container(
                          margin: const EdgeInsets.symmetric(horizontal: 20),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: GestureDetector(
                                      onTap: () {
                                        AppSingletons.selectedPlanForProInvoice
                                            .value = 1;
                                        debugPrint('Yearly Value: ${controller
                                            .yearlyPurchaseValue.value}');
                                      },
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 5, vertical: 10),
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(
                                              10),
                                          color: AppSingletons
                                              .selectedPlanForProInvoice
                                              .value == 1
                                              ? mainPurpleColor
                                              : sWhite,
                                          border: Border.all(
                                            color: mainPurpleColor,
                                            width: 2,
                                          ),
                                        ),
                                        alignment: Alignment.center,
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          mainAxisAlignment: MainAxisAlignment
                                              .center,
                                          crossAxisAlignment: CrossAxisAlignment
                                              .center,
                                          children: [
                                            Container(
                                              decoration: BoxDecoration(
                                                  color: AppSingletons
                                                      .selectedPlanForProInvoice
                                                      .value == 1
                                                      ? sWhite
                                                      : mainPurpleColor,
                                                  borderRadius: BorderRadius
                                                      .circular(5)
                                              ),

                                              padding: const EdgeInsets
                                                  .symmetric(
                                                  horizontal: 15, vertical: 3),
                                              child: Text(
                                                '3 Days Free Trail',
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                  fontFamily: 'Montserrat',
                                                  color: AppSingletons
                                                      .selectedPlanForProInvoice
                                                      .value == 1
                                                      ? mainPurpleColor
                                                      : sWhite,
                                                  fontWeight: FontWeight.w800,),
                                              ),
                                            ),
                                            const SizedBox(height: 3,),
                                            Text(
                                              'Yearly',
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  fontFamily: 'Montserrat',
                                                  color: AppSingletons
                                                      .selectedPlanForProInvoice
                                                      .value == 1
                                                      ? sWhite
                                                      : blackColor,
                                                  fontWeight: FontWeight.w700,
                                                  fontSize: 17),
                                            ),
                                            const SizedBox(height: 3,),
                                            Text(
                                              controller.yearlyPurchaseValue
                                                  .isEmpty
                                                  ||
                                                  controller.yearlyPurchaseValue
                                                      .value == ''
                                                  ? '00.00'
                                                  : '${controller
                                                  .yearlyPurchaseValue.value}',
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  fontFamily: 'Montserrat',
                                                  color: AppSingletons
                                                      .selectedPlanForProInvoice
                                                      .value == 1
                                                      ? sWhite
                                                      : blackColor,
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 17),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),),
                                  const SizedBox(width: 15,),
                                  Expanded(
                                    child: GestureDetector(
                                      onTap: () {
                                        AppSingletons.selectedPlanForProInvoice
                                            .value = 2;
                                        debugPrint('Monthly Value: ${controller
                                            .monthlyPurchaseValue.value}');
                                      },
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 5, vertical: 10),
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(
                                              10),
                                          color: AppSingletons
                                              .selectedPlanForProInvoice
                                              .value == 2
                                              ? mainPurpleColor
                                              : sWhite,
                                          border: Border.all(
                                            color: mainPurpleColor,
                                            width: 2,
                                          ),
                                        ),
                                        alignment: Alignment.center,
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          mainAxisAlignment: MainAxisAlignment
                                              .center,
                                          crossAxisAlignment: CrossAxisAlignment
                                              .center,
                                          children: [
                                            Container(
                                              decoration: BoxDecoration(
                                                  color: AppSingletons
                                                      .selectedPlanForProInvoice
                                                      .value == 2
                                                      ? sWhite
                                                      : mainPurpleColor,
                                                  borderRadius: BorderRadius
                                                      .circular(5)
                                              ),

                                              padding: const EdgeInsets
                                                  .symmetric(
                                                  horizontal: 15, vertical: 3),
                                              child: Text(
                                                'GOLD',
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                  fontFamily: 'Montserrat',
                                                  color: AppSingletons
                                                      .selectedPlanForProInvoice
                                                      .value == 2
                                                      ? mainPurpleColor
                                                      : sWhite,
                                                  fontWeight: FontWeight.w800,),
                                              ),
                                            ),
                                            const SizedBox(height: 3,),
                                            Text(
                                              'Monthly',
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  fontFamily: 'Montserrat',
                                                  color: AppSingletons
                                                      .selectedPlanForProInvoice
                                                      .value == 2
                                                      ? sWhite
                                                      : blackColor,
                                                  fontWeight: FontWeight.w700,
                                                  fontSize: 17),
                                            ),
                                            const SizedBox(height: 3,),
                                            Text(
                                              controller.monthlyPurchaseValue
                                                  .isEmpty
                                                  || controller
                                                  .monthlyPurchaseValue.value ==
                                                  ''
                                                  ? '00.00'
                                                  : '${controller
                                                  .monthlyPurchaseValue.value}',
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  fontFamily: 'Montserrat',
                                                  color: AppSingletons
                                                      .selectedPlanForProInvoice
                                                      .value == 2
                                                      ? sWhite
                                                      : blackColor,
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 17),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),),

                                ],
                              ),
                              const SizedBox(height: 15,),
                              Row(
                                children: [
                                  Expanded(
                                    child: GestureDetector(
                                      onTap: () {
                                        AppSingletons.selectedPlanForProInvoice
                                            .value = 3;
                                        debugPrint('Weekly Value: ${controller
                                            .weeklyPurchaseValue.value}');
                                      },
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 5, vertical: 10),
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(
                                              10),
                                          color: AppSingletons
                                              .selectedPlanForProInvoice
                                              .value == 3
                                              ? mainPurpleColor
                                              : sWhite,
                                          border: Border.all(
                                            color: mainPurpleColor,
                                            width: 2,
                                          ),
                                        ),
                                        alignment: Alignment.center,
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          mainAxisAlignment: MainAxisAlignment
                                              .center,
                                          crossAxisAlignment: CrossAxisAlignment
                                              .center,
                                          children: [
                                            Container(
                                              decoration: BoxDecoration(
                                                  color: AppSingletons
                                                      .selectedPlanForProInvoice
                                                      .value == 3
                                                      ? sWhite
                                                      : mainPurpleColor,
                                                  borderRadius: BorderRadius
                                                      .circular(5)
                                              ),

                                              padding: const EdgeInsets
                                                  .symmetric(
                                                  horizontal: 15, vertical: 3),
                                              child: Text(
                                                'BASIC',
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                  fontFamily: 'Montserrat',
                                                  color: AppSingletons
                                                      .selectedPlanForProInvoice
                                                      .value == 3
                                                      ? mainPurpleColor
                                                      : sWhite,
                                                  fontWeight: FontWeight.w800,),
                                              ),
                                            ),
                                            const SizedBox(height: 3,),
                                            Text(
                                              'Weekly',
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  fontFamily: 'Montserrat',
                                                  color: AppSingletons
                                                      .selectedPlanForProInvoice
                                                      .value == 3
                                                      ? sWhite
                                                      : blackColor,
                                                  fontWeight: FontWeight.w700,
                                                  fontSize: 17),
                                            ),
                                            const SizedBox(height: 3,),
                                            Text(
                                              controller.weeklyPurchaseValue
                                                  .isEmpty
                                                  ||
                                                  controller.weeklyPurchaseValue
                                                      .value == ''
                                                  ? '00.00'
                                                  : '${controller
                                                  .weeklyPurchaseValue.value}',

                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  fontFamily: 'Montserrat',
                                                  color: AppSingletons
                                                      .selectedPlanForProInvoice
                                                      .value == 3
                                                      ? sWhite
                                                      : blackColor,
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 17),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),),
                                  const SizedBox(width: 15,),
                                  Expanded(
                                    child: GestureDetector(
                                      onTap: () {
                                        AppSingletons.selectedPlanForProInvoice
                                            .value = 4;
                                      },
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 5, vertical: 10),
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(
                                              10),
                                          color: AppSingletons
                                              .selectedPlanForProInvoice
                                              .value == 4
                                              ? mainPurpleColor
                                              : sWhite,
                                          border: Border.all(
                                            color: mainPurpleColor,
                                            width: 2,
                                          ),
                                        ),
                                        alignment: Alignment.center,
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          mainAxisAlignment: MainAxisAlignment
                                              .center,
                                          crossAxisAlignment: CrossAxisAlignment
                                              .center,
                                          children: [
                                            Container(
                                              decoration: BoxDecoration(
                                                  color: AppSingletons
                                                      .selectedPlanForProInvoice
                                                      .value == 4
                                                      ? sWhite
                                                      : mainPurpleColor,
                                                  borderRadius: BorderRadius
                                                      .circular(5)
                                              ),

                                              padding: const EdgeInsets
                                                  .symmetric(
                                                  horizontal: 15, vertical: 3),
                                              child: Text(
                                                '50% OFF',
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                  fontFamily: 'Montserrat',
                                                  color: AppSingletons
                                                      .selectedPlanForProInvoice
                                                      .value == 4
                                                      ? mainPurpleColor
                                                      : sWhite,
                                                  fontWeight: FontWeight.w800,),
                                              ),
                                            ),
                                            const SizedBox(height: 3,),
                                            Text(
                                              'Life Time',
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  fontFamily: 'Montserrat',
                                                  color: AppSingletons
                                                      .selectedPlanForProInvoice
                                                      .value == 4
                                                      ? sWhite
                                                      : blackColor,
                                                  fontWeight: FontWeight.w700,
                                                  fontSize: 17),
                                            ),
                                            const SizedBox(height: 3,),
                                            Text(
                                              controller.lifeTimeValue.isEmpty
                                                  || controller.lifeTimeValue
                                                  .value == ''
                                                  ? '00.00'
                                                  : '${controller.lifeTimeValue
                                                  .value}',
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  fontFamily: 'Montserrat',
                                                  color: AppSingletons
                                                      .selectedPlanForProInvoice
                                                      .value == 4
                                                      ? sWhite
                                                      : blackColor,
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 17),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),),
                                ],
                              ),
                            ],
                          ),
                        )),

                    const SizedBox(
                      height: 20,
                    ),

                    GestureDetector(
                      onTap: () {
                        if (Platform.isAndroid) {
                          if (AppSingletons.selectedPlanForProInvoice.value ==
                              1) {
                            controller.buyProduct(
                                controller.productsDetailsAndroid.value[3]);
                            debugPrint(
                                'VALUE: ${controller.productsDetailsAndroid
                                    .value[3].rawPrice}');
                          }
                          else
                          if (AppSingletons.selectedPlanForProInvoice.value ==
                              2) {
                            controller.buyProduct(
                                controller.productsDetailsAndroid.value[1]);
                            debugPrint(
                                'VALUE: ${controller.productsDetailsAndroid
                                    .value[1].rawPrice}');
                          }
                          else
                          if (AppSingletons.selectedPlanForProInvoice.value ==
                              3) {
                            controller.buyProduct(
                                controller.productsDetailsAndroid.value[2]);
                            debugPrint(
                                'VALUE: ${controller.productsDetailsAndroid
                                    .value[2].rawPrice}');
                          }
                          else {
                            controller.buyProduct(
                                controller.productsDetailsAndroid.value[0]);
                            debugPrint(
                                'VALUE: ${controller.productsDetailsAndroid
                                    .value[0].rawPrice}');
                          }
                        }
                        else if (Platform.isIOS) {
                          // 1 = yearly
                          // 2 = Monthly
                          // 3 = Weekly
                          // 4 = Lifetime

                          if (AppSingletons.selectedPlanForProInvoice.value ==
                              1) {
                            controller.buyProductIOS(
                                controller.productsDetailsIOS.value[2]);
                          }
                          else
                          if (AppSingletons.selectedPlanForProInvoice.value ==
                              2) {
                            controller.buyProductIOS(
                                controller.productsDetailsIOS.value[1]);
                          }
                          else
                          if (AppSingletons.selectedPlanForProInvoice.value ==
                              3) {
                            controller.buyProductIOS(
                                controller.productsDetailsIOS.value[0]);
                          }
                          else {
                            controller.buyProductIOS(
                                controller.productsDetailsIOS.value[3]);
                          }

                          // controller.buyProductIOS(controller.productsDetailsIOS.value[
                          // AppSingletons.selectedPlanForProInvoice.value - 1]);

                        }

                        SharedPreferencesManager.setValue(
                            'isAppLaunchFirstTime', false);
                      },
                      child: Obx(() {
                        return Container(
                          margin: const EdgeInsets.symmetric(horizontal: 20),
                          height: 50,
                          width: AppConstants.isMobileScreen.value
                              ? double.infinity
                              : 400,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(50),
                              gradient: LinearGradient(colors: [
                                mainPurpleColor,
                                mainPurpleColor.withOpacity(0.7),
                                mainPurpleColor.withOpacity(0.4)
                              ])),
                          alignment: Alignment.center,
                          child:
                          AppSingletons.selectedPlanForProInvoice.value == 1
                              ? Column(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const Text(
                                'TRY FREE FOR 3 DAYS',
                                style: TextStyle(
                                    fontFamily: 'Montserrat',
                                    color: sWhite,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700),
                              ),
                              Text(
                                'THEN ${controller.yearlyPurchaseValue
                                    .value} PER YEAR',
                                style: const TextStyle(
                                    fontFamily: 'Montserrat',
                                    color: sWhite,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700),
                              ),
                            ],
                          )
                              : const Text(
                            'Continue',
                            style: TextStyle(
                                fontFamily: 'Montserrat',
                                color: sWhite,
                                fontSize: 16,
                                fontWeight: FontWeight.w700),
                          ),
                        );
                      }),
                    ),

                    const SizedBox(
                      height: 20,
                    ),

                    Visibility(
                        visible: false,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              margin: const EdgeInsets.symmetric(
                                  horizontal: 20),
                              child: Row(
                                children: [
                                  Container(
                                    height: 8,
                                    width: 8,
                                    decoration: const BoxDecoration(
                                        color: blackColor,
                                        shape: BoxShape.circle
                                    ),
                                  ),

                                  const SizedBox(width: 10,),

                                  const Expanded(
                                    child: Text(
                                      'Subscription will be auto-renews and tou will be automatically charged. Cancel Anytime',
                                      style: TextStyle(
                                          fontFamily: 'Montserrat',
                                          color: blackColor,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ),

                                ],
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Container(
                              margin: const EdgeInsets.symmetric(
                                  horizontal: 20),

                              child: Row(
                                children: [
                                  Container(
                                    height: 8,
                                    width: 8,
                                    decoration: const BoxDecoration(
                                        color: blackColor,
                                        shape: BoxShape.circle
                                    ),
                                  ),

                                  const SizedBox(width: 10,),

                                  const Expanded(
                                    child: Text(
                                      'Your subscription can be managed or cancelled under your google play store account profile PAYMENT AND SUBSCRIPTIONS',
                                      style: TextStyle(
                                          fontFamily: 'Montserrat',
                                          color: blackColor,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ),

                                ],
                              ),
                            ),
                          ],
                        )),

                    const SizedBox(
                      height: 10,
                    ),

                    Visibility(
                        visible: true,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              margin: const EdgeInsets.symmetric(
                                  horizontal: 20),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    height: 10,
                                    width: 10,
                                    margin: const EdgeInsets.only(top: 6),
                                    decoration: const BoxDecoration(
                                        color: blackColor,
                                        shape: BoxShape.circle
                                    ),
                                  ),

                                  const SizedBox(width: 10,),

                                  const Expanded(
                                    child: Text(
                                      'Payment will be charged to your iTunes account at confirmation of purchase. Your subscription will automatically renew unless auto-renew is turned off at least 24-hours prior to the end of the current subscription period. Automatic renewals will cost the same price you were originally charged for the subscription.',
                                      textAlign: TextAlign.justify,
                                      style: TextStyle(
                                          fontFamily: 'Montserrat',
                                          color: blackColor,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ),
                                  const SizedBox(width: 10,),
                                ],
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Container(
                              margin: const EdgeInsets.symmetric(
                                  horizontal: 20),

                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    height: 10,
                                    width: 10,
                                    margin: const EdgeInsets.only(top: 6),
                                    decoration: const BoxDecoration(
                                        color: blackColor,
                                        shape: BoxShape.circle
                                    ),
                                  ),

                                  const SizedBox(width: 10,),

                                  const Expanded(
                                    child: Text(
                                      'You can manage your subscriptions and turned off auto-renewal by going to your Account Settings on the App Store after purchase. Read our terms of services and Privacy Policy for more information.',
                                      textAlign: TextAlign.justify,
                                      style: TextStyle(
                                          fontFamily: 'Montserrat',
                                          color: blackColor,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ),
                                  const SizedBox(width: 10,),
                                ],
                              ),
                            ),
                          ],
                        )),

                    const SizedBox(
                      height: 10,
                    ),

                    Visibility(
                      visible: true,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          TextButton(
                              onPressed: () {
                                Uri url = Uri.parse(
                                    'https://vitalappstudio.blogspot.com/2024/08/%20Invoice%20Maker%20Receipt%20Creator.html');
                                launchUrl(url);
                              },
                              child: const Text('Privacy policy',
                                style: TextStyle(
                                  fontFamily: 'Montserrat',
                                  color: blackColor,
                                  fontSize: 13,),
                              )),

                          Container(
                            height: 20,
                            width: 2,
                            color: blackColor,
                          ),
                          TextButton(
                              onPressed: () {
                                Uri url = Uri.parse(
                                    'https://vitalappstudio.blogspot.com/2024/04/terms%20of%20use.html');
                                launchUrl(url);
                              },
                              child: const Text('Term of services',
                                style: TextStyle(
                                  fontFamily: 'Montserrat',
                                  color: blackColor,
                                  fontSize: 13,),
                              )),
                        ],
                      ),
                    ),

                    const SizedBox(
                      height: 10,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget mainDesktopLayout(BuildContext context) {
    return Scaffold(
      backgroundColor: mainPurpleColor,
      body: Center(
        child: SizedBox(
          width: MediaQuery
              .of(context)
              .size
              .width * 0.4,
          height: double.infinity,
          child: Column(
            children: [
              const SizedBox(
                height: 30,
              ),
              Expanded(
                flex: 1,
                child: GestureDetector(
                  onTap: () {},
                  child: Stack(
                    children: [
                      CarouselSlider(
                        items: controller.imagesList
                            .map((e) =>
                            SizedBox(
                              height: double.infinity,
                              child: Image.asset(
                                e.toString(),
                                fit: BoxFit.fill,
                              ),
                            ))
                            .toList(),
                        options: CarouselOptions(
                            height: double.infinity,
                            viewportFraction: 1,
                            autoPlayCurve: Curves.decelerate,
                            autoPlay: true,
                            autoPlayInterval: const Duration(seconds: 2)),
                      ),
                      // Positioned(
                      //   right: 0,
                      //   top: 0,
                      //   child: IconButton(
                      //     onPressed: () {
                      //       SharedPreferencesManager.setValue(
                      //           'isAppLaunchFirstTime', false);
                      //       Get.back();
                      //     },
                      //     icon: const Icon(
                      //       Icons.cancel,
                      //       color: sWhite,
                      //     ),
                      //   ),
                      // ),
                      Positioned(
                        right: 20,
                        left: 0,
                        top: 0,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            IconButton(
                              onPressed: () {
                                SharedPreferencesManager.setValue(
                                    'isAppLaunchFirstTime', false);
                                Get.back();
                              },
                              icon: const Icon(
                                Icons.cancel,
                                color: sWhite,
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                controller.getRestoreProduct();
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(50),
                                  color: sWhite,
                                ),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 5),
                                child: const Text(
                                  'RESTORE',
                                  style: TextStyle(
                                      fontFamily: 'Montserrat',
                                      fontSize: 12,
                                      color: mainPurpleColor,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                flex: 2,
                child: Container(
                  width: double.infinity,
                  color: sWhite,
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        const SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              'Invoice Generator',
                              style: TextStyle(
                                  fontFamily: 'Montserrat',
                                  fontSize: 25,
                                  color: blackColor,
                                  fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(
                              width: 5,
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 2, horizontal: 10),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  gradient: LinearGradient(colors: [
                                    mainPurpleColor,
                                    mainPurpleColor.withOpacity(0.7),
                                    mainPurpleColor.withOpacity(0.4)
                                  ])),
                              child: const Text(
                                'Pro',
                                style: TextStyle(
                                    fontFamily: 'Montserrat',
                                    fontWeight: FontWeight.w700,
                                    color: sWhite,
                                    fontSize: 16),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Container(
                          margin: const EdgeInsets.symmetric(horizontal: 20),
                          child: const Text(
                            'Unlimited access to everything',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontFamily: 'Montserrat',
                                fontSize: 20,
                                color: blackColor,
                                fontWeight: FontWeight.w700),
                          ),
                        ),

                        const SizedBox(
                          height: 20,
                        ),

                        Container(
                          margin: const EdgeInsets.symmetric(horizontal: 20),
                          child: const Row(
                            children: [
                              Expanded(
                                  child: ProScreenTextRow(
                                      iconData: Icons.check_circle_rounded,
                                      text: 'Unlimited Invoices')),
                              SizedBox(width: 5,),
                              Expanded(
                                  child: ProScreenTextRow(
                                      iconData: Icons.check_circle_rounded,
                                      text: 'Unlimited Clients')),
                            ],
                          ),
                        ),

                        const SizedBox(height: 10,),

                        Container(
                          margin: const EdgeInsets.symmetric(horizontal: 20),
                          child: const Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Expanded(
                                  child: ProScreenTextRow(
                                      iconData: Icons.check_circle_rounded,
                                      text: 'Unlimited Business')),
                              SizedBox(width: 5,),
                              Expanded(
                                  child: ProScreenTextRow(
                                      iconData: Icons.check_circle_rounded,
                                      text: 'Unlimited Items')),
                            ],
                          ),
                        ),

                        const SizedBox(height: 10,),

                        Container(
                          margin: const EdgeInsets.symmetric(horizontal: 20),
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                  child: ProScreenTextRow(
                                      iconData: Icons.check_circle_rounded,
                                      text: 'Professional Templates')),
                              SizedBox(width: 5,),
                              Expanded(
                                  child: ProScreenTextRow(
                                      iconData: Icons.check_circle_rounded,
                                      text: 'Unlimited Estimates')),
                            ],
                          ),
                        ),

                        const SizedBox(
                          height: 20,
                        ),

                        Obx(() =>
                            Container(
                              margin: const EdgeInsets.symmetric(
                                  horizontal: 20),
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      Expanded(
                                        child: GestureDetector(
                                          onTap: () {
                                            AppSingletons
                                                .selectedPlanForProInvoice
                                                .value = 1;
                                            debugPrint(
                                                'Yearly Value: ${controller
                                                    .yearlyPurchaseValue
                                                    .value}');
                                          },
                                          child: Container(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 5, vertical: 10),
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius
                                                  .circular(10),
                                              color: AppSingletons
                                                  .selectedPlanForProInvoice
                                                  .value == 1
                                                  ? mainPurpleColor
                                                  : sWhite,
                                              border: Border.all(
                                                color: mainPurpleColor,
                                                width: 2,
                                              ),
                                            ),
                                            alignment: Alignment.center,
                                            child: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              mainAxisAlignment: MainAxisAlignment
                                                  .center,
                                              crossAxisAlignment: CrossAxisAlignment
                                                  .center,
                                              children: [
                                                Container(
                                                  decoration: BoxDecoration(
                                                      color: AppSingletons
                                                          .selectedPlanForProInvoice
                                                          .value == 1
                                                          ? sWhite
                                                          : mainPurpleColor,
                                                      borderRadius: BorderRadius
                                                          .circular(5)
                                                  ),

                                                  padding: const EdgeInsets
                                                      .symmetric(horizontal: 15,
                                                      vertical: 3),
                                                  child: Text(
                                                    '3 Days Free Trail',
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                      fontFamily: 'Montserrat',
                                                      color: AppSingletons
                                                          .selectedPlanForProInvoice
                                                          .value == 1
                                                          ? mainPurpleColor
                                                          : sWhite,
                                                      fontWeight: FontWeight
                                                          .w800,),
                                                  ),
                                                ),
                                                const SizedBox(height: 3,),
                                                Text(
                                                  'Yearly',
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                      fontFamily: 'Montserrat',
                                                      color: AppSingletons
                                                          .selectedPlanForProInvoice
                                                          .value == 1
                                                          ? sWhite
                                                          : blackColor,
                                                      fontWeight: FontWeight
                                                          .w700,
                                                      fontSize: 17),
                                                ),
                                                const SizedBox(height: 3,),
                                                Text(
                                                  controller.yearlyPurchaseValue
                                                      .isEmpty
                                                      || controller
                                                      .yearlyPurchaseValue
                                                      .value == ''
                                                      ? '00.00'
                                                      : controller
                                                      .yearlyPurchaseValue
                                                      .value,
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                      fontFamily: 'Montserrat',
                                                      color: AppSingletons
                                                          .selectedPlanForProInvoice
                                                          .value == 1
                                                          ? sWhite
                                                          : blackColor,
                                                      fontWeight: FontWeight
                                                          .w600,
                                                      fontSize: 17),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),),
                                      const SizedBox(width: 15,),
                                      Expanded(
                                        child: GestureDetector(
                                          onTap: () {
                                            AppSingletons
                                                .selectedPlanForProInvoice
                                                .value = 2;
                                            debugPrint(
                                                'Monthly Value: ${controller
                                                    .monthlyPurchaseValue
                                                    .value}');
                                          },
                                          child: Container(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 5, vertical: 10),
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius
                                                  .circular(10),
                                              color: AppSingletons
                                                  .selectedPlanForProInvoice
                                                  .value == 2
                                                  ? mainPurpleColor
                                                  : sWhite,
                                              border: Border.all(
                                                color: mainPurpleColor,
                                                width: 2,
                                              ),
                                            ),
                                            alignment: Alignment.center,
                                            child: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              mainAxisAlignment: MainAxisAlignment
                                                  .center,
                                              crossAxisAlignment: CrossAxisAlignment
                                                  .center,
                                              children: [
                                                Container(
                                                  decoration: BoxDecoration(
                                                      color: AppSingletons
                                                          .selectedPlanForProInvoice
                                                          .value == 2
                                                          ? sWhite
                                                          : mainPurpleColor,
                                                      borderRadius: BorderRadius
                                                          .circular(5)
                                                  ),

                                                  padding: const EdgeInsets
                                                      .symmetric(horizontal: 15,
                                                      vertical: 3),
                                                  child: Text(
                                                    'GOLD',
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                      fontFamily: 'Montserrat',
                                                      color: AppSingletons
                                                          .selectedPlanForProInvoice
                                                          .value == 2
                                                          ? mainPurpleColor
                                                          : sWhite,
                                                      fontWeight: FontWeight
                                                          .w800,),
                                                  ),
                                                ),
                                                const SizedBox(height: 3,),
                                                Text(
                                                  'Monthly',
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                      fontFamily: 'Montserrat',
                                                      color: AppSingletons
                                                          .selectedPlanForProInvoice
                                                          .value == 2
                                                          ? sWhite
                                                          : blackColor,
                                                      fontWeight: FontWeight
                                                          .w700,
                                                      fontSize: 17),
                                                ),
                                                const SizedBox(height: 3,),
                                                Text(
                                                  controller
                                                      .monthlyPurchaseValue
                                                      .isEmpty
                                                      || controller
                                                      .monthlyPurchaseValue
                                                      .value == ''
                                                      ? '00.00'
                                                      : controller
                                                      .monthlyPurchaseValue
                                                      .value,
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                      fontFamily: 'Montserrat',
                                                      color: AppSingletons
                                                          .selectedPlanForProInvoice
                                                          .value == 2
                                                          ? sWhite
                                                          : blackColor,
                                                      fontWeight: FontWeight
                                                          .w600,
                                                      fontSize: 17),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),),

                                    ],
                                  ),
                                  const SizedBox(height: 15,),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: GestureDetector(
                                          onTap: () {
                                            AppSingletons
                                                .selectedPlanForProInvoice
                                                .value = 3;
                                            debugPrint(
                                                'Weekly Value: ${controller
                                                    .weeklyPurchaseValue
                                                    .value}');
                                          },
                                          child: Container(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 5, vertical: 10),
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius
                                                  .circular(10),
                                              color: AppSingletons
                                                  .selectedPlanForProInvoice
                                                  .value == 3
                                                  ? mainPurpleColor
                                                  : sWhite,
                                              border: Border.all(
                                                color: mainPurpleColor,
                                                width: 2,
                                              ),
                                            ),
                                            alignment: Alignment.center,
                                            child: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              mainAxisAlignment: MainAxisAlignment
                                                  .center,
                                              crossAxisAlignment: CrossAxisAlignment
                                                  .center,
                                              children: [
                                                Container(
                                                  decoration: BoxDecoration(
                                                      color: AppSingletons
                                                          .selectedPlanForProInvoice
                                                          .value == 3
                                                          ? sWhite
                                                          : mainPurpleColor,
                                                      borderRadius: BorderRadius
                                                          .circular(5)
                                                  ),

                                                  padding: const EdgeInsets
                                                      .symmetric(horizontal: 15,
                                                      vertical: 3),
                                                  child: Text(
                                                    'BASIC',
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                      fontFamily: 'Montserrat',
                                                      color: AppSingletons
                                                          .selectedPlanForProInvoice
                                                          .value == 3
                                                          ? mainPurpleColor
                                                          : sWhite,
                                                      fontWeight: FontWeight
                                                          .w800,),
                                                  ),
                                                ),
                                                const SizedBox(height: 3,),
                                                Text(
                                                  'Weekly',
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                      fontFamily: 'Montserrat',
                                                      color: AppSingletons
                                                          .selectedPlanForProInvoice
                                                          .value == 3
                                                          ? sWhite
                                                          : blackColor,
                                                      fontWeight: FontWeight
                                                          .w700,
                                                      fontSize: 17),
                                                ),
                                                const SizedBox(height: 3,),
                                                Text(
                                                  controller.weeklyPurchaseValue
                                                      .isEmpty
                                                      || controller
                                                      .weeklyPurchaseValue
                                                      .value == ''
                                                      ? '00.00'
                                                      : '${controller
                                                      .weeklyPurchaseValue}',

                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                      fontFamily: 'Montserrat',
                                                      color: AppSingletons
                                                          .selectedPlanForProInvoice
                                                          .value == 3
                                                          ? sWhite
                                                          : blackColor,
                                                      fontWeight: FontWeight
                                                          .w600,
                                                      fontSize: 17),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),),
                                      const SizedBox(width: 15,),
                                      Expanded(
                                        child: GestureDetector(
                                          onTap: () {
                                            AppSingletons
                                                .selectedPlanForProInvoice
                                                .value = 4;
                                          },
                                          child: Container(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 5, vertical: 10),
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius
                                                  .circular(10),
                                              color: AppSingletons
                                                  .selectedPlanForProInvoice
                                                  .value == 4
                                                  ? mainPurpleColor
                                                  : sWhite,
                                              border: Border.all(
                                                color: mainPurpleColor,
                                                width: 2,
                                              ),
                                            ),
                                            alignment: Alignment.center,
                                            child: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              mainAxisAlignment: MainAxisAlignment
                                                  .center,
                                              crossAxisAlignment: CrossAxisAlignment
                                                  .center,
                                              children: [
                                                Container(
                                                  decoration: BoxDecoration(
                                                      color: AppSingletons
                                                          .selectedPlanForProInvoice
                                                          .value == 4
                                                          ? sWhite
                                                          : mainPurpleColor,
                                                      borderRadius: BorderRadius
                                                          .circular(5)
                                                  ),

                                                  padding: const EdgeInsets
                                                      .symmetric(horizontal: 15,
                                                      vertical: 3),
                                                  child: Text(
                                                    '50% OFF',
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                      fontFamily: 'Montserrat',
                                                      color: AppSingletons
                                                          .selectedPlanForProInvoice
                                                          .value == 4
                                                          ? mainPurpleColor
                                                          : sWhite,
                                                      fontWeight: FontWeight
                                                          .w800,),
                                                  ),
                                                ),
                                                const SizedBox(height: 3,),
                                                Text(
                                                  'Life Time',
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                      fontFamily: 'Montserrat',
                                                      color: AppSingletons
                                                          .selectedPlanForProInvoice
                                                          .value == 4
                                                          ? sWhite
                                                          : blackColor,
                                                      fontWeight: FontWeight
                                                          .w700,
                                                      fontSize: 17),
                                                ),
                                                const SizedBox(height: 3,),
                                                Text(
                                                  controller.lifeTimeValue
                                                      .isEmpty
                                                      ||
                                                      controller.lifeTimeValue
                                                          .value == ''
                                                      ? '00.00'
                                                      : controller.lifeTimeValue
                                                      .value,
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                      fontFamily: 'Montserrat',
                                                      color: AppSingletons
                                                          .selectedPlanForProInvoice
                                                          .value == 4
                                                          ? sWhite
                                                          : blackColor,
                                                      fontWeight: FontWeight
                                                          .w600,
                                                      fontSize: 17),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),),
                                    ],
                                  ),
                                ],
                              ),
                            )),

                        const SizedBox(
                          height: 20,
                        ),
                        GestureDetector(
                          onTap: () {
                            controller.buyProductIOS(
                                controller.productsDetailsIOS.value[
                                AppSingletons.selectedPlanForProInvoice.value -
                                    1]);

                            SharedPreferencesManager.setValue(
                                'isAppLaunchFirstTime', false);
                          },
                          child: Container(
                            margin: const EdgeInsets.symmetric(horizontal: 20),
                            height: 50,
                            width: AppConstants.isMobileScreen.value
                                ? double.infinity
                                : 400,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(50),
                                gradient: LinearGradient(colors: [
                                  mainPurpleColor,
                                  mainPurpleColor.withOpacity(0.7),
                                  mainPurpleColor.withOpacity(0.4)
                                ])),
                            alignment: Alignment.center,
                            child: const Text(
                              'Buy Now',
                              style: TextStyle(
                                  fontFamily: 'Montserrat',
                                  color: sWhite,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),

                        Visibility(
                            visible: Platform.isMacOS || Platform.isWindows,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  margin: const EdgeInsets.symmetric(
                                      horizontal: 20),
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment
                                        .start,
                                    children: [
                                      Container(
                                        height: 10,
                                        width: 10,
                                        margin: const EdgeInsets.only(top: 6),
                                        decoration: const BoxDecoration(
                                            color: blackColor,
                                            shape: BoxShape.circle
                                        ),
                                      ),

                                      const SizedBox(width: 10,),

                                      const Expanded(
                                        child: Text(
                                          'Payment will be charged to your iTunes account at confirmation of purchase. Your subscription will automatically renew unless auto-renew is turned off at least 24-hours prior to the end of the current subscription period. Automatic renewals will cost the same price you were originally charged for the subscription.',
                                          textAlign: TextAlign.justify,
                                          style: TextStyle(
                                              fontFamily: 'Montserrat',
                                              color: blackColor,
                                              fontSize: 14,
                                              fontWeight: FontWeight.w500),
                                        ),
                                      ),
                                      const SizedBox(width: 10,),
                                    ],
                                  ),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Container(
                                  margin: const EdgeInsets.symmetric(
                                      horizontal: 20),

                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment
                                        .start,
                                    children: [
                                      Container(
                                        height: 10,
                                        width: 10,
                                        margin: const EdgeInsets.only(top: 6),
                                        decoration: const BoxDecoration(
                                            color: blackColor,
                                            shape: BoxShape.circle
                                        ),
                                      ),

                                      const SizedBox(width: 10,),

                                      const Expanded(
                                        child: Text(
                                          'You can manage your subscriptions and turned off auto-renewal by going to your Account Settings on the App Store after purchase. Read our terms of services and Privacy Policy for more information.',
                                          textAlign: TextAlign.justify,
                                          style: TextStyle(
                                              fontFamily: 'Montserrat',
                                              color: blackColor,
                                              fontSize: 14,
                                              fontWeight: FontWeight.w500),
                                        ),
                                      ),
                                      const SizedBox(width: 10,),
                                    ],
                                  ),
                                ),
                              ],
                            )),

                        const SizedBox(
                          height: 10,
                        ),

                        Visibility(
                          visible: Platform.isMacOS || Platform.isWindows,
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              TextButton(
                                  onPressed: () {
                                    Uri url = Uri.parse(
                                        'https://vitalappstudio.blogspot.com/2024/08/%20Invoice%20Maker%20Receipt%20Creator.html');
                                    launchUrl(url);
                                  },
                                  child: const Text('Privacy policy',
                                    style: TextStyle(
                                      fontFamily: 'Montserrat',
                                      color: blackColor,
                                      fontSize: 13,),
                                  )),

                              Container(
                                height: 20,
                                width: 2,
                                color: blackColor,
                              ),
                              TextButton(
                                  onPressed: () {
                                    Uri url = Uri.parse(
                                        'https://vitalappstudio.blogspot.com/2024/04/terms%20of%20use.html');
                                    launchUrl(url);
                                  },
                                  child: const Text('Term of services',
                                    style: TextStyle(
                                      fontFamily: 'Montserrat',
                                      color: blackColor,
                                      fontSize: 13,),
                                  )),
                            ],
                          ),
                        ),

                        const SizedBox(
                          height: 10,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
