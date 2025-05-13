

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/utils/warning_screen_dialogue.dart';

class CallWarningDialogueBox{

  static Future<void> openDialogueBox(
  {required BuildContext context,
   required bool isInvoiceWarningBox
  }
      ) async{

    final controller = Get.put<WarningScreenDialogue>(WarningScreenDialogue());

    await controller.showWarningDialogue(
        context: context,
        isInvoiceWarningBox: isInvoiceWarningBox
    );

  }

}