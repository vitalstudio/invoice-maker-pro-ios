import 'package:get/get.dart';

class ClientModel {
   final int? id;
   final String? clientName;
   final String? clientEmailAddress;
   final String? clientPhoneNo;
   final String? firstBillingAddress;
   final String? firstShippingAddress;
   final String? clientDetail;
   RxBool isChecked = false.obs;

   ClientModel({
     this.id,
     this.clientName,
     this.clientEmailAddress,
     this.clientPhoneNo,
     this.firstBillingAddress,
     this.firstShippingAddress,
     this.clientDetail,
     bool? isChecked,
}){
     this.isChecked.value = isChecked ?? false;
   }

   ClientModel.fromMap(Map<String, dynamic> clientRes)
     :id = clientRes['id'],
      clientName = clientRes['clientName'],
      clientEmailAddress = clientRes['clientEmailAddress'],
      clientPhoneNo = clientRes['clientPhoneNo'],
      firstBillingAddress = clientRes['firstBillingAddress'],
      firstShippingAddress = clientRes['firstShippingAddress'],
      clientDetail = clientRes['clientDetail'];

  Map<String, Object?> toMap(){
       return{
         'id': id,
         'clientName': clientName,
         'clientEmailAddress': clientEmailAddress,
         'clientPhoneNo': clientPhoneNo,
         'firstBillingAddress': firstBillingAddress,
         'firstShippingAddress': firstShippingAddress,
         'clientDetail': clientDetail,
       };
  }
}