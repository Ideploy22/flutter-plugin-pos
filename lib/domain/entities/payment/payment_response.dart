import 'package:flutter_plugin_pos_integration/domain/entities/payment/payment_message.dart';
import 'package:flutter_plugin_pos_integration/domain/entities/payment/payment_response_detail.dart';

enum PaymentStatusType { processing, success, error }

class PaymentResponse {
  final PaymentStatusType status;
  final PaymentResponseDetail? details;
  final PaymentMessage? terminalMessage;

  PaymentResponse({
    required this.status,
    this.details,
    this.terminalMessage,
  });
}
