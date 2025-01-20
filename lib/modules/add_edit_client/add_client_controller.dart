import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import '../../core/app_singletons/app_singletons.dart';
import '../../core/services/ads_controller.dart';
import '../../core/services/ads_helper.dart';
import '../../modules/client_list_screen/client_list_controller.dart';
import '../../database/database_helper.dart';
import '../../model/client_model.dart';

class AddClientController extends GetxController with AdsControllerMixin {
  TextEditingController clientNameController = TextEditingController();
  TextEditingController clientEmailController = TextEditingController();
  TextEditingController clientPhoneController = TextEditingController();
  TextEditingController billingAddressController = TextEditingController();

  TextEditingController shippingAddressController = TextEditingController();

  TextEditingController clientDetailController = TextEditingController();

  DBHelper? clientDbHelper;
  final RxBool isTextEmpty = true.obs;

  final clientListController = Get.put(ClientListController());

  RxInt indexId = 0.obs;

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

    clientNameController.addListener(_checkControllerEmpty);
    clientDbHelper = DBHelper();

    if(AppSingletons().isEditingClientInfo){
      getClientInfoTOEdit();
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

  void _checkControllerEmpty() {
    isTextEmpty.value = clientNameController.text.isEmpty;
  }

  void saveClientData() {
    if (!isTextEmpty.value) {
      final clientModel = ClientModel(
          clientName: clientNameController.text,
          clientEmailAddress: clientEmailController.text,
          clientPhoneNo: clientPhoneController.text,
          firstBillingAddress: billingAddressController.text,
          firstShippingAddress: shippingAddressController.text,
          clientDetail: clientDetailController.text);

      debugPrint('Client model which will be added: $clientModel');

      clientDbHelper!.insertClient(clientModel);
      clientListController.loadData();
    }

    clientNameController.clear();
    clientEmailController.clear();
    clientPhoneController.clear();
    billingAddressController.clear();
    shippingAddressController.clear();
    clientDetailController.clear();
    Get.back();
  }

  void getClientInfoTOEdit() async{
    Map<String,dynamic> clientInfo = Get.arguments;
    indexId.value = clientInfo['indexId'];

    clientNameController.text = clientInfo['clientName'];
    clientEmailController.text = clientInfo['clientEmail'];
    clientPhoneController.text = clientInfo['clientPhoneNo'];
    billingAddressController.text = clientInfo['clientBillAddress'];
    shippingAddressController.text = clientInfo['clientShipAddress'];
    clientDetailController.text = clientInfo['clientDetail'];

    debugPrint('IndexId: ${indexId.value}');

  }

  Future<void> editClientInfo(
      int indexId,
      String clientName,
      String clientEmail,
      String clientPhoneNo,
      String clientBillAddress,
      String clientShipAddress,
      String clientDetail
      )  async {

    ClientModel clientModel = ClientModel(
      id: indexId,
      clientName: clientName,
      clientEmailAddress: clientEmail,
      clientPhoneNo: clientPhoneNo,
      firstBillingAddress: clientBillAddress,
      firstShippingAddress: clientShipAddress,
      clientDetail: clientDetail
    );

   await clientDbHelper!.updateClient(clientModel);
   Get.back();
   clientListController.loadData();

  }

  @override
  void onClose() {
    clientNameController.dispose();
    clientEmailController.dispose();
    clientPhoneController.dispose();
    billingAddressController.dispose();
    shippingAddressController.dispose();
    clientDetailController.dispose();
    super.onClose();
  }

  void showAd() {
    adsControllerService.showInterstitialAd();
  }

}