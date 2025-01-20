import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../core/routes/routes.dart';
import '../../core/services/ads_controller.dart';
import '../../model/client_model.dart';
import '../../core/constants/color/color.dart';
import '../../core/utils/utils.dart';
import '../../core/constants/app_constants/App_Constants.dart';
import '../../core/app_singletons/app_singletons.dart';
import '../../database/database_helper.dart';
import '../../model/fetch_data_model.dart';
import '../../model/data_model.dart';

class HomeController extends GetxController with AdsControllerMixin {
  RxList<ClientModel> allClientNameList = <ClientModel>[].obs;
  RxString selectedName = ''.obs;

  DBHelper? homeDbHelper;

  RxList<DataModel> invoiceList = <DataModel>[].obs;

  Rx<List<FetchedData>> fetchedDataList = Rx<List<FetchedData>>([]);
  Rx<List<FetchedData>> filteredDataList = Rx<List<FetchedData>>([]);

  Rx<List<FetchedData>> fetchedUnpaidList = Rx<List<FetchedData>>([]);
  Rx<List<FetchedData>> filteredUnpaidList = Rx<List<FetchedData>>([]);

  Rx<List<FetchedData>> fetchedPPList = Rx<List<FetchedData>>([]);
  Rx<List<FetchedData>> filteredPPList = Rx<List<FetchedData>>([]);

  Rx<List<FetchedData>> fetchedOverdueList = Rx<List<FetchedData>>([]);
  Rx<List<FetchedData>> filteredOverdueList = Rx<List<FetchedData>>([]);

  Rx<List<FetchedData>> fetchedPaidList = Rx<List<FetchedData>>([]);
  Rx<List<FetchedData>> filteredPaidList = Rx<List<FetchedData>>([]);

  RxList<DataModel> dummyInvoicesList = <DataModel>[].obs;
  Rx<List<FetchedData>> assignDummyDataList = Rx<List<FetchedData>>([]);

  RxString listShowingType = AppConstants.all.obs;

  TextEditingController searchController = TextEditingController();

  RxBool isLoadingData = false.obs;

  RxInt invoiceIdToOpenPdf = 0.obs;

  RxString invoicePaidStatus = ''.obs;

  final formKey = GlobalKey<FormState>();

  TextEditingController partiallyPaidController = TextEditingController();

  Rxn<DateTime> fromDate = Rxn<DateTime>();
  Rxn<DateTime> toDate = Rxn<DateTime>();
  RxBool isFilteringList = false.obs;

  @override
  void onInit() {
    // adsControllerService.showInterstitialAd();
    homeDbHelper = DBHelper();
    loadInvoiceData();

    getAllClientList();

    searchController.addListener(_filterList);

    if(!AppSingletons.isProScreenShowed.value) {
      showProIfUserNotSubscribed();
      AppSingletons.isProScreenShowed.value = true;
    }

    super.onInit();
  }

  Future<void> getAllClientList() async {
    final list = await homeDbHelper!.getClientList();
    allClientNameList.assignAll(list);
  }

  void dateFrom(DateTime date) {
    fromDate.value = date;
  }

  void dateTo(DateTime endDate) {
    toDate.value = endDate;
  }

  void updateKeyboardVisibility(bool isKeyboardVisible) {
    AppSingletons.isKeyboardVisible.value = isKeyboardVisible;
  }

  Future<void> showProIfUserNotSubscribed() async {

    if (!AppSingletons.isSubscriptionEnabled.value) {
      Timer(const Duration(milliseconds: 500), () {
        Get.toNamed(Routes.proScreenView);
      });
    }
  }

  String getDueDays(String dueDateString) {
    try {
      DateTime today = DateTime.now();
      DateTime due;

      try {
        due = DateTime.parse(dueDateString);
      } catch (e) {
        due = DateFormat('dd/MM/yyyy').parse(dueDateString);
      }

      DateTime todayDateOnly = DateTime(today.year, today.month, today.day);
      DateTime dueDateOnly = DateTime(due.year, due.month, due.day);

      int difference = dueDateOnly.difference(todayDateOnly).inDays;

      if (difference == 0) {
        return 'Due Today';
      } else if (difference == 1) {
        return 'Due the next day';
      } else if (difference > 1) {
        return 'Due in $difference days';
      } else {
        return 'Overdue by ${difference.abs()} days';
      }
    } catch (e) {
      return 'Invalid Date';
    }
  }

  Future<void> loadInvoiceData() async {
    isLoadingData.value = true;

    try{
      final list = await homeDbHelper!.getInvoiceList();

      invoiceList.assignAll(list);

      fetchedDataList.value.clear();

      // var invoicesList = invoiceList.last;
      // debugPrint('ONLY LATEST INVOICE ID: ${invoicesList.id}');
      // int? lastIdInvoice = (invoicesList.id ?? 0) + 1;
      // AppSingletons.lastPDFID.value = lastIdInvoice;

      for (var element in invoiceList) {
        AppSingletons.invoiceStatus.value = element.documentStatus.toString();
        AppSingletons.partialPaymentAmount?.value = element.partiallyPaidAmount.toString();

        debugPrint('Invoice ID: ${element.id}');

        invoicePaidStatus.value = AppSingletons.invoiceStatus.value;

        debugPrint('ItemNamesList: ${element.itemNames}');
        debugPrint('ItemAmountList: ${element.itemsAmountList}');

        debugPrint('Template ID: ${element.selectedTemplateId}');
        //
        // debugPrint('clientName: ${element.clientName}');
        //
        // debugPrint('Invoice Paid Status: ${AppSingletons.invoiceStatus.value}');
        //
        // debugPrint('Partially paid amount: ${element.partiallyPaidAmount}');

        debugPrint('Current Date: ${DateTime.now()}');
        debugPrint('Due Date: ${element.dueDate.toString()}');
        debugPrint('isOverdue: ${Utils.isOverdue(element.dueDate.toString())}');

        String dueDaysCal = getDueDays(element.dueDate ?? '');

        int partiallyPaidAmount = int.tryParse(element.partiallyPaidAmount.toString()) ?? 0;
        int totalInvoiceAmount = int.tryParse(element.finalNetTotal.toString()) ?? 0;
        int? remainingAmount;

        if(element.documentStatus == AppConstants.partiallyPaidInvoice){
          remainingAmount = totalInvoiceAmount - partiallyPaidAmount;
          debugPrint('REMAINING-AMOUNT: $remainingAmount');
        }

        fetchedDataList.value.add(FetchedData(
            id: element.id,
            itemPrice: int.parse(element.finalNetTotal.toString()),
            clientName: element.clientName,
            endDate: element.dueDate,
            startDate: element.creationDate,
            invoiceTitle: element.titleName,
            invoiceId: element.uniqueNumber,
            invoiceTempId: int.tryParse(element.selectedTemplateId ?? '0'),
            currencyName: element.currencyName.toString(),
            partialPaymentAmount: element.partiallyPaidAmount.toString(),
            invoicePaidStatus: element.documentStatus.toString(),
            remainingPayableAmount: remainingAmount.toString(),
            dueDaysData: dueDaysCal,
            isOverdue: Utils.isOverdue(
              element.dueDate.toString(),
            )));
      }

      filteredDataList.value.assignAll(fetchedDataList.value);

      // Separating Unpaid invoices
      fetchedUnpaidList.value.assignAll(fetchedDataList.value.where((element) =>
      element.invoicePaidStatus == AppConstants.unpaidInvoice &&
          !element.isOverdue!));
      filteredUnpaidList.value.assignAll(fetchedUnpaidList.value);

      // Separating Partially Paid invoices
      fetchedPPList.value.assignAll(fetchedDataList.value.where((element) =>
      element.invoicePaidStatus == AppConstants.partiallyPaidInvoice &&
          !element.isOverdue!));
      filteredPPList.value.assignAll(fetchedPPList.value);

      // Separating overdue invoices

      fetchedOverdueList.value.assignAll(fetchedDataList.value
          .where((element) =>
      element.invoicePaidStatus != AppConstants.paidInvoice &&
          Utils.isOverdue(element.endDate.toString())));
      filteredOverdueList.value.assignAll(fetchedOverdueList.value);

      // Separating Paid invoices
      fetchedPaidList.value.assignAll(fetchedDataList.value.where((element) =>
      element.invoicePaidStatus == AppConstants.paidInvoice));
      filteredPaidList.value.assignAll(fetchedPaidList.value);

      double totalUnpaid = fetchedUnpaidList.value
          .where((element) => !element.isOverdue!)
          .fold(0, (sum, element) => sum + element.itemPrice!);

      double totalPartialUnpaid = fetchedPPList.value
          .where((element) => !element.isOverdue!)
          .fold(0, (sum, element) {
        double partialPaidAmount =
        _extractNumericValue(element.partialPaymentAmount.toString());
        double itemPrice = element.itemPrice?.toDouble() ?? 0.0;
        double remainingUnpaid = itemPrice - partialPaidAmount;

        debugPrint(
            'Remaining unpaid: $remainingUnpaid = $itemPrice - $partialPaidAmount');

        return sum + remainingUnpaid;
      });

      AppSingletons.totalUnpaidInvoices.value = (totalUnpaid + totalPartialUnpaid).toString();

      // double totalOverdue = fetchedOverdueList.value
      //     .where((element) => element.invoicePaidStatus != AppConstants.paidInvoice)
      //     .fold(0, (sum, element) => sum + element.itemPrice!);

      double totalOverdue = fetchedOverdueList.value
          .where((element) => element.invoicePaidStatus != AppConstants.paidInvoice)
          .fold(0, (sum, element) {
        double partiallyPaid = double.tryParse(element.partialPaymentAmount ?? '0') ?? 0;
        double remainingOverdue = (element.itemPrice ?? 0) - partiallyPaid;
        return sum + remainingOverdue;
      });

      AppSingletons.totalOverdueInvoices.value = totalOverdue.toString();

      debugPrint('Total Unpaid: ${AppSingletons.totalUnpaidInvoices.value}');

      debugPrint('Total Partially Unpaid: $totalPartialUnpaid');

      debugPrint('Total Overdue: ${AppSingletons.totalOverdueInvoices.value}');

      isLoadingData.value = false;
    } catch(e){
      debugPrint('Error: $e');
      isLoadingData.value = false;
    }
  }

  // Future<void> loadDummyData() async {
  //   try {
  //     isLoadingData.value = true;
  //
  //     final dummyList = await DummyDataList.getDummyList();
  //
  //     dummyInvoicesList.assignAll(dummyList);
  //
  //     assignDummyDataList.value.clear();
  //
  //     debugPrint('List 1 Length: ${dummyInvoicesList.length}');
  //
  //     for (var element in dummyInvoicesList) {
  //       assignDummyDataList.value.add(FetchedData(
  //           id: element.id,
  //           itemPrice: int.parse(element.finalNetTotal.toString()),
  //           clientName: element.clientName,
  //           endDate: element.dueDate,
  //           startDate: element.creationDate,
  //           invoiceTitle: element.titleName,
  //           invoiceId: element.uniqueNumber,
  //           invoiceTempId: int.tryParse(element.selectedTemplateId ?? '0'),
  //           currencyName: element.currencyName.toString(),
  //           partialPaymentAmount: element.partiallyPaidAmount.toString(),
  //           invoicePaidStatus: element.documentStatus.toString(),
  //           isOverdue: Utils.isOverdue(element.dueDate.toString())));
  //     }
  //
  //     debugPrint('List Length: ${assignDummyDataList.value.length}');
  //
  //     isLoadingData.value = false;
  //   } catch (e) {
  //     isLoadingData.value = false;
  //     debugPrint('Error: $e');
  //   }
  // }


  double _extractNumericValue(String partialPaymentAmount) {
    // Use a regular expression to extract numeric values from the string
    final numericString =
        RegExp(r'\d+').stringMatch(partialPaymentAmount) ?? '0';
    return double.parse(numericString);
  }

  void _filterList() {
    String query = searchController.text.toLowerCase();
    if (listShowingType.value == AppConstants.all) {
      if (query.isEmpty) {
        filteredDataList.value = fetchedDataList.value;
      } else {
        filteredDataList.value = fetchedDataList.value.where((invoice) {
          bool matchesClientName = invoice.clientName != null &&
              invoice.clientName!.toLowerCase().contains(query);
          bool matchesInvoiceTitle = invoice.invoiceTitle != null &&
              invoice.invoiceTitle!.toLowerCase().contains(query);
          bool matchesInvoiceId = invoice.invoiceId != null &&
              invoice.invoiceId!.toLowerCase().contains(query);

          return matchesClientName || matchesInvoiceTitle || matchesInvoiceId;
        }).toList();
      }
    } else if (listShowingType.value == AppConstants.unpaidInvoice) {
      if (query.isEmpty) {
        filteredUnpaidList.value = fetchedUnpaidList.value;
      } else {
        filteredUnpaidList.value = fetchedUnpaidList.value.where((invoice) {
          bool matchesClientName = invoice.clientName != null &&
              invoice.clientName!.toLowerCase().contains(query);
          bool matchesInvoiceTitle = invoice.invoiceTitle != null &&
              invoice.invoiceTitle!.toLowerCase().contains(query);
          bool matchesInvoiceId = invoice.invoiceId != null &&
              invoice.invoiceId!.toLowerCase().contains(query);

          return matchesClientName || matchesInvoiceTitle || matchesInvoiceId;
        }).toList();
      }
    } else if (listShowingType.value == AppConstants.partiallyPaidInvoice) {
      if (query.isEmpty) {
        filteredPPList.value = fetchedPPList.value;
      } else {
        filteredPPList.value = fetchedPPList.value.where((invoice) {
          bool matchesClientName = invoice.clientName != null &&
              invoice.clientName!.toLowerCase().contains(query);
          bool matchesInvoiceTitle = invoice.invoiceTitle != null &&
              invoice.invoiceTitle!.toLowerCase().contains(query);
          bool matchesInvoiceId = invoice.invoiceId != null &&
              invoice.invoiceId!.toLowerCase().contains(query);

          return matchesClientName || matchesInvoiceTitle || matchesInvoiceId;
        }).toList();
      }
    } else if (listShowingType.value == AppConstants.overdue) {
      if (query.isEmpty) {
        filteredOverdueList.value = fetchedOverdueList.value;
      } else {
        filteredOverdueList.value = fetchedOverdueList.value.where((invoice) {
          bool matchesClientName = invoice.clientName != null &&
              invoice.clientName!.toLowerCase().contains(query);
          bool matchesInvoiceTitle = invoice.invoiceTitle != null &&
              invoice.invoiceTitle!.toLowerCase().contains(query);
          bool matchesInvoiceId = invoice.invoiceId != null &&
              invoice.invoiceId!.toLowerCase().contains(query);

          return matchesClientName || matchesInvoiceTitle || matchesInvoiceId;
        }).toList();
      }
    } else if (listShowingType.value == AppConstants.paidInvoice) {
      if (query.isEmpty) {
        filteredPaidList.value = fetchedPaidList.value;
      } else {
        filteredPaidList.value = fetchedPaidList.value.where((invoice) {
          bool matchesClientName = invoice.clientName != null &&
              invoice.clientName!.toLowerCase().contains(query);
          bool matchesInvoiceTitle = invoice.invoiceTitle != null &&
              invoice.invoiceTitle!.toLowerCase().contains(query);
          bool matchesInvoiceId = invoice.invoiceId != null &&
              invoice.invoiceId!.toLowerCase().contains(query);

          return matchesClientName || matchesInvoiceTitle || matchesInvoiceId;
        }).toList();
      }
    }
  }

  deleteInvoice(int id) async {
    await homeDbHelper!.deleteInvoice(id);
    invoiceList.removeWhere((element) => element.id == id);
  }

  void clearList() async {
    await homeDbHelper!.deleteAllInvoice();
    invoiceList.clear();
  }

  Future<void> updatePaidStatusInDatabase(int invoiceId, String? statusPaid,String partiallyPaidAmount) async {
    debugPrint('ID: $invoiceId');
    debugPrint('Invoice Status: ${AppSingletons.invoiceStatus.value}');
    debugPrint('Partially Paid Amount: ${AppSingletons.partialPaymentAmount?.value}');
    debugPrint('HomeDbHelper: $homeDbHelper');

    AppSingletons.isEditingOnlyTemplate.value = false;
    Utils().dataModelForEdit(invoiceId, homeDbHelper).then((value) async {

      int storedPartiallyPaidAmount = int.tryParse(AppSingletons.partialPaymentAmount?.value ?? '0') ?? 0;
      int newAddedPartiallyAmount = int.tryParse(partiallyPaidAmount) ?? 0;
      int totalAmount = AppSingletons.finalPriceTotal?.value ?? 0;

      int calculatedPartiallyAmount = storedPartiallyPaidAmount + newAddedPartiallyAmount;

      DataModel invoiceDataModel = DataModel(
          id: invoiceId,
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
          partiallyPaidAmount: statusPaid == AppConstants.partiallyPaidInvoice
                               ? calculatedPartiallyAmount.toString()
                               : '',
          documentStatus: statusPaid ?? '',
          unlockTempIdsList: AppSingletons().unlockedTempIdsList.toList()
      );

      if(calculatedPartiallyAmount > totalAmount){
        Utils().snackBarMsg('Amount Exceeded', 'Previously partially paid was $storedPartiallyPaidAmount and new partially paid is $newAddedPartiallyAmount , so it cannot be partially paid');
      } else if(calculatedPartiallyAmount == totalAmount && statusPaid == AppConstants.partiallyPaidInvoice){
        Utils().snackBarMsg('Amount Equalled', 'Partially paid and Total amount become equal so invoice can\'t be partially paid' );
      }
      else {
        await homeDbHelper?.updateInvoice(invoiceDataModel).then((value) async {
          await loadInvoiceData();
          Utils.clearInvoiceVariables();
          Get.back();
          debugPrint('Paid Status: $statusPaid');
          debugPrint('Paid Status: ${AppSingletons.invoiceStatus.value}');
        });
      }
    });
    // Future.delayed(const Duration(milliseconds: 400),() async{
    //   await loadInvoiceData();
    //   Utils.clearInvoiceVariables();
    //   debugPrint('Paid Status: $statusPaid');
    //   debugPrint('Paid Status: ${AppSingletons.invoiceStatus.value}');
    // });
  }

  Color giveInvoiceStatusColor(bool isOverdue, String invoiceStatus) {
    if (invoiceStatus == AppConstants.paidInvoice) {
      return paidInvoiceColor;
    } else if (!isOverdue) {
      // if(invoiceStatus == AppConstants.paidInvoice){
      //   return paidInvoiceColor;
      // } else
      if (invoiceStatus == AppConstants.unpaidInvoice) {
        return unPaidInvoiceColor;
      } else if (invoiceStatus == AppConstants.partiallyPaidInvoice) {
        return partiallyPaidInvoiceColor;
      } else {
        return Colors.transparent;
      }
    } else {
      return overdueInvoiceColor;
    }
  }

  void filterData() {
    if (selectedName.value.isNotEmpty &&
        fromDate.value != null &&
        toDate.value != null) {
      filteredDataList.value = fetchedDataList.value.where((data) {
        DateTime? dataStartDate = _parseDate(data.startDate);
        DateTime? dataEndDate = _parseDate(data.endDate);

        if (dataStartDate == null || dataEndDate == null) {
          return false;
        }

        return (dataStartDate
                .isAfter(fromDate.value!.subtract(const Duration(days: 1))) &&
            dataStartDate
                .isBefore(toDate.value!.add(const Duration(days: 1))) &&
            data.clientName!
                .toLowerCase()
                .contains(selectedName.value.toLowerCase()));
      }).toList();
      filteredUnpaidList.value = fetchedUnpaidList.value.where((data) {
        DateTime? dataStartDate = _parseDate(data.startDate);
        DateTime? dataEndDate = _parseDate(data.endDate);

        if (dataStartDate == null || dataEndDate == null) {
          return false;
        }

        return (dataStartDate
                .isAfter(fromDate.value!.subtract(const Duration(days: 1))) &&
            dataStartDate
                .isBefore(toDate.value!.add(const Duration(days: 1))) &&
            data.clientName!
                .toLowerCase()
                .contains(selectedName.value.toLowerCase()));
      }).toList();
      filteredPPList.value = fetchedPPList.value.where((data) {
        DateTime? dataStartDate = _parseDate(data.startDate);
        DateTime? dataEndDate = _parseDate(data.endDate);

        if (dataStartDate == null || dataEndDate == null) {
          return false;
        }

        return (dataStartDate
                .isAfter(fromDate.value!.subtract(const Duration(days: 1))) &&
            dataStartDate
                .isBefore(toDate.value!.add(const Duration(days: 1))) &&
            data.clientName!
                .toLowerCase()
                .contains(selectedName.value.toLowerCase()));
      }).toList();
      filteredOverdueList.value = fetchedOverdueList.value.where((data) {
        DateTime? dataStartDate = _parseDate(data.startDate);
        DateTime? dataEndDate = _parseDate(data.endDate);

        if (dataStartDate == null || dataEndDate == null) {
          return false;
        }

        return (dataStartDate
                .isAfter(fromDate.value!.subtract(const Duration(days: 1))) &&
            dataStartDate
                .isBefore(toDate.value!.add(const Duration(days: 1))) &&
            data.clientName!
                .toLowerCase()
                .contains(selectedName.value.toLowerCase()));
      }).toList();
      filteredPaidList.value = fetchedPaidList.value.where((data) {
        DateTime? dataStartDate = _parseDate(data.startDate);
        DateTime? dataEndDate = _parseDate(data.endDate);

        if (dataStartDate == null || dataEndDate == null) {
          return false;
        }

        return (dataStartDate
                .isAfter(fromDate.value!.subtract(const Duration(days: 1))) &&
            dataStartDate
                .isBefore(toDate.value!.add(const Duration(days: 1))) &&
            data.clientName!
                .toLowerCase()
                .contains(selectedName.value.toLowerCase()));
      }).toList();
      ;
    } else if (selectedName.value.isNotEmpty) {
      filteredDataList.value = fetchedDataList.value
          .where((data) => data.clientName!
              .toLowerCase()
              .contains(selectedName.value.toLowerCase()))
          .toList();
      filteredUnpaidList.value = fetchedUnpaidList.value
          .where((data) => data.clientName!
              .toLowerCase()
              .contains(selectedName.value.toLowerCase()))
          .toList();
      filteredPPList.value = fetchedPPList.value
          .where((data) => data.clientName!
              .toLowerCase()
              .contains(selectedName.value.toLowerCase()))
          .toList();
      filteredOverdueList.value = fetchedOverdueList.value
          .where((data) => data.clientName!
              .toLowerCase()
              .contains(selectedName.value.toLowerCase()))
          .toList();
      filteredPaidList.value = fetchedPaidList.value
          .where((data) => data.clientName!
              .toLowerCase()
              .contains(selectedName.value.toLowerCase()))
          .toList();
    } else if (fromDate.value != null && toDate.value != null) {
      filteredDataList.value = fetchedDataList.value.where((data) {
        DateTime? dataStartDate = _parseDate(data.startDate);
        DateTime? dataEndDate = _parseDate(data.endDate);

        if (dataStartDate == null || dataEndDate == null) {
          return false;
        }

        return (dataStartDate
                .isAfter(fromDate.value!.subtract(const Duration(days: 1))) &&
            dataStartDate.isBefore(toDate.value!.add(const Duration(days: 1))));
      }).toList();
      filteredUnpaidList.value = fetchedUnpaidList.value.where((data) {
        DateTime? dataStartDate = _parseDate(data.startDate);
        DateTime? dataEndDate = _parseDate(data.endDate);

        if (dataStartDate == null || dataEndDate == null) {
          return false;
        }

        return (dataStartDate
                .isAfter(fromDate.value!.subtract(const Duration(days: 1))) &&
            dataStartDate.isBefore(toDate.value!.add(const Duration(days: 1))));
      }).toList();
      filteredPPList.value = fetchedPPList.value.where((data) {
        DateTime? dataStartDate = _parseDate(data.startDate);
        DateTime? dataEndDate = _parseDate(data.endDate);

        if (dataStartDate == null || dataEndDate == null) {
          return false;
        }

        return (dataStartDate
                .isAfter(fromDate.value!.subtract(const Duration(days: 1))) &&
            dataStartDate.isBefore(toDate.value!.add(const Duration(days: 1))));
      }).toList();
      filteredOverdueList.value = fetchedOverdueList.value.where((data) {
        DateTime? dataStartDate = _parseDate(data.startDate);
        DateTime? dataEndDate = _parseDate(data.endDate);

        if (dataStartDate == null || dataEndDate == null) {
          return false;
        }

        return (dataStartDate
                .isAfter(fromDate.value!.subtract(const Duration(days: 1))) &&
            dataStartDate.isBefore(toDate.value!.add(const Duration(days: 1))));
      }).toList();
      filteredPaidList.value = fetchedPaidList.value.where((data) {
        DateTime? dataStartDate = _parseDate(data.startDate);
        DateTime? dataEndDate = _parseDate(data.endDate);

        if (dataStartDate == null || dataEndDate == null) {
          return false;
        }

        return (dataStartDate
                .isAfter(fromDate.value!.subtract(const Duration(days: 1))) &&
            dataStartDate.isBefore(toDate.value!.add(const Duration(days: 1))));
      }).toList();
    } else {
      filteredDataList.value = fetchedDataList.value;
      filteredUnpaidList.value = fetchedUnpaidList.value;
      filteredPPList.value = fetchedPPList.value;
      filteredOverdueList.value = fetchedOverdueList.value;
      filteredPaidList.value = fetchedPaidList.value;
    }
  }

  DateTime? _parseDate(String? dateString) {
    if (dateString == null || dateString.isEmpty) return null;
    try {
      return DateTime.parse(dateString);
    } catch (e) {
      debugPrint('Error parsing date: $e');
      return null;
    }
  }
}
