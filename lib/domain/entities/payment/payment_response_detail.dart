class PaymentResponseDetail {
  final String transaction;
  final int? value;
  final String? status;
  final int? paymentType;
  final int? installments;
  final String? brand;
  final String? acquiring;
  final String? sellerName;
  final String? autoCode;
  final String? documentType;
  final String? document;
  final String? date;
  final String? hour;
  final String? sellerReceipt;
  final String? customerReceipt;
  final String? approvalMessage;
  final String? transactionId;
  final String? address;
  final String? pan;
  final String? nsu;
  final String? cv;
  final String? arqc;
  final String? aid;
  final String? aidLabel;

  PaymentResponseDetail({
    required this.transaction,
    this.value,
    this.status,
    this.paymentType,
    this.installments,
    this.brand,
    this.acquiring,
    this.sellerName,
    this.autoCode,
    this.documentType,
    this.document,
    this.date,
    this.hour,
    this.sellerReceipt,
    this.customerReceipt,
    this.approvalMessage,
    this.transactionId,
    this.address,
    this.pan,
    this.nsu,
    this.cv,
    this.arqc,
    this.aid,
    this.aidLabel,
  });
}
