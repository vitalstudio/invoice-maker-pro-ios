import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/constants/app_constants/App_Constants.dart';
import '../../core/constants/color/color.dart';
import '../app_singletons/app_singletons.dart';

class LanguageSelection {
  static Future selectALanguage({required BuildContext context,
    required String titleHeading,
    required Function() onChange,
  }) async {
    // RxInt selectedIndexNumber = 1.obs;

    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            backgroundColor: sWhite,
            child: Stack(
              children: [
                SingleChildScrollView(
                  child: Obx(() {
                    return Column(
                      children: [
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(
                              vertical: 15,
                              horizontal: 5
                          ),
                          decoration: const BoxDecoration(
                            color: mainPurpleColor,
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(10),
                                topRight: Radius.circular(10)
                            ),
                          ),
                          alignment: Alignment.center,
                          child: Text(titleHeading,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                                fontFamily: 'Montserrat',
                                fontWeight: FontWeight.w700,
                                fontSize: 16,
                                color: sWhite
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        GestureDetector(
                          onTap: () {
                            // selectedIndexNumber.value = 1;
                            AppSingletons.selectedNewLanguage.value = AppConstants.english;
                          },
                          child: Container(
                            decoration: AppSingletons.selectedNewLanguage.value
                                == AppConstants.english
                                ? BoxDecoration(
                              color: mainPurpleColor.withValues(alpha: 0.15),
                            )
                                : const BoxDecoration(),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 13,
                                  horizontal: 15
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(AppConstants.english,
                                    style: const TextStyle(
                                        fontFamily: 'Montserrat',
                                        fontWeight: FontWeight.w600,
                                        fontSize: 16,
                                        color: blackColor
                                    ),
                                  ),
                                  Visibility(
                                      visible: AppSingletons.selectedNewLanguage.value
                                          == AppConstants.english,
                                      child: const Icon(
                                          Icons.check, color: mainPurpleColor)),
                                ],
                              ),
                            ),
                          ),
                        ),
                        const Divider(
                          color: greyColor,
                          height: 2,
                        ),
                        GestureDetector(
                          onTap: () {
                            // selectedIndexNumber.value = 2;
                            AppSingletons.selectedNewLanguage.value = AppConstants.german;
                          },
                          child: Container(
                            decoration: AppSingletons.selectedNewLanguage.value
                                == AppConstants.german
                                ? BoxDecoration(
                              color: mainPurpleColor.withValues(alpha: 0.15),
                            )
                                : const BoxDecoration(),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 13,
                                  horizontal: 15
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                   Text(AppConstants.german,
                                    style: const TextStyle(
                                        fontFamily: 'Montserrat',
                                        fontWeight: FontWeight.w600,
                                        fontSize: 16,
                                        color: blackColor
                                    ),
                                  ),
                                  Visibility(
                                      visible: AppSingletons.selectedNewLanguage.value
                                          == AppConstants.german,
                                      child: const Icon(
                                          Icons.check, color: mainPurpleColor)),
                                ],
                              ),
                            ),
                          ),
                        ),
                        const Divider(
                          color: greyColor,
                          height: 2,
                        ),
                        GestureDetector(
                          onTap: () {
                            // selectedIndexNumber.value = 3;
                            AppSingletons.selectedNewLanguage.value = AppConstants.indonesian;
                          },
                          child: Container(
                            decoration: AppSingletons.selectedNewLanguage.value
                                == AppConstants.indonesian
                                ? BoxDecoration(
                              color: mainPurpleColor.withValues(alpha: 0.15),
                            )
                                : const BoxDecoration(),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 13,
                                  horizontal: 15
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(AppConstants.indonesian,
                                    style: const TextStyle(
                                        fontFamily: 'Montserrat',
                                        fontWeight: FontWeight.w600,
                                        fontSize: 16,
                                        color: blackColor
                                    ),
                                  ),
                                  Visibility(
                                      visible:AppSingletons.selectedNewLanguage.value
                                          == AppConstants.indonesian,
                                      child: const Icon(
                                          Icons.check, color: mainPurpleColor)),
                                ],
                              ),
                            ),
                          ),
                        ),
                        const Divider(
                          color: greyColor,
                          height: 2,
                        ),
                        GestureDetector(
                          onTap: () {
                            // selectedIndexNumber.value = 4;
                            AppSingletons.selectedNewLanguage.value = AppConstants.french;
                          },
                          child: Container(
                            decoration: AppSingletons.selectedNewLanguage.value
                                == AppConstants.french
                                ? BoxDecoration(
                              color: mainPurpleColor.withValues(alpha: 0.15),
                            )
                                : const BoxDecoration(),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 13,
                                  horizontal: 15
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(AppConstants.french,
                                    style: const TextStyle(
                                        fontFamily: 'Montserrat',
                                        fontWeight: FontWeight.w600,
                                        fontSize: 16,
                                        color: blackColor
                                    ),
                                  ),
                                  Visibility(
                                      visible: AppSingletons.selectedNewLanguage.value
                                          == AppConstants.french,
                                      child: const Icon(
                                          Icons.check, color: mainPurpleColor)),
                                ],
                              ),
                            ),
                          ),
                        ),
                        const Divider(
                          color: greyColor,
                          height: 2,
                        ),
                        GestureDetector(
                          onTap: () {
                            // selectedIndexNumber.value = 5;
                            AppSingletons.selectedNewLanguage.value = AppConstants.spanish;
                          },
                          child: Container(
                            decoration: AppSingletons.selectedNewLanguage.value
                                == AppConstants.spanish
                                ? BoxDecoration(
                              color: mainPurpleColor.withValues(alpha: 0.15),
                            )
                                : const BoxDecoration(),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 13,
                                  horizontal: 15
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(AppConstants.spanish,
                                    style: const TextStyle(
                                        fontFamily: 'Montserrat',
                                        fontWeight: FontWeight.w600,
                                        fontSize: 16,
                                        color: blackColor
                                    ),
                                  ),
                                  Visibility(
                                      visible: AppSingletons.selectedNewLanguage.value
                                          == AppConstants.spanish,
                                      child: const Icon(
                                          Icons.check, color: mainPurpleColor)),
                                ],
                              ),
                            ),
                          ),
                        ),
                        const Divider(
                          color: greyColor,
                          height: 2,
                        ),
                        GestureDetector(
                          onTap: () {
                            // selectedIndexNumber.value = 6;
                            AppSingletons.selectedNewLanguage.value = AppConstants.arabic;
                          },
                          child: Container(
                            decoration: AppSingletons.selectedNewLanguage.value
                                == AppConstants.arabic
                                ? BoxDecoration(
                              color: mainPurpleColor.withValues(alpha: 0.15),
                            )
                                : const BoxDecoration(),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 13,
                                  horizontal: 15
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(AppConstants.arabic,
                                    style: const TextStyle(
                                        fontFamily: 'Montserrat',
                                        fontWeight: FontWeight.w600,
                                        fontSize: 16,
                                        color: blackColor
                                    ),
                                  ),
                                  Visibility(
                                      visible:AppSingletons.selectedNewLanguage.value
                                          == AppConstants.arabic,
                                      child: const Icon(
                                          Icons.check, color: mainPurpleColor)),
                                ],
                              ),
                            ),
                          ),
                        ),
                        const Divider(
                          color: greyColor,
                          height: 2,
                        ),
                        GestureDetector(
                          onTap: () {
                            // selectedIndexNumber.value = 7;
                            AppSingletons.selectedNewLanguage.value = AppConstants.chinese;
                          },
                          child: Container(
                            decoration: AppSingletons.selectedNewLanguage.value
                                == AppConstants.chinese
                                ? BoxDecoration(
                              color: mainPurpleColor.withValues(alpha: 0.15),
                            )
                                : const BoxDecoration(),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 13,
                                  horizontal: 15
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(AppConstants.chinese,
                                    style: const TextStyle(
                                        fontFamily: 'Montserrat',
                                        fontWeight: FontWeight.w600,
                                        fontSize: 16,
                                        color: blackColor
                                    ),
                                  ),
                                  Visibility(
                                      visible: AppSingletons.selectedNewLanguage.value
                                          == AppConstants.chinese,
                                      child: const Icon(
                                          Icons.check, color: mainPurpleColor)),
                                ],
                              ),
                            ),
                          ),
                        ),
                        const Divider(
                          color: greyColor,
                          height: 2,
                        ),
                        GestureDetector(
                          onTap: () {
                            // selectedIndexNumber.value = 8;
                            AppSingletons.selectedNewLanguage.value = AppConstants.russian;
                          },
                          child: Container(
                            decoration: AppSingletons.selectedNewLanguage.value
                                == AppConstants.russian
                                ? BoxDecoration(
                              color: mainPurpleColor.withValues(alpha: 0.15),
                            )
                                : const BoxDecoration(),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 13,
                                  horizontal: 15
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(AppConstants.russian,
                                    style: const TextStyle(
                                        fontFamily: 'Montserrat',
                                        fontWeight: FontWeight.w600,
                                        fontSize: 16,
                                        color: blackColor
                                    ),
                                  ),
                                  Visibility(
                                      visible: AppSingletons.selectedNewLanguage.value
                                          == AppConstants.russian,
                                      child: const Icon(
                                          Icons.check, color: mainPurpleColor)),
                                ],
                              ),
                            ),
                          ),
                        ),
                        const Divider(
                          color: greyColor,
                          height: 2,
                        ),
                        GestureDetector(
                          onTap: () {
                            // selectedIndexNumber.value = 9;
                            AppSingletons.selectedNewLanguage.value = AppConstants.portuguese;
                          },
                          child: Container(
                            decoration: AppSingletons.selectedNewLanguage.value
                                == AppConstants.portuguese
                                ? BoxDecoration(
                              color: mainPurpleColor.withValues(alpha: 0.15),
                            )
                                : const BoxDecoration(),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 13,
                                  horizontal: 15
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(AppConstants.portuguese,
                                    style: const TextStyle(
                                        fontFamily: 'Montserrat',
                                        fontWeight: FontWeight.w600,
                                        fontSize: 16,
                                        color: blackColor
                                    ),
                                  ),
                                  Visibility(
                                      visible:AppSingletons.selectedNewLanguage.value
                                          == AppConstants.portuguese,
                                      child: const Icon(
                                          Icons.check, color: mainPurpleColor)),
                                ],
                              ),
                            ),
                          ),
                        ),
                        const Divider(
                          color: greyColor,
                          height: 2,
                        ),
                        GestureDetector(
                          onTap: () {
                            // selectedIndexNumber.value = 10;
                            AppSingletons.selectedNewLanguage.value = AppConstants.japanese;
                          },
                          child: Container(
                            decoration: AppSingletons.selectedNewLanguage.value
                                == AppConstants.japanese
                                ? BoxDecoration(
                              color: mainPurpleColor.withValues(alpha: 0.15),
                            )
                                : const BoxDecoration(),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 13,
                                  horizontal: 15
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(AppConstants.japanese,
                                    style: const TextStyle(
                                        fontFamily: 'Montserrat',
                                        fontWeight: FontWeight.w600,
                                        fontSize: 16,
                                        color: blackColor
                                    ),
                                  ),
                                  Visibility(
                                      visible: AppSingletons.selectedNewLanguage.value
                                          == AppConstants.japanese,
                                      child: const Icon(
                                          Icons.check, color: mainPurpleColor)),
                                ],
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 50,),
                      ],
                    );
                  }),
                ),
                Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Row(
                      children: [
                        Expanded(
                            child: GestureDetector(
                              onTap: (){
                                Get.back();
                              },
                              child: Container(
                                alignment: Alignment.center,
                                decoration: const BoxDecoration(
                                  borderRadius: BorderRadius.only(
                                    bottomLeft: Radius.circular(10),
                                  ),
                                  color: greyColor,
                                ),
                                padding: const EdgeInsets.symmetric(vertical: 10),
                                child: Text('cancel'.tr,
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                      fontFamily: 'Montserrat',
                                      fontWeight: FontWeight.w700,
                                      fontSize: 16,
                                      color: sWhite
                                  ),
                                ),
                              ),
                            )
                        ),
                        Expanded(
                            child: GestureDetector(
                              onTap: onChange,
                              child: Container(
                                alignment: Alignment.center,
                                decoration: const BoxDecoration(
                                    borderRadius: BorderRadius.only(
                                      bottomRight: Radius.circular(10),
                                    ),
                                    color: mainPurpleColor
                                ),
                                padding: const EdgeInsets.symmetric(vertical: 10),
                                child: Text('change'.tr,
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                      fontFamily: 'Montserrat',
                                      fontWeight: FontWeight.w700,
                                      fontSize: 16,
                                      color: sWhite
                                  ),
                                ),
                              ),
                            )
                        ),
                      ],
                    ),),
              ],
            ),
          );
        }
    );
  }

  static Future<void> updateLocale(
  {required String selectedLanguage}
      ) async{

    try{
      if(selectedLanguage == AppConstants.english){
        Get.updateLocale(const Locale('en', 'US'));
      }
      else if(selectedLanguage == AppConstants.german){
        Get.updateLocale(const Locale('de', 'DE'));
      }
      else if(selectedLanguage == AppConstants.indonesian){
        Get.updateLocale(const Locale('id', 'ID'));
        debugPrint('Locale: ${const Locale('id', 'ID')}');
      }
      else if(selectedLanguage == AppConstants.french){
        Get.updateLocale(const Locale('fr', 'FR'));
      }
      else if(selectedLanguage == AppConstants.spanish){
        Get.updateLocale(const Locale('es', 'ES'));
      }
      else if(selectedLanguage == AppConstants.arabic){
        Get.updateLocale(const Locale('ar', 'SA'));
      }
      else if(selectedLanguage == AppConstants.chinese){
        Get.updateLocale(const Locale('zh', 'CN'));
      }
      else if(selectedLanguage == AppConstants.russian){
        Get.updateLocale(const Locale('ru', 'RU'));
      }
      else if(selectedLanguage == AppConstants.portuguese){
        Get.updateLocale(const Locale('pt', 'BR'));
      }
      else if(selectedLanguage == AppConstants.japanese){
        Get.updateLocale(const Locale('ja', 'JP'));
      }
      else{
        Get.updateLocale(const Locale('en', 'US'));
      }

      debugPrint('UpdatedLocale As: $selectedLanguage');

    } catch(e){
      debugPrint('Error in updateLocale: $e');
    }
  }

}