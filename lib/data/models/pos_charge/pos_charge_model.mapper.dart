part of 'pos_charge_model.dart';

PosChargeModel _$PosChargeModelFromEntity(PosCharge entity) => PosChargeModel(
      value: entity.value,
      paymentOptionModel: entity.paymentOption,
      installments: entity.installments,
    );

PosCharge _$PosChargeModelToEntity(PosChargeModel model) => PosCharge(
      value: model.value,
      paymentOption: model.paymentOptionModel,
      installments: model.installments,
    );

PaymentType _$PaymentTypeEnumFromJson(String? value) {
  if (value == PaymentType.credit.zoopType) {
    return PaymentType.credit;
  } else if (value == PaymentType.debit.zoopType) {
    return PaymentType.debit;
  }
  return PaymentType.unknown;
}

String _$PaymentTypeEnumToJson(PaymentType value) {
  return value.zoopType;
}
