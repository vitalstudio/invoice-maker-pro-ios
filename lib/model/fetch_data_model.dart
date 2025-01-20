

class FetchedData {
  int? id;
  String? startDate;
  String? endDate;
  String? clientName;
  String? invoiceTitle;
  String? invoiceId;
  int? itemPrice;
  int? invoiceTempId;
  String? currencyName;
  String? partialPaymentAmount;
  String? remainingPayableAmount;
  String? invoicePaidStatus;
  bool? isOverdue;
  String? dueDaysData;

  FetchedData({
    this.id,
    this.startDate,
    this.endDate,
    this.clientName,
    this.invoiceTitle,
    this.invoiceId,
    this.itemPrice,
    this.invoiceTempId,
    this.currencyName,
    this.partialPaymentAmount,
    this.remainingPayableAmount,
    this.invoicePaidStatus,
    this.isOverdue,
    this.dueDaysData
  });
}