import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import '../../core/services/ads_helper.dart';
import '../../modules/estimate_entrance/estimate_entrance_controller.dart';
import '../../modules/invoice_entrance_screen/invoice_entrance_controller.dart';
import '../../core/app_singletons/app_singletons.dart';
import '../../database/database_helper.dart';
import '../../model/item_model.dart';

class ItemScreenController extends GetxController{

  DBHelper? itemDbHelper;
  RxList<ItemModel> itemList = <ItemModel>[].obs;
  RxList<ItemModel> filteredItemList = <ItemModel>[].obs;

  TextEditingController searchItemController = TextEditingController();

  // final invoiceEntranceController = Get.put(InvoiceEntranceController());

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

    itemDbHelper = DBHelper();
    loadData();

    searchItemController.addListener(_filterList);
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

  void updateKeyboardVisibility(bool isKeyboardVisible) {
    AppSingletons.isKeyboardVisible.value = isKeyboardVisible;
  }

  void selectAllItems() {
    for (var item in filteredItemList) {
        item.isChecked.value = true;
        AppSingletons.isSelectedAll.value = true;
    }
  }
  void deSelectAllItems() {
    for (var item in filteredItemList) {
      item.isChecked.value = false;
      AppSingletons.isSelectedAll.value = false;
    }
  }

  RxBool isLoadingData = false.obs;

  Future<void> loadData() async {

    try{
      isLoadingData.value = true;

      final list = await itemDbHelper!.getItemList();

      debugPrint('Item List first: ${list.length}');

      itemList.assignAll(list);

      debugPrint('Item List: ${itemList.length}');

      filteredItemList.assignAll(list);

      debugPrint('Filtered Item List: ${filteredItemList.length}');

      isLoadingData.value = false;
    } catch(e){
      isLoadingData.value = false;
      debugPrint('Error: $e');
    }
  }

  void _filterList() {
    String query = searchItemController.text.toLowerCase();
    if (query.isEmpty) {
      filteredItemList.value = itemList;
    } else {
      filteredItemList.value =  itemList.where((itemsData){
        bool matchesItemName = itemsData.itemName != null && itemsData.itemName!.toLowerCase().contains(query);

        return matchesItemName;
      }).toList();
    }
  }

  Future<void> addingItemsInInvoice(
      String? itemName,
      String? itemAmount,
      String? itemDiscount,String? itemPrice,String? itemQuantity,String? itemTaxes,
      String? itemUnitName,String? itemDescription) async{

    AppSingletons().addItemNameList(itemName ?? '');
    AppSingletons().addItemAmountList(itemAmount ?? '--');
    AppSingletons().addItemDiscountList(itemDiscount ?? '--');
    AppSingletons().addItemPriceList(itemPrice ?? '--');
    AppSingletons().addItemQuantityList(itemQuantity ?? '--');
    AppSingletons().addItemTaxesList(itemTaxes ?? '--');
    AppSingletons().addItemUnitList(itemUnitName ?? '--');
    AppSingletons().addItemDescriptionList(itemDescription ?? '--');

    if(AppSingletons.isInvoiceDocument.value){
      // invoiceEntranceController.loadItemData();
      Get.find<InvoiceEntranceController>().loadItemData();
    } else {
      Get.find<EstimateEntranceController>().loadItemData();
    }
    Get.back();

  }

  void deleteItem(int id) async {
    await itemDbHelper!.deleteItem(id);
    itemList.removeWhere((element) => element.id == id);
  }
  void clearList() async {
    await itemDbHelper!.deleteAllItem();
    itemList.clear();
  }

}