import 'dart:typed_data';
import 'dart:ui';
import 'package:get/get.dart';
import '../../core/constants/app_constants/App_Constants.dart';

class AppSingletons{
  static final AppSingletons _appSingletons = AppSingletons._internal();

  factory AppSingletons() => _appSingletons;

  AppSingletons._internal();

  static RxBool isSelectedAll = false.obs;

  static RxString storedInvoiceCurrency = 'Rs'.obs;

  static RxInt lastPDFID = 0.obs;

  static RxInt noOfInvoicesMadeAlready = 0.obs;
  static RxInt noOfEstimatesMadeAlready = 0.obs;

  static RxString shareChartDetailTitle = 'Sales Trending'.obs;
  static RxString selectedTimePeriod = AppConstants.last30days.obs;

  static RxBool androidBannerAdsEnabled = true.obs;
  static RxBool iOSBannerAdsEnabled = true.obs;

  static RxBool androidInterstitialAdsEnabled = true.obs;
  static RxBool iOSInterstitialAdsEnabled = true.obs;

  static RxBool openAppAdsAndroidEnabled = true.obs;

  static RxBool isSubscriptionEnabled = false.obs;
  static RxBool isProScreenShowed = false.obs;

  static RxString appVersionNo = ''.obs;
  static RxString appBuildNo = ''.obs;

  static RxBool isMakingNewINVEST = false.obs;

  static RxInt selectedTempIndexToCheck = 0.obs;

  static RxBool isInvoiceDocument = false.obs;

  static RxBool isEditingOnlyTemplate = false.obs;

  static RxBool isEditInvoice = false.obs;

  static RxBool isEditEstimate = false.obs;

  static RxBool isEditingItemDataFromInvoice = false.obs;

  static RxInt invoiceIdWhichWillEdit = 0.obs;

  static RxInt estimateIdWhichWillEdit = 0.obs;

  static RxString totalUnpaidInvoices = '0'.obs;

  static RxString totalOverdueInvoices = '0'.obs;

  static RxBool isPreviewingPdfBeforeSave = false.obs;

  static RxBool isPreviewEstimateDoc = false.obs;

  static RxString invoiceStatus = AppConstants.unpaidInvoice.obs;

  static RxString estimateStatus = AppConstants.pending.obs;

  static RxString? partialPaymentAmount = ''.obs;

  static RxInt selectedPlanForProInvoice = 1.obs;

  static RxBool isStartDeletingItem = false.obs;

  static RxBool isSearchingEstimate = false.obs;
  static RxBool isSearchingInvoice = false.obs;
  static RxBool isSearchingClient = false.obs;
  static RxBool isSearchingItem = false.obs;
  static RxBool isKeyboardVisible = false.obs;

  bool isEditingClientInfo = false;
  bool isEditingItemInfo = false;
  bool isEditingBusinessInfo = false;
  bool isComingFromBottomBar = false;

  static bool isAddingItemInINVEST = false;

  static bool isAddNewItemInINVEST = false;

  RxList<String> itemsIdsList = <String>[].obs;
  RxList<String> itemsNameList = <String>[].obs;
  RxList<String> itemsQuantityList = <String>[].obs;
  RxList<String> itemsPriceList = <String>[].obs;
  RxList<String> itemsDiscountList = <String>[].obs;
  RxList<String> itemsTaxesList = <String>[].obs;
  RxList<String> itemsAmountList = <String>[].obs;
  RxList<String> itemUnitList = <String>[].obs;
  RxList<String> itemDescriptionList = <String>[].obs;

  RxList<String> unlockedTempIdsList = <String>['0','1'].obs;

  RxInt templatesPageNumber = 0.obs;

  void addUnlockedTempIdsList(String addUnlockedTempID) {
    unlockedTempIdsList.add(addUnlockedTempID);
  }
  void addItemNameList(String itemName) {
    itemsNameList.add(itemName);
  }
  void addItemQuantityList(String itemQuantity) {
    itemsQuantityList.add(itemQuantity);
  }
  void addItemPriceList(String itemPrice) {
    itemsPriceList.add(itemPrice);
  }
  void addItemDiscountList(String itemDiscount) {
    itemsDiscountList.add(itemDiscount);
  }
  void addItemTaxesList(String itemTaxes) {
    itemsTaxesList.add(itemTaxes);
  }
  void addItemAmountList(String itemAmount) {
    itemsAmountList.add(itemAmount);
  }
  void addItemUnitList(String itemUnitName) {
    itemUnitList.add(itemUnitName);
  }
  void addItemDescriptionList(String itemDescription) {
    itemDescriptionList.add(itemDescription);
  }

  // Variables used for invoices

  static RxString? invoiceNumberId = ''.obs;
  static RxString? invoiceTitle = RxString('');
  static RxString? poNumber = RxString('');
  static RxString? languageName = RxString('English');
  static Rx<Locale>? selectedLocale_2 =  const Locale('en', 'US').obs;
  static Rx<DateTime> creationDate = DateTime.now().obs;
  static Rx<DateTime> dueDate = DateTime.now().obs;
  static RxString discountAmount = '0'.obs;
  static RxString? discountPercentage = RxString('');
  static RxString taxAmount = '0'.obs;
  static RxString? taxPercentage = RxString('');
  static RxString shippingCost = '0'.obs;
  static RxString? clientNameINV = RxString('');
  static RxString? clientPhoneNumberINV = RxString('');
  static RxString? clientBillingAddressINV = RxString('');
  static RxString? clientEmailINV = RxString('');
  static RxString? clientShippingAddressINV = RxString('');
  static RxString? clientDetailINV = RxString('');
  static Rx<Uint8List> businessLogoImg = Rx<Uint8List>(Uint8List(0));
  static RxString? businessNameINV = RxString('');
  static RxString? businessEmailINV = RxString('');
  static RxString? businessWebsiteINV = RxString('');
  static RxString? businessPhoneNumberINV = RxString('');
  static RxString? businessBillingAddressINV = RxString('');
  static RxString? currencyNameINV  = RxString('Rs');
  static Rx<Uint8List>? signatureImgINV = Rx<Uint8List>(Uint8List(0));
  static RxString? termAndConditionINV = RxString('');
  static RxString? paymentMethodINV = RxString('');
  static RxString invoiceTemplateIdINV = ''.obs;
  static RxInt? subTotal = RxInt(0);
  static RxInt? finalPriceTotal = RxInt(0);
  static RxString documentStatus = AppConstants.unpaidInvoice.obs;

  // Variables used for estimates

  static RxString? estNumberId = RxString('');
  static RxString? estTitle = RxString('');
  static RxString? estPoNumber = RxString('');
  static RxString? estLanguageName = RxString('English');
  static Rx<Locale>? estSelectedLocale_2 =  const Locale('en', 'US').obs;
  static Rx<DateTime> estCreationDate = DateTime.now().obs;
  static Rx<DateTime> estDueDate = DateTime.now().obs;
  static RxString estDiscountAmount = '0'.obs;
  static RxString? estDiscountPercentage = RxString('');
  static RxString estTaxAmount = '0'.obs;
  static RxString? estTaxPercentage = RxString('');
  static RxString estShippingCost = '0'.obs;
  static RxString? estClientNameINV = RxString('');
  static RxString? estClientPhoneNumberINV = RxString('');
  static RxString? estClientBillingAddressINV = RxString('');
  static RxString? estClientEmailINV = RxString('');
  static RxString? estClientShippingAddressINV = RxString('');
  static RxString? estClientDetailINV = RxString('');
  static Rx<Uint8List> estBusinessLogoImg = Rx<Uint8List>(Uint8List(0));
  static RxString? estBusinessNameINV = RxString('');
  static RxString? estBusinessEmailINV = RxString('');
  static RxString? estBusinessWebsiteINV = RxString('');
  static RxString? estBusinessPhoneNumberINV = RxString('');
  static RxString? estBusinessBillingAddressINV = RxString('');
  static RxString? estCurrencyNameINV  = RxString('Rs');
  static Rx<Uint8List>? estSignatureImgINV = Rx<Uint8List>(Uint8List(0));
  static RxString? estTermAndConditionINV = RxString('');
  static RxString? estPaymentMethodINV = RxString('');
  static RxString estTemplateIdINV = ''.obs;
  static RxInt? estSubTotal = RxInt(0);
  static RxInt? estFinalPriceTotal = RxInt(0);
  static RxString estDocumentStatus = AppConstants.pending.obs;


  // For Estimates set default value

  static RxString? estDefaultLanguageName = RxString('English');

  static RxString? estDefaultCurrencyNameINV  = RxString('Rs');
  static RxInt? estDefaultBusinessId = 0.obs;
  // static RxInt? estDefaultClientId = 0.obs;
  static RxInt? estDefaultSignatureId = 0.obs;
  static RxInt? estDefaultTermAndCId = 0.obs;
  static RxInt? estDefaultPaymentMethodId = 0.obs;

  // For Invoices set default value

  static RxString? invDefaultLanguageName = RxString('English');

  static RxString? invDefaultCurrencyNameINV  = 'Rs'.obs;
  static RxInt? invDefaultBusinessId = 0.obs;
  // static RxInt? invDefaultClientId = 0.obs;
  static RxInt? invDefaultSignatureId = 0.obs;
  static RxInt? invDefaultTermAndCId = 0.obs;
  static RxInt? invDefaultPaymentMethodId = 0.obs;

  static RxString selectedNewLanguage = AppConstants.english.obs;
  static RxString storedAppLanguage = AppConstants.english.obs;

}