import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../core/constants/app_constants/App_Constants.dart';
import 'package:launch_app_store/launch_app_store.dart';
import '../../database/database_helper.dart';
import '../../model/data_model.dart';
import '../../core/constants/color/color.dart';
import '../app_singletons/app_singletons.dart';

class Utils {
  void snackBarMsg(String titleText, String subTitleText) {
    Get.snackbar(
      titleText,
      subTitleText,
      colorText: orangeLight_1,
      borderRadius: 8,
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      backgroundColor: mainPurpleColor,
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      snackPosition: SnackPosition.BOTTOM,
      isDismissible: true,
      dismissDirection: DismissDirection.startToEnd,
      forwardAnimationCurve: Curves.easeOutBack,
    );
  }

  static String showLimitedText(String text, int maxLength) {
    if (text.length > maxLength) {
      return '${text.substring(0, maxLength)}...';
    }
    return text;
  }

  Future<void> dataModelForEdit(int invoiceIdToEdit, DBHelper? dbHelper) async {
    try {

      debugPrint('Data ID: $invoiceIdToEdit');

      DataModel? dataModel = DataModel();
      dataModel = await dbHelper!.getSingleInvoiceById(invoiceIdToEdit);

      AppSingletons.invoiceTitle?.value = dataModel!.titleName.toString();
      AppSingletons.creationDate.value = DateTime.parse(dataModel!.creationDate.toString());
      AppSingletons.dueDate.value = DateTime.parse(dataModel.dueDate.toString());
      AppSingletons.invoiceTemplateIdINV.value = dataModel.selectedTemplateId.toString();
      AppSingletons.invoiceNumberId?.value = dataModel.uniqueNumber.toString();
      AppSingletons.languageName?.value = dataModel.languageName.toString();
      AppSingletons.discountAmount.value = dataModel.discountInTotal.toString();
      AppSingletons.taxAmount.value = dataModel.taxInTotal.toString();
      AppSingletons.currencyNameINV?.value = dataModel.currencyName.toString();
      AppSingletons.finalPriceTotal?.value = int.parse(dataModel.finalNetTotal.toString());
      AppSingletons.subTotal?.value = int.parse(dataModel.subTotal.toString());
      AppSingletons.businessLogoImg.value = dataModel.businessLogoImg ?? Uint8List(0);
      AppSingletons.shippingCost.value = dataModel.shippingCost.toString();
      AppSingletons().itemsNameList.assignAll(dataModel.itemNames ?? []);
      AppSingletons().itemsDiscountList.assignAll(dataModel.itemsDiscountList ?? []);
      AppSingletons().itemsAmountList.assignAll(dataModel.itemsAmountList ?? []);
      AppSingletons().itemsPriceList.assignAll(dataModel.itemsPriceList ?? []);
      AppSingletons().itemsTaxesList.assignAll(dataModel.itemsTaxesList ?? []);
      AppSingletons().itemsQuantityList.assignAll(dataModel.itemsQuantityList ?? []);
      AppSingletons().itemUnitList.assignAll(dataModel.itemsUnitList ?? []);
      AppSingletons().itemDescriptionList.assignAll(dataModel.itemsDescriptionList ?? []);
      AppSingletons().unlockedTempIdsList.assignAll(dataModel.unlockTempIdsList ?? ['0','1']);
      AppSingletons.clientNameINV?.value = dataModel.clientName.toString();
      AppSingletons.clientEmailINV?.value = dataModel.clientEmail.toString();
      AppSingletons.clientPhoneNumberINV?.value = dataModel.clientPhoneNumber.toString();
      AppSingletons.clientBillingAddressINV?.value = dataModel.clientBillingAddress.toString();
      AppSingletons.clientShippingAddressINV?.value = dataModel.clientShippingAddress.toString();
      AppSingletons.clientDetailINV?.value = dataModel.clientDetail.toString();
      AppSingletons.businessNameINV?.value = dataModel.businessName.toString();
      AppSingletons.businessEmailINV?.value = dataModel.businessEmail.toString();
      AppSingletons.businessPhoneNumberINV?.value = dataModel.businessPhoneNumber.toString();
      AppSingletons.businessBillingAddressINV?.value = dataModel.businessBillingAddress.toString();
      AppSingletons.businessWebsiteINV?.value = dataModel.businessWebsite.toString();
      AppSingletons.signatureImgINV?.value = dataModel.signatureImg ?? Uint8List(0);
      AppSingletons.termAndConditionINV?.value = dataModel.termAndCondition.toString();
      AppSingletons.paymentMethodINV?.value = dataModel.paymentMethod.toString();
      AppSingletons.discountPercentage?.value = dataModel.discountPercentage.toString();
      AppSingletons.taxPercentage?.value = dataModel.taxPercentage.toString();
      AppSingletons.shippingCost.value = dataModel.shippingCost.toString();

      AppSingletons.partialPaymentAmount?.value = dataModel.partiallyPaidAmount ?? '';

      // if(AppSingletons.isEditingOnlyTemplate.value == true){
      //   AppSingletons.partialPaymentAmount?.value = dataModel.partiallyPaidAmount ?? '';
      // }

      AppSingletons.invoiceStatus.value = dataModel.documentStatus ?? AppConstants.unpaidInvoice;
      debugPrint('Template id stored: ${dataModel.selectedTemplateId}');
    } catch (e) {
      debugPrint('Error $e');
    }
  }

  Future<void> getEstimatesData(int estimateId, DBHelper? dbHelper) async {
    try{
      DataModel? getEstimateData = DataModel();
      getEstimateData = await dbHelper!.getSingleEstimateById(estimateId);

      AppSingletons.estTitle?.value = getEstimateData!.titleName.toString();
      AppSingletons.estCreationDate.value = DateTime.parse(getEstimateData!.creationDate.toString());
      AppSingletons.estDueDate.value = DateTime.parse(getEstimateData.dueDate.toString());
      AppSingletons.estTemplateIdINV.value = getEstimateData.selectedTemplateId.toString();
      AppSingletons.estPoNumber?.value = getEstimateData.purchaseOrderNo.toString();
      AppSingletons.estNumberId?.value = getEstimateData.uniqueNumber.toString();
      AppSingletons.estLanguageName?.value = getEstimateData.languageName.toString();
      AppSingletons.estDiscountAmount.value = getEstimateData.discountInTotal.toString();
      AppSingletons.estTaxAmount.value = getEstimateData.taxInTotal.toString();
      AppSingletons.estCurrencyNameINV?.value = getEstimateData.currencyName.toString();
      AppSingletons.estFinalPriceTotal?.value = int.parse(getEstimateData.finalNetTotal.toString());
      AppSingletons.estSubTotal?.value = int.parse(getEstimateData.subTotal.toString());
      AppSingletons.estBusinessLogoImg.value = getEstimateData.businessLogoImg ?? Uint8List(0);
      AppSingletons.estShippingCost.value = getEstimateData.shippingCost.toString();
      AppSingletons().itemsNameList.assignAll(getEstimateData.itemNames ?? []);
      AppSingletons().itemsDiscountList.assignAll(getEstimateData.itemsDiscountList ?? []);
      AppSingletons().itemsAmountList.assignAll(getEstimateData.itemsAmountList ?? []);
      AppSingletons().itemsPriceList.assignAll(getEstimateData.itemsPriceList ?? []);
      AppSingletons().itemsTaxesList.assignAll(getEstimateData.itemsTaxesList ?? []);
      AppSingletons().itemsQuantityList.assignAll(getEstimateData.itemsQuantityList ?? []);
      AppSingletons().itemUnitList.assignAll(getEstimateData.itemsUnitList ?? []);
      AppSingletons().itemDescriptionList.assignAll(getEstimateData.itemsDescriptionList ?? []);
      AppSingletons().unlockedTempIdsList.assignAll(getEstimateData.unlockTempIdsList ?? ['0','1']);
      AppSingletons.estClientNameINV?.value = getEstimateData.clientName.toString();
      AppSingletons.estClientEmailINV?.value = getEstimateData.clientEmail.toString();
      AppSingletons.estClientPhoneNumberINV?.value = getEstimateData.clientPhoneNumber.toString();
      AppSingletons.estClientBillingAddressINV?.value = getEstimateData.clientBillingAddress.toString();
      AppSingletons.estClientShippingAddressINV?.value = getEstimateData.clientShippingAddress.toString();
      AppSingletons.estClientDetailINV?.value = getEstimateData.clientDetail.toString();
      AppSingletons.estBusinessNameINV?.value = getEstimateData.businessName.toString();
      AppSingletons.estBusinessEmailINV?.value = getEstimateData.businessEmail.toString();
      AppSingletons.estBusinessPhoneNumberINV?.value = getEstimateData.businessPhoneNumber.toString();
      AppSingletons.estBusinessBillingAddressINV?.value = getEstimateData.businessBillingAddress.toString();
      AppSingletons.estBusinessWebsiteINV?.value = getEstimateData.businessWebsite.toString();
      AppSingletons.estSignatureImgINV?.value = getEstimateData.signatureImg ?? Uint8List(0);
      AppSingletons.estTermAndConditionINV?.value = getEstimateData.termAndCondition.toString();
      AppSingletons.estPaymentMethodINV?.value = getEstimateData.paymentMethod.toString();
      AppSingletons.estDiscountPercentage?.value = getEstimateData.discountPercentage.toString();
      AppSingletons.estTaxPercentage?.value = getEstimateData.taxPercentage.toString();
      AppSingletons.estShippingCost.value = getEstimateData.shippingCost.toString();
      AppSingletons.estimateStatus.value = getEstimateData.documentStatus.toString();

    } catch (e){
      debugPrint('Error: $e');
      Get.back();
    }
  }

  static Future<dynamic> rateUs(String title) async {
    return Get.defaultDialog(
      title: title,
      titleStyle: const TextStyle(
          fontFamily: 'Montserrat',
          color: blackColor, fontWeight: FontWeight.w700, fontSize: 16),
      content: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            const Text(
              'If you like our app, please rate us 5 start',
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontFamily: 'Montserrat',
                  color: blackColor, fontWeight: FontWeight.w500, fontSize: 14),
            ),
            const SizedBox(
              height: 20,
            ),
            RatingBar(
                ratingWidget: RatingWidget(
                  empty: const Icon(Icons.star_border_outlined,
                      color: mainPurpleColor),
                  full: const Icon(Icons.star, color: mainPurpleColor),
                  half: const Icon(Icons.star_half, color: mainPurpleColor),
                ),
                onRatingUpdate: (value) {
                  debugPrint('Rate: $value');
                }),
            const SizedBox(
              height: 20,
            ),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  if(Platform.isIOS) {
                    Uri url = Uri.parse(
                        'https://apps.apple.com/us/app/com.InvoiceMaker.ReceiptCreator.Billing.app/id6657994457');
                    launchUrl(url);
                  }
                  else {
                    LaunchReview.launch(
                        androidAppId: 'com.InvoiceMaker.ReceiptCreator.Billing.app',
                        iOSAppId: '6657994457'
                    );
                  }
                  Get.back();
                },
                style: ElevatedButton.styleFrom(
                    backgroundColor: mainPurpleColor,
                    shape: ContinuousRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    )),
                child: const Text(
                  'RATE',
                  style: TextStyle(
                    fontFamily: 'Montserrat',
                    color: sWhite,
                    fontWeight: FontWeight.w600,
                    fontSize: 15,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
      titlePadding:
          const EdgeInsets.only(top: 30, bottom: 10, left: 20, right: 20),
    );
  }

  static bool isOverdue(String dueDateString) {
    try {
      DateTime dueDate = DateTime.parse(dueDateString);
      DateTime now = DateTime.now();
      return dueDate.isBefore(DateTime(now.year, now.month, now.day));
    } catch (e) {
      debugPrint("Error parsing date: $e");
      return false;
    }
  }

  static Future<void> clearInvoiceVariables() async {
    debugPrint('INVOICES VARIABLES CLEARED');
    AppSingletons.creationDate.value = DateTime.now();
    AppSingletons.dueDate.value = DateTime.now().add(const Duration(days: 7));
    AppSingletons.clientNameINV?.value = '';
    AppSingletons.clientEmailINV?.value = '';
    AppSingletons.clientPhoneNumberINV?.value = '';
    AppSingletons.clientBillingAddressINV?.value = '';
    AppSingletons.clientShippingAddressINV?.value = '';
    AppSingletons.clientDetailINV?.value = '';
    AppSingletons.businessNameINV?.value = '';
    AppSingletons.businessEmailINV?.value = '';
    AppSingletons.businessPhoneNumberINV?.value = '';
    AppSingletons.businessBillingAddressINV?.value = '';
    AppSingletons.businessWebsiteINV?.value = '';
    AppSingletons.paymentMethodINV?.value = '';
    AppSingletons.signatureImgINV?.value = Uint8List(0);
    AppSingletons.businessLogoImg.value = Uint8List(0);
    AppSingletons.termAndConditionINV?.value = '';
    AppSingletons.currencyNameINV?.value = '';
    AppSingletons.subTotal?.value = 0;
    AppSingletons.finalPriceTotal?.value = 0;
    AppSingletons.invoiceTemplateIdINV.value = '';
    AppSingletons.invoiceNumberId?.value = '';
    AppSingletons.invoiceTitle?.value = '';
    AppSingletons.languageName?.value = '';
    AppSingletons.discountAmount.value = '0';
    AppSingletons.discountPercentage?.value = '';
    AppSingletons.taxPercentage?.value = '';
    AppSingletons.taxAmount.value = '0';
    AppSingletons.shippingCost.value = '0';
    AppSingletons().itemsNameList.clear();
    AppSingletons().itemsQuantityList.clear();
    AppSingletons().itemsTaxesList.clear();
    AppSingletons().itemsPriceList.clear();
    AppSingletons().itemsDiscountList.clear();
    AppSingletons().itemsAmountList.clear();
    AppSingletons().itemUnitList.clear();
    AppSingletons().itemDescriptionList.clear();
    AppSingletons().unlockedTempIdsList.clear();
  }

  static Future<void> clearEstimateVariables() async {
    debugPrint('ESTIMATES VARIABLES CLEARED');
    AppSingletons.estCreationDate.value = DateTime.now();
    AppSingletons.estDueDate.value = DateTime.now().add(const Duration(days: 7));
    AppSingletons.estClientNameINV?.value = '';
    AppSingletons.estClientEmailINV?.value = '';
    AppSingletons.estClientPhoneNumberINV?.value = '';
    AppSingletons.estClientBillingAddressINV?.value = '';
    AppSingletons.estClientShippingAddressINV?.value = '';
    AppSingletons.estClientDetailINV?.value = '';
    AppSingletons.estBusinessNameINV?.value = '';
    AppSingletons.estBusinessEmailINV?.value = '';
    AppSingletons.estBusinessPhoneNumberINV?.value = '';
    AppSingletons.estBusinessBillingAddressINV?.value = '';
    AppSingletons.estBusinessWebsiteINV?.value = '';
    AppSingletons.estPaymentMethodINV?.value = '';
    AppSingletons.estSignatureImgINV?.value = Uint8List(0);
    AppSingletons.estBusinessLogoImg.value = Uint8List(0);
    AppSingletons.estTermAndConditionINV?.value = '';
    AppSingletons.estCurrencyNameINV?.value = '';
    AppSingletons.estSubTotal?.value = 0;
    AppSingletons.estFinalPriceTotal?.value = 0;
    AppSingletons.estTemplateIdINV.value = '';
    AppSingletons.estNumberId?.value = '';
    AppSingletons.estTitle?.value = '';
    AppSingletons.estLanguageName?.value = '';
    AppSingletons.estDiscountAmount.value = '0';
    AppSingletons.estDiscountPercentage?.value = '';
    AppSingletons.estTaxPercentage?.value = '';
    AppSingletons.estTaxAmount.value = '0';
    AppSingletons.estShippingCost.value = '0';
    AppSingletons().itemsNameList.clear();
    AppSingletons().itemsQuantityList.clear();
    AppSingletons().itemsTaxesList.clear();
    AppSingletons().itemsPriceList.clear();
    AppSingletons().itemsDiscountList.clear();
    AppSingletons().itemsAmountList.clear();
    AppSingletons().itemUnitList.clear();
    AppSingletons().itemDescriptionList.clear();
    AppSingletons().unlockedTempIdsList.clear();
  }

}

class PercentageInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    final text = newValue.text;

    // Check if input is empty
    if (text.isEmpty) {
      return newValue;
    }

    // Check if input is a valid number
    final double? value = double.tryParse(text);
    if (value == null) {
      return oldValue;
    }

    // Check if input is in range 0-100
    if (value < 0 || value > 100) {
      return oldValue;
    }

    // Check for decimal precision
    final parts = text.split('.');
    if (parts.length == 2 && parts[1].length > 3) {
      return oldValue;
    }

    return newValue;
  }
}

class AmountInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    if (newValue.text.isEmpty) {
      return newValue;
    }

    try {
      final double value = double.parse(newValue.text);
      if (value < 0) {
        return oldValue;
      }
    } catch (e) {
      return oldValue;
    }

    return newValue;
  }
}
