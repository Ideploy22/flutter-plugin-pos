import 'dart:convert';

import 'package:flutter_plugin_pos_integration/constants.dart';

class PaymentMessage {
  final POSEvent event;
  final Map<String, dynamic> data;

  PaymentMessage({
    required this.data,
    required this.event,
  });

  factory PaymentMessage.fromRawMessage(Map<String, dynamic> message) {
    final String strType = message['type'];
    final POSEvent event = POSEvent.values.firstWhere(
      (POSEvent element) => element.event == strType,
      orElse: () => POSEvent.unknown,
    );

    return PaymentMessage(
      event: event,
      data: Map<String, dynamic>.from(jsonDecode(message['data'])),
    );
  }
}
