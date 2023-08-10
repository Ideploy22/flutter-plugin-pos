// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pos_charge_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PosChargeModel _$PosChargeModelFromJson(Map json) => PosChargeModel(
      value: json['value'] as int,
      paymentOptionModel:
          _$PaymentTypeEnumFromJson(json['paymentOption'] as String?),
      installments: json['installments'] as int,
    );

Map<String, dynamic> _$PosChargeModelToJson(PosChargeModel instance) =>
    <String, dynamic>{
      'value': instance.value,
      'installments': instance.installments,
      'paymentOption': _$PaymentTypeEnumToJson(instance.paymentOptionModel),
    };
