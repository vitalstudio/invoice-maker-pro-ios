
import 'dart:typed_data';


class PDFDataModel{
  String? invoiceTitle;
  String? invoiceNumber;
  String? creationDate;
  String? dueDate;
  String? fName;
  String? fEmail;
  String? fBillingAddress;
  String? fPhoneNumber;
  String? fWebsiteUrl;
  String? cName;
  String? cEmail;
  String? cPhoneNo;
  String? cBillingAddress;
  String? cShippingAddress;
  List<String>? itemDescription;
  List<String>? itemQTY;
  List<String>? itemPrice;
  List<String>? itemDiscount;
  List<String>? itemTAX;
  List<String>? itemAmount;
  String? paymentMethod;
  String? netTotal;
  String? termAndCondition;
  Uint8List? signatureImg;

  List<String>? itemsNameList;
  List<String>? itemsAmountList;
  List<String>? itemsQuantityList;
  List<String>? itemsPriceList;
  List<String>? itemsTaxesList;
  List<String>? itemsDiscountList;

  PDFDataModel({
    this.invoiceTitle,
    this.invoiceNumber,
    this.termAndCondition,
    this.netTotal,
    this.itemDescription,
    this.cEmail,
    this.cPhoneNo,
    this.cShippingAddress,
    this.fWebsiteUrl,
    this.fEmail,
    this.fPhoneNumber,
    this.fBillingAddress,
    this.fName,
    this.creationDate,
    this.dueDate,
    this.itemDiscount,
    this.itemPrice,
    this.cBillingAddress,
    this.cName,
    this.itemAmount,
    this.itemQTY,
    this.itemTAX,
    this.paymentMethod,
    this.signatureImg,
    this.itemsTaxesList,
    this.itemsPriceList,
    this.itemsDiscountList,
    this.itemsAmountList,
    this.itemsNameList,
    this.itemsQuantityList
});

}