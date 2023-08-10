import 'package:flutter_plugin_pos_integration/domain/entities/pos_charge/pos_charge.dart';
import 'package:flutter_plugin_pos_integration/domain/entities/pos_charge/pos_payment_type.dart';
import 'package:json_annotation/json_annotation.dart';

part 'pos_charge_model.g.dart';
part 'pos_charge_model.mapper.dart';

@JsonSerializable(anyMap: true)
class PosChargeModel extends PosCharge {
  @JsonKey(name: 'paymentOption', fromJson: _$PaymentTypeEnumFromJson, toJson: _$PaymentTypeEnumToJson)
  final PaymentType paymentOptionModel;

  const PosChargeModel({
    required int value,
    required this.paymentOptionModel,
    required int installments,
  }) : super(
          value: value,
          paymentOption: paymentOptionModel,
          installments: installments,
        );

  factory PosChargeModel.fromJson(Map<String, dynamic> json) => _$PosChargeModelFromJson(json);
  Map<String, dynamic> toJson() => _$PosChargeModelToJson(this);

  factory PosChargeModel.fromEntity(PosCharge entity) => _$PosChargeModelFromEntity(entity);
  PosCharge toEntity() => _$PosChargeModelToEntity(this);
}
