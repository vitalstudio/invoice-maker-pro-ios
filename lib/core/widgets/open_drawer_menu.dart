import 'dart:io';

import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../core/constants/color/color.dart';
import '../routes/routes.dart';
import '../utils/utils.dart';
import 'package:get/get.dart';

class DrawerMenuOpen extends StatelessWidget {
  const DrawerMenuOpen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: sWhite,
      shape: const Border.symmetric(horizontal: BorderSide.none,vertical: BorderSide.none),
      child: Column(
        children: [
          Container(
            color: mainPurpleColor,
            height: 200,
            padding: const EdgeInsets.all(60),
            alignment: Alignment.center,
            child: Image.asset('assets/icons/name.png'),
          ),
          ListView(
            shrinkWrap: true,
            padding: EdgeInsets.zero,
            children: [
              const SizedBox(height: 15,),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 15),
                decoration: BoxDecoration(
                  color: mainPurpleColor,
                  borderRadius: BorderRadius.circular(5)
                ),
                child: ListTile(
                  onTap: (){
                    Get.toNamed(Routes.proScreenView);
                  },
                  leading: Image.asset('assets/icons/vip_icon.png',height: 35,width: 35,),
                  title:  Text('join_pro'.tr,
                  style: const TextStyle(
                    fontFamily: 'Montserrat',
                    fontWeight: FontWeight.w700,
                    color: sWhite
                  ),
                 ),

                  trailing: Container(
                    height: 15,
                    width: 15,
                    alignment: Alignment.center,
                    decoration: const BoxDecoration(
                      color: sWhite,
                      shape: BoxShape.circle
                    ),
                    child: const Icon(Icons.keyboard_arrow_right_outlined,color: mainPurpleColor,size: 15,),
                  ),

                ),
              ),
              ListTile(
                contentPadding: const EdgeInsets.symmetric(horizontal: 20,vertical: 0),
                onTap: (){
                  Get.toNamed(Routes.chartsView);
                },
                leading: const Icon(
                  Icons.add_chart,color: mainPurpleColor,size: 20,
                ),
                title: Text(
                  'reports'.tr,
                  style: const TextStyle(
                      fontFamily: 'Montserrat',
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: grey_1
                  ),
                ),
              ),
              ListTile(
                contentPadding: const EdgeInsets.symmetric(horizontal: 20,vertical: 0),
                onTap: (){
                  Utils.rateUs('enjoy_app'.tr);
                },
                leading: const Icon(
                  Icons.verified,color: mainPurpleColor,size: 20,
                ),
                title: Text(
                  'rate_us'.tr,
                  style: const TextStyle(
                      fontFamily: 'Montserrat',
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: grey_1
                  ),
                ),
              ),
              ListTile(
                contentPadding: const EdgeInsets.symmetric(horizontal: 20,vertical: 0),
                onTap: () async {
                  final box = context.findRenderObject() as RenderBox?;
                  if(Platform.isAndroid){
                    await Share.share(
                        'android_prompt'.tr);
                  }
                  if(Platform.isIOS){
                    try {
                      await Share.share(
                        sharePositionOrigin: box!.localToGlobal(Offset.zero) & box.size,
                          'ios_prompt'.tr);
                    }
                    catch (e) {
                      print("Error: $e");
                    }
                  }
                },
                leading: const Icon(
                  Icons.share,color: mainPurpleColor,size: 20,
                ),
                title:  Text(
                  'share'.tr,
                  style: const TextStyle(
                      fontFamily: 'Montserrat',
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: grey_1
                  ),
                ),
              ),
              ListTile(
                contentPadding: const EdgeInsets.symmetric(horizontal: 20,vertical: 0),
                onTap: (){
                  Uri url = Uri.parse(
                      'https://vitalappstudio.blogspot.com/2024/08/%20Invoice%20Maker%20Receipt%20Creator.html');
                  launchUrl(url);
                },
                leading: const Icon(
                  Icons.privacy_tip_outlined,color: mainPurpleColor,size: 20,
                ),
                title:  Text(
                  'privacy_policy'.tr,
                  style: const TextStyle(
                      fontFamily: 'Montserrat',
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: grey_1
                  ),
                ),
              ),
              ListTile(
                contentPadding: const EdgeInsets.symmetric(horizontal: 20,vertical: 0),
                onTap: (){
                  Uri url = Uri.parse(
                      'https://vitalappstudio.blogspot.com/2024/04/terms%20of%20use.html');
                  launchUrl(url);
                },
                leading: const Icon(
                  Icons.list_alt_rounded,color: mainPurpleColor,size: 20,
                ),
                title: Text(
                  'terms_title'.tr,
                  style: const TextStyle(
                      fontFamily: 'Montserrat',
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: grey_1
                  ),
                ),
              ),
              ListTile(
                contentPadding: const EdgeInsets.symmetric(horizontal: 20,vertical: 0),
                onTap: () async {

                  if(Platform.isIOS) {
                    Uri url = Uri.parse(
                        'https://apps.apple.com/us/app/com.InvoiceMaker.ReceiptCreator.Billing.app/id6657994457');
                    launchUrl(url);
                  }
                  else {
                    final Uri emailLaunchUri = Uri(
                      scheme: 'mailto',
                      path: 'vitalappstudios@gmail.com',
                      query: 'subject=${'feedback_title'.tr}',
                    );
                    var url = emailLaunchUri.toString();
                    if (await canLaunchUrl(emailLaunchUri)) {
                      await launchUrl(emailLaunchUri, mode: LaunchMode.externalNonBrowserApplication);
                    } else {
                      throw 'Could not launch $url';
                    }
                  }
                },
                leading: const Icon(
                  Icons.email,color: mainPurpleColor,size: 20,
                ),
                title: Text(
                  'feedback'.tr,
                  style: const TextStyle(
                      fontFamily: 'Montserrat',
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: grey_1
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
