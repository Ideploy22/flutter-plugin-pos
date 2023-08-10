part of 'pos_auth_model.dart';

PosCredentialsModel _$PosCredentialsModelFromEntity(PosCredentials entity) => PosCredentialsModel(
      marketplaceId: entity.marketplaceId,
      sellerId: entity.sellerId,
      sellerName: entity.sellerName,
      terminal: entity.terminal,
      accessKey: entity.accessKey,
    );

PosCredentialsModel _$PosCredentialsModelToEntity(PosCredentialsModel model) => PosCredentialsModel(
      marketplaceId: model.marketplaceId,
      sellerId: model.sellerId,
      sellerName: model.sellerName,
      terminal: model.terminal,
      accessKey: model.accessKey,
    );
