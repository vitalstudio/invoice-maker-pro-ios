import 'dart:io';
import 'dart:math';
import 'dart:typed_data';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import '../../core/services/ads_helper.dart';
import '../../core/utils/utils.dart';
import '../../pdf_templates/chart_data_pdf/chart_data_pdf.dart';
import '../../core/app_singletons/app_singletons.dart';
import '../../core/constants/app_constants/App_Constants.dart';
import '../../core/constants/color/color.dart';
import '../../database/database_helper.dart';
import '../../model/client_summary.dart';
import '../../model/data_model.dart';
import '../../model/item_summary.dart';

class ShareChartDetailController extends GetxController {
  DBHelper? shareDetailDBHelper;
  final RxList<DataModel> _invoices = <DataModel>[].obs;
  final RxList<DataModel> filteredInvoices = <DataModel>[].obs;

  final RxList<ClientSummary> _filterByClients = <ClientSummary>[].obs;
  final RxList<ItemSummary> filterAllItems = <ItemSummary>[].obs;

  final DateTime now = DateTime.now();
  Rx<DateTime> startChosenDate = DateTime.now().obs;
  Rx<DateTime> endChosenDate = DateTime.now().obs;
  RxString selectedDateFilter = 'Last 30 Days'.obs;
  RxString selectedFilterValue = AppConstants.last30days.obs;

  String? randomNumberId;
  String? randomAlphabetId;

  RxList<String> fetchAllDates = <String>[].obs;
  RxList<String> fetchInvoiceCount = <String>[].obs;
  RxList<String> fetchFinalAmountTotalList = <String>[].obs;
  RxList<String> fetchOnlyPaidAmountList = <String>[].obs;

  RxInt totalInvoicesCount = 0.obs;
  RxInt totalSalesAmount = 0.obs;

  RxInt totalSalesAsClient = 0.obs;
  RxInt totalInvoicesAsClient = 0.obs;
  RxDouble totalPercentageAsClient = 0.0.obs;

  RxInt totalItemsQTY = 0.obs;
  RxInt totalSalesByItems = 0.obs;
  RxDouble totalPercentageAsItems = 0.0.obs;

  RxInt totalPaid = 0.obs;

  RxBool isLoadingData = true.obs;

  RxList<Map<String, dynamic>> tableData = <Map<String, dynamic>>[].obs;

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

    shareDetailDBHelper = DBHelper();
    randomNumberId = generateUniqueNumberId();
    randomAlphabetId = generateUniqueAlphabetId();
    fetchInvoices();
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

  String generateUniqueNumberId() {
    Random random = Random();
    String characters = '01234567891011121314151617181920';
    String id = '';
    for (var i = 0; i < 5; i++) {
      id += characters[random.nextInt(characters.length)];
    }
    return id;
  }

  String generateUniqueAlphabetId() {
    Random random = Random();
    String characters = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
    String id = '';
    for (var i = 0; i < 5; i++) {
      id += characters[random.nextInt(characters.length)];
    }
    return id;
  }

  Future<void> fetchInvoices() async {

    selectedFilterValue.value = AppSingletons.selectedTimePeriod.value;
    _invoices.value = await shareDetailDBHelper!.getInvoiceList();
    filterInvoicesData(selectedFilterValue.value);
    filterAllClients(selectedFilterValue.value);
    filterTopItems(selectedFilterValue.value);
    isLoadingData.value = false;
  }

  void filterInvoicesData(String filterType, {DateTime? startDate, DateTime? endDate}) {
    DateTime start;
    DateTime end = now;

    switch (filterType) {
      case 'last7days':
        start = now.subtract(const Duration(days: 7));
        selectedDateFilter.value = 'Last 7 Days';
        selectedFilterValue.value = 'last7days';
        break;
      case 'last30days':
        start = now.subtract(const Duration(days: 30));
        selectedDateFilter.value = 'Last 30 Days';
        selectedFilterValue.value = 'last30days';
        break;
      case 'thismonth':
        start = DateTime(now.year, now.month, 1);
        end = DateTime(now.year, now.month + 1, 1).subtract(const Duration(days: 1));
        selectedDateFilter.value = 'This Month';
        selectedFilterValue.value = 'thismonth';
        break;
      case 'thisquarter':
        int currentQuarter = ((now.month - 1) ~/ 3) + 1;
        start = DateTime(now.year, (currentQuarter - 1) * 3 + 1, 1);
        end = DateTime(now.year, currentQuarter * 3 + 1, 1).subtract(const Duration(days: 1));
        selectedDateFilter.value = 'This Quarter';
        selectedFilterValue.value = 'thisquarter';
        break;
      case 'thisyear':
        start = DateTime(now.year, 1, 1);
        end = DateTime(now.year, 12, 31);
        selectedDateFilter.value = 'This Year';
        selectedFilterValue.value = 'thisyear';
        break;
      case 'lastmonth':
        start = DateTime(now.year, now.month - 1, 1);
        end = DateTime(now.year, now.month, 1).subtract(const Duration(days: 1));
        selectedDateFilter.value = 'Last Month';
        selectedFilterValue.value = 'lastmonth';
        break;
      case 'lastquarter':
        int currentQuarter = ((now.month - 1) ~/ 3) + 1;
        start = DateTime(now.year, (currentQuarter - 2) * 3 + 1, 1);
        end = DateTime(now.year, (currentQuarter - 1) * 3, 1).subtract(const Duration(days: 1));
        selectedDateFilter.value = 'Last Quarter';
        selectedFilterValue.value = 'lastquarter';
        break;
      case 'lastyear':
        start = DateTime(now.year - 1, 1, 1);
        end = DateTime(now.year - 1, 12, 31);
        selectedDateFilter.value = 'Last Year';
        selectedFilterValue.value = 'lastyear';
        break;
      case 'custom':
        start = startDate!;
        end = endDate!;
        selectedDateFilter.value = 'Custom';
        selectedFilterValue.value = 'custom';
        break;
      default:
        start = now.subtract(const Duration(days: 30));
        selectedDateFilter.value = 'Last 30 Days';
        selectedFilterValue.value = 'last30days';
        break;
    }

    startChosenDate.value = start;
    endChosenDate.value = end;

    List<DataModel> innerFilteredInvoices = _invoices.where((invoice) {
      DateTime creationDate = DateFormat('yyyy-MM-dd').parse(invoice.creationDate.toString());
      return creationDate.isAfter(start.subtract(const Duration(days: 1))) &&
          creationDate.isBefore(end.add(const Duration(days: 1)));
    }).toList();

    filteredInvoices.value = innerFilteredInvoices;

    final Map<String, Map<String, dynamic>> aggregatedData = {};

    for (var invoice in filteredInvoices) {
      final creationDate = DateFormat('yyyy-MM-dd').format(DateFormat('yyyy-MM-dd').parse(invoice.creationDate.toString()));
      final finalAmount = double.tryParse(invoice.finalNetTotal.toString()) ?? 0.0;
      final partiallyPaidNumeric = RegExp(r'\d+').firstMatch(invoice.partiallyPaidAmount ?? '');
      final partiallyPaidAmount = partiallyPaidNumeric != null ? double.tryParse(partiallyPaidNumeric.group(0) ?? '') : 0.0;
      final isPaid = invoice.documentStatus.toString() == AppConstants.paidInvoice;
      final isPartiallyPaid = invoice.documentStatus.toString() == AppConstants.partiallyPaidInvoice;

      if (!aggregatedData.containsKey(creationDate)) {
        aggregatedData[creationDate] = {
          'count': 0,
          'totalAmount': 0.0,
          'paidAmount': 0.0,
        };
      }

      aggregatedData[creationDate]!['count'] = (aggregatedData[creationDate]!['count'] as int) + 1;
      aggregatedData[creationDate]!['totalAmount'] = (aggregatedData[creationDate]!['totalAmount'] as double) + finalAmount;
      if (isPaid) {
        debugPrint('isPaid Called');
        aggregatedData[creationDate]!['paidAmount'] = (aggregatedData[creationDate]!['paidAmount'] as double) + finalAmount;
      }
      if (isPartiallyPaid) {

        aggregatedData[creationDate]!['paidAmount'] = (aggregatedData[creationDate]!['paidAmount'] as double) + partiallyPaidAmount!;
      }
    }

    final sortedDates = aggregatedData.keys.toList()
      ..sort((a, b) => DateFormat('yyyy-MM-dd').parse(a).compareTo(DateFormat('yyyy-MM-dd').parse(b)));

    final formattedDates = sortedDates.map((date) {
      return DateFormat('dd/MM/yyyy').format(DateFormat('yyyy-MM-dd').parse(date));
    }).toList();

    fetchAllDates.value = formattedDates;
    fetchInvoiceCount.value = sortedDates.map((date) => aggregatedData[date]!['count'].toString()).toList();
    fetchFinalAmountTotalList.value = sortedDates.map((date) => aggregatedData[date]!['totalAmount'].toString()).toList();
    fetchOnlyPaidAmountList.value = sortedDates.map((date) => aggregatedData[date]!['paidAmount'].toString()).toList();

    calculateTotals();

    isLoadingData.value = false;
  }

  void calculateTotals() {
    try{
      int totalInvoiceCount = fetchInvoiceCount.value
          .map((count) => int.tryParse(count) ?? 0)
          .reduce((a, b) => a + b);

      totalInvoicesCount.value = totalInvoiceCount;

      double totalFinalAmount = fetchFinalAmountTotalList.value
          .map((amount) => double.tryParse(amount) ?? 0.0)
          .reduce((a, b) => a + b);

      totalSalesAmount.value = totalFinalAmount.toInt();

      double totalPaidAmount = fetchOnlyPaidAmountList.value
          .map((amount) => double.tryParse(amount) ?? 0.0)
          .reduce((a, b) => a + b);

      totalPaid.value = totalPaidAmount.toInt();

      debugPrint('Total Invoice Count: $totalInvoiceCount');
      debugPrint('Total Final Amount: $totalFinalAmount');
      debugPrint('Total Paid Amount: $totalPaidAmount');
    } catch(e){
      debugPrint('$e');
      isLoadingData.value = false;
    }
  }

  void filterAllClients(String filterType, {DateTime? startDate, DateTime? endDate}) {
    DateTime start;
    DateTime end = now;

    switch (filterType) {
      case 'last7days':
        start = now.subtract(const Duration(days: 7));
        selectedDateFilter.value = 'Last 7 Days';
        break;
      case 'last30days':
        start = now.subtract(const Duration(days: 30));
        selectedDateFilter.value = 'Last 30 Days';
        break;
      case 'thismonth':
        start = DateTime(now.year, now.month, 1);
        selectedDateFilter.value = 'This Month';
        break;
      case 'thisquarter':
        int currentQuarter = ((now.month - 1) ~/ 3) + 1;
        start = DateTime(now.year, (currentQuarter - 1) * 3 + 1, 1);
        selectedDateFilter.value = 'This Quarter';
        break;
      case 'thisyear':
        start = DateTime(now.year, 1, 1);
        selectedDateFilter.value = 'This Year';
        break;
      case 'lastmonth':
        start = DateTime(now.year, now.month - 1, 1);
        end = DateTime(now.year, now.month, 1).subtract(const Duration(days: 1));
        selectedDateFilter.value = 'Last Month';
        break;
      case 'lastquarter':
        int currentQuarter = ((now.month - 1) ~/ 3) + 1;
        start = DateTime(now.year, (currentQuarter - 2) * 3 + 1, 1);
        end = DateTime(now.year, (currentQuarter - 1) * 3, 1)
            .subtract(const Duration(days: 1));
        selectedDateFilter.value = 'Last Quarter';
        break;
      case 'lastyear':
        start = DateTime(now.year - 1, 1, 1);
        end = DateTime(now.year - 1, 12, 31);
        selectedDateFilter.value = 'Last Year';
        break;
      case 'custom':
        start = startDate!;
        end = endDate!;
        selectedDateFilter.value = 'Custom';
        break;
      default:
        start = now.subtract(const Duration(days: 30));
        break;
    }

    List<DataModel> filteredInvoices = _invoices.where((invoice) {
      DateTime creationDate = DateFormat('yyyy-MM-dd').parse(invoice.creationDate.toString());
      return creationDate.isAfter(start.subtract(const Duration(days: 1))) &&
          creationDate.isBefore(end.add(const Duration(days: 1)));
    }).toList();

    int totalInvoices = filteredInvoices.length;

    for(var data in filteredInvoices){

    }

    Map<String, ClientSummary> clientMap = {};
    for (var invoice in filteredInvoices) {
      if (clientMap.containsKey(invoice.clientName)) {
        clientMap[invoice.clientName]!.totalAmount += int.tryParse(invoice.finalNetTotal.toString()) ?? 0;
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

    List<ClientSummary> sortedClients = clientMap.values.toList()
      ..sort((a, b) => b.totalAmount.compareTo(a.totalAmount));
    _filterByClients.value = sortedClients.toList();

    for(var data in _filterByClients){
      totalSalesAsClient.value += data.totalAmount.toInt();
      totalInvoicesAsClient.value += data.count;
      totalPercentageAsClient.value += data.percentage;
    }
  }

  List<ClientSummary> get filterByClient => _filterByClients;

  Color? giveBoxValues(int index) {
    switch(index % 5){
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

  void filterTopItems(String filterType, {DateTime? startDate, DateTime? endDate}) {
    DateTime start;
    DateTime end = now;

    switch (filterType) {
      case 'last7days':
        start = now.subtract(const Duration(days: 7));
        selectedDateFilter.value = 'Last 7 Days';
        break;
      case 'last30days':
        start = now.subtract(const Duration(days: 30));
        selectedDateFilter.value = 'Last 30 Days';
        break;
      case 'thismonth':
        start = DateTime(now.year, now.month, 1);
        selectedDateFilter.value = 'This Month';
        break;
      case 'thisquarter':
        int currentQuarter = ((now.month - 1) ~/ 3) + 1;
        start = DateTime(now.year, (currentQuarter - 1) * 3 + 1, 1);
        selectedDateFilter.value = 'This Quarter';
        break;
      case 'thisyear':
        start = DateTime(now.year, 1, 1);
        selectedDateFilter.value = 'This Year';
        break;
      case 'lastmonth':
        start = DateTime(now.year, now.month - 1, 1);
        end = DateTime(now.year, now.month, 1).subtract(const Duration(days: 1));
        selectedDateFilter.value = 'Last Month';
        break;
      case 'lastquarter':
        int currentQuarter = ((now.month - 1) ~/ 3) + 1;
        start = DateTime(now.year, (currentQuarter - 2) * 3 + 1, 1);
        end = DateTime(now.year, (currentQuarter - 1) * 3, 1).subtract(const Duration(days: 1));
        selectedDateFilter.value = 'Last Quarter';
        break;
      case 'lastyear':
        start = DateTime(now.year - 1, 1, 1);
        end = DateTime(now.year - 1, 12, 31);
        selectedDateFilter.value = 'Last Year';
        break;
      case 'custom':
        start = startDate!;
        end = endDate!;
        selectedDateFilter.value = 'Custom';
        break;
      default:
        start = now.subtract(const Duration(days: 30));
        break;
    }

    // Filter invoices based on date range
    List<DataModel> filteredInvoices = _invoices.where((invoice) {
      DateTime creationDate = DateFormat('yyyy-MM-dd').parse(invoice.creationDate.toString());
      return creationDate.isAfter(start.subtract(const Duration(days: 1))) &&
          creationDate.isBefore(end.add(const Duration(days: 1)));
    }).toList();

    // Aggregate and sum amounts by item
    Map<String, ItemSummary> itemMap = {};
    for (var invoice in filteredInvoices) {
      List<String> items = invoice.itemNames ?? []; // Assuming 'items' is a list of item names in the invoice
      List<String> quantities = invoice.itemsQuantityList ?? []; // Assuming 'quantities' is a list of quantities for the items
      List<String> amounts = invoice.itemsAmountList ?? []; // Assuming 'amounts' is a list of amounts for the items

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

    double totalAmount = itemMap.values.fold(0.0, (sum, item) => sum + item.totalAmount);
    itemMap.forEach((itemName, summary) {
      summary.percentage = (summary.totalAmount / totalAmount) * 100;
    });

    // Sort and get top 5 items
    List<ItemSummary> sortedItems = itemMap.values.toList()
      ..sort((a, b) => b.totalAmount.compareTo(a.totalAmount));
    filterAllItems.value = sortedItems.toList();

    for(var data in filterAllItems){

      totalItemsQTY.value += data.quantity;
      totalSalesByItems.value += data.totalAmount.toInt();
      totalPercentageAsItems.value += data.percentage;
    }
  }

  Future<Uint8List> loadChartPdf() async{
    return PdfChartDataWork.createPDFSalesTrending(
        fetchAllDates,
        fetchInvoiceCount,
        fetchFinalAmountTotalList,
        fetchOnlyPaidAmountList,
        totalInvoicesCount.value.toString(),
        totalSalesAmount.value.toString(),
        totalPaid.value.toString(),
        DateFormat('dd/MM').format(startChosenDate.value),
        DateFormat('dd/MM').format(endChosenDate.value),
    );
  }

  Future<Uint8List> loadSalesByClientPdf() async{
    return PdfChartDataWork.createPDFSalesBClient(
        filterByClient,
        totalInvoicesAsClient.value.toString(),
        totalSalesAsClient.value.toString(),
        totalPercentageAsClient.value.toStringAsFixed(2),
        DateFormat('dd/MM').format(startChosenDate.value),
        DateFormat('dd/MM').format(endChosenDate.value),
    );
  }

  Future<Uint8List> loadSalesByItemPdf() async {
    return PdfChartDataWork.createPDFSalesByItems(
      filterAllItems,
      totalItemsQTY.value.toString(),
      totalSalesByItems.value.toString(),
      totalPercentageAsItems.value.toStringAsFixed(2),
      DateFormat('dd/MM').format(startChosenDate.value),
      DateFormat('dd/MM').format(endChosenDate.value),
    );
  }

  Future<void> sharePdfFile(Uint8List pdfData, String filename) async {
    try {

      final directory = await getTemporaryDirectory();
      final filePath = '${directory.path}\\$filename';

      debugPrint("Directory Path: $directory");
      debugPrint("File Path: $filePath");

      final file = File(filePath);
      await file.writeAsBytes(pdfData);

      await Share.shareXFiles([XFile(filePath)], text: 'Check out this PDF file!');

      debugPrint('PDF file saved and shared successfully.');
    } catch (e) {
      debugPrint('Error sharing PDF: $e');
      Utils().snackBarMsg('Error', 'Failed to share the file');
    }
  }

  Future<void> downloadPdfInDesktop(Uint8List pdfData, String fileName) async{
    Directory? downloadsDirectory = await getDownloadsDirectory();

    if (downloadsDirectory == null) {
      throw Exception(
          'Could not find the downloads directory');
    }

    final filePath = '${downloadsDirectory.path}/$fileName.pdf';
    final file = File(filePath);

    await file.writeAsBytes(pdfData);
  }

}