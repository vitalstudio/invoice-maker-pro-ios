import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import '../../core/app_singletons/app_singletons.dart';
import '../../core/services/ads_helper.dart';
import '../../database/database_helper.dart';
import '../../model/client_model.dart';

class ClientListController extends GetxController {

  DBHelper? clientDbHelper;
  RxList<ClientModel> clientList = <ClientModel>[].obs;

  RxList<ClientModel> filteredClientList = <ClientModel>[].obs;

  RxBool isLoadingData = false.obs;

  RxInt selectedValue = 0.obs;

  TextEditingController searchClientList = TextEditingController();

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

    clientDbHelper = DBHelper();
    loadData();

    searchClientList.addListener(_filterList);

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

  Future<void> loadData() async {
    isLoadingData.value = true;
    final list = await clientDbHelper!.getClientList();
    clientList.assignAll(list);

    filteredClientList.assignAll(clientList);

    debugPrint("Client List length: ${clientList.length}");
    isLoadingData.value = false;
  }

  void selectAllClients() {
    for (var clients in filteredClientList) {
      clients.isChecked.value = true;
      AppSingletons.isSelectedAll.value = true;
    }
  }
  void deSelectAllClients() {
    for (var clients in filteredClientList) {
      clients.isChecked.value = false;
      AppSingletons.isSelectedAll.value = false;
    }
  }

  void _filterList() {
    String query = searchClientList.text.toLowerCase();
    if (query.isEmpty) {
      filteredClientList.value = clientList;
    } else {
      filteredClientList.value =  clientList.where((client){
        bool matchesClientName = client.clientName != null && client.clientName!.toLowerCase().contains(query);
        bool matchesPhoneNo = client.clientPhoneNo != null && client.clientPhoneNo!.toLowerCase().contains(query);

        return matchesClientName || matchesPhoneNo;
      }).toList();
    }
  }

  void updateKeyboardVisibility(bool isKeyboardVisible) {
    AppSingletons.isKeyboardVisible.value = isKeyboardVisible;
  }

  void deleteClient(int id) async {
    await clientDbHelper!.deleteClient(id);
    clientList.removeWhere((element) => element.id == id);
    loadData();
  }

  void deleteAllClientList() async {
    await clientDbHelper!.deleteAllClient();
    clientList.clear();
    loadData();
  }
}
