import 'dart:io';

import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:intl/intl.dart';
import '../../core/app_singletons/app_singletons.dart';
import '../../core/services/ads_helper.dart';
import '../../core/utils/chart_data_methods.dart';
import '../../core/utils/utils.dart';
import '../../core/constants/app_constants/App_Constants.dart';
import '../../core/constants/color/color.dart';
import '../../database/database_helper.dart';
import '../../model/client_summary.dart';
import '../../model/data_model.dart';
import '../../model/item_summary.dart';

class ChartsController extends GetxController {
  DBHelper? chartDBHelper;
  final RxList<DataModel> _invoices = <DataModel>[].obs;

  final RxList<DataModel> filteredInvoices = <DataModel>[].obs;

  final RxList<ClientSummary> _topClients = <ClientSummary>[].obs;
  final RxList<ItemSummary> _topItems = <ItemSummary>[].obs;

  final RxList<InvoiceAmount> _invoicesAmount = <InvoiceAmount>[].obs;

  RxBool isLoadingData = true.obs;

  final DateTime now = DateTime.now();

  Rx<DateTime> startChosenDate = DateTime.now().obs;
  Rx<DateTime> endChosenDate = DateTime.now().obs;

  RxString selectedDateFilter = 'last_30_days'.obs;
  RxString selectedFilterValue = AppConstants.last30days.obs;

  RxInt totalSalesValue = 0.obs;
  RxInt totalPaidSalesValue = 0.obs;

  Rx<bool> isBannerAdReady = false.obs;
  late BannerAd bannerAd;

  @override
  void onInit() async {
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

    chartDBHelper = DBHelper();
    await fetchInvoices();
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

  Future<void> fetchInvoices() async {
    _invoices.value = await chartDBHelper!.getInvoiceList();

    filterTopClients('last30days');
    filterTopItems('last30days');
    filterInvoicesData('last30days');

    ChartDataMethods.generateDateLabels(
        startChosenDate.value, endChosenDate.value, 'last30days');

    isLoadingData.value = false;
  }

  void filterTopClients(String filterType,
      {DateTime? startDate, DateTime? endDate}) {
    DateTime start;
    DateTime end = now;

    switch (filterType) {
      case 'last7days':
        start = now.subtract(const Duration(days: 7));
        selectedDateFilter.value = 'last_7_days';
        break;
      case 'last30days':
        start = now.subtract(const Duration(days: 30));
        selectedDateFilter.value = 'last_30_days';
        break;
      case 'thismonth':
        start = DateTime(now.year, now.month, 1);
        selectedDateFilter.value = 'this_month';
        break;
      case 'thisquarter':
        int currentQuarter = ((now.month - 1) ~/ 3) + 1;
        start = DateTime(now.year, (currentQuarter - 1) * 3 + 1, 1);
        selectedDateFilter.value = 'this_quarter';
        break;
      case 'thisyear':
        start = DateTime(now.year, 1, 1);
        selectedDateFilter.value = 'this_year';
        break;
      case 'lastmonth':
        start = DateTime(now.year, now.month - 1, 1);
        end =
            DateTime(now.year, now.month, 1).subtract(const Duration(days: 1));
        selectedDateFilter.value = 'last_month';
        break;
      case 'lastquarter':
        int currentQuarter = ((now.month - 1) ~/ 3) + 1;
        start = DateTime(now.year, (currentQuarter - 2) * 3 + 1, 1);
        end = DateTime(now.year, (currentQuarter - 1) * 3, 1)
            .subtract(const Duration(days: 1));
        selectedDateFilter.value = 'last_quarter';
        break;
      case 'lastyear':
        start = DateTime(now.year - 1, 1, 1);
        end = DateTime(now.year - 1, 12, 31);
        selectedDateFilter.value = 'last_year';
        break;
      case 'custom':
        start = startDate!;
        end = endDate!;
        selectedDateFilter.value = 'custom';
        break;
      default:
        start = now.subtract(const Duration(days: 30));
        break;
    }

    // Filter invoices based on date range
    List<DataModel> filteredInvoices = _invoices.where((invoice) {
      DateTime creationDate =
          DateFormat('yyyy-MM-dd').parse(invoice.creationDate.toString());
      return creationDate.isAfter(start.subtract(const Duration(days: 1))) &&
          creationDate.isBefore(end.add(const Duration(days: 1)));
    }).toList();

    int totalInvoices = filteredInvoices.length; // Total number of invoices

    // Aggregate and sum amounts by client
    Map<String, ClientSummary> clientMap = {};
    for (var invoice in filteredInvoices) {
      if (clientMap.containsKey(invoice.clientName)) {
        clientMap[invoice.clientName]!.totalAmount +=
            int.tryParse(invoice.finalNetTotal.toString()) ?? 0;
        clientMap[invoice.clientName]!.count++; // Increment count
      } else {
        clientMap[invoice.clientName.toString()] = ClientSummary(
          clientName: invoice.clientName.toString(),
          totalAmount: double.tryParse(invoice.finalNetTotal.toString()) ?? 0.0,
          count: 1, // Initial count is 1
          percentage: 0.0, // Placeholder for now
        );
      }
    }

    clientMap.forEach((clientName, summary) {
      summary.percentage = (summary.count / totalInvoices) * 100;
    });

    // Sort and get top 5 clients
    List<ClientSummary> sortedClients = clientMap.values.toList()
      ..sort((a, b) => b.totalAmount.compareTo(a.totalAmount));
    _topClients.value = sortedClients.take(5).toList();
  }

  List<ClientSummary> get topClients => _topClients;

  Color? giveBoxValues(int index) {
    switch (index) {
      case 0:
        return mainPurpleColor;
      case 1:
        return blueTapTemplate;
      case 2:
        return greenColor;
      case 3:
        return orangeMedium_1;
      case 4:
        return proIconColor;
      default:
        return mainPurpleColor;
    }
  }

  void filterTopItems(String filterType,
      {DateTime? startDate, DateTime? endDate}) {
    DateTime start;
    DateTime end = now;

    switch (filterType) {
      case 'last7days':
        start = now.subtract(const Duration(days: 7));
        selectedDateFilter.value = 'last_7_days';
        break;
      case 'last30days':
        start = now.subtract(const Duration(days: 30));
        selectedDateFilter.value = 'last_30_days';
        break;
      case 'thismonth':
        start = DateTime(now.year, now.month, 1);
        selectedDateFilter.value = 'this_month';
        break;
      case 'thisquarter':
        int currentQuarter = ((now.month - 1) ~/ 3) + 1;
        start = DateTime(now.year, (currentQuarter - 1) * 3 + 1, 1);
        selectedDateFilter.value = 'this_quarter';
        break;
      case 'thisyear':
        start = DateTime(now.year, 1, 1);
        selectedDateFilter.value = 'this_year';
        break;
      case 'lastmonth':
        start = DateTime(now.year, now.month - 1, 1);
        end =
            DateTime(now.year, now.month, 1).subtract(const Duration(days: 1));
        selectedDateFilter.value = 'last_month';
        break;
      case 'lastquarter':
        int currentQuarter = ((now.month - 1) ~/ 3) + 1;
        start = DateTime(now.year, (currentQuarter - 2) * 3 + 1, 1);
        end = DateTime(now.year, (currentQuarter - 1) * 3, 1)
            .subtract(const Duration(days: 1));
        selectedDateFilter.value = 'last_quarter';
        break;
      case 'lastyear':
        start = DateTime(now.year - 1, 1, 1);
        end = DateTime(now.year - 1, 12, 31);
        selectedDateFilter.value = 'last_year';
        break;
      case 'custom':
        start = startDate!;
        end = endDate!;
        selectedDateFilter.value = 'custom';
        break;
      default:
        start = now.subtract(const Duration(days: 30));
        break;
    }

    List<DataModel> filteredInvoices = _invoices.where((invoice) {
      DateTime creationDate =
          DateFormat('yyyy-MM-dd').parse(invoice.creationDate.toString());
      return creationDate.isAfter(start.subtract(const Duration(days: 1))) &&
          creationDate.isBefore(end.add(const Duration(days: 1)));
    }).toList();

    Map<String, ItemSummary> itemMap = {};

    try {
      for (var invoice in filteredInvoices) {
        List<String> items = invoice.itemNames ??
            []; // Assuming 'items' is a list of item names in the invoice
        List<String> quantities = invoice.itemsQuantityList ??
            []; // Assuming 'quantities' is a list of quantities for the items
        List<String> amounts = invoice.itemsAmountList ??
            []; // Assuming 'amounts' is a list of amounts for the items

        for (int i = 0; i < items.length; i++) {
          String itemName = items[i];
          double itemAmount = double.tryParse(amounts[i]) ?? 0.0;
          int itemQuantity = int.tryParse(quantities[i]) ?? 0;

          if (itemMap.containsKey(itemName)) {
            itemMap[itemName]!.totalAmount += itemAmount;
            itemMap[itemName]!.quantity += itemQuantity;
          } else {
            itemMap[itemName] = ItemSummary(
              itemName: itemName,
              totalAmount: itemAmount,
              quantity: itemQuantity,
              percentage: 0.0, // Placeholder for now
            );
          }
        }
      }

      double totalAmount =
          itemMap.values.fold(0.0, (sum, item) => sum + item.totalAmount);
      itemMap.forEach((itemName, summary) {
        summary.percentage = (summary.totalAmount / totalAmount) * 100;
      });

      List<ItemSummary> sortedItems = itemMap.values.toList()
        ..sort((a, b) => b.totalAmount.compareTo(a.totalAmount));
      _topItems.value = sortedItems.take(5).toList();
    } catch (e) {
      debugPrint('Error: $e');
    }
  }

  List<ItemSummary> get topItems => _topItems;

  void filterInvoicesData(String filterType,
      {DateTime? startDate, DateTime? endDate}) {
    DateTime start;
    DateTime end = now;

    switch (filterType) {
      case 'last7days':
        start = now.subtract(const Duration(days: 7));
        selectedDateFilter.value = 'last_7_days';
        selectedFilterValue.value = 'last7days';
        startChosenDate.value = start;
        endChosenDate.value = end;
        break;
      case 'last30days':
        start = now.subtract(const Duration(days: 30));
        selectedDateFilter.value = 'last_30_days';
        selectedFilterValue.value = 'last30days';
        startChosenDate.value = start;
        endChosenDate.value = end;
        break;
      case 'thismonth':
        start = DateTime(now.year, now.month, 1);
        end = DateTime(now.year, now.month + 1, 1)
            .subtract(const Duration(days: 1));
        selectedDateFilter.value = 'this_month';
        selectedFilterValue.value = 'thismonth';
        startChosenDate.value = start;
        endChosenDate.value = end;
        break;
      case 'thisquarter':
        int currentQuarter = ((now.month - 1) ~/ 3) + 1;
        start = DateTime(now.year, (currentQuarter - 1) * 3 + 1, 1);
        end = DateTime(now.year, currentQuarter * 3 + 1, 1)
            .subtract(const Duration(days: 1));
        selectedDateFilter.value = 'this_quarter';
        selectedFilterValue.value = 'thisquarter';
        startChosenDate.value = start;
        endChosenDate.value = end;
        break;
      case 'thisyear':
        start = DateTime(now.year, 1, 1);
        end = DateTime(now.year, 12, 31);
        selectedDateFilter.value = 'this_year';
        selectedFilterValue.value = 'thisyear';
        startChosenDate.value = start;
        endChosenDate.value = end;
        break;
      case 'lastmonth':
        start = DateTime(now.year, now.month - 1, 1);
        end =
            DateTime(now.year, now.month, 1).subtract(const Duration(days: 1));
        selectedDateFilter.value = 'last_month';
        selectedFilterValue.value = 'lastmonth';
        startChosenDate.value = start;
        endChosenDate.value = end;
        break;
      case 'lastquarter':
        int currentQuarter = ((now.month - 1) ~/ 3) + 1;
        start = DateTime(now.year, (currentQuarter - 2) * 3 + 1, 1);
        end = DateTime(now.year, (currentQuarter - 1) * 3, 1)
            .subtract(const Duration(days: 1));
        selectedDateFilter.value = 'last_quarter';
        selectedFilterValue.value = 'lastquarter';
        startChosenDate.value = start;
        endChosenDate.value = end;
        break;
      case 'lastyear':
        start = DateTime(now.year - 1, 1, 1);
        end = DateTime(now.year - 1, 12, 31);
        selectedDateFilter.value = 'last_year';
        selectedFilterValue.value = 'lastyear';
        startChosenDate.value = start;
        endChosenDate.value = end;
        break;
      case 'custom':
        start = startDate!;
        end = endDate!;
        selectedDateFilter.value = 'custom';
        selectedFilterValue.value = 'custom';
        startChosenDate.value = start;
        endChosenDate.value = end;
        break;
      default:
        start = now.subtract(const Duration(days: 30));
        startChosenDate.value = start;
        endChosenDate.value = end;
        break;
    }

    List<DataModel> innerFilterInvoices = _invoices.where((invoice) {
      DateTime creationDate =
          DateFormat('yyyy-MM-dd').parse(invoice.creationDate.toString());
      return creationDate.isAfter(start.subtract(const Duration(days: 1))) &&
          creationDate.isBefore(end.add(const Duration(days: 1)));
    }).toList();

    totalSalesValue.value = 0;

    for (var data in innerFilterInvoices) {
      totalSalesValue.value += int.tryParse(data.finalNetTotal.toString()) ?? 0;
    }

    totalPaidSalesValue.value = 0;
    int totalFullyPaidAmounts = 0;
    int totalPartiallyPaidAmounts = 0;
    int totalPartiallyPaidInOverdue = 0;

    for (var data in innerFilterInvoices.where(
        (element) => element.documentStatus == AppConstants.paidInvoice)) {
      debugPrint('Paid Doc Id: ${data.uniqueNumber}');
      debugPrint('Paid Doc Status: ${data.documentStatus}');
      totalFullyPaidAmounts += int.tryParse(data.finalNetTotal.toString()) ?? 0;
    }

    for (var data in innerFilterInvoices.where((element) => !Utils.isOverdue(element.dueDate ?? '') &&
        element.documentStatus == AppConstants.partiallyPaidInvoice)) {
      debugPrint('Paid Doc Id: ${data.uniqueNumber}');
      debugPrint('Paid Doc Status: ${data.documentStatus}');
      debugPrint('Paid Doc Status: ${data.partiallyPaidAmount}');
      final numericPart = RegExp(r'\d+').firstMatch(data.partiallyPaidAmount ?? '');
      final amount = numericPart != null ? int.tryParse(numericPart.group(0) ?? '') : 0;
      totalPartiallyPaidAmounts += amount ?? 0;
    }

    for(var data in innerFilterInvoices.
    where((element) => Utils.isOverdue(element.dueDate ?? ''))
    ){
      debugPrint('partiallyPaidAmount in overdue: ${data.partiallyPaidAmount}');
      final amount = int.tryParse(data.partiallyPaidAmount ?? '') ?? 0;
      totalPartiallyPaidInOverdue += amount;
    }

    totalPaidSalesValue.value = totalFullyPaidAmounts + totalPartiallyPaidAmounts + totalPartiallyPaidInOverdue;

    debugPrint('Total Sales: ${totalSalesValue.value}');
    debugPrint('Total F Paid: $totalFullyPaidAmounts');
    debugPrint('Total P Paid: $totalPartiallyPaidAmounts');
    debugPrint('Total Paid S: ${totalPaidSalesValue.value}');

    filteredInvoices.value = innerFilterInvoices;

    Map<String, double> aggregatedTotals = {};

    for (var invoice in innerFilterInvoices) {
      String dateKey = DateTime.parse(invoice.creationDate.toString())
          .toLocal()
          .toString()
          .split(' ')[0];
      double total = double.tryParse(invoice.finalNetTotal.toString()) ?? 0.0;

      if (aggregatedTotals.containsKey(dateKey)) {
        aggregatedTotals[dateKey] = aggregatedTotals[dateKey]! + total;
      } else {
        aggregatedTotals[dateKey] = total;
      }
    }
    List<InvoiceAmount> aggregatedInvoices =
        aggregatedTotals.entries.map((entry) {
      return InvoiceAmount(
        creationDate: entry.key,
        finalAmount: entry.value,
      );
    }).toList();

    _invoicesAmount.value = aggregatedInvoices;
  }

  List<InvoiceAmount> get invoicesAmount => _invoicesAmount;
}

class InvoiceAmount {
  String creationDate;
  double finalAmount;

  InvoiceAmount({
    required this.creationDate,
    required this.finalAmount,
  });
}
