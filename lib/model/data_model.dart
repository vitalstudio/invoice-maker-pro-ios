import 'dart:typed_data';

class DataModel{
  int? id;
  String? uniqueNumber;
  String? creationDate;
  String? dueDate;
  String? purchaseOrderNo;
  String? titleName;
  String? languageName;
  String? clientName;
  String? clientEmail;
  String? clientPhoneNumber;
  String? clientBillingAddress;
  String? clientShippingAddress;
  String? clientDetail;
  Uint8List? businessLogoImg;
  String? businessName;
  String? businessEmail;
  String? businessPhoneNumber;
  String? businessBillingAddress;
  String? businessWebsite;
  List<String>? itemNames;
  List<String>? itemsQuantityList;
  List<String>? itemsPriceList;
  List<String>? itemsDiscountList;
  List<String>? itemsTaxesList;
  List<String>? itemsAmountList;
  List<String>? itemsUnitList;
  List<String>? itemsDescriptionList;
  String? currencyName;
  Uint8List? signatureImg;
  String? termAndCondition;
  String? paymentMethod;
  String? selectedTemplateId;
  String? discountInTotal;
  String? discountPercentage;
  String? taxInTotal;
  String? taxPercentage;
  String? shippingCost;
  String? subTotal;
  String? finalNetTotal;
  String? documentStatus;
  String? partiallyPaidAmount;
  List<String>? unlockTempIdsList;

  DataModel({
   this.id,
   this.uniqueNumber,
   this.creationDate,
   this.dueDate,
   this.titleName,
   this.purchaseOrderNo,
   this.languageName,
   this.clientName,
   this.clientEmail,
   this.clientPhoneNumber,
   this.clientBillingAddress,
   this.clientShippingAddress,
   this.clientDetail,
   this.businessLogoImg,
   this.businessName,
   this.businessEmail,
   this.businessPhoneNumber,
   this.businessBillingAddress,
   this.businessWebsite,
   this.itemNames,
   this.itemsAmountList,
   this.itemsQuantityList,
   this.itemsDiscountList,
   this.itemsTaxesList,
   this.itemsPriceList,
   this.itemsUnitList,
   this.itemsDescriptionList,
   this.currencyName,
   this.signatureImg,
   this.termAndCondition,
   this.paymentMethod,
   this.selectedTemplateId,
   this.discountInTotal,
   this.discountPercentage,
   this.taxInTotal,
   this.taxPercentage,
   this.shippingCost,
   this.subTotal,
   this.finalNetTotal,
   this.documentStatus,
   this.partiallyPaidAmount,
   this.unlockTempIdsList
});

  DataModel.fromMap(Map<String,dynamic> map):
      id = map['id'],
      uniqueNumber = map['uniqueNumber'],
      creationDate = map['creationDate'],
      dueDate = map['dueDate'],
      titleName = map['titleName'],
      purchaseOrderNo = map['purchaseOrderNo'],
      languageName = map['languageName'],
      clientName = map['clientName'],
      clientEmail = map['clientEmail'],
      clientPhoneNumber = map['clientPhoneNumber'],
      clientBillingAddress = map['clientBillingAddress'],
      clientShippingAddress = map['clientShippingAddress'],
      clientDetail = map['clientDetail'],
      businessLogoImg = map['businessLogoImg'],
      businessName = map['businessName'],
      businessEmail = map['businessEmail'],
      businessPhoneNumber = map['businessPhoneNumber'],
      businessBillingAddress = map['businessBillingAddress'],
      businessWebsite = map['businessWebsite'],
      itemsAmountList = map['itemsAmountList'].split(',') ?? [],
      itemsPriceList = map['itemsPriceList'].split(',') ?? [],
      itemNames = map['itemNames'].split(',') ?? [],
      itemsDiscountList = map['itemsDiscountList'].split(',') ?? [],
      itemsQuantityList = map['itemsQuantityList'].split(',') ?? [],
      itemsTaxesList = map['itemsTaxesList'].split(',') ?? [],
      itemsUnitList = map['itemsUnitList'].split(',') ?? [],
      itemsDescriptionList = map['itemsDescriptionList'].split(',') ?? [],
      unlockTempIdsList = map['unlockTempIds'].split(',') ?? [],
      currencyName = map['currencyName'],
      signatureImg = map['signatureImg'],
      termAndCondition = map['termAndCondition'],
      paymentMethod = map['paymentMethod'],
      selectedTemplateId = map['selectedTemplateId'] ?? '0',
      discountInTotal = map['discountInTotal'],
      discountPercentage = map['discountPercentage'],
      taxInTotal = map['taxInTotal'],
      taxPercentage = map['taxPercentage'],
      shippingCost = map['shippingCost'],
      subTotal = map['subTotal'],
      finalNetTotal = map['finalNetTotal'],
      documentStatus = map['documentStatus'],
      partiallyPaidAmount = map['partiallyPaidAmount'];

  Map<String,Object?> toMap(){
    return {
      'id': id,
      'uniqueNumber' : uniqueNumber,
      'creationDate' : creationDate,
      'dueDate' : dueDate,
      'titleName' : titleName,
      'purchaseOrderNo' : purchaseOrderNo,
      'languageName' : languageName,
      'clientName' : clientName,
      'clientEmail' : clientEmail,
      'clientPhoneNumber' : clientPhoneNumber,
      'clientBillingAddress' : clientBillingAddress,
      'clientShippingAddress' : clientShippingAddress,
      'clientDetail' : clientDetail,
      'businessLogoImg' : businessLogoImg,
      'businessName' : businessName,
      'businessEmail' : businessEmail,
      'businessPhoneNumber' : businessPhoneNumber,
      'businessBillingAddress' : businessBillingAddress,
      'businessWebsite' : businessWebsite,
      'itemsAmountList' : itemsAmountList?.join(','),
      'itemsPriceList' : itemsPriceList?.join(','),
      'itemNames' : itemNames?.join(','),
      'itemsDiscountList' : itemsDiscountList?.join(','),
      'itemsTaxesList' : itemsTaxesList?.join(','),
      'itemsQuantityList' : itemsQuantityList?.join(','),
      'itemsUnitList' : itemsUnitList?.join(','),
      'itemsDescriptionList' : itemsDescriptionList?.join(','),
      'unlockTempIds' : unlockTempIdsList?.join(','),
      'currencyName' : currencyName,
      'signatureImg' : signatureImg,
      'termAndCondition' : termAndCondition,
      'paymentMethod' : paymentMethod,
      'selectedTemplateId' : selectedTemplateId,
      'discountInTotal' : discountInTotal,
      'discountPercentage' : discountPercentage,
      'taxInTotal' : taxInTotal,
      'taxPercentage' : taxPercentage,
      'shippingCost' : shippingCost,
      'subTotal' : subTotal,
      'finalNetTotal' : finalNetTotal,
      'documentStatus' : documentStatus,
      'partiallyPaidAmount' : partiallyPaidAmount
    };
  }
}