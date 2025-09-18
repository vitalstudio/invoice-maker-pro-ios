import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:invoice/core/services/ads_controller.dart';
import '../../core/services/ads_helper.dart';
import '../../modules/saved_pdf/saved_pdf_controller.dart';
import '../../database/database_helper.dart';
import '../../core/utils/utils.dart';
import '../../core/app_singletons/app_singletons.dart';
import '../../model/data_model.dart';

class TemplatesController extends GetxController with AdsControllerMixin {
  RxBool isLoading = false.obs;

  static DataModel? invoiceDataModel;

  DBHelper? tempDBHelper;

  RxInt selectedTempIndexId = 0.obs;

  final unlockedTemplates = <int>[0, 1].obs;

  List<String> tempDesignList = [
    'assets/images/temp_00.png',
    'assets/images/temp_01.png',
    'assets/images/temp_02.png',
    'assets/images/temp_03.png',
    'assets/images/temp_04.png',
    'assets/images/temp_05.jpg',
    'assets/images/temp_06.jpg',
    'assets/images/temp_07.jpg',
    'assets/images/temp_08.jpg',
    'assets/images/temp_09.jpg',
    'assets/images/temp_10.jpg',
    'assets/images/temp_11.jpg',
    'assets/images/temp_12.jpg',
    'assets/images/temp_13.jpg',
    'assets/images/temp_14.jpg',
  ];

  PageController pageController = PageController();

  RxBool isLoadingTemps = true.obs;

  Rx<bool> isBannerAdReady = false.obs;
  late BannerAd bannerAd;

  @override
  void onInit() async {


    // if(Platform.isAndroid || Platform.isIOS){
    //   updateUnlockedTemplatesFromDatabase();
    // }

    if(!AppSingletons.isSubscriptionEnabled.value){
      if(Platform.isAndroid && AppSingletons.androidBannerAdsEnabled.value){
        _loadBannerAd();
      }

      if(Platform.isIOS && AppSingletons.iOSBannerAdsEnabled.value){
        _loadBannerAd();
      }
    }

    tempDBHelper = DBHelper();

    debugPrint('isEditingOnlyTemp: ${AppSingletons.isEditingOnlyTemplate.value}');

    pageController = PageController(
      initialPage: selectedTempIndexId.value,
      viewportFraction: 0.5
    );

    isLoadingTemps.value = true;

    if(AppSingletons.isEditingOnlyTemplate.value){
      Timer(const Duration(seconds: 3), () {
        isLoadingTemps.value = false;
        getDataToEditTemplate();
      });
    } else {
      Timer(const Duration(seconds: 1), () {
        isLoadingTemps.value = false;
      });
    }

    Timer(const Duration(seconds: 3), () {
      isLoadingTemps.value = false;
      if(AppSingletons.isEditingOnlyTemplate.value){
        getDataToEditTemplate();
      }
    });

    if(!AppSingletons.isEditingOnlyTemplate.value){
      if (AppSingletons.isInvoiceDocument.value) {
        selectedTempIndexId.value = int.tryParse(AppSingletons.invoiceTemplateIdINV.value) ?? 0;
        debugPrint('current tempId for INV: ${AppSingletons.invoiceTemplateIdINV.value}');
      } else {
        selectedTempIndexId.value = int.tryParse(AppSingletons.estTemplateIdINV.value) ?? 0;
        debugPrint('current tempId for EST: ${AppSingletons.estTemplateIdINV.value}');
      }
    }

    super.onInit();
  }

  void _loadBannerAd() {
    bannerAd = BannerAd(
      adUnitId: AdHelper.bannerAdUnitId,
      request: AdRequest(),
      size: AdSize.banner,
      listener: BannerAdListener(
        onAdLoaded: (_) {
          isBannerAdReady.value = true;
        },
        onAdFailedToLoad: (ad, err) {
          isBannerAdReady.value = false;
          ad.dispose();
        },
      ),
    );

    bannerAd.load();
  }

  // void updateUnlockedTemplatesFromDatabase() {
  //   // Convert List<String> to List<int>
  //   List<int> unlockedIds = AppSingletons().unlockedTempIdsList.map((id) => int.parse(id)).toList();
  //   unlockedTemplates.addAll(unlockedIds);
  // }

  // bool isUnlocked(int templateId) {
  //   return unlockedTemplates.contains(templateId);
  // }

  double mmToPixels(double mm, double dpi) {
    return mm * (dpi / 25.4);
  }

  String getSelectedPdfTemplate(int selectedId) {
     switch(selectedId){
      case 0:
         return 'assets/images/temp_00.png';
      case 1:
         return 'assets/images/temp_01.png';
      case 2:
         return 'assets/images/temp_02.png';
       case 3:
         return 'assets/images/temp_03.png';
       case 4:
         return 'assets/images/temp_04.png';
       case 5:
         return 'assets/images/temp_05.jpg';
       case 6:
         return 'assets/images/temp_06.jpg';
       case 7:
         return 'assets/images/temp_07.jpg';
       case 8:
         return 'assets/images/temp_08.jpg';
       case 9:
         return 'assets/images/temp_09.jpg';
       case 10:
         return 'assets/images/temp_10.jpg';
       case 11:
         return 'assets/images/temp_11.jpg';
       case 12:
         return 'assets/images/temp_12.jpg';
       case 13:
         return 'assets/images/temp_13.jpg';
       case 14:
         return 'assets/images/temp_14.jpg';
       default:
         return 'assets/images/temp_00.jpg';
    }
  }

  void nextPage() {
    if (selectedTempIndexId.value < 9) {
      selectedTempIndexId.value++;
      pageController.animateToPage(
        selectedTempIndexId.value,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void previousPage() {
    if (selectedTempIndexId.value > 0) {
      selectedTempIndexId.value--;
      pageController.animateToPage(
        selectedTempIndexId.value,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void changeTemplateCall() {
    if(AppSingletons.isInvoiceDocument.value){
      editInvoiceTemplate();
    } else {
      editEstimateTemplate();
    }

    Get.find<SavedPdfController>().onInit();

    Get.back();

  }

  void getDataToEditTemplate() {

    if(AppSingletons.isMakingNewINVEST.value){
      if(AppSingletons.isInvoiceDocument.value){
        Utils().dataModelForEdit(AppSingletons.lastPDFID.value, tempDBHelper);
        debugPrint('TEMPLATE: ${selectedTempIndexId.value}');
        debugPrint('TEMPLATE 2: ${AppSingletons.invoiceTemplateIdINV.value}');

        selectedTempIndexId.value = int.tryParse(AppSingletons.invoiceTemplateIdINV.value) ?? 0;
      } else {
        Utils().getEstimatesData(AppSingletons.lastPDFID.value, tempDBHelper);
        debugPrint('ID: ${AppSingletons.estimateIdWhichWillEdit.value}');
        selectedTempIndexId.value = int.tryParse(AppSingletons.estTemplateIdINV.value) ?? 0;
      }
    } else{
      if(AppSingletons.isInvoiceDocument.value){
        Utils().dataModelForEdit(AppSingletons.invoiceIdWhichWillEdit.value, tempDBHelper);
        debugPrint('TEMPLATE: ${selectedTempIndexId.value}');
        debugPrint('TEMPLATE 2: ${AppSingletons.invoiceTemplateIdINV.value}');

        selectedTempIndexId.value = int.tryParse(AppSingletons.invoiceTemplateIdINV.value) ?? 0;
      } else {
        Utils().getEstimatesData(AppSingletons.estimateIdWhichWillEdit.value, tempDBHelper);
        debugPrint('ID: ${AppSingletons.estimateIdWhichWillEdit.value}');
        selectedTempIndexId.value = int.tryParse(AppSingletons.estTemplateIdINV.value) ?? 0;
      }
    }
  }

  void editInvoiceTemplate() async {
    String? newTemplateId = selectedTempIndexId.value.toString();

    int? documentId;

    if(AppSingletons.isMakingNewINVEST.value){
      documentId = AppSingletons.lastPDFID.value;
    } else{
      documentId = AppSingletons.invoiceIdWhichWillEdit.value;
    }

    DataModel invoiceDataModel = DataModel(
        id: documentId,
        titleName: AppSingletons.invoiceTitle?.value ?? '',
        purchaseOrderNo: AppSingletons.poNumber?.value ?? '',
        uniqueNumber: AppSingletons.invoiceNumberId?.value ?? '',
        languageName: AppSingletons.languageName?.value ?? '',
        selectedTemplateId: newTemplateId ?? '0',
        creationDate: AppSingletons.creationDate.value.toString(),
        dueDate: AppSingletons.dueDate.value.toString(),
        discountInTotal: AppSingletons.discountAmount.value,
        taxInTotal: AppSingletons.taxAmount.value,
        shippingCost: AppSingletons.shippingCost.value,
        itemNames: AppSingletons().itemsNameList.toList(),
        itemsAmountList: AppSingletons().itemsAmountList.toList(),
        itemsDiscountList: AppSingletons().itemsDiscountList.toList(),
        itemsPriceList: AppSingletons().itemsPriceList.toList(),
        itemsQuantityList: AppSingletons().itemsQuantityList.toList(),
        itemsTaxesList: AppSingletons().itemsTaxesList.toList(),
        itemsDescriptionList: AppSingletons().itemDescriptionList.toList(),
        itemsUnitList: AppSingletons().itemUnitList.toList(),
        currencyName: AppSingletons.currencyNameINV?.value ?? '',
        finalNetTotal: AppSingletons.finalPriceTotal?.value.toString() ?? '',
        subTotal: AppSingletons.subTotal?.value.toString() ?? '',
        clientName: AppSingletons.clientNameINV?.value ?? '',
        clientEmail: AppSingletons.clientEmailINV?.value ?? '',
        clientPhoneNumber: AppSingletons.clientPhoneNumberINV?.value ?? '',
        clientBillingAddress: AppSingletons.clientBillingAddressINV?.value ?? '',
        clientShippingAddress: AppSingletons.clientShippingAddressINV?.value ?? '',
        clientDetail: AppSingletons.clientDetailINV?.value ?? '',
        businessLogoImg: AppSingletons.businessLogoImg.value,
        businessName: AppSingletons.businessNameINV?.value ?? '',
        businessEmail: AppSingletons.businessEmailINV?.value ?? '',
        businessPhoneNumber: AppSingletons.businessPhoneNumberINV?.value ?? '',
        businessBillingAddress: AppSingletons.businessBillingAddressINV?.value ?? '',
        businessWebsite: AppSingletons.businessWebsiteINV?.value ?? '',
        paymentMethod: AppSingletons.paymentMethodINV?.value ?? '',
        signatureImg: AppSingletons.signatureImgINV?.value,
        termAndCondition: AppSingletons.termAndConditionINV?.value ?? '',
        discountPercentage: AppSingletons.discountPercentage?.value ?? '',
        taxPercentage: AppSingletons.taxPercentage?.value ?? '',
        partiallyPaidAmount: AppSingletons.partialPaymentAmount?.value ?? '',
        documentStatus: AppSingletons.invoiceStatus.value ?? '',
        unlockTempIdsList: AppSingletons().unlockedTempIdsList.toList()
    );

    await tempDBHelper?.updateInvoice(invoiceDataModel).then((value){
    debugPrint('Invoice Template ID Edited');
    });
  }

  void editEstimateTemplate() async {
    String? newTemplateId = selectedTempIndexId.value.toString();

    int? documentId;

    if(AppSingletons.isMakingNewINVEST.value){
      documentId = AppSingletons.lastPDFID.value;
    } else{
      documentId = AppSingletons.estimateIdWhichWillEdit.value;
    }

    DataModel estimateDataModel = DataModel(
        id: documentId,
        titleName: AppSingletons.estTitle?.value ?? '',
        purchaseOrderNo: AppSingletons.estPoNumber?.value ?? '',
        uniqueNumber: AppSingletons.estNumberId?.value ?? '',
        languageName: AppSingletons.estLanguageName?.value ?? 'English',
        selectedTemplateId: newTemplateId ?? '0',
        creationDate: AppSingletons.estCreationDate.value.toString(),
        dueDate: AppSingletons.estDueDate.value.toString(),
        discountInTotal: AppSingletons.estDiscountAmount.value,
        taxInTotal: AppSingletons.estTaxAmount.value,
        shippingCost: AppSingletons.estShippingCost.value,
        itemNames: AppSingletons().itemsNameList.toList(),
        itemsAmountList: AppSingletons().itemsAmountList.toList(),
        itemsDiscountList: AppSingletons().itemsDiscountList.toList(),
        itemsPriceList: AppSingletons().itemsPriceList.toList(),
        itemsQuantityList: AppSingletons().itemsQuantityList.toList(),
        itemsTaxesList: AppSingletons().itemsTaxesList.toList(),
        itemsDescriptionList: AppSingletons().itemDescriptionList.toList(),
        itemsUnitList: AppSingletons().itemUnitList.toList(),
        currencyName: AppSingletons.estCurrencyNameINV?.value ?? 'Rs',
        finalNetTotal: AppSingletons.estFinalPriceTotal?.value.toString() ?? '',
        clientName: AppSingletons.estClientNameINV?.value ?? '',
        clientEmail: AppSingletons.estClientEmailINV?.value ?? '',
        clientPhoneNumber: AppSingletons.estClientPhoneNumberINV?.value ?? '',
        clientBillingAddress: AppSingletons.estClientBillingAddressINV?.value ?? '',
        clientShippingAddress: AppSingletons.estClientShippingAddressINV?.value ?? '',
        clientDetail: AppSingletons.estClientDetailINV?.value ?? '',
        businessLogoImg: AppSingletons.estBusinessLogoImg.value,
        businessName: AppSingletons.estBusinessNameINV?.value ?? '',
        businessEmail: AppSingletons.estBusinessEmailINV?.value ?? '',
        businessPhoneNumber: AppSingletons.estBusinessPhoneNumberINV?.value ?? '',
        businessBillingAddress: AppSingletons.estBusinessBillingAddressINV?.value ?? '',
        businessWebsite: AppSingletons.estBusinessWebsiteINV?.value ?? '',
        paymentMethod: AppSingletons.estPaymentMethodINV?.value ?? '',
        signatureImg: AppSingletons.estSignatureImgINV?.value ?? Uint8List(0),
        termAndCondition: AppSingletons.estTermAndConditionINV?.value ?? '',
        taxPercentage: AppSingletons.estTaxPercentage?.value ?? '0',
        discountPercentage: AppSingletons.estDiscountPercentage?.value ?? '0',
        subTotal: AppSingletons.estSubTotal?.value.toString() ?? '',
        documentStatus: AppSingletons.estimateStatus.value,
        unlockTempIdsList: AppSingletons().unlockedTempIdsList.toList(),
        partiallyPaidAmount: '');

    await tempDBHelper!.updateEstimate(estimateDataModel).then((value) {

      debugPrint('Estimate Template ID Edited');
    });
  }

  void selectProBillTemplate() {
    // adsControllerService.showRewardedAd(onRewardGranted: () {
      if (AppSingletons.isEditingOnlyTemplate.value) {
        changeTemplateCall();
      }
      else {
        if (AppSingletons.isInvoiceDocument.value) {
          AppSingletons.invoiceTemplateIdINV.value =
              selectedTempIndexId.value.toString();
          Get.back();
          debugPrint(
              'selected tempId for INV: ${AppSingletons
                  .invoiceTemplateIdINV.value}');
        } else {
          AppSingletons.estTemplateIdINV.value =
              selectedTempIndexId.value.toString();
          Get.back();
          debugPrint('selected tempId for EST: ${AppSingletons.estTemplateIdINV.value}');
        }
      }

      AppSingletons().addUnlockedTempIdsList(selectedTempIndexId.value.toString());

    // });
  }

}
