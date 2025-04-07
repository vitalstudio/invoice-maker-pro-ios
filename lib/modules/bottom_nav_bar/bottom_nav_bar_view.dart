import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../core/preferenceManager/sharedPreferenceManager.dart';
import '../../core/utils/dialogue_to_select_language.dart';
import '../../core/widgets/dialogueToDelete.dart';
import '../../core/routes/routes.dart';
import '../../core/constants/app_constants/App_Constants.dart';
import '../../modules/estimate/estimate_list_controller.dart';
import '../../modules/estimate/estimates_list_view.dart';
import '../../modules/client_list_screen/client_list_controller.dart';
import '../../modules/home_screen/home_controller.dart';
import '../../modules/item_list_screen/item_screen_controller.dart';
import '../../core/app_singletons/app_singletons.dart';
import '../../core/widgets/open_drawer_menu.dart';
import '../../../modules/item_list_screen/item_screen_view.dart';
import '../../../modules/setting_screen/setting_screen_view.dart';
import '../client_list_screen/client_list_view.dart';
import '../home_screen/home_view.dart';
import 'bottom_nav_bar_controller.dart';
import '../../core/constants/color/color.dart';

class BottomNavView extends GetView<BottomNavController> {
  BottomNavView({super.key});

  final GlobalKey<ScaffoldState> scaffoldKeyMenu = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {

    bool checkIsMobileLayout = AppConstants.isMobileScreen.value;

    final List<Widget> screens = [
      const HomeView(),
      const EstimateListView(),
      const ClientListView(),
      const ItemScreenView(),
      const SettingScreenView(),
    ];

    return checkIsMobileLayout
        ? mainMobileLayout(context, screens)
        : mainDesktopLayout(context, screens);
  }

  Widget mainMobileLayout(BuildContext context, List<Widget> screens) {
    return Scaffold(
      backgroundColor: sWhite,
      key: scaffoldKeyMenu,
      drawer: const DrawerMenuOpen(),
      appBar: AppBar(
        backgroundColor: mainPurpleColor,
        leading: IconButton(
          onPressed: () {
            scaffoldKeyMenu.currentState!.openDrawer();
          },
          icon: const Icon(
            Icons.menu,
            color: orangeLight_1,
          ),
        ),
        title: Obx(() => Text(
              controller.appBarTitleText.value,
              style: const TextStyle(
                  fontFamily: 'SFProDisplay',
                  color: orangeLight_1,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 1),
            )),
        actions: [
          Obx(() {
            if (controller.currentIndex.value == 0) {
              return Row(
                children: [
                  IconButton(
                      onPressed: () async{
                        AppSingletons.selectedNewLanguage.value = AppSingletons.storedAppLanguage.value;

                        await LanguageSelection.selectALanguage(
                            context: context,
                            titleHeading: 'SELECT APP LANGUAGE',
                            onChange: () async{
                              await LanguageSelection.updateLocale(
                                  selectedLanguage: AppSingletons.selectedNewLanguage.value
                              );
                              Get.back();

                              await SharedPreferencesManager.setValue(
                                  AppConstants.keyStoredAppLanguage,
                                  AppSingletons.selectedNewLanguage.value
                              );

                              AppSingletons.storedAppLanguage.value = AppSingletons.selectedNewLanguage.value;

                              debugPrint('StoredAppLanguage: ${AppSingletons.selectedNewLanguage.value}');

                            }
                        );

                        Get.find<HomeController>().loadInvoiceData();
                      },
                      icon: const Icon(
                        Icons.translate,
                        color: orangeLight_1,
                      )),
                  Obx(() {
                    if (AppSingletons.isSearchingInvoice.value == false) {
                      return IconButton(
                          onPressed: () {
                            AppSingletons.isSearchingInvoice.value = true;
                          },
                          icon: const Icon(
                            Icons.search,
                            color: orangeLight_1,
                          ));
                    } else {
                      return IconButton(
                          onPressed: () {
                            AppSingletons.isSearchingInvoice.value = false;
                            AppSingletons.isKeyboardVisible.value = false;

                            Get.find<HomeController>().searchController.clear();
                          },
                          icon: const Icon(
                            Icons.cancel,
                            color: orangeLight_1,
                          ));
                    }
                  }),
                  IconButton(
                      onPressed: () {
                        // if(AppSingletons.isSubscriptionEnabled.value){
                        //   Get.toNamed(Routes.chartsView);
                        // } else {
                        //   Get.toNamed(Routes.proScreenView);
                        // }
                        Get.toNamed(Routes.chartsView);
                      },
                      icon: const Icon(
                        Icons.add_chart,
                        color: orangeLight_1,
                      )),
                ],
              );
            }
            else if (controller.currentIndex.value == 1) {
              return Obx(() {
                if (AppSingletons.isSearchingEstimate.value == false) {
                  return IconButton(
                      onPressed: () {
                        AppSingletons.isSearchingEstimate.value = true;
                      },
                      icon: const Icon(
                        Icons.search,
                        color: orangeLight_1,
                      ));
                } else {
                  return IconButton(
                      onPressed: () {
                        AppSingletons.isSearchingEstimate.value = false;
                        AppSingletons.isKeyboardVisible.value = false;

                        Get.find<EstimateListController>()
                            .searchController
                            .clear();
                      },
                      icon: const Icon(
                        Icons.cancel,
                        color: orangeLight_1,
                      ));
                }
              });
            }
            else if (controller.currentIndex.value == 2) {
              return Row(
                children: [
                  Obx(() => Visibility(
                        visible:
                            AppSingletons.isStartDeletingItem.value == false &&
                                AppSingletons().isComingFromBottomBar,
                        child: IconButton(
                            onPressed: () {
                              AppSingletons.isStartDeletingItem.value = true;
                            },
                            icon: const Icon(
                              Icons.delete,
                              color: sWhite,
                            )),
                      )),
                  Obx(() => Visibility(
                        visible:
                            AppSingletons.isStartDeletingItem.value == true &&
                                AppSingletons().isComingFromBottomBar,
                        child: IconButton(
                            onPressed: () {
                              AppSingletons.isStartDeletingItem.value = false;
                            },
                            icon: const Icon(
                              Icons.cancel_rounded,
                              color: sWhite,
                            )),
                      )),
                  Obx(() => Visibility(
                        visible:
                            AppSingletons.isStartDeletingItem.value == true &&
                                AppSingletons().isComingFromBottomBar,
                        child: IconButton(
                            onPressed: () {
                              CustomDialogues.showDialogueToDelete(
                                  false,
                                  'delete_client'.tr,
                                  'are_you_sure_you_want_to_delete'.tr,
                                  'selected_clients'.tr,
                                  () => {
                                        controller.bottomDbHelper!
                                            .deleteCheckedClients(
                                                Get.find<ClientListController>()
                                                    .filteredClientList)
                                      },
                                  () => {
                                        Timer(const Duration(seconds: 2), () {
                                          Get.find<ClientListController>()
                                              .loadData();
                                        })
                                      });
                            },
                            icon: const Icon(
                              Icons.delete_sweep,
                              color: sWhite,
                            )),
                      )),
                  Obx(() => Visibility(
                        visible:
                            AppSingletons.isStartDeletingItem.value == true &&
                                AppSingletons().isComingFromBottomBar,
                        child: IconButton(
                            onPressed: () {
                              if (AppSingletons.isSelectedAll.value) {
                                Get.find<ClientListController>()
                                    .deSelectAllClients();
                              } else {
                                Get.find<ClientListController>()
                                    .selectAllClients();
                              }
                            },
                            icon: Icon(
                              AppSingletons.isSelectedAll.value
                                  ? Icons.deselect
                                  : Icons.select_all,
                              color: sWhite,
                            )),
                      )),
                  Obx(() {
                    if (AppSingletons.isSearchingClient.value == false) {
                      return Visibility(
                        visible: !AppSingletons.isStartDeletingItem.value,
                        child: IconButton(
                            onPressed: () {
                              AppSingletons.isSearchingClient.value = true;
                            },
                            icon: const Icon(
                              Icons.search,
                              color: orangeLight_1,
                            )),
                      );
                    } else {
                      return IconButton(
                          onPressed: () {
                            AppSingletons.isSearchingClient.value = false;
                            AppSingletons.isKeyboardVisible.value = false;

                            Get.find<ClientListController>()
                                .searchClientList
                                .clear();
                          },
                          icon: const Icon(
                            Icons.cancel,
                            color: orangeLight_1,
                          ));
                    }
                  }),
                ],
              );
            }
            else if (controller.currentIndex.value == 3) {
              return Row(
                children: [
                  Obx(() => Visibility(
                        visible:
                            AppSingletons.isStartDeletingItem.value == false &&
                                AppSingletons().isComingFromBottomBar,
                        child: IconButton(
                            onPressed: () {
                              AppSingletons.isStartDeletingItem.value = true;
                            },
                            icon: const Icon(
                              Icons.delete,
                              color: sWhite,
                            )),
                      )),
                  Obx(() => Visibility(
                        visible:
                            AppSingletons.isStartDeletingItem.value == true &&
                                AppSingletons().isComingFromBottomBar,
                        child: IconButton(
                            onPressed: () {
                              AppSingletons.isStartDeletingItem.value = false;
                            },
                            icon: const Icon(
                              Icons.cancel_rounded,
                              color: sWhite,
                            )),
                      )),
                  Obx(() => Visibility(
                        visible:
                            AppSingletons.isStartDeletingItem.value == true &&
                                AppSingletons().isComingFromBottomBar,
                        child: IconButton(
                            onPressed: () {
                              if (AppSingletons.isSelectedAll.value) {
                                Get.find<ItemScreenController>()
                                    .deSelectAllItems();
                              } else {
                                Get.find<ItemScreenController>()
                                    .selectAllItems();
                              }
                            },
                            icon: Icon(
                              AppSingletons.isSelectedAll.value
                                  ? Icons.deselect
                                  : Icons.select_all,
                              color: sWhite,
                            )),
                      )),
                  Obx(() => Visibility(
                        visible:
                            AppSingletons.isStartDeletingItem.value == true &&
                                AppSingletons().isComingFromBottomBar,
                        child: IconButton(
                            onPressed: () {
                              CustomDialogues.showDialogueToDelete(
                                  false,
                                  'delete_item'.tr,
                                  'are_you_sure_you_want_to_delete'.tr,
                                   'selected_items'.tr,
                                  () => {
                                        controller.bottomDbHelper!
                                            .deleteCheckedItems(
                                                Get.find<ItemScreenController>()
                                                    .filteredItemList)
                                      },
                                  () => {
                                        Timer(const Duration(seconds: 2), () {
                                          Get.find<ItemScreenController>()
                                              .loadData();
                                        })
                                      });
                            },
                            icon: const Icon(
                              Icons.delete_sweep,
                              color: sWhite,
                            )),
                      )),
                  Obx(() {
                    if (AppSingletons.isSearchingItem.value == false) {
                      return Visibility(
                        visible: !AppSingletons.isStartDeletingItem.value,
                        child: IconButton(
                            onPressed: () {
                              AppSingletons.isSearchingItem.value = true;
                            },
                            icon: const Icon(
                              Icons.search,
                              color: orangeLight_1,
                            )),
                      );
                    } else {
                      return IconButton(
                          onPressed: () {
                            AppSingletons.isSearchingItem.value = false;
                            AppSingletons.isKeyboardVisible.value = false;

                            Get.find<ItemScreenController>()
                                .searchItemController
                                .clear();
                          },
                          icon: const Icon(
                            Icons.cancel,
                            color: orangeLight_1,
                          ));
                    }
                  }),
                ],
              );
            }
            else {
              return const SizedBox.shrink();
            }
          }),
          Obx(() {
            return Visibility(
              visible: !AppSingletons.isStartDeletingItem.value,
              child: IconButton(
                onPressed: () {
                  Get.toNamed(Routes.proScreenView);
                },
                icon: Image.asset(
                  'assets/icons/vip_icon.png',
                  height: 35,
                  width: 35,
                ),
              ),
            );
          })
        ],
      ),
      body: WillPopScope(
          onWillPop: () async {
            if (scaffoldKeyMenu.currentState!.isDrawerOpen) {
              scaffoldKeyMenu.currentState!.openEndDrawer();
              return false;
            } else {
              bool shouldClose = await _showExitDialog();
              return shouldClose;
            }
          },
          child: Obx(
            () => screens[controller.currentIndex.value],
          )),
      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.only(
              topRight: Radius.circular(15),
              topLeft: Radius.circular(15),
            ),
            child: Obx(
              () => BottomNavigationBar(
                currentIndex: controller.currentIndex.value,
                onTap: (index) {
                  switch (index) {
                    case 0:
                      controller.changePage(0);
                      AppSingletons.isStartDeletingItem.value = false;
                      AppSingletons.isSearchingItem.value = false;
                      AppSingletons.isSearchingClient.value = false;
                      AppSingletons.isSelectedAll.value = false;
                      break;
                    case 1:
                      controller.changePage(1);
                      AppSingletons().isComingFromBottomBar = true;
                      AppSingletons.isStartDeletingItem.value = false;
                      AppSingletons.isSearchingItem.value = false;
                      AppSingletons.isSearchingClient.value = false;
                      AppSingletons.isSelectedAll.value = false;
                      break;
                    case 2:
                      controller.changePage(2);
                      AppSingletons().isComingFromBottomBar = true;
                      AppSingletons.isStartDeletingItem.value = false;
                      AppSingletons.isSearchingItem.value = false;
                      AppSingletons.isSelectedAll.value = false;
                      break;
                    case 3:
                      controller.changePage(3);
                      AppSingletons().isComingFromBottomBar = true;
                      AppSingletons.isSelectedAll.value = false;
                      AppSingletons.isSearchingClient.value = false;
                      AppSingletons.isStartDeletingItem.value = false;
                      AppSingletons.isSelectedAll.value = false;
                      break;
                    case 4:
                      controller.changePage(4);
                      AppSingletons().isComingFromBottomBar = true;
                      AppSingletons.isStartDeletingItem.value = false;
                      AppSingletons.isSelectedAll.value = false;
                      AppSingletons.isSearchingItem.value = false;
                      AppSingletons.isSearchingClient.value = false;
                      break;
                  }
                },
                backgroundColor: mainPurpleColor,
                selectedFontSize: 14,
                selectedIconTheme:
                    const IconThemeData(color: orangeMedium_1, size: 25),
                selectedItemColor: orangeMedium_1,
                selectedLabelStyle: const TextStyle(
                  fontWeight: FontWeight.w800,
                ),
                type: BottomNavigationBarType.fixed,
                unselectedFontSize: 12,
                unselectedIconTheme:
                    const IconThemeData(color: sWhite, size: 20),
                unselectedItemColor: sWhite,
                unselectedLabelStyle:
                    const TextStyle(fontWeight: FontWeight.w600),
                showUnselectedLabels: true,
                showSelectedLabels: true,
                items: <BottomNavigationBarItem>[
                  BottomNavigationBarItem(
                    icon: ImageIcon(
                      const AssetImage('assets/icons/invoice_icon.png'),
                      size: 20,
                      color: controller.currentIndex.value == 0
                          ? orangeMedium_1
                          : sWhite,
                    ),
                    label: "invoice".tr,
                  ),
                  BottomNavigationBarItem(
                    icon: ImageIcon(
                      const AssetImage('assets/icons/estimate.png'),
                      size: 20,
                      color: controller.currentIndex.value == 1
                          ? orangeMedium_1
                          : sWhite,
                    ),
                    label: "estimate".tr,
                  ),
                   BottomNavigationBarItem(
                    icon: const Icon(Icons.person),
                    label: "client".tr,
                  ),
                  BottomNavigationBarItem(
                    icon: const Icon(Icons.shopping_bag),
                    label: "item".tr,
                  ),
                  BottomNavigationBarItem(
                    icon: const Icon(Icons.settings),
                    label: "settings".tr,
                  ),
                ],
              ),
            ),
          ),

          Obx(() {
            return Visibility(
                visible: !AppSingletons.isSubscriptionEnabled.value,
                child: Visibility(
                  visible: (Platform.isAndroid &&
                          AppSingletons.androidBannerAdsEnabled.value) ||
                      (Platform.isIOS &&
                          AppSingletons.iOSBannerAdsEnabled.value),
                  child: controller.isBannerAdReady.value == true
                      ? Container(
                          padding: const EdgeInsets.symmetric(vertical: 5),
                          // width: controller.bannerAd.size.width.toDouble(),
                          // width: double.infinity,
                          height: 60,
                          child: AdWidget(ad: controller.bannerAd),
                        )
                      : Container(
                          padding: const EdgeInsets.symmetric(vertical: 5),
                          // width: controller.bannerAd.size.width.toDouble(),
                          height: 50,
                          child: const Center(child: Text('Loading Ad')),
                        ),
                ));
          }),
        ],
      ),
    );
  }

  Widget mainDesktopLayout(BuildContext context, List<Widget> screens) {
    return Scaffold(
      backgroundColor: mainPurpleColor,
      body: Obx(() {
        return Row(
          children: [
            Container(
              width: MediaQuery.of(context).size.width * 0.25,
              height: double.infinity,
              decoration: BoxDecoration(
                border: Border.all(color: mainPurpleColor, width: 0),
              ),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(50),
                      height: 200,
                      width: double.infinity,
                      color: mainPurpleColor,
                      child: Image.asset(
                        'assets/icons/name.png',
                        color: sWhite,
                      ),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    Container(
                      margin: const EdgeInsets.only(right: 15),
                      decoration: BoxDecoration(
                          color: sWhite,
                          borderRadius: BorderRadius.circular(5)),
                      child: ListTile(
                        onTap: () {
                          Get.toNamed(Routes.proScreenView);
                        },
                        leading: Image.asset(
                          'assets/icons/vip_icon.png',
                          height: 35,
                          width: 35,
                        ),
                        title: const Text(
                          'Join PRO',
                          style: TextStyle(
                              fontFamily: 'Montserrat',
                              fontWeight: FontWeight.w700,
                              color: mainPurpleColor),
                        ),
                        trailing: Container(
                          height: 15,
                          width: 15,
                          alignment: Alignment.center,
                          decoration: const BoxDecoration(
                              color: mainPurpleColor, shape: BoxShape.circle),
                          child: const Icon(
                            Icons.keyboard_arrow_right_outlined,
                            color: sWhite,
                            size: 15,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    Container(
                      margin: const EdgeInsets.only(right: 50),
                      decoration: const BoxDecoration(
                          color: sWhite,
                          borderRadius: BorderRadius.only(
                            topRight: Radius.circular(50),
                            bottomRight: Radius.circular(50),
                          )),
                      child: ListTile(
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 0),
                        onTap: () {
                          Get.toNamed(Routes.chartsView);
                        },
                        leading: const Icon(
                          Icons.add_chart,
                          color: mainPurpleColor,
                          size: 20,
                        ),
                        title: const Text(
                          'Reports',
                          style: TextStyle(
                              fontFamily: 'Montserrat',
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: mainPurpleColor),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Container(
                      margin: const EdgeInsets.only(right: 50),
                      decoration: const BoxDecoration(
                          color: sWhite,
                          borderRadius: BorderRadius.only(
                            topRight: Radius.circular(50),
                            bottomRight: Radius.circular(50),
                          )),
                      child: ListTile(
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 0),
                        onTap: () {},
                        leading: const Icon(
                          Icons.verified,
                          color: mainPurpleColor,
                          size: 20,
                        ),
                        title: const Text(
                          'Rate Us',
                          style: TextStyle(
                              fontFamily: 'Montserrat',
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: mainPurpleColor),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Container(
                      margin: const EdgeInsets.only(right: 50),
                      decoration: const BoxDecoration(
                          color: sWhite,
                          borderRadius: BorderRadius.only(
                            topRight: Radius.circular(50),
                            bottomRight: Radius.circular(50),
                          )),
                      child: ListTile(
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 0),
                        onTap: () async {
                          await Share.share(
                              'Save time, Save money. Create professional invoices in seconds "Invoice Maker !Receipt Creator"');
                        },
                        leading: const Icon(
                          Icons.share,
                          color: mainPurpleColor,
                          size: 20,
                        ),
                        title: const Text(
                          'Share',
                          style: TextStyle(
                              fontFamily: 'Montserrat',
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: mainPurpleColor),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Container(
                      margin: const EdgeInsets.only(right: 50),
                      decoration: const BoxDecoration(
                          color: sWhite,
                          borderRadius: BorderRadius.only(
                            topRight: Radius.circular(50),
                            bottomRight: Radius.circular(50),
                          )),
                      child: ListTile(
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 0),
                        onTap: () {
                          Uri url = Uri.parse(
                              'https://vitalappstudio.blogspot.com/2024/08/%20Invoice%20Maker%20Receipt%20Creator.html');
                          launchUrl(url);
                        },
                        leading: const Icon(
                          Icons.privacy_tip_outlined,
                          color: mainPurpleColor,
                          size: 20,
                        ),
                        title: const Text(
                          'Privacy Policy',
                          style: TextStyle(
                              fontFamily: 'Montserrat',
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: mainPurpleColor),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),

                    Container(
                      margin: const EdgeInsets.only(right: 50),
                      decoration: const BoxDecoration(
                          color: sWhite,
                          borderRadius: BorderRadius.only(
                            topRight: Radius.circular(50),
                            bottomRight: Radius.circular(50),
                          )),
                      child: ListTile(
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 0),
                        onTap: () {
                          Uri url = Uri.parse(
                              'https://vitalappstudio.blogspot.com/2024/04/terms%20of%20use.html');
                          launchUrl(url);
                        },
                        leading: const Icon(
                          Icons.list_alt_rounded,
                          color: mainPurpleColor,
                          size: 20,
                        ),
                        title: const Text(
                          'Term Of Use',
                          style: TextStyle(
                              fontFamily: 'Montserrat',
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: mainPurpleColor),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),

                    Container(
                      margin: const EdgeInsets.only(right: 50),
                      decoration: const BoxDecoration(
                          color: sWhite,
                          borderRadius: BorderRadius.only(
                            topRight: Radius.circular(50),
                            bottomRight: Radius.circular(50),
                          )),
                      child: ListTile(
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 0),
                        onTap: () {
                          final Uri emailLaunchUri = Uri(
                              scheme: 'mailto',
                              path: 'vitalappstudios@gmail.com',
                              queryParameters: <String, String>{
                                'subject': 'Feedback about Invoice Maker !Receipt Creator',
                              });
                          launchUrl(emailLaunchUri);
                        },
                        leading: const Icon(
                          Icons.email,
                          color: mainPurpleColor,
                          size: 20,
                        ),
                        title: const Text(
                          'Feedback',
                          style: TextStyle(
                              fontFamily: 'Montserrat',
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: mainPurpleColor),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: Stack(
                children: [
                  screens[controller.currentIndex.value],
                  Positioned(
                      left: 0,
                      right: 0,
                      bottom: 0,
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        width: double.infinity,
                        decoration: BoxDecoration(
                            color: mainPurpleColor,
                            border:
                                Border.all(color: mainPurpleColor, width: 0),
                            borderRadius: const BorderRadius.only(
                              topRight: Radius.circular(10),
                              topLeft: Radius.circular(10),
                            )),
                        child: Row(
                          children: [
                            Expanded(
                                child: GestureDetector(
                              onTap: () {
                                controller.currentIndex.value = 0;
                                AppSingletons().isComingFromBottomBar = true;
                              },
                              child: Column(
                                children: [
                                  ImageIcon(
                                    const AssetImage(
                                        'assets/icons/invoice_icon.png'),
                                    size: 20,
                                    color: controller.currentIndex.value == 0
                                        ? orangeMedium_1
                                        : sWhite,
                                  ),
                                  const SizedBox(
                                    height: 2,
                                  ),
                                  Text(
                                    'Invoice',
                                    style: TextStyle(
                                      fontFamily: 'Montserrat',
                                      fontWeight: FontWeight.w700,
                                      color: controller.currentIndex.value == 0
                                          ? orangeMedium_1
                                          : sWhite,
                                    ),
                                  )
                                ],
                              ),
                            )),
                            Expanded(
                                child: GestureDetector(
                              onTap: () {
                                controller.currentIndex.value = 1;
                                AppSingletons().isComingFromBottomBar = true;
                              },
                              child: Column(
                                children: [
                                  ImageIcon(
                                    const AssetImage(
                                        'assets/icons/estimate.png'),
                                    size: 20,
                                    color: controller.currentIndex.value == 1
                                        ? orangeMedium_1
                                        : sWhite,
                                  ),
                                  const SizedBox(
                                    height: 2,
                                  ),
                                  Text(
                                    'Estimate',
                                    style: TextStyle(
                                      fontFamily: 'Montserrat',
                                      fontWeight: FontWeight.w700,
                                      color: controller.currentIndex.value == 1
                                          ? orangeMedium_1
                                          : sWhite,
                                    ),
                                  )
                                ],
                              ),
                            )),
                            Expanded(
                                child: GestureDetector(
                              onTap: () {
                                controller.currentIndex.value = 2;
                                AppSingletons().isComingFromBottomBar = true;
                              },
                              child: Column(
                                children: [
                                  Icon(
                                    Icons.person,
                                    size: 20,
                                    color: controller.currentIndex.value == 2
                                        ? orangeMedium_1
                                        : sWhite,
                                  ),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  Text(
                                    'Client',
                                    style: TextStyle(
                                      fontFamily: 'Montserrat',
                                      fontWeight: FontWeight.w700,
                                      color: controller.currentIndex.value == 2
                                          ? orangeMedium_1
                                          : sWhite,
                                    ),
                                  )
                                ],
                              ),
                            )),
                            Expanded(
                                child: GestureDetector(
                              onTap: () {
                                controller.currentIndex.value = 3;
                                AppSingletons().isComingFromBottomBar = true;
                              },
                              child: Column(
                                children: [
                                  Icon(
                                    Icons.shopping_bag,
                                    size: 20,
                                    color: controller.currentIndex.value == 3
                                        ? orangeMedium_1
                                        : sWhite,
                                  ),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  Text(
                                    'Item',
                                    style: TextStyle(
                                      fontFamily: 'Montserrat',
                                      fontWeight: FontWeight.w700,
                                      color: controller.currentIndex.value == 3
                                          ? orangeMedium_1
                                          : sWhite,
                                    ),
                                  )
                                ],
                              ),
                            )),
                            Expanded(
                                child: GestureDetector(
                              onTap: () {
                                controller.currentIndex.value = 4;
                                AppSingletons().isComingFromBottomBar = true;
                              },
                              child: Column(
                                children: [
                                  Icon(
                                    Icons.settings,
                                    size: 20,
                                    color: controller.currentIndex.value == 4
                                        ? orangeMedium_1
                                        : sWhite,
                                  ),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  Text(
                                    'Settings',
                                    style: TextStyle(
                                      fontFamily: 'Montserrat',
                                      fontWeight: FontWeight.w700,
                                      color: controller.currentIndex.value == 4
                                          ? orangeMedium_1
                                          : sWhite,
                                    ),
                                  )
                                ],
                              ),
                            )),
                          ],
                        ),
                      )),
                ],
              ),
            ),
          ],
        );
      }),
    );
  }

  Future<bool> _showExitDialog() async {
    return await Get.dialog(
          AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15)
            ),
            title: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                  color: mainPurpleColor,
                  borderRadius: BorderRadius.circular(7)),
              padding: const EdgeInsets.symmetric(vertical: 10),
              alignment: Alignment.center,
              child: Text(
                'quit_app'.tr,
                style: const TextStyle(
                    color: sWhite, fontSize: 16, fontFamily: 'Montserrat'),
              ),
            ),
            content: Text(
              'quit_confirmation'.tr,
              style: const TextStyle(
                  color: blackColor, fontSize: 16, fontFamily: 'Montserrat'),
            ),
            actions: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        Get.back(result: false);
                      },
                      child: Container(
                        width: double.infinity,
                        alignment: Alignment.center,
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        decoration: const BoxDecoration(
                            color: grey_4,
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(5),
                                bottomLeft: Radius.circular(5))),
                        child: Text(
                          'no'.tr,
                          style: const TextStyle(
                            fontFamily: 'Montserrat',
                            color: sWhite,
                            fontWeight: FontWeight.w500,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        Get.back(result: true);
                      },
                      child: Container(
                        width: double.infinity,
                        alignment: Alignment.center,
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        decoration: const BoxDecoration(
                            color: mainPurpleColor,
                            borderRadius: BorderRadius.only(
                                topRight: Radius.circular(5),
                                bottomRight: Radius.circular(5))),
                        child: Text(
                          'yes'.tr,
                          style: const TextStyle(
                            fontFamily: 'Montserrat',
                            color: sWhite,
                            fontWeight: FontWeight.w500,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ) ??
        false;
  }
}
