
class PaymentModel{
  int? id;
  String? paymentMethod;

  PaymentModel({this.id,this.paymentMethod});

  PaymentModel.fromMap(Map<String,dynamic> pay):
        id = pay['id'],
        paymentMethod = pay['paymentMethod'];

  Map<String,Object?> toMap() {
    return {
      'id': id,
      'paymentMethod': paymentMethod,
    };
  }
}