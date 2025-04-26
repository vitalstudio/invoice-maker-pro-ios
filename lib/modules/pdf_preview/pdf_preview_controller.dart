import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import '../../core/constants/app_constants/App_Constants.dart';
import '../../core/services/ads_controller.dart';
import '../../core/services/ads_helper.dart';
import '../../core/utils/dialogue_to_select_language.dart';
import '../../modules/estimate/estimate_list_controller.dart';
import '../../modules/home_screen/home_controller.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import '../../core/utils/utils.dart';
import '../../pdf_templates/simple_blue_template/simple_blue_template_pdf.dart';
import '../../pdf_templates/simple_red_template/simple_red_temp_pdf.dart';
import '../../pdf_templates/grey_wallpaper_temp/gery_wall_pdf.dart';
import '../../pdf_templates/blue_black_dotted_temp/black_dotted_pdf.dart';
import '../../pdf_templates/orange_black_temp/orange_temp_pdf.dart';
import '../../pdf_templates/pink_and_blue_temp/pink_temp_pdf.dart';
import '../../model/data_model.dart';
import '../../../database/database_helper.dart';
import '../../core/app_singletons/app_singletons.dart';
import '../../pdf_templates/black_yellow_temp/black_yellow_template.dart';
import '../../pdf_templates/blue_tap_temp/blue_tap_template.dart';
import '../../pdf_templates/mat_brown_temp/mat_brown.dart';
import '../../pdf_templates/purple_temp/purple_template.dart';

class PdfPreviewController extends GetxController with AdsControllerMixin {

  RxInt previewTempNo = 0.obs;

  // PageController pageController = PageController();

  RxBool isLoading = false.obs;

  DBHelper? pdfDbHelper;
  String? netTotal;

  RxString clientName = ''.obs;
  RxString finalAmount = ''.obs;
  RxString dueDateInv = ''.obs;

  DataModel? invoiceDataModel;
  String? randomId;

  PageController? pageController;

  RxString currentStatusOfData = ''.obs;

  final unlockedTemplates = <int>[0, 1].obs;

  RxBool isOverdue = false.obs;

  Future<Uint8List>? pdf00;
  Future<Uint8List>? pdf01;
  Future<Uint8List>? pdf02;
  Future<Uint8List>? pdf03;
  Future<Uint8List>? pdf04;
  Future<Uint8List>? pdf05;
  Future<Uint8List>? pdf06;
  Future<Uint8List>? pdf07;
  Future<Uint8List>? pdf08;
  Future<Uint8List>? pdf09;

  final homeScController = Get.put(HomeController());
  final estListController = Get.put(EstimateListController());

  Rx<bool> isBannerAdReady = false.obs;
  late BannerAd bannerAd;

  @override
  void onInit() async {
    // if(Platform.isAndroid || Platform.isIOS){
    //   _loadBannerAd();
    // }

    // updateUnlockedTemplatesFromDatabase();

    if(!AppSingletons.isSubscriptionEnabled.value){
      if(Platform.isAndroid && AppSingletons.androidBannerAdsEnabled.value){
        _loadBannerAd();
      }

      if(Platform.isIOS && AppSingletons.iOSBannerAdsEnabled.value){
        _loadBannerAd();
      }
    }

    debugPrint('Init method called');

    randomId = generateUniqueId();

    previewTemplateId();

    pdfDbHelper = DBHelper();

    pageController =  PageController(
      initialPage: previewTempNo.value,
      viewportFraction: 0.85,
    );

    // if(AppSingletons.isMakingNewINVEST.value){
    //
    //   if(AppSingletons.isInvoiceDocument.value){
    //     await makingNewInvoiceDoc();
    //   } else {
    //     await makingNewEstimateDoc();
    //   }
    //
    // } else {
    //   await fetchInvoiceData();
    // }

    await fetchInvoiceData();

    super.onInit();
  }

  void _loadBannerAd() {
    bannerAd = BannerAd(
      adUnitId: AdHelper.bannerAdUnitId,
      request: const AdRequest(),
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

  void previewTemplateId() {
    if(AppSingletons.isInvoiceDocument.value){
      previewTempNo.value = int.tryParse(AppSingletons.invoiceTemplateIdINV.value) ?? 0;
    } else{
      previewTempNo.value = int.tryParse(AppSingletons.estTemplateIdINV.value) ?? 0;
    }
    // pageController = PageController(
    //   initialPage: previewTempNo.value,
    //   viewportFraction: 0.85,
    // );
  }

  Future<void> getDummyData() async {
    invoiceDataModel = DataModel();

    isLoading.value = true;

    invoiceDataModel = DataModel(
        discountPercentage: '0.0',
        taxPercentage: '0.0',
        creationDate: '2024-06-11 16:17:17.496134',
        dueDate: '2024-06-11 16:17:17.498956',
        titleName: 'Dummy Name',
        paymentMethod: 'Online Payment',
        uniqueNumber: 'INVWE432',
        termAndCondition: 'The registered users can fill this form',
        signatureImg: Uint8List(0),
        businessWebsite: 'www.pakTv.com',
        businessBillingAddress: 'New York',
        businessPhoneNumber: '+1234567891346',
        businessEmail: 'explore@gmail.com',
        businessName: 'Explore world',
        clientDetail: 'None',
        clientShippingAddress: 'Shinghai',
        clientBillingAddress: 'Washington DC',
        clientPhoneNumber: '+123456789355',
        clientEmail: 'gamer@gmail.com',
        clientName: 'The Gamer',
        shippingCost: '300',
        taxInTotal: '1',
        discountInTotal: '1',
        selectedTemplateId: '0',
        languageName: 'English',
        purchaseOrderNo: '09765431245',
        currencyName: 'Rs',
        finalNetTotal: '7700',
        itemsAmountList: ['2200', '2200', '3000'],
        itemNames: ['Helment', 'Paint', 'Door Bell'],
        itemsDescriptionList: ['ABC', 'XYZ', '--'],
        itemsDiscountList: ['0', '0', '0'],
        itemsPriceList: ['200', '220', '300'],
        itemsQuantityList: ['11', '10', '10'],
        itemsTaxesList: ['0', '0', '0'],
        itemsUnitList: ['', '', ''],
        subTotal: '7400'
    );

    isLoading.value = false;
  }

  // void updateUnlockedTemplatesFromDatabase() {
  //   List<int> unlockedIds = AppSingletons().unlockedTempIdsList.map((id) => int.parse(id)).toList();
  //   unlockedTemplates.addAll(unlockedIds);
  // }

  // bool isUnlocked(int templateId) {
  //   return unlockedTemplates.contains(templateId);
  // }

  String generateUniqueId() {
    Random random = Random();
    String characters =
        '01234567891011121314151617181920';
    String id = '';
    for (var i = 0; i < 5; i++) {
      id += characters[random.nextInt(characters.length)];
    }
    return id;
  }

  void nextPage() {
    if (previewTempNo.value < 9) {
      previewTempNo.value++;
      pageController?.animateToPage(
        previewTempNo.value,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void previousPage() {
    if (previewTempNo.value > 0) {
      previewTempNo.value--;
      pageController?.animateToPage(
        previewTempNo.value,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  Future<void> fetchInvoiceData() async {
    // if (AppSingletons.isPreviewingPdfBeforeSave.value) {
    // }
    // else {
    //   try {
    //     isLoading.value = true;
    //
    //     if (AppSingletons.isEditInvoice.value) {
    //       debugPrint('Fetch Data For Invoice');
    //       invoiceDataModel = await pdfDbHelper!.getSingleInvoiceById(AppSingletons.invoiceIdWhichWillEdit.value);
    //     }
    //     else {
    //       debugPrint('Fetch Data For Estimate');
    //       invoiceDataModel = await pdfDbHelper!.getSingleEstimateById(AppSingletons.estimateIdWhichWillEdit.value);
    //     }
    //     debugPrint('InvoiceData: ${invoiceDataModel?.itemNames?.length}');
    //
    //     clientName.value = invoiceDataModel!.clientName.toString();
    //     finalAmount.value = invoiceDataModel!.finalNetTotal.toString();
    //     dueDateInv.value = invoiceDataModel!.dueDate.toString();
    //
    //     isOverdue.value = Utils.isOverdue(invoiceDataModel!.dueDate.toString());
    //
    //     currentStatusOfData.value = invoiceDataModel!.documentStatus.toString();
    //
    //     debugPrint('INVOICE TEMPLATE ID: ${invoiceDataModel!.selectedTemplateId}');
    //     double totalPrice = 0.0;
    //     for (var itemAmount in invoiceDataModel!.itemsAmountList!) {
    //       double dItemAmount = double.parse(itemAmount);
    //       totalPrice += dItemAmount;
    //     }
    //
    //     netTotal = totalPrice.toString();
    //     var selectedLocale = const Locale('en', 'US');
    //     if (invoiceDataModel!.languageName == 'Deutsch') {
    //       selectedLocale = const Locale('de', 'DE');
    //     } else if (invoiceDataModel!.languageName == 'Española') {
    //       selectedLocale = const Locale('es', 'ES');
    //     } else if (invoiceDataModel!.languageName == 'Français') {
    //       selectedLocale = const Locale('fr', 'FR');
    //     } else if (invoiceDataModel!.languageName == 'हिंदी') {
    //       selectedLocale = const Locale('hi', 'IN');
    //     } else if (invoiceDataModel!.languageName == 'Indonesia') {
    //       selectedLocale = const Locale('id', 'ID');
    //     } else {
    //       selectedLocale = const Locale('en', 'US');
    //     }
    //
    //     Get.updateLocale(selectedLocale);
    //
    //     debugPrint('Stored Locale: $selectedLocale');
    //
    //     isLoading.value = false;
    //   } catch (e) {
    //     debugPrint('Error: $e');
    //     isLoading.value = false;
    //   }
    // }

    if (AppSingletons.isPreviewEstimateDoc.value) {
      debugPrint('Previewing ESTIMATE Data');
      invoiceDataModel = DataModel(
        titleName: AppSingletons.estTitle?.value ?? '',
        purchaseOrderNo: AppSingletons.estPoNumber?.value ?? '',
        uniqueNumber: AppSingletons.estNumberId?.value ?? '',
        languageName: AppSingletons.estLanguageName?.value ?? 'English',
        selectedTemplateId: AppSingletons.estTemplateIdINV.value,
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
        finalNetTotal:
        AppSingletons.estFinalPriceTotal?.value.toString() ?? '',
        clientName: AppSingletons.estClientNameINV?.value ?? '',
        clientEmail: AppSingletons.estClientEmailINV?.value ?? '',
        clientPhoneNumber: AppSingletons.estClientPhoneNumberINV?.value ?? '',
        clientBillingAddress:
        AppSingletons.estClientBillingAddressINV?.value ?? '',
        clientShippingAddress:
        AppSingletons.estClientShippingAddressINV?.value ?? '',
        clientDetail: AppSingletons.estClientDetailINV?.value ?? '',
        businessLogoImg: AppSingletons.estBusinessLogoImg.value,
        businessName: AppSingletons.estBusinessNameINV?.value ?? '',
        businessEmail: AppSingletons.estBusinessEmailINV?.value ?? '',
        businessPhoneNumber:
        AppSingletons.estBusinessPhoneNumberINV?.value ?? '',
        businessBillingAddress:
        AppSingletons.estBusinessBillingAddressINV?.value ?? '',
        businessWebsite: AppSingletons.estBusinessWebsiteINV?.value ?? '',
        paymentMethod: AppSingletons.estPaymentMethodINV?.value ?? '',
        signatureImg: AppSingletons.estSignatureImgINV?.value ?? Uint8List(0),
        termAndCondition: AppSingletons.estTermAndConditionINV?.value ?? '',
        taxPercentage: AppSingletons.estTaxPercentage?.value ?? '0',
        discountPercentage: AppSingletons.estDiscountPercentage?.value ?? '0',
        subTotal: AppSingletons.estSubTotal?.value.toString() ?? '',
      );

      await getPDFTemplates();

      await Future.delayed(const Duration(seconds: 15));

      await LanguageSelection.updateLocale(
          selectedLanguage: AppSingletons.storedAppLanguage.value);

    }
    else {
      debugPrint('Previewing INVOICE Data');
      invoiceDataModel = DataModel(
          itemsUnitList: AppSingletons().itemUnitList,
          itemsTaxesList: AppSingletons().itemsTaxesList,
          itemsQuantityList: AppSingletons().itemsQuantityList,
          itemsPriceList: AppSingletons().itemsPriceList,
          itemsDiscountList: AppSingletons().itemsDiscountList,
          itemsDescriptionList: AppSingletons().itemDescriptionList,
          itemNames: AppSingletons().itemsNameList,
          itemsAmountList: AppSingletons().itemsAmountList,
          currencyName: AppSingletons.currencyNameINV?.value ?? '',
          purchaseOrderNo: AppSingletons.poNumber?.value ?? '',
          languageName: AppSingletons.languageName?.value ?? '',
          selectedTemplateId: AppSingletons.invoiceTemplateIdINV.value,
          discountInTotal: AppSingletons.discountAmount.value,
          discountPercentage: AppSingletons.discountPercentage?.value ?? '',
          taxInTotal: AppSingletons.taxAmount.value,
          taxPercentage: AppSingletons.taxPercentage?.value ?? '',
          shippingCost: AppSingletons.shippingCost.value,
          clientName: AppSingletons.clientNameINV?.value ?? '',
          clientEmail: AppSingletons.clientEmailINV?.value ?? '',
          clientPhoneNumber: AppSingletons.clientPhoneNumberINV?.value ?? '',
          clientBillingAddress: AppSingletons.clientBillingAddressINV?.value ?? '',
          clientShippingAddress: AppSingletons.clientShippingAddressINV?.value ?? '',
          clientDetail: AppSingletons.clientDetailINV?.value ?? '',
          creationDate: AppSingletons.creationDate.value.toString(),
          dueDate: AppSingletons.dueDate.value.toString(),
          businessName: AppSingletons.businessNameINV?.value ?? '',
          businessEmail: AppSingletons.businessEmailINV?.value ?? '',
          businessPhoneNumber: AppSingletons.businessPhoneNumberINV?.value ?? '',
          businessLogoImg: AppSingletons.businessLogoImg.value,
          businessBillingAddress: AppSingletons.businessBillingAddressINV?.value ?? '',
          businessWebsite: AppSingletons.businessWebsiteINV?.value ?? '',
          signatureImg: AppSingletons.signatureImgINV?.value ?? Uint8List(0),
          termAndCondition: AppSingletons.termAndConditionINV?.value ?? '',
          uniqueNumber: AppSingletons.invoiceNumberId?.value ?? '',
          paymentMethod: AppSingletons.paymentMethodINV?.value ?? '',
          titleName: AppSingletons.invoiceTitle?.value ?? '',
          finalNetTotal: AppSingletons.finalPriceTotal?.value.toString() ?? '',
          subTotal: AppSingletons.subTotal?.value.toString() ?? '',
          documentStatus: AppSingletons.documentStatus.value,
          partiallyPaidAmount: AppSingletons.partialPaymentAmount?.value ?? ''
      );

      await getPDFTemplates();

      await Future.delayed(const Duration(seconds: 15));

      await LanguageSelection.updateLocale(
          selectedLanguage: AppSingletons.storedAppLanguage.value);

    }

  }

  Future<Uint8List> loadTemplateData() async {
    int tempId;

    if (AppSingletons.isPreviewingPdfBeforeSave.value) {
      if (AppSingletons.isInvoiceDocument.value) {
        tempId = int.tryParse(AppSingletons.invoiceTemplateIdINV.value) ?? 0;
      } else {
        tempId = int.tryParse(AppSingletons.estTemplateIdINV.value) ?? 0;
      }
    } else {
      tempId = int.tryParse(invoiceDataModel?.selectedTemplateId ?? '0') ?? 0;
    }

    debugPrint('TEMP ID: $tempId');

    Uint8List pdfData;

    switch (tempId) {
      case 0:
        pdfData = await SimpleRedAndBluePDFTemplate.createPreviewPdf(invoiceDataModel!,templateIdNo: 0);
        break;
      case 1:
        pdfData = await SimpleRedAndBluePDFTemplate.createPreviewPdf(invoiceDataModel!, templateIdNo: 1);
        break;
      case 2:
        pdfData = await WithImagesPDFTemplates.createPreviewPdf(invoiceDataModel!,templateIdNo: 2);
        break;
      case 3:
        pdfData = await WithImagesPDFTemplates.createPreviewPdf(invoiceDataModel!,templateIdNo: 3);
         break;
      case 4:
        pdfData = await WithImagesPDFTemplates.createPreviewPdf(invoiceDataModel!,templateIdNo: 4);
         break;
      case 5:
        pdfData = await WithImagesPDFTemplates.createPreviewPdf(invoiceDataModel!,templateIdNo: 5);
         break;
      case 6:
        pdfData = await WithImagesPDFTemplates.createPreviewPdf(invoiceDataModel!,templateIdNo: 6);
         break;
      case 7:
        pdfData = await WithImagesPDFTemplates.createPreviewPdf(invoiceDataModel!,templateIdNo: 7);
         break;
      case 8:
        pdfData = await WithImagesPDFTemplates.createPreviewPdf(invoiceDataModel!,templateIdNo: 8);
         break;
      case 9:
        pdfData = await WithImagesPDFTemplates.createPreviewPdf(invoiceDataModel!,templateIdNo: 9);
         break;
      default:
        pdfData = await SimpleRedAndBluePDFTemplate.createPreviewPdf(invoiceDataModel!, templateIdNo: 0);
    }

    await LanguageSelection.updateLocale(
        selectedLanguage: AppSingletons.storedAppLanguage.value);

    return pdfData;

  }

  Future<void> saveAndSharePdf(Uint8List pdfData, String filename) async {
    try {

      final directory = await getTemporaryDirectory();
      final filePath = '${directory.path}\\$filename';

      debugPrint("Directory Path: $directory");
      debugPrint("File Path: $filePath");

      final file = File(filePath);
      await file.writeAsBytes(pdfData);

      await Share.shareXFiles([XFile(filePath)], text: 'Check out this PDF file!');

      debugPrint('PDF file saved and shared successfully.');
    } catch (e) {
      debugPrint('Error sharing PDF: $e');
      Utils().snackBarMsg('Error', 'Failed to share the file');
    }
  }

  Future<void> makingNewInvoiceDoc() async{
    debugPrint('Making New Invoice');
    invoiceDataModel = DataModel(
      uniqueNumber: AppSingletons.invoiceNumberId?.value,
      titleName: AppSingletons.invoiceTitle?.value,
      purchaseOrderNo: AppSingletons.poNumber?.value,
      languageName: AppSingletons.languageName?.value,
      creationDate: AppSingletons.creationDate.value.toString(),
      dueDate: AppSingletons.dueDate.value.toString(),
      discountInTotal: AppSingletons.discountAmount.value,
      discountPercentage: AppSingletons.discountPercentage?.value,
      taxInTotal: AppSingletons.taxAmount.value,
      taxPercentage: AppSingletons.taxPercentage?.value,
      shippingCost: AppSingletons.shippingCost.value,
      clientName: AppSingletons.clientNameINV?.value,
      clientEmail: AppSingletons.clientEmailINV?.value,
      clientPhoneNumber: AppSingletons.clientPhoneNumberINV?.value,
      clientBillingAddress: AppSingletons.clientBillingAddressINV?.value,
      clientShippingAddress: AppSingletons.clientShippingAddressINV?.value,
      clientDetail: AppSingletons.clientDetailINV?.value,
      businessName: AppSingletons.businessNameINV?.value,
      businessEmail: AppSingletons.businessEmailINV?.value,
      businessLogoImg: AppSingletons.businessLogoImg.value,
      businessBillingAddress: AppSingletons.businessBillingAddressINV?.value,
      businessPhoneNumber: AppSingletons.businessPhoneNumberINV?.value,
      businessWebsite: AppSingletons.businessWebsiteINV?.value,
      currencyName: AppSingletons.currencyNameINV?.value,
      signatureImg: AppSingletons.signatureImgINV?.value,
      paymentMethod: AppSingletons.paymentMethodINV?.value,
      termAndCondition: AppSingletons.termAndConditionINV?.value,
      subTotal: AppSingletons.subTotal?.value.toString(),
      finalNetTotal: AppSingletons.finalPriceTotal?.value.toString(),
      documentStatus: AppSingletons.documentStatus.value,
      partiallyPaidAmount: AppSingletons.partialPaymentAmount?.value,
      selectedTemplateId: AppSingletons.invoiceTemplateIdINV.value,
      itemNames: AppSingletons().itemsNameList,
      itemsAmountList: AppSingletons().itemsAmountList,
      itemsDescriptionList: AppSingletons().itemDescriptionList,
      itemsDiscountList: AppSingletons().itemsDiscountList,
      itemsPriceList: AppSingletons().itemsPriceList,
      itemsQuantityList: AppSingletons().itemsQuantityList,
      itemsTaxesList: AppSingletons().itemsTaxesList,
      itemsUnitList: AppSingletons().itemUnitList,
    );
  }

  Future<void> makingNewEstimateDoc() async{
    debugPrint('Making New Estimate');
    invoiceDataModel = DataModel(
      uniqueNumber: AppSingletons.estNumberId?.value,
      titleName: AppSingletons.estTitle?.value,
      purchaseOrderNo: AppSingletons.estPoNumber?.value,
      languageName: AppSingletons.estLanguageName?.value,
      creationDate: AppSingletons.estCreationDate.value.toString(),
      dueDate: AppSingletons.estDueDate.value.toString(),
      discountInTotal: AppSingletons.estDiscountAmount.value,
      discountPercentage: AppSingletons.estDiscountPercentage?.value,
      taxInTotal: AppSingletons.estTaxAmount.value,
      taxPercentage: AppSingletons.estTaxPercentage?.value,
      shippingCost: AppSingletons.estShippingCost.value,
      clientName: AppSingletons.estClientNameINV?.value,
      clientEmail: AppSingletons.estClientEmailINV?.value,
      clientPhoneNumber: AppSingletons.estClientPhoneNumberINV?.value,
      clientBillingAddress: AppSingletons.estClientBillingAddressINV?.value,
      clientShippingAddress: AppSingletons.estClientShippingAddressINV?.value,
      clientDetail: AppSingletons.estClientDetailINV?.value,
      businessName: AppSingletons.estBusinessNameINV?.value,
      businessEmail: AppSingletons.estBusinessEmailINV?.value,
      businessLogoImg: AppSingletons.estBusinessLogoImg.value,
      businessBillingAddress: AppSingletons.estBusinessBillingAddressINV?.value,
      businessPhoneNumber: AppSingletons.estBusinessPhoneNumberINV?.value,
      businessWebsite: AppSingletons.estBusinessWebsiteINV?.value,
      currencyName: AppSingletons.estCurrencyNameINV?.value,
      signatureImg: AppSingletons.estSignatureImgINV?.value,
      paymentMethod: AppSingletons.estPaymentMethodINV?.value,
      termAndCondition: AppSingletons.estTermAndConditionINV?.value,
      subTotal: AppSingletons.estSubTotal?.value.toString(),
      finalNetTotal: AppSingletons.estFinalPriceTotal?.value.toString(),
      documentStatus: AppSingletons.estDocumentStatus.value,
      partiallyPaidAmount: '',
      selectedTemplateId: AppSingletons.estTemplateIdINV.value,
      itemNames: AppSingletons().itemsNameList,
      itemsAmountList: AppSingletons().itemsAmountList,
      itemsDescriptionList: AppSingletons().itemDescriptionList,
      itemsDiscountList: AppSingletons().itemsDiscountList,
      itemsPriceList: AppSingletons().itemsPriceList,
      itemsQuantityList: AppSingletons().itemsQuantityList,
      itemsTaxesList: AppSingletons().itemsTaxesList,
      itemsUnitList: AppSingletons().itemUnitList,
    );
  }

  Future<void> getPDFTemplates() async{

    debugPrint('getPDFTemplates called');

    pdf00 = SimpleRedAndBluePDFTemplate.createPreviewPdf(invoiceDataModel!,templateIdNo: 0);
    pdf01 = SimpleRedAndBluePDFTemplate.createPreviewPdf(invoiceDataModel!,templateIdNo: 1);
    pdf02 = WithImagesPDFTemplates.createPreviewPdf(invoiceDataModel!,templateIdNo: 2);
    pdf03 = WithImagesPDFTemplates.createPreviewPdf(invoiceDataModel!,templateIdNo: 3);
    pdf04 = WithImagesPDFTemplates.createPreviewPdf(invoiceDataModel!,templateIdNo: 4);
    pdf05 = WithImagesPDFTemplates.createPreviewPdf(invoiceDataModel!,templateIdNo: 5);
    pdf06 = WithImagesPDFTemplates.createPreviewPdf(invoiceDataModel!,templateIdNo: 6);
    pdf07 = WithImagesPDFTemplates.createPreviewPdf(invoiceDataModel!,templateIdNo: 7);
    pdf08 = WithImagesPDFTemplates.createPreviewPdf(invoiceDataModel!,templateIdNo: 8);
    pdf09 = WithImagesPDFTemplates.createPreviewPdf(invoiceDataModel!,templateIdNo: 9);
  }

  // void selectProBillTemplate() {
  //
  //   adsControllerService.showRewardedAd(onRewardGranted: () {
  //     AppSingletons.isPreviewingPdfBeforeSave.value = false;
  //     if(AppSingletons.isInvoiceDocument.value){
  //       AppSingletons.invoiceTemplateIdINV.value = previewTempNo.value.toString();
  //
  //       debugPrint('Temp Id After preview ${AppSingletons.invoiceTemplateIdINV.value}');
  //
  //     }
  //     else{
  //       AppSingletons.estTemplateIdINV.value = previewTempNo.value.toString();
  //
  //       debugPrint('Temp Id After preview ${AppSingletons.estTemplateIdINV.value}');
  //
  //     }
  //     AppSingletons.isPreviewingPdfBeforeSave.value = false;
  //     Get.back();
  //
  //     AppSingletons().addUnlockedTempIdsList(previewTempNo.value.toString());
  //
  //   });
  // }

}
