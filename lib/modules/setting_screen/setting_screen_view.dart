import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:invoice/core/app_singletons/app_singletons.dart';
import '../../core/preferenceManager/sharedPreferenceManager.dart';
import '../../core/utils/dialogue_to_select_language.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../core/constants/app_constants/App_Constants.dart';
import '../../core/utils/utils.dart';
import '../../core/constants/color/color.dart';
import '../../core/routes/routes.dart';
import '../../core/widgets/custom_setting_container.dart';
import 'setting_screen_controller.dart';

class SettingScreenView extends GetView<SettingScreenController> {
  const SettingScreenView({super.key});

  @override
  Widget build(BuildContext context) {

    bool checkIsMobileLayout = AppConstants.isMobileScreen.value;

    return checkIsMobileLayout ? mainMobileLayout(context) :  mainDesktopLayout(context);
  }

  Widget mainMobileLayout(context) {
    return Scaffold(
      backgroundColor: orangeLight_1,
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const SizedBox(height: 5,),
            Container(
              width: double.infinity,

              margin: const EdgeInsets.symmetric(horizontal: 20,vertical: 5),
              decoration: BoxDecoration(
                color: mainPurpleColor,
                borderRadius: BorderRadius.circular(10)
              ),

              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 10,),
                   Text('invoice_pro'.tr,
                  style: const TextStyle(
                    fontFamily: 'Montserrat',
                    fontWeight: FontWeight.bold,
                    fontSize: 25,
                    color: proIconColor
                  ),
                 ),
                   Text('full_access_to_all_features'.tr,
                    style: const TextStyle(
                        fontFamily: 'Montserrat',
                        fontWeight: FontWeight.normal,
                        fontSize: 15,
                        color: proIconColor
                    ),
                  ),
                  const SizedBox(height: 15,),
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 5),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(child: Column(

                          children: [
                            const Icon(Icons.account_balance_wallet,color: proIconColor,),
                            Text('professional_templates'.tr,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                  fontFamily: 'Montserrat',
                                  fontWeight: FontWeight.normal,
                                  fontSize: 11,
                                  color: proIconColor
                              ),
                            ),
                          ],
                        )),
                        Expanded(child: Column(
                          children: [
                            const Icon(Icons.accessibility,color: proIconColor,),
                            Text('unlimited_invoices_and_estimates'.tr,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                  fontFamily: 'Montserrat',
                                  fontWeight: FontWeight.normal,
                                  fontSize: 11,
                                  color: proIconColor
                              ),
                            ),
                          ],
                        )),
                        Expanded(child: Column(
                          children: [
                           const Icon(Icons.cloud_upload_rounded,color: proIconColor,),
                            Text('unlimited_export'.tr,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                  fontFamily: 'Montserrat',
                                  fontWeight: FontWeight.normal,
                                  fontSize: 11,
                                  color: proIconColor
                              ),
                            ),
                          ],
                        )),

                        Expanded(child: Column(
                          children: [
                            const Icon(Icons.add_chart_sharp,color: proIconColor,),
                            Text('business_reports'.tr,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                  fontFamily: 'Montserrat',
                                  fontWeight: FontWeight.normal,
                                  fontSize: 11,
                                  color: proIconColor
                              ),
                            ),
                          ],
                        )),

                      ],
                    ),
                  ),
                  const SizedBox(height: 15,),
                  GestureDetector(
                    onTap: (){
                      Get.toNamed(Routes.proScreenView);
                    },
                    child: Container(
                      width: double.infinity,
                      height: 40,
                      margin: const EdgeInsets.symmetric(horizontal: 15),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(7),
                        gradient: LinearGradient(
                          colors: [
                            proIconColor.withOpacity(0.4),
                            proIconColor.withOpacity(0.6),
                            proIconColor,
                          ]
                        )
                      ),
                      child:  Text('join_now'.tr,
                        style: const TextStyle(
                            fontFamily: 'Montserrat',
                            fontWeight: FontWeight.w600,
                            fontSize: 15,
                            color: blackColor
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 15,),
                ],
              ),

            ),
            const SizedBox(height: 5,),
            CustomSettingContainer(
              onTap: (){
                Get.toNamed(Routes.termsAndConditionView);
              },
              iconData:  Icons.event_note_sharp,
              title: 'term_and_condition'.tr,
              subTitle: 'add_new_term_and_condition'.tr,
            ),
            CustomSettingContainer(
              onTap: (){
                Get.toNamed(Routes.signatureView);
              },
              iconData:  Icons.edit,
              title: 'signature'.tr,
              subTitle: 'add_new_signature'.tr,
            ),
            CustomSettingContainer(
              onTap: (){
                Get.toNamed(Routes.paymentView);
              },
              iconData:  Icons.credit_card_rounded,
              title: 'payment_method'.tr,
              subTitle: 'add_new_payment_method'.tr,
            ),

            CustomSettingContainer(
              onTap: (){
                Get.toNamed(Routes.businessListView);
              },
              iconData: Icons.add_business,
              title: 'business_info'.tr,
              subTitle: 'add_new_businesses'.tr,
            ),

            CustomSettingContainer(
              onTap: () async{

                AppSingletons.selectedNewLanguage.value = AppSingletons.storedAppLanguage.value;

                await LanguageSelection.selectALanguage(
                    context: context,
                    titleHeading: 'SELECT APP LANGUAGE',
                    onChange: () async{
                      await LanguageSelection.updateLocale(
                        selectedLanguage: AppSingletons.selectedNewLanguage.value
                      );
                      Get.back();

                      await SharedPreferencesManager.setValue(
                          AppConstants.keyStoredAppLanguage,
                          AppSingletons.selectedNewLanguage.value
                      );

                      AppSingletons.storedAppLanguage.value = AppSingletons.selectedNewLanguage.value;

                      debugPrint('StoredAppLanguage: ${AppSingletons.selectedNewLanguage.value}');

                    }
                );
              },
              iconData: Icons.translate,
              title: 'app_language'.tr,
              subTitle: 'tap_to_switch_language'.tr,
            ),

            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20,vertical: 10),
              alignment: Alignment.centerLeft,
              child:  Text(
                'support'.tr,
                style: const TextStyle(
                    fontFamily: 'Montserrat',
                    color: grey_1,
                    fontWeight: FontWeight.w600,
                    fontSize: 15
                ),
              ),
            ),

            CustomSettingContainer(
              onTap: (){
                Utils.rateUs('enjoy_app'.tr);
              },
              iconData: Icons.verified,
              title: 'rate_us'.tr,
              subTitle: 'your_best_reward_to_us'.tr,
            ),

            CustomSettingContainer(
              onTap: () async {
                final size = MediaQuery.of(context).size;
                if(Platform.isAndroid){
                  await Share.share(
                      'android_prompt'.tr);
                }
                if(Platform.isIOS){
                  try {
                    await Share.share(
                        sharePositionOrigin: Rect.fromLTWH(0, 0, size.width, size.height / 2),
                        'ios_prompt'.tr);
                  }
                  catch (e) {
                    print("Error: $e");
                  }
                }
              },
              iconData: Icons.share,
              title: 'share'.tr,
              subTitle: 'share_app_with_friends'.tr,
            ),

            CustomSettingContainer(
              onTap: (){
                Uri url = Uri.parse(
                    'https://vitalappstudio.blogspot.com/2024/08/%20Invoice%20Maker%20Receipt%20Creator.html');
                launchUrl(url);
              },
              iconData: Icons.privacy_tip_outlined,
              title: 'privacy_policy'.tr,
              subTitle: 'read_privacy_policy'.tr,
            ),

            CustomSettingContainer(
              onTap: (){
                Uri url = Uri.parse(
                    'https://vitalappstudio.blogspot.com/2024/04/terms%20of%20use.html');
                launchUrl(url);
              },
              iconData: Icons.list_alt_rounded,
              title: 'terms_title'.tr,
              subTitle: 'read_terms'.tr,
            ),

            CustomSettingContainer(
              onTap: (){
                final Uri emailLaunchUri = Uri(
                    scheme: 'mailto',
                    path: 'vitalappstudios@gmail.com',
                    queryParameters: <String, String>{
                      'subject': 'feedback_title'.tr,
                    });
                launchUrl(emailLaunchUri);
              },
              iconData: Icons.email,
              title: 'feedback'.tr,
              subTitle: 'share_your_honest_feedback_with_us'.tr,
            ),
          ],
        ),
      ),
    );
  }

  Widget mainDesktopLayout(BuildContext context) {
    return Scaffold(
        backgroundColor: mainPurpleColor,
        appBar: AppBar(
          backgroundColor: mainPurpleColor,
          automaticallyImplyLeading: false,
          title: const Text('SETTINGS',
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontFamily: 'Montserrat',
                color: sWhite,
                fontSize: 16
            ),
          ),
          actions:  [
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
           child: Center(
             child: Container(
               width: MediaQuery.of(context).size.width * 0.53,
               alignment: Alignment.center,
               child: Column(
                 children: [
                   const SizedBox(height: 15,),
                   Container(
                     width: double.infinity,

                     margin: const EdgeInsets.symmetric(horizontal: 20,vertical: 5),
                     decoration: BoxDecoration(
                         color: mainPurpleColor,
                         borderRadius: BorderRadius.circular(10)
                     ),

                     child: Column(
                       mainAxisAlignment: MainAxisAlignment.start,
                       crossAxisAlignment: CrossAxisAlignment.center,
                       children: [
                         const SizedBox(height: 10,),
                         const Text('INVOICE PRO',
                           style: TextStyle(
                               fontFamily: 'Montserrat',
                               fontWeight: FontWeight.bold,
                               fontSize: 25,
                               color: proIconColor
                           ),
                         ),
                         const Text('Full access to all features',
                           style: TextStyle(
                               fontFamily: 'Montserrat',
                               fontWeight: FontWeight.normal,
                               fontSize: 15,
                               color: proIconColor
                           ),
                         ),
                         const SizedBox(height: 15,),
                         Container(
                           margin: const EdgeInsets.symmetric(horizontal: 5),
                           child: const Row(
                             crossAxisAlignment: CrossAxisAlignment.start,
                             children: [
                               Expanded(child: Column(

                                 children: [
                                   Icon(Icons.account_balance_wallet,color: proIconColor,),
                                   Text('Professional Templates',
                                     textAlign: TextAlign.center,
                                     style: TextStyle(
                                         fontFamily: 'Montserrat',
                                         fontWeight: FontWeight.normal,
                                         fontSize: 11,
                                         color: proIconColor
                                     ),
                                   ),
                                 ],
                               )),
                               Expanded(child: Column(
                                 children: [
                                   Icon(Icons.accessibility,color: proIconColor,),
                                   Text('Unlimited Invoices and Estimates',
                                     textAlign: TextAlign.center,
                                     style: TextStyle(
                                         fontFamily: 'Montserrat',
                                         fontWeight: FontWeight.normal,
                                         fontSize: 11,
                                         color: proIconColor
                                     ),
                                   ),
                                 ],
                               )),
                               Expanded(child: Column(
                                 children: [
                                   Icon(Icons.cloud_upload_rounded,color: proIconColor,),
                                   Text('Unlimited Export',
                                     textAlign: TextAlign.center,
                                     style: TextStyle(
                                         fontFamily: 'Montserrat',
                                         fontWeight: FontWeight.normal,
                                         fontSize: 11,
                                         color: proIconColor
                                     ),
                                   ),
                                 ],
                               )),

                               Expanded(child: Column(
                                 children: [
                                   Icon(Icons.add_chart_sharp,color: proIconColor,),
                                   Text('Business Reports',
                                     textAlign: TextAlign.center,
                                     style: TextStyle(
                                         fontFamily: 'Montserrat',
                                         fontWeight: FontWeight.normal,
                                         fontSize: 11,
                                         color: proIconColor
                                     ),
                                   ),
                                 ],
                               )),

                             ],
                           ),
                         ),
                         const SizedBox(height: 15,),
                         GestureDetector(
                           onTap: (){
                             Get.toNamed(Routes.proScreenView);
                           },
                           child: Container(
                             width: double.infinity,
                             height: 40,
                             margin: const EdgeInsets.symmetric(horizontal: 15),
                             alignment: Alignment.center,
                             decoration: BoxDecoration(
                                 borderRadius: BorderRadius.circular(7),
                                 gradient: LinearGradient(
                                     colors: [
                                       proIconColor.withOpacity(0.4),
                                       proIconColor.withOpacity(0.6),
                                       proIconColor,
                                     ]
                                 )
                             ),
                             child: const Text('Join Now',
                               style: TextStyle(
                                   fontFamily: 'Montserrat',
                                   fontWeight: FontWeight.w600,
                                   fontSize: 15,
                                   color: blackColor
                               ),
                             ),
                           ),
                         ),
                         const SizedBox(height: 15,),
                       ],
                     ),

                   ),
                   const SizedBox(height: 15,),
                   Row(
                     crossAxisAlignment: CrossAxisAlignment.start,
                     children: [
                       Expanded(
                           child: CustomSettingContainer(
                             iconData: Icons.event_note_sharp,
                             title: 'Term & Condition',
                             onTap: (){
                               Get.toNamed(Routes.termsAndConditionView);
                             },
                             subTitle: 'Add new term and condition',
                           )),
                       Expanded(
                           child: CustomSettingContainer(
                             iconData: Icons.edit,
                             title: 'Signature',
                             onTap: (){
                               Get.toNamed(Routes.signatureView);
                             },
                             subTitle: 'Add new signature',
                           )),
                     ],
                   ),
                   const SizedBox(height: 10,),
                   Row(
                     crossAxisAlignment: CrossAxisAlignment.start,
                     children: [
                       Expanded(
                           child: CustomSettingContainer(
                             iconData: Icons.credit_card_outlined,
                             title: 'Payment Method',
                             onTap: (){
                               Get.toNamed(Routes.paymentView);
                             },
                             subTitle: 'Add new payment method',
                           )),
                       Expanded(
                           child: CustomSettingContainer(
                             iconData: Icons.add_business,
                             title: 'Business Info',
                             onTap: (){
                               Get.toNamed(Routes.businessListView);
                             },
                             subTitle: 'Add new businesses',
                           )),
                     ],
                   ),
                   const SizedBox(height: 10,),
                   Container(
                     margin: const EdgeInsets.only(left: 20),
                     alignment: Alignment.centerLeft,
                     child: const Text('Support',
                       style: TextStyle(
                           fontWeight: FontWeight.bold,
                           fontFamily: 'Montserrat',
                           color: blackColor,
                           fontSize: 16
                       ),
                     ),
                   ),
                   const SizedBox(height: 10,),
                   Row(
                     crossAxisAlignment: CrossAxisAlignment.start,
                     children: [
                       Expanded(
                           child: CustomSettingContainer(
                             iconData: Icons.verified,
                             title: 'Rate Us',
                             onTap: (){
                               Uri url = Uri.parse(
                                   'https://apps.apple.com/us/app/com.InvoiceMaker.ReceiptCreator.Billing.app/id6657994457');
                               launchUrl(url);
                             },
                             subTitle: 'Your best reward to us',
                           )),
                       Expanded(
                           child: CustomSettingContainer(
                             iconData: Icons.share,
                             title: 'Share',
                             onTap: () async {
                             await Share.share(
                             'Save time, Save money. Create professional invoices in seconds "Invoice Maker !Receipt Creator"');
                             },
                             subTitle: 'Share app with friends',
                           )),
                     ],
                   ),
                   const SizedBox(height: 10,),
                   Row(
                     crossAxisAlignment: CrossAxisAlignment.start,
                     children: [
                       Expanded(
                           child: CustomSettingContainer(
                             onTap: (){
                               Uri url = Uri.parse(
                                   'https://vitalappstudio.blogspot.com/2024/08/%20Invoice%20Maker%20Receipt%20Creator.html');
                               launchUrl(url);
                             },
                             iconData: Icons.privacy_tip_outlined,
                             title: 'Privacy policy',
                             subTitle: 'Read privacy policy',
                           )),
                       Expanded(
                           child: CustomSettingContainer(
                             iconData: Icons.email,
                             title: 'Feedback',
                             onTap: (){

                               Uri url = Uri.parse(
                                   'https://apps.apple.com/us/app/com.InvoiceMaker.ReceiptCreator.Billing.app/id6657994457');
                               launchUrl(url);

                               // final Uri emailLaunchUri = Uri(
                               //     scheme: 'mailto',
                               //     path: 'vitalappstudios@gmail.com',
                               //     queryParameters: <String, String>{
                               //       'subject': 'Feedback about Invoice Maker !Receipt Creator',
                               //     });
                               // launchUrl(emailLaunchUri);
                             },
                             subTitle: 'Share your honest feedback with us',
                           )),
                     ],
                   ),
                   const SizedBox(height: 10,),
                   Row(
                     children: [
                       Expanded(
                         child: CustomSettingContainer(
                           onTap: (){
                             Uri url = Uri.parse(
                                 'https://vitalappstudio.blogspot.com/2024/04/terms%20of%20use.html');
                             launchUrl(url);
                           },
                           iconData: Icons.list_alt_rounded,
                           title: 'Term of use',
                           subTitle: 'Read the Terms of Use carefully',
                         ),
                       ),
                       Expanded(child: Container())
                     ],
                   ),
                   const SizedBox(height: 100,),
                 ],
               ),
             ),
           ),
          ),
        )
    );
  }
}