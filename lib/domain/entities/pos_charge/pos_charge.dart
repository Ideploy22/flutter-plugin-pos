import 'package:flutter_plugin_pos_integration/domain/entities/pos_charge/pos_payment_type.dart';

class PosCharge {
  final int value;
  final PaymentType paymentOption;
  final int installments;

  const PosCharge({
    required this.value,
    required this.paymentOption,
    required this.installments,
  });
}
