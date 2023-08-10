import 'dart:convert';

class PosConnection {
  final String marketplaceId;
  final String sellerId;
  final String accessKey;

  PosConnection({
    required this.marketplaceId,
    required this.sellerId,
    required this.accessKey,
  });

  @override
  String toString() {
    return jsonEncode({
      "marketplaceId": marketplaceId,
      "sellerId": sellerId,
      "accessKey": accessKey,
    });
  }
}
