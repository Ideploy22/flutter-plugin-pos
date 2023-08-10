import 'package:flutter_plugin_pos_integration/domain/entities/auth/pos_auth.dart';
import 'package:ideploy_package/ideploy_package.dart';

part 'pos_auth_model.g.dart';
part 'pos_auth_model.mapper.dart';

@JsonSerializable(anyMap: true)
class PosCredentialsModel extends PosCredentials {
  const PosCredentialsModel({
    required String marketplaceId,
    required String sellerId,
    required String sellerName,
    required String terminal,
    required String accessKey,
  }) : super(
          marketplaceId: marketplaceId,
          sellerId: sellerId,
          sellerName: sellerName,
          terminal: terminal,
          accessKey: accessKey,
        );

  factory PosCredentialsModel.fromJson(Map<String, dynamic> json) => _$PosCredentialsModelFromJson(json);

  Map<String, dynamic> toJson() => _$PosCredentialsModelToJson(this);

  factory PosCredentialsModel.fromEntity(PosCredentials entity) => _$PosCredentialsModelFromEntity(entity);

  PosCredentials toEntity() => _$PosCredentialsModelToEntity(this);
}
