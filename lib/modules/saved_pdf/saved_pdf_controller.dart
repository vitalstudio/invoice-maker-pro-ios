import 'dart:io';
import 'dart:math';
import 'dart:typed_data';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import '../../core/app_singletons/app_singletons.dart';
import '../../core/services/ads_helper.dart';
import '../../core/utils/utils.dart';
import '../../database/database_helper.dart';
import '../../model/data_model.dart';
import '../../pdf_templates/black_yellow_temp/black_yellow_template.dart';
import '../../pdf_templates/blue_black_dotted_temp/black_dotted_pdf.dart';
import '../../pdf_templates/blue_tap_temp/blue_tap_template.dart';
import '../../pdf_templates/grey_wallpaper_temp/gery_wall_pdf.dart';
import '../../pdf_templates/mat_brown_temp/mat_brown.dart';
import '../../pdf_templates/orange_black_temp/orange_temp_pdf.dart';
import '../../pdf_templates/pink_and_blue_temp/pink_temp_pdf.dart';
import '../../pdf_templates/purple_temp/purple_template.dart';
import '../../pdf_templates/simple_blue_template/simple_blue_template_pdf.dart';
import '../../pdf_templates/simple_red_template/simple_red_temp_pdf.dart';
import '../estimate/estimate_list_controller.dart';
import '../home_screen/home_controller.dart';

class SavedPdfController extends GetxController{

  RxBool isLoading = false.obs;
  DBHelper? pdfDbHelper;
  DataModel? dataModelPdf;
  String? randomId;
  RxString currentStatusOfData = ''.obs;
  RxBool isOverdue = false.obs;
  RxString clientName = ''.obs;
  RxString finalAmount = ''.obs;
  RxString dueDateInv = ''.obs;
  String? netTotal;
  final homeScController = Get.put<HomeController>(HomeController());
  final estListController = Get.put<EstimateListController>(EstimateListController());

  Rx<bool> isBannerAdReady = false.obs;
  late BannerAd bannerAd;

  RxList<DataModel> invoiceList = <DataModel>[].obs;

  @override
  void onInit() async{
    super.onInit();
    // if(Platform.isAndroid || Platform.isIOS){
    //   _loadBannerAd();
    // }

    if(!AppSingletons.isSubscriptionEnabled.value){
      if(Platform.isAndroid && AppSingletons.androidBannerAdsEnabled.value){
        _loadBannerAd();
      }

      if(Platform.isIOS && AppSingletons.iOSBannerAdsEnabled.value){
        _loadBannerAd();
      }
    }

    randomId = generateUniqueId();
    pdfDbHelper = DBHelper();

    // if(AppSingletons.isMakingNewINVEST.value){
    //   if(AppSingletons.isInvoiceDocument.value){
    //     await makingNewInvoiceDoc();
    //   } else {
    //     await makingNewEstimateDoc();
    //   }
    // } else {
    //   await fetchPdfData();
    // }

    await fetchPdfData();

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

  Future<void> fetchPdfData() async {
    try {
      isLoading.value = true;

      if(AppSingletons.isMakingNewINVEST.value){
        if(AppSingletons.isInvoiceDocument.value){
          final list = await pdfDbHelper!.getInvoiceList();
          invoiceList.assignAll(list);
          int? lastInvoiceId = invoiceList.last.id;
          AppSingletons.lastPDFID.value = lastInvoiceId!;
          debugPrint('LAST INVOICE ID: $lastInvoiceId');

          dataModelPdf = await pdfDbHelper!.getSingleInvoiceById(lastInvoiceId);

        } else{
          final list = await pdfDbHelper!.getEstimateList();
          invoiceList.assignAll(list);
          int? lastEstimateId = invoiceList.last.id;
          AppSingletons.lastPDFID.value = lastEstimateId!;
          debugPrint('LAST ESTIMATE ID: $lastEstimateId');

          dataModelPdf = await pdfDbHelper!.getSingleEstimateById(lastEstimateId);

        }
      } else if (AppSingletons.isEditInvoice.value) {
        debugPrint('Fetch Data For Invoice');
        dataModelPdf = await pdfDbHelper!.getSingleInvoiceById(AppSingletons.invoiceIdWhichWillEdit.value);
      }
      else {
        debugPrint('Fetch Data For Estimate');
        dataModelPdf = await pdfDbHelper!.getSingleEstimateById(AppSingletons.estimateIdWhichWillEdit.value);
      }
      debugPrint('InvoiceData: ${dataModelPdf?.itemNames?.length}');

      clientName.value = dataModelPdf!.clientName.toString();
      finalAmount.value = dataModelPdf!.finalNetTotal.toString();
      dueDateInv.value = dataModelPdf!.dueDate.toString();

      isOverdue.value = Utils.isOverdue(dataModelPdf!.dueDate.toString());

      currentStatusOfData.value = dataModelPdf!.documentStatus.toString();

      debugPrint('INVOICE TEMPLATE ID: ${dataModelPdf!.selectedTemplateId}');
      double totalPrice = 0.0;
      for (var itemAmount in dataModelPdf!.itemsAmountList!) {
        double dItemAmount = double.parse(itemAmount);
        totalPrice += dItemAmount;
      }

      netTotal = totalPrice.toString();
      var selectedLocale = const Locale('en', 'US');
      if (dataModelPdf!.languageName == 'Deutsch') {
        selectedLocale = const Locale('de', 'DE');
      } else if (dataModelPdf!.languageName == 'Española') {
        selectedLocale = const Locale('es', 'ES');
      } else if (dataModelPdf!.languageName == 'Français') {
        selectedLocale = const Locale('fr', 'FR');
      } else if (dataModelPdf!.languageName == 'हिंदी') {
        selectedLocale = const Locale('hi', 'IN');
      } else if (dataModelPdf!.languageName == 'Indonesia') {
        selectedLocale = const Locale('id', 'ID');
      } else {
        selectedLocale = const Locale('en', 'US');
      }

      Get.updateLocale(selectedLocale);

      debugPrint('Stored Locale: $selectedLocale');

      isLoading.value = false;
    } catch (e) {
      debugPrint('Error: $e');
      isLoading.value = false;
    }
  }

  Future<Uint8List> loadTemplateData() async {
    int tempId;

    debugPrint('Store ID: ${dataModelPdf?.selectedTemplateId}');

    tempId = int.tryParse(dataModelPdf?.selectedTemplateId ?? '0') ?? 0;

    debugPrint('TEMP ID: $tempId');

    switch (tempId) {
      case 0:
        return PdfSimpleRedTemplate.createPreviewPdf(dataModelPdf!);
      case 1:
        return PdfSimpleBlueTemplate.createPreviewPdf(dataModelPdf!);
      case 2:
        return PdfPurpleTemplate.createPreviewPdf(dataModelPdf!);
      case 3:
        return PdfMatBrownTemplate.createPreviewPdf(dataModelPdf!);
      case 4:
        return PdfBlueTapTemplate.createPreviewPdf(dataModelPdf!);
      case 5:
        return PdfBlackYellowTemplate.createPreviewPdf(dataModelPdf!);
      case 6:
        return PdfPinkBlueTemplate.createPreviewPdf(dataModelPdf!);
      case 7:
        return PdfOrangeBlackTemplate.createPreviewPdf(dataModelPdf!);
      case 8:
        return PdfBlueBlackDottedTemplate.createPreviewPdf(dataModelPdf!);
      case 9:
        return PdfGreyWallpaperTemplate.createPreviewPdf(dataModelPdf!);
      default:
        return PdfSimpleRedTemplate.createPreviewPdf(dataModelPdf!);
    }
  }

  Future<void> sharePdfFromDesktop(Uint8List pdfData, String filename) async {
    try {

      final directory = await getTemporaryDirectory();
      final filePath = '${directory.path}\\$filename';

      print("Directory Path: $directory");
      print("File Path: $filePath");

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
    dataModelPdf = DataModel(
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
    dataModelPdf = DataModel(
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

  Future<void> sharePdfFile(Uint8List pdfData, String filename) async {
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

}