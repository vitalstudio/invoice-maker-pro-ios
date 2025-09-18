import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import '../../core/services/ads_helper.dart';
import '../../modules/estimate_entrance/estimate_entrance_controller.dart';
import '../../modules/invoice_entrance_screen/invoice_entrance_controller.dart';
import '../../modules/item_list_screen/item_screen_controller.dart';
import '../../core/app_singletons/app_singletons.dart';
import '../../database/database_helper.dart';
import '../../model/item_model.dart';

class AddItemController extends GetxController{
   RxInt indexId = 0.obs;

   TextEditingController itemNameController = TextEditingController();
   TextEditingController itemPriceController = TextEditingController();
   TextEditingController itemUnitToMeasureController = TextEditingController();
   TextEditingController itemDiscountController = TextEditingController();
   TextEditingController itemDescriptionController = TextEditingController();
   TextEditingController itemTextRateController = TextEditingController();
   TextEditingController itemQuantityController = TextEditingController();

   DBHelper? itemDbHelper;

   RxInt itemIdToEditInvoice = 0.obs;

   RxInt itemPrice = 0.obs;
   RxInt quantity = 0.obs;
   RxInt discount = 0.obs;
   RxInt textValue = 0.obs;
   RxInt totalPrice = 0.obs;


   final RxBool isTextEmpty = true.obs;

   final itemScreenListController = Get.put(ItemScreenController());

   Rx<bool> isBannerAdReady = false.obs;
   late BannerAd bannerAd;

   @override
  void onInit() {
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
     itemNameController.addListener(_checkTextEmpty);
     itemPriceController.addListener(calculateResult);
     itemQuantityController.addListener(calculateResult);
     itemDiscountController.addListener(calculateResult);
     itemTextRateController.addListener(calculateResult);

     itemDbHelper = DBHelper();

     debugPrint('ISEditItem: ${AppSingletons.isEditingItemDataFromInvoice.value}');

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

  @override
  void onReady() {
    if(AppSingletons.isEditingItemDataFromInvoice.value){
      getArgumentToEditInvoice();
    } else if(AppSingletons().isEditingItemInfo){
      getItemInfoTOEdit();
    } else if(AppSingletons.isAddNewItemInINVEST == false && !AppSingletons().isComingFromBottomBar){
      getItemInfoTOEdit();
      if(AppSingletons.isEditingItemDataFromInvoice.value != true){
        itemQuantityController.text = '1';
      }
    } else{
      itemQuantityController.text = '1';
    }
    super.onReady();
  }

   void _checkTextEmpty() {
     isTextEmpty.value = itemNameController.text.isEmpty;
   }

   void calculateResult() {
     // Get values from text controllers
     itemPrice.value = int.tryParse(itemPriceController.text) ?? 0;
     quantity.value = int.tryParse(itemQuantityController.text) ?? 0;
     discount.value = int.tryParse(itemDiscountController.text) ?? 0;
     textValue.value = int.tryParse(itemTextRateController.text) ?? 0;

     // Extract values from Rx variables
     int itemPriceValue = itemPrice.value;
     int quantityValue = quantity.value;
     int discountValue = discount.value;
     int textValueValue = textValue.value;

     // Calculate result as per your formula

     RxDouble calculatedValue = 0.0.obs;
     calculatedValue.value = (itemPriceValue * quantityValue) -
         ((itemPriceValue * quantityValue) * (discountValue / 100)) +  // Here add tex rate will be updated
         ((itemPriceValue * quantityValue) * (textValueValue / 100));

     totalPrice.value =  calculatedValue.value.toInt();

   }

   void saveItemData() async {
     debugPrint('NEW Item saved');
     final itemModel = ItemModel(
       itemName: itemNameController.text,
       itemPrice: itemPriceController.text,
       itemDetail:itemDescriptionController.text,
       unitToMeasure: itemUnitToMeasureController.text,
       // itemDiscount: itemDiscountController.text,
       // itemTaxRate: itemTextRateController.text,
       // itemQuantity: itemQuantityController.text,
       // itemFinalAmount: totalPrice.value.toString(),
     );

     debugPrint('Item Model which will be added: $itemModel');

     try {
       await itemDbHelper!.insertItem(itemModel);
       itemScreenListController.loadData();

       debugPrint('Data added successfully');

     } catch (e) {
       debugPrint('Failed to save item data: $e');
     }

     // itemDbHelper!.insertItem(itemModel);
     // itemScreenListController.loadData();
   }

   void getItemInfoTOEdit() async{
     Map<String,dynamic> itemInfo = Get.arguments;

     String? itemPrice = itemInfo['itemPrice'] ?? '';
     String? itemUnit = itemInfo['unitToMeasure'] ?? '';
     String? itemDescription = itemInfo['itemDetail'] ?? '';

     indexId.value = itemInfo['indexId'];
     itemNameController.text = itemInfo['itemName'];
     itemPriceController.text = itemPrice ?? '';
     itemUnitToMeasureController.text = itemUnit ?? '';
     itemDescriptionController.text = itemDescription ?? '';

     debugPrint('IndexId: ${indexId.value}');

   }

  Future<void> editItemInfo(
      int indexId,
      String itemName,
      String itemPrice,
      String unitToMeasure,
      // String itemDiscount,
      // String itemQuantity,
      // String itemTextRate,
      // String itemPriceTotal,
      String itemDescription,

      )  async {

    ItemModel itemModelToEdit = ItemModel(
      id: indexId,
      itemDetail: itemDescription,
      itemName: itemName,
      itemPrice: itemPrice,
      unitToMeasure: unitToMeasure,
      // itemDiscount: itemDiscount,
      // itemQuantity: itemQuantity,
      // itemTaxRate: itemTextRate,
      // itemFinalAmount: itemPriceTotal
    );

    await itemDbHelper!.updateItem(itemModelToEdit);
    itemScreenListController.loadData();
  }

  Future<void> addingItemsInInvoice(
      String? itemName,
      String? itemAmount,
      String? itemDiscount,
      String? itemPrice,
      String? itemQuantity,
      String? itemTaxes,
      String? itemUnitName,
      String? itemDescription) async{

     AppSingletons().addItemNameList(itemName ?? '');
     AppSingletons().addItemAmountList(itemAmount ?? '--');
     AppSingletons().addItemDiscountList(itemDiscount ?? '--');
     AppSingletons().addItemPriceList(itemPrice ?? '--');
     AppSingletons().addItemQuantityList(itemQuantity ?? '--');
     AppSingletons().addItemTaxesList(itemTaxes ?? '--');
     AppSingletons().addItemUnitList(itemUnitName ?? '--');
     AppSingletons().addItemDescriptionList(itemDescription ?? '--');

     if(AppSingletons.isInvoiceDocument.value){
       Get.find<InvoiceEntranceController>().loadItemData();
     } else{
       Get.find<EstimateEntranceController>().loadItemData();
     }
  }

   @override
  void onClose() {
    itemNameController.dispose();
    itemPriceController.dispose();
    itemUnitToMeasureController.dispose();
    itemQuantityController.dispose();
    itemDiscountController.dispose();
    itemTextRateController.dispose();
    itemDescriptionController.dispose();
    super.onClose();
  }

  void getArgumentToEditInvoice() async {
     final arguments = Get.arguments;

     itemIdToEditInvoice.value = arguments['indexId'];
     itemNameController.text = arguments['itemName'];
     itemPriceController.text = arguments['itemPrice'];
     itemUnitToMeasureController.text = arguments['itemUnit'];
     itemQuantityController.text = arguments['itemQuantity'];
     itemDiscountController.text = arguments['itemDiscount'];
     itemTextRateController.text = arguments['itemTaxRate'];
     itemDescriptionController.text = arguments['itemDescription'];

     debugPrint('Received ID: ${arguments['indexId']}');

  }

  void editItemFromInvoiceItemList(int index) {
      AppSingletons().itemsNameList[index] = itemNameController.text;
      AppSingletons().itemsPriceList[index] = itemPriceController.text;
      AppSingletons().itemUnitList[index] = itemUnitToMeasureController.text;
      AppSingletons().itemsQuantityList[index] = itemQuantityController.text;
      AppSingletons().itemsDiscountList[index] = itemDiscountController.text;
      AppSingletons().itemsTaxesList[index] = itemTextRateController.text;
      AppSingletons().itemDescriptionList[index] = itemDescriptionController.text;
      AppSingletons().itemsAmountList[index] = totalPrice.value.toString();

      AppSingletons.isEditingItemDataFromInvoice.value = false;

      if(AppSingletons.isInvoiceDocument.value){
        Get.find<InvoiceEntranceController>().loadItemData();
      } else {
        Get.find<EstimateEntranceController>().loadItemData();
      }

      Get.back();

  }

  void deleteItemFromInvoiceItemList(int index) {
    AppSingletons().itemsNameList.removeAt(index);
    AppSingletons().itemsPriceList.removeAt(index);
    AppSingletons().itemUnitList.removeAt(index);
    AppSingletons().itemsQuantityList.removeAt(index);
    AppSingletons().itemsDiscountList.removeAt(index);
    AppSingletons().itemsTaxesList.removeAt(index);
    AppSingletons().itemDescriptionList.removeAt(index);
    AppSingletons().itemsAmountList.removeAt(index);

    AppSingletons.isEditingItemDataFromInvoice.value = false;

    debugPrint('Item deleted from invoice');

    if(AppSingletons.isInvoiceDocument.value){
      Get.find<InvoiceEntranceController>().loadItemData();
    } else {
      Get.find<EstimateEntranceController>().loadItemData();
    }

    Get.back();
  }

}