import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/app_singletons/app_singletons.dart';
import '../../core/constants/app_constants/App_Constants.dart';
import '../../core/constants/color/color.dart';
import '../../core/utils/utils.dart';
import '../../database/database_helper.dart';
import '../../model/client_model.dart';
import '../../model/fetch_data_model.dart';
import '../../model/data_model.dart';

class EstimateListController extends GetxController{

  DBHelper? estimateDbHelper;

  TextEditingController searchController = TextEditingController();

  RxList<DataModel> estimateList = <DataModel>[].obs;

  Rx<List<FetchedData>> fetchedDataList = Rx<List<FetchedData>>([]);
  Rx<List<FetchedData>> filteredDataList = Rx<List<FetchedData>>([]);

  Rx<List<FetchedData>> fetchedPendingList = Rx<List<FetchedData>>([]);
  Rx<List<FetchedData>> filteredPendingList = Rx<List<FetchedData>>([]);

  Rx<List<FetchedData>> fetchedApprovedList = Rx<List<FetchedData>>([]);
  Rx<List<FetchedData>> filteredApprovedList = Rx<List<FetchedData>>([]);

  Rx<List<FetchedData>> fetchedOverdueList = Rx<List<FetchedData>>([]);
  Rx<List<FetchedData>> filteredOverdueList = Rx<List<FetchedData>>([]);

  Rx<List<FetchedData>> fetchedCancelList = Rx<List<FetchedData>>([]);
  Rx<List<FetchedData>> filteredCancelList = Rx<List<FetchedData>>([]);

  RxList<ClientModel> allClientNameList = <ClientModel>[].obs;
  RxString selectedName = ''.obs;
  Rxn<DateTime> fromDate = Rxn<DateTime>();
  Rxn<DateTime> toDate = Rxn<DateTime>();
  RxBool isFilteringList = false.obs;

  RxString estimateStatus = ''.obs;

  RxBool isLoadingData = false.obs;

  RxString listShowingType = AppConstants.all.obs;

  void updateKeyboardVisibility(bool isKeyboardVisible) {

    AppSingletons.isKeyboardVisible.value = isKeyboardVisible;

  }

  Future<void> getAllClientList() async {

    final list = await estimateDbHelper!.getClientList();
    allClientNameList.assignAll(list);

  }

  @override
  void onInit() {
    estimateDbHelper = DBHelper();
    loadEstimateData();
    getAllClientList();
    searchController.addListener(_filterList);
    super.onInit();
  }

  void dateFrom(DateTime date) {
    fromDate.value = date;
  }
  void dateTo(DateTime endDate) {
    toDate.value = endDate;
  }

  Future<void> loadEstimateData() async{
    isLoadingData.value = true;
    final list = await estimateDbHelper!.getEstimateList();

    estimateList.assignAll(list);

    fetchedDataList.value.clear();

    for(var element in estimateList){

      AppSingletons.estimateStatus.value = element.documentStatus.toString();
      estimateStatus.value = AppSingletons.estimateStatus.value;

      fetchedDataList.value.add(
          FetchedData(
              id: element.id,
              itemPrice: int.parse(element.finalNetTotal.toString()),
              clientName: element.clientName,
              endDate: element.dueDate,
              startDate: element.creationDate,
              invoiceTitle: element.titleName,
              invoiceId: element.uniqueNumber,
              invoiceTempId: int.tryParse(element.selectedTemplateId ?? '0'),
              currencyName: element.currencyName.toString(),
              invoicePaidStatus: element.documentStatus,
              isOverdue: Utils.isOverdue(element.dueDate.toString())
          )
      );
    }

    filteredDataList.value.assignAll(fetchedDataList.value);

    // Separating Pending Estimates List
    fetchedPendingList.value.assignAll(fetchedDataList.value.where((element) =>
    element.invoicePaidStatus == AppConstants.pending && !element.isOverdue!));
    filteredPendingList.value.assignAll(fetchedPendingList.value);

    // Separating Approved Estimates List

    fetchedApprovedList.value.assignAll(fetchedDataList.value.where((element) =>
    element.invoicePaidStatus == AppConstants.approved));
    filteredApprovedList.value.assignAll(fetchedApprovedList.value);

    // Separating Overdue Estimate List
    fetchedOverdueList.value.assignAll(fetchedDataList.value.where(
            (element) =>
                element.invoicePaidStatus != AppConstants.approved &&
                element.invoicePaidStatus != AppConstants.cancel &&
                Utils.isOverdue(element.endDate.toString())
    ));
    filteredOverdueList.value.assignAll(fetchedOverdueList.value);

    // Separating Cancel Estimates List
    fetchedCancelList.value.assignAll(fetchedDataList.value.where((element) =>
    element.invoicePaidStatus == AppConstants.cancel));
    filteredCancelList.value.assignAll(fetchedCancelList.value);


    isLoadingData.value = false;
  }

  void _filterList() {
    String query = searchController.text.toLowerCase();

    if(listShowingType.value == AppConstants.all){

      if (query.isEmpty) {
        filteredDataList.value = fetchedDataList.value;
      } else {
        filteredDataList.value = fetchedDataList.value.where((invoice) {
          bool matchesClientName = invoice.clientName != null && invoice.clientName!.toLowerCase().contains(query);
          bool matchesInvoiceTitle = invoice.invoiceTitle != null && invoice.invoiceTitle!.toLowerCase().contains(query);
          bool matchesInvoiceId = invoice.invoiceId != null && invoice.invoiceId!.toLowerCase().contains(query);

          return matchesClientName || matchesInvoiceTitle || matchesInvoiceId;
        }).toList();
      }

    } else if(listShowingType.value == AppConstants.pending){

      if (query.isEmpty) {
        filteredPendingList.value = fetchedPendingList.value;
      } else {
        filteredPendingList.value = fetchedPendingList.value.where((invoice) {
          bool matchesClientName = invoice.clientName != null && invoice.clientName!.toLowerCase().contains(query);
          bool matchesInvoiceTitle = invoice.invoiceTitle != null && invoice.invoiceTitle!.toLowerCase().contains(query);
          bool matchesInvoiceId = invoice.invoiceId != null && invoice.invoiceId!.toLowerCase().contains(query);

          return matchesClientName || matchesInvoiceTitle || matchesInvoiceId;
        }).toList();
      }

    } else if(listShowingType.value == AppConstants.approved){

      if (query.isEmpty) {
        filteredApprovedList.value = fetchedApprovedList.value;
      } else {
        filteredApprovedList.value = fetchedApprovedList.value.where((invoice) {
          bool matchesClientName = invoice.clientName != null && invoice.clientName!.toLowerCase().contains(query);
          bool matchesInvoiceTitle = invoice.invoiceTitle != null && invoice.invoiceTitle!.toLowerCase().contains(query);
          bool matchesInvoiceId = invoice.invoiceId != null && invoice.invoiceId!.toLowerCase().contains(query);

          return matchesClientName || matchesInvoiceTitle || matchesInvoiceId;
        }).toList();
      }

    } else if(listShowingType.value == AppConstants.overdue){

      if (query.isEmpty) {
        filteredOverdueList.value = fetchedOverdueList.value;
      } else {
        filteredOverdueList.value = fetchedOverdueList.value.where((invoice) {
          bool matchesClientName = invoice.clientName != null && invoice.clientName!.toLowerCase().contains(query);
          bool matchesInvoiceTitle = invoice.invoiceTitle != null && invoice.invoiceTitle!.toLowerCase().contains(query);
          bool matchesInvoiceId = invoice.invoiceId != null && invoice.invoiceId!.toLowerCase().contains(query);

          return matchesClientName || matchesInvoiceTitle || matchesInvoiceId;
        }).toList();
      }

    } else if(listShowingType.value == AppConstants.cancel){

      if (query.isEmpty) {
        filteredCancelList.value = fetchedCancelList.value;
      } else {
        filteredCancelList.value = fetchedCancelList.value.where((invoice) {
          bool matchesClientName = invoice.clientName != null && invoice.clientName!.toLowerCase().contains(query);
          bool matchesInvoiceTitle = invoice.invoiceTitle != null && invoice.invoiceTitle!.toLowerCase().contains(query);
          bool matchesInvoiceId = invoice.invoiceId != null && invoice.invoiceId!.toLowerCase().contains(query);

          return matchesClientName || matchesInvoiceTitle || matchesInvoiceId;
        }).toList();
      }
    }

  }

  deleteEstimate(int id) async {
    await estimateDbHelper!.deleteEstimate(id);
    estimateList.removeWhere((element) => element.id == id);
  }

  void clearList() async {
    await estimateDbHelper!.deleteAllEstimate();
    estimateList.clear();
  }

  Future<void> updateEstimateStatusInDatabase(int estimateId,String? estimateStatusValue) async {

    debugPrint('ID: $estimateId');
    debugPrint('Invoice Status: ${AppSingletons.invoiceStatus.value}');
    debugPrint('HomeDbHelper: $estimateDbHelper');

    Utils().getEstimatesData(estimateId, estimateDbHelper).then((value) async{
      DataModel estimateDataModel = DataModel(
          id: estimateId,
          titleName: AppSingletons.estTitle?.value ?? '',
          purchaseOrderNo: AppSingletons.estPoNumber?.value ?? '',
          uniqueNumber: AppSingletons.estNumberId?.value ?? '',
          languageName: AppSingletons.estLanguageName?.value ?? 'English',
          selectedTemplateId: AppSingletons.estTemplateIdINV.value,
          creationDate: AppSingletons.estCreationDate.value.toString(),
          dueDate: AppSingletons.estDueDate.value.toString(),
          discountInTotal: AppSingletons.estDiscountAmount.value,
          taxInTotal: AppSingletons.estTaxAmount.value,
          shippingCost: AppSingletons.estShippingCost.value,
          itemNames: AppSingletons().itemsNameList.toList(),
          itemsAmountList: AppSingletons().itemsAmountList.toList(),
          itemsDiscountList: AppSingletons().itemsDiscountList.toList(),
          itemsPriceList: AppSingletons().itemsPriceList.toList(),
          itemsQuantityList: AppSingletons().itemsQuantityList.toList(),
          itemsTaxesList: AppSingletons().itemsTaxesList.toList(),
          itemsDescriptionList: AppSingletons().itemDescriptionList.toList(),
          itemsUnitList: AppSingletons().itemUnitList.toList(),
          currencyName: AppSingletons.estCurrencyNameINV?.value ?? 'Rs',
          finalNetTotal: AppSingletons.estFinalPriceTotal?.value.toString() ?? '',
          clientName: AppSingletons.estClientNameINV?.value ?? '',
          clientEmail: AppSingletons.estClientEmailINV?.value ?? '',
          clientPhoneNumber: AppSingletons.estClientPhoneNumberINV?.value ?? '',
          clientBillingAddress: AppSingletons.estClientBillingAddressINV?.value ?? '',
          clientShippingAddress: AppSingletons.estClientShippingAddressINV?.value ?? '',
          clientDetail: AppSingletons.estClientDetailINV?.value ?? '',
          businessLogoImg: AppSingletons.estBusinessLogoImg.value,
          businessName: AppSingletons.estBusinessNameINV?.value ?? '',
          businessEmail: AppSingletons.estBusinessEmailINV?.value ?? '',
          businessPhoneNumber: AppSingletons.estBusinessPhoneNumberINV?.value ?? '',
          businessBillingAddress: AppSingletons.estBusinessBillingAddressINV?.value ?? '',
          businessWebsite: AppSingletons.estBusinessWebsiteINV?.value ?? '',
          paymentMethod: AppSingletons.estPaymentMethodINV?.value ?? '',
          signatureImg: AppSingletons.estSignatureImgINV?.value ?? Uint8List(0),
          termAndCondition: AppSingletons.estTermAndConditionINV?.value ?? '',
          taxPercentage: AppSingletons.estTaxPercentage?.value ?? '0',
          discountPercentage: AppSingletons.estDiscountPercentage?.value ?? '0',
          subTotal: AppSingletons.estSubTotal?.value.toString() ?? '',
          documentStatus: estimateStatusValue,
          partiallyPaidAmount: '',
          unlockTempIdsList: AppSingletons().unlockedTempIdsList.toList()
      );

      await estimateDbHelper!.updateEstimate(estimateDataModel).then((value) {
        Get.back();
        Utils.clearEstimateVariables();
        loadEstimateData();
        debugPrint('Paid Status: $estimateStatusValue');
        debugPrint('Paid Status: ${AppSingletons.estimateStatus.value}');
      });
    });
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

  Color giveInvoiceStatusColor(bool isOverdue, String invoiceStatus) {

    if(invoiceStatus == AppConstants.approved){
      return paidInvoiceColor;
    } else if(invoiceStatus == AppConstants.cancel){
    return partiallyPaidInvoiceColor;
    } else if(isOverdue){
      return overdueInvoiceColor;
    } else if(invoiceStatus == AppConstants.pending){
      return unPaidInvoiceColor;
    } else{
      return overdueInvoiceColor;
    }

    // if(!isOverdue){
    //   if(invoiceStatus == AppConstants.approved){
    //     return paidInvoiceColor;
    //   } else if(invoiceStatus == AppConstants.pending){
    //     return unPaidInvoiceColor;
    //   } else if(invoiceStatus == AppConstants.cancel){
    //     return partiallyPaidInvoiceColor;
    //   } else{
    //     return Colors.transparent;
    //   }
    // } else{
    //   return overdueInvoiceColor;
    // }
  }

  String getEstimateStatusText(bool isOverdue, String invoiceStatus) {
    if(invoiceStatus == AppConstants.approved){
      return invoiceStatus;
    } else if(invoiceStatus == AppConstants.cancel){
      return invoiceStatus;
    } else if(isOverdue){
      return 'Overdue';
    } else if(invoiceStatus == AppConstants.pending){
      return invoiceStatus;
    } else{
      return '';
    }
  }

  // void filterData() {
  //
  //   if(listShowingType.value == AppConstants.all){
  //     if(selectedName.value.isNotEmpty && fromDate.value != null && toDate.value != null){
  //
  //       filteredDataList.value = fetchedDataList.value.where((data) {
  //         DateTime? dataStartDate = _parseDate(data.startDate);
  //         DateTime? dataEndDate = _parseDate(data.endDate);
  //
  //         if (dataStartDate == null || dataEndDate == null) {
  //           return false;
  //         }
  //
  //         return (
  //             dataStartDate.isAfter(fromDate.value!.subtract(const Duration(days: 1))) &&
  //                 dataStartDate.isBefore(toDate.value!.add(const Duration(days: 1))) &&
  //                 data.clientName!.toLowerCase().contains(selectedName.value.toLowerCase())
  //         );
  //       }).toList();
  //
  //     }
  //     else if (selectedName.value.isNotEmpty) {
  //
  //       filteredDataList.value = fetchedDataList.value
  //           .where((data) => data.clientName!.toLowerCase().contains(selectedName.value.toLowerCase()))
  //           .toList();
  //     }
  //     else if (fromDate.value != null && toDate.value != null) {
  //
  //       filteredDataList.value = fetchedDataList.value.where((data) {
  //         DateTime? dataStartDate = _parseDate(data.startDate);
  //         DateTime? dataEndDate = _parseDate(data.endDate);
  //
  //         if (dataStartDate == null || dataEndDate == null) {
  //           return false;
  //         }
  //
  //         return (dataStartDate.isAfter(fromDate.value!.subtract(const Duration(days: 1))) &&
  //             dataStartDate.isBefore(toDate.value!.add(const Duration(days: 1))));
  //       }).toList();
  //     }
  //     else {
  //
  //       filteredDataList.value = fetchedDataList.value;
  //
  //     }
  //   }
  //   else if(listShowingType.value == AppConstants.pending){
  //     if(selectedName.value.isNotEmpty && fromDate.value != null && toDate.value != null){
  //
  //       filteredPendingList.value = fetchedPendingList.value.where((data) {
  //         DateTime? dataStartDate = _parseDate(data.startDate);
  //         DateTime? dataEndDate = _parseDate(data.endDate);
  //
  //         if (dataStartDate == null || dataEndDate == null) {
  //           return false;
  //         }
  //
  //         return (
  //             dataStartDate.isAfter(fromDate.value!.subtract(const Duration(days: 1))) &&
  //                 dataStartDate.isBefore(toDate.value!.add(const Duration(days: 1))) &&
  //                 data.clientName!.toLowerCase().contains(selectedName.value.toLowerCase())
  //         );
  //       }).toList();
  //
  //     }
  //     else if (selectedName.value.isNotEmpty) {
  //
  //       filteredPendingList.value = fetchedPendingList.value
  //           .where((data) => data.clientName!.toLowerCase().contains(selectedName.value.toLowerCase()))
  //           .toList();
  //     }
  //     else if (fromDate.value != null && toDate.value != null) {
  //
  //       filteredPendingList.value = fetchedPendingList.value.where((data) {
  //         DateTime? dataStartDate = _parseDate(data.startDate);
  //         DateTime? dataEndDate = _parseDate(data.endDate);
  //
  //         if (dataStartDate == null || dataEndDate == null) {
  //           return false;
  //         }
  //
  //         return (dataStartDate.isAfter(fromDate.value!.subtract(const Duration(days: 1))) &&
  //             dataStartDate.isBefore(toDate.value!.add(const Duration(days: 1))));
  //       }).toList();
  //     }
  //     else {
  //
  //       filteredPendingList.value = fetchedPendingList.value;
  //
  //     }
  //   }
  //   else if(listShowingType.value == AppConstants.approved){
  //     if(selectedName.value.isNotEmpty && fromDate.value != null && toDate.value != null){
  //
  //        fetchedApprovedList.value = fetchedApprovedList.value.where((data) {
  //         DateTime? dataStartDate = _parseDate(data.startDate);
  //         DateTime? dataEndDate = _parseDate(data.endDate);
  //
  //         if (dataStartDate == null || dataEndDate == null) {
  //           return false;
  //         }
  //
  //         return (
  //             dataStartDate.isAfter(fromDate.value!.subtract(const Duration(days: 1))) &&
  //                 dataStartDate.isBefore(toDate.value!.add(const Duration(days: 1))) &&
  //                 data.clientName!.toLowerCase().contains(selectedName.value.toLowerCase())
  //         );
  //       }).toList();
  //
  //     }
  //     else if (selectedName.value.isNotEmpty) {
  //
  //       filteredApprovedList.value = fetchedApprovedList.value
  //           .where((data) => data.clientName!.toLowerCase().contains(selectedName.value.toLowerCase()))
  //           .toList();
  //     }
  //     else if (fromDate.value != null && toDate.value != null) {
  //
  //       filteredApprovedList.value = fetchedApprovedList.value.where((data) {
  //         DateTime? dataStartDate = _parseDate(data.startDate);
  //         DateTime? dataEndDate = _parseDate(data.endDate);
  //
  //         if (dataStartDate == null || dataEndDate == null) {
  //           return false;
  //         }
  //
  //         return (dataStartDate.isAfter(fromDate.value!.subtract(const Duration(days: 1))) &&
  //             dataStartDate.isBefore(toDate.value!.add(const Duration(days: 1))));
  //       }).toList();
  //     }
  //     else {
  //
  //       filteredApprovedList.value = fetchedApprovedList.value;
  //
  //     }
  //   }
  //   else if(listShowingType.value == AppConstants.overdue){
  //     if(selectedName.value.isNotEmpty && fromDate.value != null && toDate.value != null){
  //
  //       filteredOverdueList.value = fetchedOverdueList.value.where((data) {
  //         DateTime? dataStartDate = _parseDate(data.startDate);
  //         DateTime? dataEndDate = _parseDate(data.endDate);
  //
  //         if (dataStartDate == null || dataEndDate == null) {
  //           return false;
  //         }
  //
  //         return (
  //             dataStartDate.isAfter(fromDate.value!.subtract(const Duration(days: 1))) &&
  //                 dataStartDate.isBefore(toDate.value!.add(const Duration(days: 1))) &&
  //                 data.clientName!.toLowerCase().contains(selectedName.value.toLowerCase())
  //         );
  //       }).toList();
  //
  //     }
  //     else if (selectedName.value.isNotEmpty) {
  //
  //       filteredOverdueList.value = fetchedOverdueList.value
  //           .where((data) => data.clientName!.toLowerCase().contains(selectedName.value.toLowerCase()))
  //           .toList();
  //     }
  //     else if (fromDate.value != null && toDate.value != null) {
  //
  //       filteredOverdueList.value = fetchedOverdueList.value.where((data) {
  //         DateTime? dataStartDate = _parseDate(data.startDate);
  //         DateTime? dataEndDate = _parseDate(data.endDate);
  //
  //         if (dataStartDate == null || dataEndDate == null) {
  //           return false;
  //         }
  //
  //         return (dataStartDate.isAfter(fromDate.value!.subtract(const Duration(days: 1))) &&
  //             dataStartDate.isBefore(toDate.value!.add(const Duration(days: 1))));
  //       }).toList();
  //     }
  //     else {
  //
  //       filteredOverdueList.value = fetchedOverdueList.value;
  //
  //     }
  //   }
  //   else if(listShowingType.value == AppConstants.cancel){
  //     if(selectedName.value.isNotEmpty && fromDate.value != null && toDate.value != null){
  //
  //       filteredCancelList.value = fetchedCancelList.value.where((data) {
  //         DateTime? dataStartDate = _parseDate(data.startDate);
  //         DateTime? dataEndDate = _parseDate(data.endDate);
  //
  //         if (dataStartDate == null || dataEndDate == null) {
  //           return false;
  //         }
  //
  //         return (
  //             dataStartDate.isAfter(fromDate.value!.subtract(const Duration(days: 1))) &&
  //                 dataStartDate.isBefore(toDate.value!.add(const Duration(days: 1))) &&
  //                 data.clientName!.toLowerCase().contains(selectedName.value.toLowerCase())
  //         );
  //       }).toList();
  //
  //     }
  //     else if (selectedName.value.isNotEmpty) {
  //
  //       filteredCancelList.value = fetchedCancelList.value
  //           .where((data) => data.clientName!.toLowerCase().contains(selectedName.value.toLowerCase()))
  //           .toList();
  //     }
  //     else if (fromDate.value != null && toDate.value != null) {
  //
  //       filteredCancelList.value = fetchedCancelList.value.where((data) {
  //         DateTime? dataStartDate = _parseDate(data.startDate);
  //         DateTime? dataEndDate = _parseDate(data.endDate);
  //
  //         if (dataStartDate == null || dataEndDate == null) {
  //           return false;
  //         }
  //
  //         return (dataStartDate.isAfter(fromDate.value!.subtract(const Duration(days: 1))) &&
  //             dataStartDate.isBefore(toDate.value!.add(const Duration(days: 1))));
  //       }).toList();
  //     }
  //     else {
  //       filteredCancelList.value = fetchedCancelList.value;
  //     }
  //   }
  // }

  void filterData() {
    if(selectedName.value.isNotEmpty && fromDate.value != null && toDate.value != null){

      filteredDataList.value = fetchedDataList.value.where((data) {
        DateTime? dataStartDate = _parseDate(data.startDate);
        DateTime? dataEndDate = _parseDate(data.endDate);

        if (dataStartDate == null || dataEndDate == null) {
          return false;
        }

        return (
            dataStartDate.isAfter(fromDate.value!.subtract(const Duration(days: 1))) &&
                dataStartDate.isBefore(toDate.value!.add(const Duration(days: 1))) &&
                data.clientName!.toLowerCase().contains(selectedName.value.toLowerCase())
        );
      }).toList();
      filteredPendingList.value = fetchedPendingList.value.where((data) {
        DateTime? dataStartDate = _parseDate(data.startDate);
        DateTime? dataEndDate = _parseDate(data.endDate);

        if (dataStartDate == null || dataEndDate == null) {
          return false;
        }

        return (
            dataStartDate.isAfter(fromDate.value!.subtract(const Duration(days: 1))) &&
                dataStartDate.isBefore(toDate.value!.add(const Duration(days: 1))) &&
                data.clientName!.toLowerCase().contains(selectedName.value.toLowerCase())
        );
      }).toList();
      filteredApprovedList.value = fetchedApprovedList.value.where((data) {
        DateTime? dataStartDate = _parseDate(data.startDate);
        DateTime? dataEndDate = _parseDate(data.endDate);

        if (dataStartDate == null || dataEndDate == null) {
          return false;
        }

        return (
            dataStartDate.isAfter(fromDate.value!.subtract(const Duration(days: 1))) &&
                dataStartDate.isBefore(toDate.value!.add(const Duration(days: 1))) &&
                data.clientName!.toLowerCase().contains(selectedName.value.toLowerCase())
        );
      }).toList();
      filteredOverdueList.value = fetchedOverdueList.value.where((data) {
        DateTime? dataStartDate = _parseDate(data.startDate);
        DateTime? dataEndDate = _parseDate(data.endDate);

        if (dataStartDate == null || dataEndDate == null) {
          return false;
        }

        return (
            dataStartDate.isAfter(fromDate.value!.subtract(const Duration(days: 1))) &&
                dataStartDate.isBefore(toDate.value!.add(const Duration(days: 1))) &&
                data.clientName!.toLowerCase().contains(selectedName.value.toLowerCase())
        );
      }).toList();
      filteredCancelList.value = fetchedCancelList.value.where((data) {
        DateTime? dataStartDate = _parseDate(data.startDate);
        DateTime? dataEndDate = _parseDate(data.endDate);

        if (dataStartDate == null || dataEndDate == null) {
          return false;
        }

        return (
            dataStartDate.isAfter(fromDate.value!.subtract(const Duration(days: 1))) &&
                dataStartDate.isBefore(toDate.value!.add(const Duration(days: 1))) &&
                data.clientName!.toLowerCase().contains(selectedName.value.toLowerCase())
        );
      }).toList();

    }
    else if (selectedName.value.isNotEmpty) {

      filteredDataList.value = fetchedDataList.value.where((data) => data.clientName!.toLowerCase().contains(selectedName.value.toLowerCase()
      )).toList();
      filteredPendingList.value = fetchedPendingList.value.where((data) => data.clientName!.toLowerCase().contains(selectedName.value.toLowerCase()
      )).toList();
      filteredApprovedList.value = fetchedApprovedList.value.where((data) => data.clientName!.toLowerCase().contains(selectedName.value.toLowerCase()
      )).toList();
      filteredOverdueList.value = fetchedOverdueList.value.where((data) => data.clientName!.toLowerCase().contains(selectedName.value.toLowerCase()
      )).toList();
      filteredCancelList.value = fetchedCancelList.value.where((data) => data.clientName!.toLowerCase().contains(selectedName.value.toLowerCase()
      )).toList();

    }
    else if (fromDate.value != null && toDate.value != null) {

      filteredDataList.value = fetchedDataList.value.where((data) {
        DateTime? dataStartDate = _parseDate(data.startDate);
        DateTime? dataEndDate = _parseDate(data.endDate);

        if (dataStartDate == null || dataEndDate == null) {
          return false;
        }

        return (dataStartDate.isAfter(fromDate.value!.subtract(const Duration(days: 1))) &&
            dataStartDate.isBefore(toDate.value!.add(const Duration(days: 1))));
      }).toList();
      filteredPendingList.value = fetchedPendingList.value.where((data) {
        DateTime? dataStartDate = _parseDate(data.startDate);
        DateTime? dataEndDate = _parseDate(data.endDate);

        if (dataStartDate == null || dataEndDate == null) {
          return false;
        }

        return (dataStartDate.isAfter(fromDate.value!.subtract(const Duration(days: 1))) &&
            dataStartDate.isBefore(toDate.value!.add(const Duration(days: 1))));
      }).toList();
      filteredApprovedList.value = fetchedApprovedList.value.where((data) {
        DateTime? dataStartDate = _parseDate(data.startDate);
        DateTime? dataEndDate = _parseDate(data.endDate);

        if (dataStartDate == null || dataEndDate == null) {
          return false;
        }

        return (dataStartDate.isAfter(fromDate.value!.subtract(const Duration(days: 1))) &&
            dataStartDate.isBefore(toDate.value!.add(const Duration(days: 1))));
      }).toList();
      filteredOverdueList.value = fetchedOverdueList.value.where((data) {
        DateTime? dataStartDate = _parseDate(data.startDate);
        DateTime? dataEndDate = _parseDate(data.endDate);

        if (dataStartDate == null || dataEndDate == null) {
          return false;
        }

        return (dataStartDate.isAfter(fromDate.value!.subtract(const Duration(days: 1))) &&
            dataStartDate.isBefore(toDate.value!.add(const Duration(days: 1))));
      }).toList();
      filteredCancelList.value = fetchedCancelList.value.where((data) {
        DateTime? dataStartDate = _parseDate(data.startDate);
        DateTime? dataEndDate = _parseDate(data.endDate);

        if (dataStartDate == null || dataEndDate == null) {
          return false;
        }

        return (dataStartDate.isAfter(fromDate.value!.subtract(const Duration(days: 1))) &&
            dataStartDate.isBefore(toDate.value!.add(const Duration(days: 1))));
      }).toList();

    }
    else {

      filteredDataList.value = fetchedDataList.value;
      filteredPendingList.value = fetchedPendingList.value;
      filteredApprovedList.value = fetchedApprovedList.value;
      filteredOverdueList.value = fetchedOverdueList.value;
      filteredCancelList.value = fetchedCancelList.value;

    }

  }

}