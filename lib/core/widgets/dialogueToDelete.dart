import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../constants/color/color.dart';

class CustomDialogues{
  static showDialogueToDelete(
      bool isDoubleTimeBackTrue,
      String title,
      String content_1,
      String content_2,
     Function() deleteData,Function() loadData
      ) async {
    return Get.dialog(
      AlertDialog(
        backgroundColor: sWhite,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10)
        ),
        title: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: mainPurpleColor,
            borderRadius: BorderRadius.circular(5)
          ),
          child: Text(title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontFamily: 'Montserrat',
              color: sWhite,
              fontWeight: FontWeight.w700,
              fontSize: 16,
            ),
          ),
        ),
        content:  Text('$content_1 $content_2',
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontFamily: 'Montserrat',
            color: blackColor,
            fontWeight: FontWeight.normal,
            fontSize: 16,
          ),
        ),
        alignment: Alignment.center,
        actions: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: (){
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
                    child:  Text('cancel'.tr,
                      style: const TextStyle(
                        fontFamily: 'Montserrat',
                        color: sWhite,
                        fontWeight: FontWeight.w500,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: GestureDetector(
                  onTap: (){
                    deleteData();
                    Get.back();
                    loadData();
                    if(isDoubleTimeBackTrue){
                      Get.back();
                    }
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
                    child: Text('delete'.tr,
                      style: const TextStyle(
                        fontFamily: 'Montserrat',
                        color: sWhite,
                        fontWeight: FontWeight.w500,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),

        ],
      ),
    );
  }
}


