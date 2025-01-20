
import 'package:get/get.dart';

class ItemModel{
  int? id;
  String? itemName;
  String? itemPrice;
  String? itemDetail;
  String? unitToMeasure;
  RxBool isChecked = false.obs;
  // String? itemQuantity;
  // String? itemDiscount;
  // String? itemTaxRate;
  // String? itemFinalAmount;

  ItemModel({
    this.id,
    this.itemName,
    this.itemPrice,
    this.itemDetail,
    this.unitToMeasure,
    bool? isChecked,
    // this.itemTaxRate,
    // this.itemDiscount,
    // this.itemQuantity,
    // this.itemFinalAmount
  }){
    this.isChecked.value = isChecked ?? false;
  }

  ItemModel.fromMap(Map<String,dynamic> items):
      id = items['id'],
      itemName = items['itemName'],
      itemPrice = items['itemPrice'],
      unitToMeasure = items['unitToMeasure'],
      itemDetail = items['itemDetail']
      // isChecked = (items['isChecked'] == 1).obs
      // itemQuantity = items['itemQuantity'],
      // itemDiscount = items['itemDiscount'],
      // itemFinalAmount = items['itemFinalAmount'],
      // itemTaxRate = items['itemTaxRate']
      ;

  Map<String,dynamic> toMap() {
    return{
      'id':id,
      'itemName':itemName,
      'itemPrice':itemPrice,
      'unitToMeasure':unitToMeasure,
      'itemDetail': itemDetail,
      // 'isChecked': isChecked.value ? 1 : 0,
      // 'itemQuantity' : itemQuantity,
      // 'itemDiscount' : itemDiscount,
      // 'itemTaxRate' : itemTaxRate,
      // 'itemFinalAmount' : itemFinalAmount,
    };
  }
}