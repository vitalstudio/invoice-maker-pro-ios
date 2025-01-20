import 'dart:typed_data';
class BusinessInfoModel {
  final int? id;
  final String? businessName;
  final String? businessEmail;
  final String? businessPhoneNo;
  final String? businessBillingOne;
  final String? businessWebsite;
  final Uint8List? businessLogoImg;

  BusinessInfoModel({
    this.id,
    this.businessName,
    this.businessEmail,
    this.businessPhoneNo,
    this.businessBillingOne,
    this.businessWebsite,
    this.businessLogoImg});

  BusinessInfoModel.fromMap(Map<String, dynamic> companyRes)
  : id = companyRes['id'],
   businessName = companyRes['businessName'],
   businessEmail = companyRes['businessEmail'],
   businessPhoneNo = companyRes['businessPhoneNo'],
   businessBillingOne = companyRes['businessBillingOne'],
   businessWebsite = companyRes['businessWebsite'],
   businessLogoImg = companyRes['businessLogoImg'];

  Map<String,Object?> toMap(){
    return {
      'id': id,
      'businessName': businessName,
      'businessEmail': businessEmail,
      'businessPhoneNo': businessPhoneNo,
      'businessBillingOne': businessBillingOne,
      'businessWebsite': businessWebsite,
      'businessLogoImg': businessLogoImg,
    };
  }

}