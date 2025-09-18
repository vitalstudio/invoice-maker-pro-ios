import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';
import 'package:currency_picker/currency_picker.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import '../../core/services/ads_helper.dart';
import '../../modules/pdf_preview/pdf_preview_controller.dart';
import '../../model/client_model.dart';
import '../../model/company_model.dart';
import '../../model/payment_model.dart';
import '../../model/signature_model.dart';
import '../../model/termAndCondition_model.dart';
import '../../core/preferenceManager/sharedPreferenceManager.dart';
import '../../core/app_singletons/app_singletons.dart';
import '../../core/constants/app_constants/App_Constants.dart';
import '../../core/routes/routes.dart';
import '../../core/utils/utils.dart';
import '../../database/database_helper.dart';
import '../../model/data_model.dart';

class EstimateEntranceController extends GetxController{

  RxString discountHeading = 'Discount %'.obs;
  RxString taxRateHeading = 'Tax %'.obs;

  TextEditingController estimateNumberController = TextEditingController();
  TextEditingController poController = TextEditingController();
  TextEditingController titleNameController = TextEditingController();

  TextEditingController discountInTotalControl = TextEditingController();
  TextEditingController discFlatAmountController = TextEditingController();
  TextEditingController taxInTotalControl = TextEditingController();
  TextEditingController taxFlatAmountController = TextEditingController();
  TextEditingController shippingCostControl = TextEditingController();

  FocusNode discPercentageFocusNode = FocusNode();
  FocusNode discFlatAmountFocusNode = FocusNode();

  FocusNode taxPercentageFocusNode = FocusNode();
  FocusNode taxFlatAmountFocusNode = FocusNode();

  DBHelper? estimateDbHelper;
  final RxInt dueTermValue = 7.obs;
  RxBool isLoading = false.obs;

  RxBool isLoadingDefaultValues = false.obs;

  Rx<Currency?> selectedCurrency = Rx<Currency?>(null);
  var selectedItemNames = [].obs;
  var selectedItemPrice = [].obs;
  var selectedItemUnitName = [].obs;
  var selectedItemQuantity = [].obs;
  var selectedItemDiscount = [].obs;
  var selectedItemTaxRate = [].obs;
  var selectedItemDescription = [].obs;
  var selectedItemAmount = [].obs;

  DataModel? getEstimateData;
  BusinessInfoModel? getBusinessData;
  ClientModel? getClientData;
  SignatureModel? getSignatureData;
  TermModel? getTACData;
  PaymentModel? getPaymentData;

  final List locale = [
    {'name': 'ENGLISH', 'locale': const Locale('en', 'US')},
    {'name': 'Deutsch', 'locale': const Locale('de', 'DE')},
    {'name': 'Français', 'locale': const Locale('fr', 'FR')},
    {'name': 'Española', 'locale': const Locale('es', 'ES')},
    {'name': 'हिंदी', 'locale': const Locale('hi', 'IN')},
    {'name': 'Indonesia', 'locale': const Locale('id', 'ID')},
  ];

  Rx<bool> isBannerAdReady = false.obs;
  late BannerAd bannerAd;

  @override
  void onInit() async {
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

    if(AppSingletons.isEditEstimate.value){
      estimateDbHelper = DBHelper();

      await getEstimateDataForEdit(AppSingletons.estimateIdWhichWillEdit.value);

      estimateNumberController.text = AppSingletons.estNumberId?.value.toString() ?? '';
      poController.text = AppSingletons.estPoNumber?.value ?? '';
      titleNameController.text = AppSingletons.estTitle?.value ?? '';

    } else {
      String? estimateNumber;
      estimateNumber = 'EST${generateUniqueId()}';
      estimateDbHelper = DBHelper();
      AppSingletons.estNumberId?.value = estimateNumber.toString();
      estimateNumberController.text = AppSingletons.estNumberId?.value ?? '';
      AppSingletons.estDueDate.value = DateTime.parse(DateTime.now().add(Duration(days: dueTermValue.value)).obs.toString());
      loadItemData();

      isLoadingDefaultValues.value = true;

      Timer(const Duration(seconds: 1), () {
        getDefaultValues();
      });

      debugPrint('Making New Estimate Started');
    }

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

  Future<void> onSave() async {
    AppSingletons.estNumberId?.value = estimateNumberController.text;
    AppSingletons.estTitle?.value = titleNameController.text;
    AppSingletons.estPoNumber?.value = poController.text;

    Get.back();
  }

  String generateUniqueId() {
    Random random = Random();
    String characters = '0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ';
    String id = '';
    for (var i = 0; i < 5; i++) {
      id += characters[random.nextInt(characters.length)];
    }
    return id;
  }

  Future loadItemData() async {
    debugPrint('Function called');

    selectedItemNames.clear();
    selectedItemPrice.clear();
    selectedItemUnitName.clear();
    selectedItemQuantity.clear();
    selectedItemDiscount.clear();
    selectedItemTaxRate.clear();
    selectedItemDescription.clear();
    selectedItemAmount.clear();

    debugPrint('List length ${selectedItemNames.length}');

    isLoading.value = true;

    AppSingletons.estSubTotal?.value = 0;
    AppSingletons.estFinalPriceTotal?.value = 0;
    int disAmount = 0;
    int subDFromB = 0;
    int txAmount = 0;
    int shippingCost = 0;

    selectedItemNames.assignAll(AppSingletons().itemsNameList);
    selectedItemPrice.assignAll(AppSingletons().itemsPriceList);
    selectedItemUnitName.assignAll(AppSingletons().itemUnitList);
    selectedItemQuantity.assignAll(AppSingletons().itemsQuantityList);
    selectedItemDiscount.assignAll(AppSingletons().itemsDiscountList);
    selectedItemTaxRate.assignAll(AppSingletons().itemsTaxesList);
    selectedItemDescription.assignAll(AppSingletons().itemDescriptionList);
    selectedItemAmount.assignAll(AppSingletons().itemsAmountList);

    debugPrint('List length after: ${selectedItemNames.length}');

    for (String price in selectedItemAmount) {
      int dPrice = int.parse(price);
      AppSingletons.estSubTotal?.value += dPrice;

    }

    disAmount = int.parse(AppSingletons.estDiscountAmount.value);

    subDFromB = AppSingletons.estSubTotal?.value ?? 0;

    txAmount = int.parse(AppSingletons.estTaxAmount.value);

    shippingCost = int.parse(AppSingletons.estShippingCost.value);

    AppSingletons.estFinalPriceTotal?.value = subDFromB + txAmount + shippingCost - disAmount;

    debugPrint('Total Price: ${AppSingletons.estSubTotal?.value}');
    debugPrint('tax Price: ${AppSingletons.estTaxAmount.value}');
    debugPrint('discount Price: ${AppSingletons.estDiscountAmount.value}');
    debugPrint('shipping Price: ${AppSingletons.estShippingCost.value}');

    isLoading.value = false;
  }

  Future<void> calculateNumberOfEstimates() async{

    int checkNumberOfEstimatesMadeAlready = SharedPreferencesManager.getValue('noOfEstimatesMadeAlready') ?? 0;

    int afterIncreaseByOneEST = checkNumberOfEstimatesMadeAlready + 1;

    SharedPreferencesManager.setValue('noOfEstimatesMadeAlready', afterIncreaseByOneEST);

    AppSingletons.noOfEstimatesMadeAlready.value = afterIncreaseByOneEST;

    debugPrint('NewNoOfEstimates: ${AppSingletons.noOfEstimatesMadeAlready.value}');
  }

  Future<void> minusDiscountAmount() async {
    debugPrint('minusDiscount called');

    double percentage = 0;
    double discount = 0.0;
    int discountR = 0;
    int taxAmount = 0;
    int shippingCost = 0;
    int calculatedResult = 0;

    if(discountHeading.value == 'Discount %'){
      percentage = double.tryParse(AppSingletons.estDiscountPercentage?.value ?? '0.0') ?? 0.0;
      discount = (percentage / 100) * AppSingletons.estSubTotal!.value;

      debugPrint('minusDiscount P: $percentage');
      debugPrint('minusDiscount D: $discount');

      discountR = discount.toInt();

      AppSingletons.estDiscountAmount.value = discountR.toString();
    } else {
      discountR = int.parse(AppSingletons.estDiscountAmount.value);
    }

    debugPrint('minusDiscount DR: $discountR');

    taxAmount = int.parse(AppSingletons.estTaxAmount.value);

    shippingCost = int.tryParse(AppSingletons.estShippingCost.value) ?? 0;

    calculatedResult = AppSingletons.estSubTotal!.value - discountR + taxAmount + shippingCost;

    AppSingletons.estFinalPriceTotal?.value = calculatedResult;

    debugPrint('Result after Disc: ${AppSingletons.estFinalPriceTotal?.value}');
  }

  Future<void> addTaxInAmount() async {
    debugPrint('AddTax called');

    double percentage = 0.0;
    double taxCalculation = 0.0;
    int taxCalculationR = 0;
    int calculationResult = 0;
    int discountAmount = 0;
    int shippingCost = 0;
    int amountToWhichAddTax = 0;

    if(taxRateHeading.value == 'Tax %'){
      percentage = double.tryParse(AppSingletons.estTaxPercentage?.value ?? '0.0') ?? 0.0;

      int disAMou = int.parse(AppSingletons.estDiscountAmount.value);

      amountToWhichAddTax = (AppSingletons.estSubTotal?.value ?? 0) - disAMou;

      taxCalculation = (percentage / 100) * amountToWhichAddTax;

      taxCalculationR = taxCalculation.toInt();

      AppSingletons.estTaxAmount.value = taxCalculationR.toString();
    } else{
      taxCalculationR = int.parse(AppSingletons.estTaxAmount.value);
    }

    discountAmount = int.parse(AppSingletons.estDiscountAmount.value);

    shippingCost = int.tryParse(AppSingletons.estShippingCost.value) ?? 0;

    calculationResult = AppSingletons.estSubTotal!.value + taxCalculationR + shippingCost - discountAmount;

    debugPrint('Tax Added: $calculationResult');

    AppSingletons.estFinalPriceTotal?.value = calculationResult;

    debugPrint('Result after Tax: ${AppSingletons.estFinalPriceTotal?.value}');
  }

  Future<void> addShippingCostInAmount() async {

    int subTotal = AppSingletons.estSubTotal?.value ?? 0;
    int taxAmount = int.tryParse(AppSingletons.estTaxAmount.value) ?? 0;
    int discAmount = int.tryParse(AppSingletons.estDiscountAmount.value) ?? 0;
    int shippingCost = int.tryParse(AppSingletons.estShippingCost.value) ?? 0;

    AppSingletons.estFinalPriceTotal?.value = subTotal + taxAmount + shippingCost - discAmount;
  }

  void selectCurrency(Currency currency) {
    selectedCurrency.value = currency;
    AppSingletons.estCurrencyNameINV?.value = currency.symbol.toString();
    AppSingletons.estDefaultCurrencyNameINV?.value = currency.symbol.toString();
    debugPrint('Currency symbol: ${AppSingletons.estCurrencyNameINV?.value}');
  }

  void startDate(DateTime date) {
    AppSingletons.estCreationDate.value = date;
  }

  void endDate(DateTime endDate) {
    AppSingletons.estDueDate.value = endDate;
  }

  Future<void> saveDataInEstimate() async {
    if(AppSingletons.estTemplateIdINV.value.isEmpty){
      Utils().snackBarMsg('Template', 'Must be added');
    } else if (AppSingletons.estBusinessNameINV?.value.isEmpty ?? true) {
      Utils().snackBarMsg('Business', 'Must be selected');
    } else if (AppSingletons.estClientNameINV?.value.isEmpty ?? true) {
      Utils().snackBarMsg('Client', 'Must be selected');
    } else if (AppSingletons().itemsNameList.isEmpty) {
      Utils().snackBarMsg('Items', 'Please add items');
    }
    // else if (AppSingletons.estSignatureImgINV!.value.isEmpty) {
    //   Utils().snackBarMsg('Signature', 'Please add signature');
    // }
    // else if (AppSingletons.estTermAndConditionINV!.value.isEmpty) {
    //   Utils().snackBarMsg('Add Terms and Conditions', '');
    // } else if (AppSingletons.estPaymentMethodINV!.value.isEmpty) {
    //   Utils().snackBarMsg('Please add payment method', '');
    // }
    else {
      try {
        DataModel estimateDataModel = DataModel(
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
            unlockTempIdsList: AppSingletons().unlockedTempIdsList.toList(),
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
            documentStatus: AppConstants.pending,
            partiallyPaidAmount: '');

        await estimateDbHelper!.insertEstimate(estimateDataModel);
        Get.offNamed(Routes.savedPdfView);

        // Future.delayed(const Duration(milliseconds: 100), () {
        //   Get.find<BottomNavController>().changePage(1);
        // });
        await setDefaultValues();

        await calculateNumberOfEstimates();

        debugPrint('Data saving in estimate');

        estimateNumberController.dispose();
        poController.dispose();
        titleNameController.dispose();
      } catch (e) {
        debugPrint('Error $e');
      }
    }
  }

  Future<void> getEstimateDataForEdit(int estimateIdToEdit) async {
    try {
      getEstimateData = DataModel();

      getEstimateData = await estimateDbHelper!.getSingleEstimateById(estimateIdToEdit);

      AppSingletons.estTitle?.value = getEstimateData!.titleName.toString();
      AppSingletons.estCreationDate.value = DateTime.parse(getEstimateData!.creationDate.toString());
      AppSingletons.estDueDate.value = DateTime.parse(getEstimateData!.dueDate.toString());
      AppSingletons.estTemplateIdINV.value = getEstimateData!.selectedTemplateId.toString();
      AppSingletons.estPoNumber?.value = getEstimateData!.purchaseOrderNo.toString();
      AppSingletons.estNumberId?.value = getEstimateData!.uniqueNumber.toString();
      AppSingletons.estLanguageName?.value = getEstimateData!.languageName.toString();
      AppSingletons.estDiscountAmount.value = getEstimateData!.discountInTotal.toString();
      AppSingletons.estTaxAmount.value = getEstimateData!.taxInTotal.toString();
      AppSingletons.estCurrencyNameINV?.value = getEstimateData!.currencyName.toString();
      AppSingletons.estFinalPriceTotal?.value = int.parse(getEstimateData!.finalNetTotal.toString());
      AppSingletons.estSubTotal?.value = int.parse(getEstimateData!.subTotal.toString());
      AppSingletons.estBusinessLogoImg.value = getEstimateData!.businessLogoImg ?? Uint8List(0);
      shippingCostControl.text = getEstimateData!.shippingCost.toString();
      AppSingletons().itemsNameList.assignAll(getEstimateData!.itemNames ?? []);
      AppSingletons().itemsDiscountList.assignAll(getEstimateData!.itemsDiscountList ?? []);
      AppSingletons().itemsAmountList.assignAll(getEstimateData!.itemsAmountList ?? []);
      AppSingletons().itemsPriceList.assignAll(getEstimateData!.itemsPriceList ?? []);
      AppSingletons().itemsTaxesList.assignAll(getEstimateData!.itemsTaxesList ?? []);
      AppSingletons().itemsQuantityList.assignAll(getEstimateData!.itemsQuantityList ?? []);
      AppSingletons().itemUnitList.assignAll(getEstimateData!.itemsUnitList ?? []);
      AppSingletons().unlockedTempIdsList.assignAll(getEstimateData!.unlockTempIdsList ?? ['0','1']);
      AppSingletons().itemDescriptionList.assignAll(getEstimateData!.itemsDescriptionList ?? []);
      AppSingletons.estClientNameINV?.value = getEstimateData?.clientName.toString() ?? '';
      AppSingletons.estClientEmailINV?.value = getEstimateData?.clientEmail.toString() ?? '';
      AppSingletons.estClientPhoneNumberINV?.value = getEstimateData?.clientPhoneNumber.toString() ?? '';
      AppSingletons.estClientBillingAddressINV?.value = getEstimateData?.clientBillingAddress.toString() ?? '';
      AppSingletons.estClientShippingAddressINV?.value = getEstimateData?.clientShippingAddress.toString() ?? '';
      AppSingletons.estClientDetailINV?.value = getEstimateData?.clientDetail.toString() ?? '';
      AppSingletons.estBusinessNameINV?.value = getEstimateData?.businessName.toString() ?? '';
      AppSingletons.estBusinessEmailINV?.value = getEstimateData?.businessEmail.toString() ?? '';
      AppSingletons.estBusinessPhoneNumberINV?.value = getEstimateData?.businessPhoneNumber.toString() ?? '';
      AppSingletons.estBusinessBillingAddressINV?.value = getEstimateData?.businessBillingAddress.toString() ?? '';
      AppSingletons.estBusinessWebsiteINV?.value = getEstimateData?.businessWebsite.toString() ?? '';
      AppSingletons.estSignatureImgINV?.value = getEstimateData?.signatureImg ?? Uint8List(0);
      AppSingletons.estTermAndConditionINV?.value = getEstimateData?.termAndCondition.toString() ?? '';
      AppSingletons.estPaymentMethodINV?.value = getEstimateData?.paymentMethod.toString() ?? '';
      AppSingletons.estDiscountPercentage?.value = getEstimateData?.discountPercentage.toString() ?? '';
      AppSingletons.estTaxPercentage?.value = getEstimateData?.taxPercentage.toString() ?? '';
      AppSingletons.estShippingCost.value = getEstimateData?.shippingCost.toString() ?? '';
      AppSingletons.estimateStatus.value = getEstimateData?.documentStatus.toString() ?? '';

      await loadItemData();

      debugPrint('Template id stored: ${getEstimateData?.selectedTemplateId}');
    } catch (e) {
      debugPrint('Error $e');
    }
  }

  Future<void> editEstimateData() async {
    if(AppSingletons.estTemplateIdINV.value.isEmpty){
      Utils().snackBarMsg('Template', 'Must be added');
    } else if (AppSingletons.estBusinessNameINV?.value.isEmpty ?? true) {
      Utils().snackBarMsg('Business', 'Must be selected');
    } else if (AppSingletons.estClientNameINV?.value.isEmpty ?? true) {
      Utils().snackBarMsg('Client', 'Must be selected');
    } else if (AppSingletons().itemsNameList.isEmpty) {
      Utils().snackBarMsg('Items', 'Please add items');
    }
    // else if (AppSingletons.estSignatureImgINV!.value.isEmpty) {
    //   Utils().snackBarMsg('Signature', 'Please add signature');
    // }
    // else if (AppSingletons.estTermAndConditionINV!.value.isEmpty) {
    //   Utils().snackBarMsg('Add Terms and Conditions', '');
    // } else if (AppSingletons.estPaymentMethodINV!.value.isEmpty) {
    //   Utils().snackBarMsg('Please add payment method', '');
    // }
    else {
      try {

        DataModel invoiceDataModel = DataModel(
            id: AppSingletons.estimateIdWhichWillEdit.value,
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
            unlockTempIdsList: AppSingletons().unlockedTempIdsList.toList(),
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
            partiallyPaidAmount: '');

        await estimateDbHelper!.updateEstimate(invoiceDataModel).then((value) {
          Get.offNamedUntil(Routes.savedPdfView, (route) => route.isFirst);
          Get.find<PdfPreviewController>().onInit();

          // Future.delayed(const Duration(milliseconds: 100), () {
          //   Get.find<BottomNavController>().changePage(1);
          // });
          debugPrint('Data edited in invoice');
        }).onError((error, stackTrace) {
          debugPrint('Error: $error');
        });

        estimateNumberController.dispose();
        poController.dispose();
        titleNameController.dispose();

        clearData();
      } catch (e) {
        debugPrint('Error: $e');
      }
    }
  }

  Future<void> clearData() async {
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
  }

  Future<void> setDefaultValues() async{

    debugPrint('Default values SET method called');
    debugPrint('BID: ${AppSingletons.estDefaultBusinessId?.value}');
    // debugPrint('CID: ${ AppSingletons.estDefaultClientId?.value}');
    debugPrint('TACID:${AppSingletons.estDefaultTermAndCId?.value}');
    debugPrint('PMID: ${AppSingletons.estDefaultPaymentMethodId?.value}');
    debugPrint('SIGID ${AppSingletons.estDefaultSignatureId?.value}');

    SharedPreferencesManager.setValue('setDefaultBusinessId_EST', AppSingletons.estDefaultBusinessId?.value);
    // SharedPreferencesManager.setValue('setDefaultClientId_EST', AppSingletons.estDefaultClientId?.value);
    SharedPreferencesManager.setValue('setDefaultTermAndCId_EST', AppSingletons.estDefaultTermAndCId?.value);
    SharedPreferencesManager.setValue('setDefaultPaymentMethodId_EST', AppSingletons.estDefaultPaymentMethodId?.value);
    SharedPreferencesManager.setValue('setDefaultSignatureId_EST', AppSingletons.estDefaultSignatureId?.value);
    SharedPreferencesManager.setValue('setDefaultCurrency_EST', AppSingletons.estDefaultCurrencyNameINV?.value);
    SharedPreferencesManager.setValue('setDefaultLanguageName_EST', AppSingletons.estDefaultLanguageName?.value);
    SharedPreferencesManager.setValue('setDefaultTemplateID_EST', AppSingletons.estTemplateIdINV.value);
  }

  Future<void> getDefaultValues() async {

    debugPrint('Default values GET method called');

    getBusinessData = BusinessInfoModel();
    getClientData = ClientModel();
    getSignatureData = SignatureModel();
    getTACData = TermModel();
    getPaymentData = PaymentModel();

    int? estDefaultBusinessId = SharedPreferencesManager.getValue('setDefaultBusinessId_EST');
    // int? estDefaultClientId = SharedPreferencesManager.getValue('setDefaultClientId_EST');
    int? estDefaultSignatureId = SharedPreferencesManager.getValue('setDefaultSignatureId_EST');
    int? estDefaultTermAndCId = SharedPreferencesManager.getValue('setDefaultTermAndCId_EST');
    int? estDefaultPaymentMId = SharedPreferencesManager.getValue('setDefaultPaymentMethodId_EST');
    String? currencySymbol = SharedPreferencesManager.getValue('setDefaultCurrency_EST');
    String? languageName = SharedPreferencesManager.getValue('setDefaultLanguageName_EST');
    // String? defaultTemplateId = SharedPreferencesManager.getValue('setDefaultTemplateID_EST');

    AppSingletons.estDefaultBusinessId?.value = estDefaultBusinessId ?? 0;
    AppSingletons.estDefaultTermAndCId?.value = estDefaultTermAndCId ?? 0;
    AppSingletons.estDefaultPaymentMethodId?.value = estDefaultPaymentMId ?? 0;
    AppSingletons.estDefaultSignatureId?.value = estDefaultSignatureId ?? 0;
    AppSingletons.estDefaultCurrencyNameINV?.value = currencySymbol ?? 'Rs';
    AppSingletons.estDefaultLanguageName?.value = languageName ?? 'English';
    // AppSingletons.estTemplateIdINV.value = defaultTemplateId ?? '0';

    try {
      AppSingletons.estLanguageName?.value = languageName ?? 'English';
      AppSingletons.estCurrencyNameINV?.value = currencySymbol ?? 'Rs';
      // AppSingletons.estTemplateIdINV.value = defaultTemplateId ?? '0';
      // var selectedLocale = const Locale('en', 'US');
      // if (AppSingletons.estLanguageName?.value == 'Deutsch') {
      //   selectedLocale = const Locale('de', 'DE');
      // }
      // else if (AppSingletons.estLanguageName?.value == 'Española') {
      //   selectedLocale = const Locale('es', 'ES');
      // }
      // else if (AppSingletons.estLanguageName?.value == 'Français') {
      //   selectedLocale = const Locale('fr', 'FR');
      // }
      // else if (AppSingletons.estLanguageName?.value == 'हिंदी') {
      //   selectedLocale = const Locale('hi', 'IN');
      // }
      // else if (AppSingletons.estLanguageName?.value == 'Indonesia') {
      //   selectedLocale = const Locale('id', 'ID');
      // }
      // else {
      //   selectedLocale = const Locale('en', 'US');
      // }
      // AppSingletons.estSelectedLocale_2?.value = selectedLocale;
      // Get.updateLocale(selectedLocale);
      // debugPrint('Stored Locale: $selectedLocale');
    } catch(e){
      debugPrint('Error for name in EST: $e');
    }

    try{
      if(estDefaultBusinessId != null){
        getBusinessData = await estimateDbHelper!.getBusinessInfoById(estDefaultBusinessId);

        AppSingletons.estBusinessNameINV?.value = getBusinessData!.businessName ?? '';
        AppSingletons.estBusinessEmailINV?.value = getBusinessData!.businessEmail ?? '';
        AppSingletons.estBusinessPhoneNumberINV?.value = getBusinessData!.businessPhoneNo ?? '';
        AppSingletons.estBusinessBillingAddressINV?.value = getBusinessData!.businessBillingOne ?? '';
        AppSingletons.estBusinessWebsiteINV?.value = getBusinessData!.businessWebsite ?? '';
        AppSingletons.estBusinessLogoImg.value = getBusinessData!.businessLogoImg ?? Uint8List(0);
      }
    }catch(e){
      debugPrint('Error for Default Business in EST: $e');
    }

    // try{
    //   if(estDefaultClientId != null){
    //     getClientData = await estimateDbHelper!.getClientById(estDefaultClientId);
    //     AppSingletons.estClientNameINV?.value = getClientData!.clientName ?? '';
    //     AppSingletons.estClientEmailINV?.value = getClientData!.clientEmailAddress?? '';
    //     AppSingletons.estClientPhoneNumberINV?.value = getClientData!.clientPhoneNo ?? '';
    //     AppSingletons.estClientBillingAddressINV?.value = getClientData!.firstBillingAddress?? '';
    //     AppSingletons.estClientShippingAddressINV?.value = getClientData!.firstShippingAddress ?? '';
    //     AppSingletons.estClientDetailINV?.value = getClientData!.clientDetail ?? '';
    //   }
    // }catch(e){
    //   debugPrint('Error for Default Client in EST: $e');
    // }

    try{
      if(estDefaultSignatureId != null){
        getSignatureData = await estimateDbHelper!.getSignatureById(estDefaultSignatureId);
        AppSingletons.estSignatureImgINV?.value = getSignatureData!.pngBytes ?? Uint8List(0);
      }
    }catch(e){
      debugPrint('Error for Default Signature in EST: $e');
    }

    try{
      if(estDefaultTermAndCId != null){
        getTACData = await estimateDbHelper!.getTermById(estDefaultTermAndCId);
        AppSingletons.estTermAndConditionINV?.value = getTACData!.tcDetail ?? '';
      }
    }catch(e){
      debugPrint('Error for Default TAC in EST: $e');
    }

    try{
      if(estDefaultPaymentMId != null) {
        getPaymentData = await estimateDbHelper!.getPaymentById(estDefaultPaymentMId);
        AppSingletons.estPaymentMethodINV?.value  = getPaymentData!.paymentMethod ?? '';
      }
    }catch(e){
      debugPrint('Error for Default PayM in EST: $e');
    }

    isLoadingDefaultValues.value = false;

  }

  Future<void> addItemQuantity(int index) async {

    String itemPri = AppSingletons().itemsPriceList[index];
    String itemQua = AppSingletons().itemsQuantityList[index];
    String itemDis = AppSingletons().itemsDiscountList[index];
    String itemTax = AppSingletons().itemsTaxesList[index];

    int? itemPrice = int.tryParse(itemPri) ?? 0;
    int? itemQuantity = int.tryParse(itemQua) ?? 0;
    int? itemDiscount = int.tryParse(itemDis) ?? 0;
    int? itemTaxRate = int.tryParse(itemTax) ?? 0;

    int addQuantity = itemQuantity + 1;

    double calculatedAmount = (itemPrice * addQuantity) -
        ((itemPrice * addQuantity) * (itemDiscount / 100)) +  // Here add tex rate will be updated
        ((itemPrice * addQuantity) * (itemTaxRate / 100));

    AppSingletons().itemsQuantityList[index] = addQuantity.toString();
    AppSingletons().itemsAmountList[index] = calculatedAmount.toStringAsFixed(0);

    loadItemData();
  }

  Future<void> subtractItemQuantity(int index) async {
    String itemPri = AppSingletons().itemsPriceList[index];
    String itemQua = AppSingletons().itemsQuantityList[index];
    String itemDis = AppSingletons().itemsDiscountList[index];
    String itemTax = AppSingletons().itemsTaxesList[index];

    int? itemPrice = int.tryParse(itemPri) ?? 0;
    int? itemQuantity = int.tryParse(itemQua) ?? 0;
    int? itemDiscount = int.tryParse(itemDis) ?? 0;
    int? itemTaxRate = int.tryParse(itemTax) ?? 0;

    if(itemQuantity > 1){
      int addQuantity = itemQuantity - 1;

      double calculatedAmount = (itemPrice * addQuantity) -
          ((itemPrice * addQuantity) * (itemDiscount / 100)) +  // Here add tex rate will be updated
          ((itemPrice * addQuantity) * (itemTaxRate / 100));

      AppSingletons().itemsQuantityList[index] = addQuantity.toString();
      AppSingletons().itemsAmountList[index] = calculatedAmount.toStringAsFixed(0);

      loadItemData();
    }
  }

  @override
  void onClose() {
    selectedItemNames.clear();
    selectedItemPrice.clear();
    selectedItemUnitName.clear();
    selectedItemQuantity.clear();
    selectedItemTaxRate.clear();
    selectedItemDiscount.clear();
    selectedItemDescription.clear();
    selectedItemAmount.clear();
    super.onClose();
  }

}