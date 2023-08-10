enum PaymentType {
  credit("CREDIT"),
  debit("DEBIT"),
  unknown("UNKNOWN");

  final String zoopType;

  const PaymentType(this.zoopType);
}
