// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pos_auth_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PosCredentialsModel _$PosCredentialsModelFromJson(Map json) =>
    PosCredentialsModel(
      marketplaceId: json['marketplaceId'] as String,
      sellerId: json['sellerId'] as String,
      sellerName: json['sellerName'] as String,
      terminal: json['terminal'] as String,
      accessKey: json['accessKey'] as String,
    );

Map<String, dynamic> _$PosCredentialsModelToJson(
        PosCredentialsModel instance) =>
    <String, dynamic>{
      'marketplaceId': instance.marketplaceId,
      'sellerId': instance.sellerId,
      'sellerName': instance.sellerName,
      'terminal': instance.terminal,
      'accessKey': instance.accessKey,
    };
