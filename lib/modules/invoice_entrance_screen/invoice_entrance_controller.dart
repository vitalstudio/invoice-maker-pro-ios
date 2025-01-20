import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';
import 'package:currency_picker/currency_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import '../../core/services/ads_controller.dart';
import '../../core/preferenceManager/sharedPreferenceManager.dart';
import '../../core/services/ads_helper.dart';
import '../../model/client_model.dart';
import '../../model/company_model.dart';
import '../../model/payment_model.dart';
import '../../model/signature_model.dart';
import '../../model/termAndCondition_model.dart';
import '../../modules/home_screen/home_controller.dart';
import '../../core/constants/app_constants/App_Constants.dart';
import '../../core/app_singletons/app_singletons.dart';
import '../../core/utils/utils.dart';
import '../../database/database_helper.dart';
import '../../model/data_model.dart';
import '../../core/routes/routes.dart';
import '../pdf_preview/pdf_preview_controller.dart';

class InvoiceEntranceController extends GetxController with AdsControllerMixin {
  var numberEnter = ''.obs;
  DBHelper? invoiceDbHelper;
  RxBool isLoading = false.obs;
  RxBool isLoadingDefaultValues = false.obs;

  RxString discountHeading = 'Discount %'.obs;
  RxString taxRateHeading = 'Tax %'.obs;

  TextEditingController invoiceNumberController = TextEditingController();
  TextEditingController titleNameController = TextEditingController();
  TextEditingController poController = TextEditingController();
  TextEditingController discountInTotalControl = TextEditingController();
  TextEditingController discFlatAmountController = TextEditingController();
  TextEditingController taxInTotalControl = TextEditingController();
  TextEditingController taxFlatAmountController = TextEditingController();
  TextEditingController shippingCostControl = TextEditingController();

  FocusNode discPercentageFocusNode = FocusNode();
  FocusNode discFlatAmountFocusNode = FocusNode();

  FocusNode taxPercentageFocusNode = FocusNode();
  FocusNode taxFlatAmountFocusNode = FocusNode();

  final HomeController homeController = Get.put(HomeController());

  final RxInt dueTermValue = 7.obs;
  Rx<Currency?> selectedCurrency = Rx<Currency?>(null);
  var selectedItemNames = [].obs;
  var selectedItemPrice = [].obs;
  var selectedItemUnitName = [].obs;
  var selectedItemQuantity = [].obs;
  var selectedItemDiscount = [].obs;
  var selectedItemTaxRate = [].obs;
  var selectedItemDescription = [].obs;
  var selectedItemAmount = [].obs;

  RxString nameOfItem = ''.obs;
  RxString priceOfItem = ''.obs;
  RxString unitNameOfItem = ''.obs;
  RxString quantityOfItem = ''.obs;
  RxString discountOfItem = ''.obs;
  RxString taxRateOfItem = ''.obs;
  RxString descriptionOfItem = ''.obs;
  RxString amountOfItem = ''.obs;

  DataModel? getInvoiceData;
  BusinessInfoModel? getBusinessData;
  ClientModel? getClientData;
  SignatureModel? getSignatureData;
  TermModel? getTACData;
  PaymentModel? getPaymentData;

  String? invoiceNumber;
  String? defaultBussName;
  String? defaultBussEmail;
  String? defaultBussPHNumber;
  String? defaultBussBillingAddress;
  String? defaultBussWeb;
  Uint8List? defaultBussLOGO;

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

    debugPrint('isUserEditingInvoice: ${AppSingletons.isEditInvoice.value}');

    if (AppSingletons.isEditInvoice.value) {
      invoiceDbHelper = DBHelper();
      await getInvoiceDataForEdit(AppSingletons.invoiceIdWhichWillEdit.value);
      invoiceNumberController.text = AppSingletons.invoiceNumberId?.value.toString() ?? '';
      poController.text = AppSingletons.poNumber?.value ?? '';
      titleNameController.text = AppSingletons.invoiceTitle?.value ?? '';
      debugPrint('Editing Invoice Started');
    }
    else {

      loadItemData();

      isLoadingDefaultValues.value = true;

      Timer(const Duration(seconds: 3), () {

        invoiceNumber = 'INV${generateUniqueId()}';
        invoiceDbHelper = DBHelper();
        AppSingletons.invoiceNumberId?.value = invoiceNumber.toString();
        invoiceNumberController.text = AppSingletons.invoiceNumberId?.value ?? '';
        debugPrint('Random ID: ${AppSingletons.invoiceNumberId?.value}');
        debugPrint('Creation Date: ${AppSingletons.creationDate.value}');
        debugPrint('Due Date: ${AppSingletons.dueDate.value}');
        AppSingletons.dueDate.value = DateTime.parse(
            AppSingletons.creationDate.value
                .add(Duration(days: dueTermValue.value))
                .obs.toString());

        getDefaultValues();
      });

      debugPrint('Making New Invoice Started');
    }
    super.onInit();
  }

  final List locale = [
    {'name': 'ENGLISH', 'locale': const Locale('en', 'US')},
    {'name': 'Deutsch', 'locale': const Locale('de', 'DE')},
    {'name': 'Français', 'locale': const Locale('fr', 'FR')},
    {'name': 'Española', 'locale': const Locale('es', 'ES')},
    {'name': 'हिंदी', 'locale': const Locale('hi', 'IN')},
    {'name': 'Indonesia', 'locale': const Locale('id', 'ID')},
  ];

  void startDate(DateTime date) {
    // creationDate.value = date;
    AppSingletons.creationDate.value = date;
  }

  void endDate(DateTime endDate) {
    // dueDate.value = endDate;
    AppSingletons.dueDate.value = endDate;
  }

  void selectCurrency(Currency currency) {
    selectedCurrency.value = currency;
    AppSingletons.currencyNameINV?.value = currency.symbol.toString();
    AppSingletons.invDefaultCurrencyNameINV?.value = currency.symbol.toString();
    debugPrint('Currency symbol: ${AppSingletons.currencyNameINV?.value}');
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

  Future<void> onSave() async {
    AppSingletons.invoiceNumberId?.value = invoiceNumberController.text;
    AppSingletons.invoiceTitle?.value = titleNameController.text;
    AppSingletons.poNumber?.value = poController.text;

    Get.back();
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

    AppSingletons.subTotal?.value = 0;
    AppSingletons.finalPriceTotal?.value = 0;
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
      AppSingletons.subTotal?.value += dPrice;
      // AppSingletons.finalPriceTotal?.value += dPrice;
    }

    disAmount = int.parse(AppSingletons.discountAmount.value);

    subDFromB = AppSingletons.subTotal?.value ?? 0;

    txAmount = int.parse(AppSingletons.taxAmount.value);

    shippingCost = int.parse(AppSingletons.shippingCost.value);

    AppSingletons.finalPriceTotal?.value = subDFromB + txAmount + shippingCost - disAmount;

    debugPrint('Total Price: ${AppSingletons.subTotal?.value}');
    debugPrint('tax Price: ${AppSingletons.taxAmount.value}');
    debugPrint('discount Price: ${AppSingletons.discountAmount.value}');
    debugPrint('shipping Price: ${AppSingletons.shippingCost.value}');

    isLoading.value = false;

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
      percentage = double.tryParse(AppSingletons.discountPercentage?.value ?? '0.0') ?? 0.0;
      discount = (percentage / 100) * AppSingletons.subTotal!.value;
      debugPrint('minusDiscount P: $percentage');
      debugPrint('minusDiscount D: $discount');
      discountR = discount.toInt();
      AppSingletons.discountAmount.value = discountR.toString();
    }
    else{
      discountR = int.parse(AppSingletons.discountAmount.value);
    }

    debugPrint('minusDiscount DR: $discountR');

    taxAmount = int.parse(AppSingletons.taxAmount.value);

    shippingCost = int.tryParse(AppSingletons.shippingCost.value) ?? 0;

    calculatedResult = AppSingletons.subTotal!.value - discountR + taxAmount + shippingCost;

    AppSingletons.finalPriceTotal?.value = calculatedResult;

    debugPrint('Result after Disc: ${AppSingletons.finalPriceTotal?.value}');
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
      percentage = double.tryParse(AppSingletons.taxPercentage?.value ?? '0.0') ?? 0.0;

      int disAMou = int.parse(AppSingletons.discountAmount.value);

      amountToWhichAddTax = (AppSingletons.subTotal?.value ?? 0) - disAMou;

      debugPrint('amountToWhichAddTax =  ${AppSingletons.subTotal?.value ?? 0 } - $disAMou = $amountToWhichAddTax');

      // taxCalculation = (percentage / 100) * AppSingletons.finalPriceTotal!.value;

      taxCalculation = (percentage / 100) * amountToWhichAddTax;

      taxCalculationR = taxCalculation.toInt();

      AppSingletons.taxAmount.value = taxCalculationR.toString();
    } else {
      taxCalculationR = int.parse(AppSingletons.taxAmount.value);
    }


    discountAmount = int.parse(AppSingletons.discountAmount.value);

    shippingCost = int.tryParse(AppSingletons.shippingCost.value) ?? 0;

    calculationResult = AppSingletons.subTotal!.value + taxCalculationR + shippingCost - discountAmount;

    debugPrint('Tax Added: $calculationResult');

    AppSingletons.finalPriceTotal?.value = calculationResult;

    debugPrint('Result after Tax: ${AppSingletons.finalPriceTotal?.value}');
  }

  Future<void> addShippingCostInAmount() async {

    int subTotal = AppSingletons.subTotal?.value ?? 0;
    int taxAmount = int.tryParse(AppSingletons.taxAmount.value) ?? 0;
    int discAmount = int.tryParse(AppSingletons.discountAmount.value) ?? 0;
    int shippingCost = int.tryParse(AppSingletons.shippingCost.value) ?? 0;

    AppSingletons.finalPriceTotal?.value = subTotal + taxAmount + shippingCost - discAmount;
  }

  Future<void> calculateNumberOfInvoices() async{
    int checkNumberOfInvoicesMadeAlready = SharedPreferencesManager.getValue('noOfInvoicesMadeAlready') ?? 0;
    int afterIncreaseByOneINV = checkNumberOfInvoicesMadeAlready + 1;
    SharedPreferencesManager.setValue('noOfInvoicesMadeAlready', afterIncreaseByOneINV);
    AppSingletons.noOfInvoicesMadeAlready.value = afterIncreaseByOneINV;
    debugPrint('NewNoOfInvoices: $afterIncreaseByOneINV');
    debugPrint('NewNoOfInvoices: ${AppSingletons.noOfInvoicesMadeAlready.value}');
  }

  Future<void> saveDataInInvoice() async {
    if(AppSingletons.invoiceTemplateIdINV.value.isEmpty){
      Utils().snackBarMsg('Template', 'Must be added');
    } else if (AppSingletons.businessNameINV?.value.isEmpty ?? true) {
      Utils().snackBarMsg('Business', 'Must be selected');
    } else if (AppSingletons.clientNameINV?.value.isEmpty ?? true) {
      Utils().snackBarMsg('Client', 'Must be selected');
    } else if (AppSingletons().itemsNameList.isEmpty) {
      Utils().snackBarMsg('Items', 'Please add items');
    }
    // else if (AppSingletons.signatureImgINV!.value.isEmpty) {
    //   Utils().snackBarMsg('Signature', 'Please add signature');
    // }
    // else if (AppSingletons.termAndConditionINV!.value.isEmpty) {
    //   Utils().snackBarMsg('Add Terms and Conditions', '');
    // } else if (AppSingletons.paymentMethodINV!.value.isEmpty) {
    //   Utils().snackBarMsg('Please add payment method', '');
    // }
    else {
      try {
        DataModel invoiceDataModel = DataModel(
            titleName: AppSingletons.invoiceTitle?.value ?? '',
            purchaseOrderNo: AppSingletons.poNumber?.value ?? '',
            uniqueNumber: AppSingletons.invoiceNumberId?.value ?? '',
            languageName: AppSingletons.languageName?.value ?? 'English',
            selectedTemplateId: AppSingletons.invoiceTemplateIdINV.value,
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
            unlockTempIdsList: AppSingletons().unlockedTempIdsList.toList(),
            currencyName: AppSingletons.currencyNameINV?.value ?? 'Rs',
            finalNetTotal: AppSingletons.finalPriceTotal?.value.toString() ?? '',
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
            signatureImg: AppSingletons.signatureImgINV?.value ?? Uint8List(0),
            termAndCondition: AppSingletons.termAndConditionINV?.value ?? '',
            taxPercentage: AppSingletons.taxPercentage?.value ?? '0',
            discountPercentage: AppSingletons.discountPercentage?.value ?? '0',
            subTotal: AppSingletons.subTotal?.value.toString() ?? '',
            documentStatus: AppConstants.unpaidInvoice,
            partiallyPaidAmount: '');

        await invoiceDbHelper!.insertInvoice(invoiceDataModel);
        Get.offNamed(Routes.savedPdfView);
        debugPrint('Data saving in invoice');

        await setDefaultValues();

        await calculateNumberOfInvoices();

        invoiceNumberController.dispose();
        poController.dispose();
        titleNameController.dispose();
      } catch (e) {
        debugPrint('Error $e');
      }
    }
  }

  Future<void> getInvoiceDataForEdit(int invoiceIdToEdit) async {
    try {
      getInvoiceData = DataModel();

      getInvoiceData = await invoiceDbHelper!.getSingleInvoiceById(invoiceIdToEdit);

      AppSingletons.invoiceTitle?.value = getInvoiceData!.titleName.toString();
      AppSingletons.creationDate.value = DateTime.parse(getInvoiceData!.creationDate.toString());
      AppSingletons.dueDate.value = DateTime.parse(getInvoiceData!.dueDate.toString());
      AppSingletons.invoiceTemplateIdINV.value = getInvoiceData!.selectedTemplateId.toString();
      AppSingletons.poNumber?.value = getInvoiceData!.purchaseOrderNo.toString();
      AppSingletons.invoiceNumberId?.value = getInvoiceData!.uniqueNumber.toString();
      AppSingletons.languageName?.value = getInvoiceData!.languageName.toString();
      AppSingletons.discountAmount.value = getInvoiceData!.discountInTotal.toString();
      AppSingletons.taxAmount.value = getInvoiceData!.taxInTotal.toString();
      AppSingletons.currencyNameINV?.value = getInvoiceData!.currencyName.toString();
      AppSingletons.finalPriceTotal?.value = int.parse(getInvoiceData!.finalNetTotal.toString());
      AppSingletons.subTotal?.value = int.parse(getInvoiceData!.subTotal.toString());
      AppSingletons.businessLogoImg.value = getInvoiceData!.businessLogoImg ?? Uint8List(0);
      shippingCostControl.text = getInvoiceData!.shippingCost.toString();
      AppSingletons().itemsNameList.assignAll(getInvoiceData!.itemNames ?? []);
      AppSingletons().itemsDiscountList.assignAll(getInvoiceData!.itemsDiscountList ?? []);
      AppSingletons().itemsAmountList.assignAll(getInvoiceData!.itemsAmountList ?? []);
      AppSingletons().itemsPriceList.assignAll(getInvoiceData!.itemsPriceList ?? []);
      AppSingletons().itemsTaxesList.assignAll(getInvoiceData!.itemsTaxesList ?? []);
      AppSingletons().itemsQuantityList.assignAll(getInvoiceData!.itemsQuantityList ?? []);
      AppSingletons().itemUnitList.assignAll(getInvoiceData!.itemsUnitList ?? []);
      AppSingletons().itemDescriptionList.assignAll(getInvoiceData!.itemsDescriptionList ?? []);
      AppSingletons.clientNameINV?.value = getInvoiceData?.clientName.toString() ?? '';
      AppSingletons.clientEmailINV?.value = getInvoiceData?.clientEmail.toString() ?? '';
      AppSingletons.clientPhoneNumberINV?.value = getInvoiceData?.clientPhoneNumber.toString() ?? '';
      AppSingletons.clientBillingAddressINV?.value = getInvoiceData?.clientBillingAddress.toString() ?? '';
      AppSingletons.clientShippingAddressINV?.value = getInvoiceData?.clientShippingAddress.toString() ?? '';
      AppSingletons.clientDetailINV?.value = getInvoiceData?.clientDetail.toString() ?? '';
      AppSingletons.businessNameINV?.value = getInvoiceData?.businessName.toString() ?? '';
      AppSingletons.businessEmailINV?.value = getInvoiceData?.businessEmail.toString() ?? '';
      AppSingletons.businessPhoneNumberINV?.value = getInvoiceData?.businessPhoneNumber.toString() ?? '';
      AppSingletons.businessBillingAddressINV?.value = getInvoiceData?.businessBillingAddress.toString() ?? '';
      AppSingletons.businessWebsiteINV?.value = getInvoiceData?.businessWebsite.toString() ?? '';
      AppSingletons.signatureImgINV?.value = getInvoiceData?.signatureImg ?? Uint8List(0);
      AppSingletons.termAndConditionINV?.value = getInvoiceData?.termAndCondition.toString() ?? '';
      AppSingletons.paymentMethodINV?.value = getInvoiceData?.paymentMethod.toString() ?? '';
      AppSingletons.discountPercentage?.value = getInvoiceData?.discountPercentage.toString() ?? '';
      AppSingletons.taxPercentage?.value = getInvoiceData?.taxPercentage.toString() ?? '';
      AppSingletons.shippingCost.value = getInvoiceData?.shippingCost.toString() ?? '';
      AppSingletons.invoiceStatus.value = getInvoiceData?.documentStatus.toString() ?? '';
      AppSingletons.partialPaymentAmount?.value = getInvoiceData?.partiallyPaidAmount ?? '';
      AppSingletons().unlockedTempIdsList.assignAll(getInvoiceData?.unlockTempIdsList ?? ['0','1']);

      await loadItemData();

      debugPrint('Template id stored: ${getInvoiceData?.selectedTemplateId}');
    } catch (e) {
      debugPrint('Error $e');
    }
  }

  Future<void> editInvoiceData() async {
    if(AppSingletons.invoiceTemplateIdINV.value.isEmpty){
      Utils().snackBarMsg('Template', 'Must be added');
    } else if (AppSingletons.businessNameINV?.value.isEmpty ?? true) {
      Utils().snackBarMsg('Business', 'Must be selected');
    }
    else if (AppSingletons.clientNameINV!.value.isEmpty) {
      Utils().snackBarMsg('Client', 'Must be selected');
    }
    else if (AppSingletons().itemsNameList.isEmpty) {
      Utils().snackBarMsg('Items', 'Please add items');
    }
    // else if (AppSingletons.signatureImgINV!.value.isEmpty) {
    //   Utils().snackBarMsg('Signature', 'Please add signature');
    // }
    // else if (AppSingletons.termAndConditionINV!.value.isEmpty) {
    //   Utils().snackBarMsg('Add Terms and Conditions', '');
    // } else if (AppSingletons.paymentMethodINV!.value.isEmpty) {
    //   Utils().snackBarMsg('Please add payment method', '');
    // }
    else {
      try {
       DataModel invoiceDataModel = DataModel(
            id: AppSingletons.invoiceIdWhichWillEdit.value,
            titleName: AppSingletons.invoiceTitle?.value ?? '',
            purchaseOrderNo: AppSingletons.poNumber?.value ?? '',
            uniqueNumber: AppSingletons.invoiceNumberId?.value ?? '',
            languageName: AppSingletons.languageName?.value ?? '',
            selectedTemplateId: AppSingletons.invoiceTemplateIdINV.value,
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
            unlockTempIdsList: AppSingletons().unlockedTempIdsList.toList(),
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
            documentStatus: AppSingletons.invoiceStatus.value,
            partiallyPaidAmount: AppSingletons.partialPaymentAmount?.value ?? '');

        await invoiceDbHelper!.updateInvoice(invoiceDataModel).then((value) {
          Get.offNamedUntil(Routes.savedPdfView, (route) => route.isFirst);
          Get.find<PdfPreviewController>().onInit();
          debugPrint('Data edited in invoice');
        }).onError((error, stackTrace) {
          debugPrint('Error: $error');
        });

        invoiceNumberController.dispose();
        poController.dispose();
        titleNameController.dispose();

        clearData();
      } catch (e) {
        debugPrint('Error: $e');
      }
    }
  }

  Future<void> clearData() async {
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
  }

  Future<void> setDefaultValues() async{

    debugPrint('Default values SET method called');

    await SharedPreferencesManager.setValue('setDefaultBusinessId_INV', AppSingletons.invDefaultBusinessId?.value);
    // SharedPreferencesManager.setValue('setDefaultClientId_INV', AppSingletons.invDefaultClientId?.value);
    await SharedPreferencesManager.setValue('setDefaultTermAndCId_INV', AppSingletons.invDefaultTermAndCId?.value);
    await SharedPreferencesManager.setValue('setDefaultPaymentMethodId_INV', AppSingletons.invDefaultPaymentMethodId?.value);
    await SharedPreferencesManager.setValue('setDefaultSignatureId_INV', AppSingletons.invDefaultSignatureId?.value);
    await SharedPreferencesManager.setValue('setDefaultCurrency_INV', AppSingletons.invDefaultCurrencyNameINV?.value);
    await SharedPreferencesManager.setValue('setDefaultLanguageName_INV', AppSingletons.invDefaultLanguageName?.value);
    // await SharedPreferencesManager.setValue('setDefaultTemplateID_INV', AppSingletons.invoiceTemplateIdINV.value);

    debugPrint('Default SETTLED VALUE: ${ AppSingletons.invoiceTemplateIdINV.value}');

  }

  Future<void> getDefaultValues() async {

    debugPrint('Default values GET method called');

    invoiceDbHelper = DBHelper();

    getBusinessData = BusinessInfoModel();
    getClientData = ClientModel();
    getSignatureData = SignatureModel();
    getTACData = TermModel();
    getPaymentData = PaymentModel();

    int? invDefaultBusinessId = await SharedPreferencesManager.getValue('setDefaultBusinessId_INV');
    // int? invDefaultClientId = SharedPreferencesManager.getValue('setDefaultClientId_INV');
    int? invDefaultSignatureId = await SharedPreferencesManager.getValue('setDefaultSignatureId_INV');
    int? invDefaultTermAndCId = await SharedPreferencesManager.getValue('setDefaultTermAndCId_INV');
    int? invDefaultPaymentMId = await SharedPreferencesManager.getValue('setDefaultPaymentMethodId_INV');
    String? currencySymbol = await SharedPreferencesManager.getValue('setDefaultCurrency_INV');
    String? languageName = await SharedPreferencesManager.getValue('setDefaultLanguageName_INV');
    // String? defaultTemplateId = await SharedPreferencesManager.getValue('setDefaultTemplateID_INV');

    AppSingletons.invDefaultBusinessId?.value = invDefaultBusinessId ?? 0;
    AppSingletons.invDefaultTermAndCId?.value = invDefaultTermAndCId ?? 0;
    AppSingletons.invDefaultPaymentMethodId?.value = invDefaultPaymentMId ?? 0;
    AppSingletons.invDefaultSignatureId?.value = invDefaultSignatureId ?? 0;
    AppSingletons.invDefaultCurrencyNameINV?.value = currencySymbol ?? 'Rs';
    AppSingletons.invDefaultLanguageName?.value = languageName ?? 'English';
    // AppSingletons.invoiceTemplateIdINV.value = defaultTemplateId ?? '0';

    debugPrint('Default TEMP : ${SharedPreferencesManager.getValue('setDefaultTemplateID_INV')}');
    debugPrint('Default BID : ${SharedPreferencesManager.getValue('setDefaultBusinessId_INV')}');
    debugPrint('Default SID : ${SharedPreferencesManager.getValue('setDefaultSignatureId_INV')}');
    debugPrint('Default TID : ${SharedPreferencesManager.getValue('setDefaultTermAndCId_INV')}');
    debugPrint('Default PID : ${SharedPreferencesManager.getValue('setDefaultPaymentMethodId_INV')}');
    debugPrint('Default LANG : ${SharedPreferencesManager.getValue('setDefaultLanguageName_INV')}');
    debugPrint('Default CURR : ${SharedPreferencesManager.getValue('setDefaultCurrency_INV')}');

    try {
      AppSingletons.languageName?.value = languageName ?? 'English';
      AppSingletons.currencyNameINV?.value = currencySymbol ?? 'Rs';
      // AppSingletons.invoiceTemplateIdINV.value = defaultTemplateId ?? '0';

      debugPrint('Default Values 2: ${AppSingletons.invoiceTemplateIdINV.value}');

      var selectedLocale = const Locale('en', 'US');
      if (AppSingletons.languageName?.value == 'Deutsch') {
        selectedLocale = const Locale('de', 'DE');
      }
      else if (AppSingletons.languageName?.value == 'Española') {
        selectedLocale = const Locale('es', 'ES');
      }
      else if (AppSingletons.languageName?.value == 'Français') {
        selectedLocale = const Locale('fr', 'FR');
      }
      else if (AppSingletons.languageName?.value == 'हिंदी') {
        selectedLocale = const Locale('hi', 'IN');
      }
      else if (AppSingletons.languageName?.value == 'Indonesia') {
        selectedLocale = const Locale('id', 'ID');
      }
      else {
        selectedLocale = const Locale('en', 'US');
      }
      AppSingletons.selectedLocale_2?.value = selectedLocale;
      Get.updateLocale(selectedLocale);
      debugPrint('Stored Locale: $selectedLocale');
    } catch(e){
      debugPrint('Error for name in INV: $e');
    }

    try{
      if(invDefaultBusinessId != null){
        getBusinessData = await invoiceDbHelper!.getBusinessInfoById(invDefaultBusinessId);

        AppSingletons.businessNameINV?.value = getBusinessData!.businessName ?? '';
        AppSingletons.businessEmailINV?.value = getBusinessData!.businessEmail ?? '';
        AppSingletons.businessPhoneNumberINV?.value = getBusinessData!.businessPhoneNo ?? '';
        AppSingletons.businessBillingAddressINV?.value = getBusinessData!.businessBillingOne ?? '';
        AppSingletons.businessWebsiteINV?.value = getBusinessData!.businessWebsite ?? '';
        AppSingletons.businessLogoImg.value = getBusinessData!.businessLogoImg ?? Uint8List(0);
      }
    }catch(e){
      debugPrint('Error for Default Business in INV: $e');
    }

    // try{
    //   if(invDefaultClientId != null){
    //     getClientData = await invoiceDbHelper!.getClientById(invDefaultClientId);
    //     AppSingletons.clientNameINV?.value = getClientData!.clientName ?? '';
    //     AppSingletons.clientEmailINV?.value = getClientData!.clientEmailAddress?? '';
    //     AppSingletons.clientPhoneNumberINV?.value = getClientData!.clientPhoneNo ?? '';
    //     AppSingletons.clientBillingAddressINV?.value = getClientData!.firstBillingAddress?? '';
    //     AppSingletons.clientShippingAddressINV?.value = getClientData!.firstShippingAddress ?? '';
    //     AppSingletons.clientDetailINV?.value = getClientData!.clientDetail ?? '';
    //   }
    // }catch(e){
    //   debugPrint('Error for Default Client in INV: $e');
    // }

    try{
      if(invDefaultSignatureId != null){
        getSignatureData = await invoiceDbHelper!.getSignatureById(invDefaultSignatureId);
        AppSingletons.signatureImgINV?.value = getSignatureData!.pngBytes ?? Uint8List(0);
      }
    }catch(e){
      debugPrint('Error for Default Signature in INV: $e');
    }

    try{
      if(invDefaultTermAndCId != null){
        getTACData = await invoiceDbHelper!.getTermById(invDefaultTermAndCId);
        AppSingletons.termAndConditionINV?.value = getTACData!.tcDetail ?? '';
      }
    }catch(e){
      debugPrint('Error for Default TAC in INV: $e');
    }

    try{
      if(invDefaultPaymentMId != null) {
        getPaymentData = await invoiceDbHelper!.getPaymentById(invDefaultPaymentMId);
        AppSingletons.paymentMethodINV?.value  = getPaymentData!.paymentMethod ?? '';
      }
    }catch(e){
      debugPrint('Error for Default PayM in INV: $e');
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

  void showAd() {
    adsControllerService.showInterstitialAd();
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
