import 'package:flutter_plugin_pos_integration/domain/entities/payment/payment_message.dart';
import 'package:flutter_plugin_pos_integration/domain/entities/payment/payment_response_detail.dart';

enum PaymentStatusType { processing, success, error }

class PosPaymentResponse {
  final PaymentStatusType status;
  final PaymentResponseDetail? details;
  final PaymentMessage? terminalMessage;

  PosPaymentResponse({
    required this.status,
    this.details,
    this.terminalMessage,
  });
}
