import 'package:flutter_plugin_pos_integration/constants.dart';

enum PaymentMessageType {
  display('Display'),
  notification('Notification'),
  error('Error'),
  unknown('Unknown');

  final String zoopName;

  const PaymentMessageType(this.zoopName);
}

class PaymentMessage {
  final POSEvent event;
  final String message;
  final PaymentMessageType terminalMessageType;

  PaymentMessage({
    required this.event,
    required this.message,
    required this.terminalMessageType,
  });

  factory PaymentMessage.fromRawMessage(Map<String, dynamic> message) {
    final String strType = message['type'];
    final POSEvent event = POSEvent.values.firstWhere(
      (POSEvent element) => element.event == strType,
      orElse: () => POSEvent.unknown,
    );

    final data = Map<String, dynamic>.from(message['data']);

    final PaymentMessageType terminalMessageType = PaymentMessageType.values.firstWhere(
      (PaymentMessageType element) => element.zoopName == data['terminalMessageType'],
      orElse: () => PaymentMessageType.unknown,
    );

    return PaymentMessage(
      event: event,
      message: data['message'],
      terminalMessageType: terminalMessageType,
    );
  }
}
