import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:image_picker/image_picker.dart';
import '../../core/services/ads_controller.dart';
import '../../core/services/ads_helper.dart';
import '../../core/utils/utils.dart';
import '../../core/app_singletons/app_singletons.dart';
import '../../database/database_helper.dart';
import '../../model/company_model.dart';
import '../../modules/business_info_list/business_list_controller.dart';

class BusinessInfoController extends GetxController with AdsControllerMixin{

  DBHelper? dbBusinessInfo;

  RxInt indexId = 0.obs;

  Rx<Uint8List> businessLogoImg = Rx<Uint8List>(Uint8List(0));

  TextEditingController businessNameController = TextEditingController();
  TextEditingController emailAddressController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController billAddressONEController = TextEditingController();
  TextEditingController businessWebsiteController = TextEditingController();

  final businessListController = Get.put(BusinessListController());

  final picker = ImagePicker();
  final Rx<XFile?> _image = Rx<XFile?>(null);

  set image(XFile? value) => _image.value = value;

  XFile? get image => _image.value;

  final RxBool isTextEmpty = true.obs;

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

    dbBusinessInfo = DBHelper();

    businessNameController.addListener(_checkControllerEmpty);

    if(AppSingletons().isEditingBusinessInfo) {
      getArgumentData();
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

    isTextEmpty.value = businessNameController.text.isEmpty;
  }

  Future<void> editBusinessInfo() async {
    BusinessInfoModel businessInfoModel = BusinessInfoModel(
      id: indexId.value,
      businessName: businessNameController.text,
      businessEmail: emailAddressController.text,
      businessPhoneNo: phoneController.text,
      businessBillingOne: billAddressONEController.text,
      businessWebsite: businessWebsiteController.text,
      businessLogoImg: businessLogoImg.value
    );

    await dbBusinessInfo!.updateBusinessInfo(businessInfoModel);
    Get.back();
    businessListController.loadData();
  }

  Future<void> saveData() async {
    BusinessInfoModel businessInfoModel = BusinessInfoModel(
      businessBillingOne: billAddressONEController.text,
      businessEmail: emailAddressController.text,
      businessName:  businessNameController.text,
      businessPhoneNo:  phoneController.text,
      businessWebsite: businessWebsiteController.text,
      businessLogoImg: businessLogoImg.value
    );

    await dbBusinessInfo!.insertBusinessInfo(businessInfoModel);

    businessListController.loadData();

  }

  Future<void> getArgumentData() async {
    Map<String,dynamic> businessInfoData = Get.arguments;
    indexId.value = businessInfoData['indexId'];

    businessNameController.text = businessInfoData['businessName'];
    emailAddressController.text = businessInfoData['businessEmail'];
    phoneController.text = businessInfoData['businessPhoneNo'];
    billAddressONEController.text = businessInfoData['businessBillAddress'];
    businessWebsiteController.text = businessInfoData['businessWebsite'];
    businessLogoImg.value = businessInfoData['businessLogoImg'];

    debugPrint('IndexId: ${indexId.value}');

  }

  @override
  void onClose() {
    businessNameController.dispose();
    emailAddressController.dispose();
    phoneController.dispose();
    billAddressONEController.dispose();
    businessWebsiteController.dispose();
    super.onClose();
  }

  Future pickGalleryImage(BuildContext context) async {
    final pickedImage = await picker.pickImage(source: ImageSource.gallery, imageQuality: 100);

    if (pickedImage != null) {

      final file = File(pickedImage.path);
      final fileSizeInBytes = await file.length();
      final fileSizeInMB = fileSizeInBytes / (1024 * 1024);

      if(fileSizeInMB<= 2.1){

        _image.value = XFile(pickedImage.path);

        businessLogoImg.value = await _image.value!.readAsBytes();

        if(businessLogoImg.value.isNotEmpty){
          debugPrint('Image pick successfully');
          debugPrint('Image picked: ${pickedImage.path}');
        } else{
          debugPrint('Error in picking image');
        }
      } else{
        // debugPrint('File size should not be greater then 2.1 MB');

        Utils().snackBarMsg('Larger image size', 'Maximum of 2.1 MB sized image can be uploaded');

      }
    }
  }

  void showAd() {
    adsControllerService.showInterstitialAd();
  }

}