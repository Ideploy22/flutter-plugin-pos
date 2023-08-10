enum PosLoginStatus { requestToken, error, waitingValidateToken, success }

class PosCredentials {
  final String marketplaceId;
  final String sellerId;
  final String sellerName;
  final String terminal;
  final String accessKey;

  const PosCredentials({
    required this.marketplaceId,
    required this.sellerId,
    required this.sellerName,
    required this.terminal,
    required this.accessKey,
  });
}
